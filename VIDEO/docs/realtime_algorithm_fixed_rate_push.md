# 实时算法服务：`run_deploy.py` 流畅度与卡顿治理说明

本文档说明 **`VIDEO/services/realtime_algorithm_service/run_deploy.py`** 中与「观感卡顿、快进、忽快忽慢」相关的改进思路；实现细节以源码为准（函数 **`_fixed_rate_push_worker`**、**`buffer_streamer_worker`** 等）。

## 卡顿的典型成因（本服务语境）

1. **拉流、解码、推理、画框、写 FFmpeg stdin 串在同一条热路径上**  
   某一环变慢时，下一环要么饿死要么突发追赶，表现为画面一顿一顿或突然「快进几秒」。

2. **推流侧节拍与「算法产出帧」节拍强行绑定**  
   AI 某几帧变慢时，若仍按「来一帧推一帧」，播放器侧容易看到时间轴不均匀；若积压后一次性flush，会出现_burst_式快进。

3. **国标 GB28181 / 录像回放等非实时源流**  
   源流可能按文件或会话全速吐帧，若消费过快会像快进播放；若异步队列策略不当，恢复网络后又易出现 OSD 时间「跳秒」。

4. **多路任务挤占同一张 GPU**  
   推理排队变长，端到端延迟上升，用户体感为「卡」。

---

## 改进一：固定速率推帧线程（解耦「算法主循环」与「写 FFmpeg」）

新增 **`_fixed_rate_push_worker(device_id)`** 独立线程，专门按 **配置的输出帧率**（与 **`_get_effective_realtime_stream_params()`** 一致）向 FFmpeg 的 **stdin** 写 **raw RGB** 数据。

| 行为 | 作用 |
|------|------|
| 使用 **`time.perf_counter()`** 计算下一帧目标时刻，不足则 **`sleep`** | 推流时间轴尽量 **匀速**，减轻播放器侧不均匀卡顿 |
| 主循环只更新 **`device_output_frames[device_id]`**（带锁），推送线程只读 **最新一帧** | 产出快时 **自然丢旧追新**，避免内存与延迟无限堆积 |
| 若暂时 **没有新帧**（AI 慢或缓冲未跟上），则 **重复推送上一帧** | 保持码流连贯，避免「缺帧 → 突然扎堆」造成的 **快进感** |
| 若调度 **严重落后**（超过约 2 帧间隔），**重置时间基准** | 避免为了还债而 **突发连推多帧**，再度放大快进感 |

主循环 **`buffer_streamer_worker`** 中，完成画框/插值后的 **`output_frame`** 写入 **`device_output_frames`**；**不再**让耗时不确定的推理与 **同步 `stdin.write`** 抢同一段循环时间片，从结构上削弱卡顿来源。

---

## 改进二：源流消费节拍与 GB28181 场景

- 每次 **`cap.read()` 前** 按 **`_frame_interval`** 做消费节流（与 **`_last_frame_consume_time`** 配合），避免 **非实时源全速读帧** 导致 **快进**。
- 对 **GB28181** 源，在打开捕获后尝试读取 **`CAP_PROP_FPS`**，用 **源流实际帧率** 修正 **`_frame_interval`**，使「读帧节拍」与真实 **摄像头/回放会话** 一致。
- **异步拉流**（**`AsyncVideoStream`**）下，对 GB28181 等可配置 **`AI_GB28181_ASYNC_QUEUE_MAX`**，在 **FIFO 深度 > 1** 时按序消化，减轻网络恢复后 **画面/OSD 跳秒**（与 **`AI_RTSP_ASYNC_QUEUE_MAX`** 的全局语义配合，详见下文档）。

更完整的 RTSP/RTMP 异步拉流背景见：**`VIDEO/docs/realtime_algorithm_rtsp_async_read.md`**。

---

## 改进三：队列与并行度（减轻积压）

默认参数调整方向包括（可通过环境变量覆盖）：

- **`DETECTION_QUEUE_SIZE` / `PUSH_QUEUE_SIZE`** 默认 **100**（注释说明由原先 50 抬高），在负载冲高时 **减少因队列满而丢帧、抖动**。
- **`EXTRACT_QUEUE_SIZE`**、**`YOLO_WORKER_THREADS`** 等配合 **抽帧 → 检测 → 回灌** 流水线，降低 **单线程瓶颈** 带来的周期性卡顿。

具体默认值以源码与环境变量为准。

---

## 改进四：多 GPU 调度（可选）

当启用 GPU 时，通过 **`get_assigned_gpu_id` / `get_infer_device` / `get_ffmpeg_gpu_id`** 等，将不同设备 **稳定映射** 到多张卡（策略可由 **`GPU_POLICY` / `INFER_GPU_POLICY` / `FFMPEG_GPU_POLICY`** 等控制 **hash 或 round-robin**），减轻 **单卡挤爆** 导致的推理延迟与观感卡顿。

---

## 配置与环境变量速查

| 主题 | 变量或位置 |
|------|------------|
| 异步拉流总开关与队列 | **`AI_RTSP_ASYNC_READ`**、**`AI_RTSP_ASYNC_QUEUE_MAX`** |
| GB28181 异步 FIFO 深度 | **`AI_GB28181_ASYNC_QUEUE_MAX`** |
| 检测/推帧/抽帧队列 | **`DETECTION_QUEUE_SIZE`**、**`PUSH_QUEUE_SIZE`**、**`EXTRACT_QUEUE_SIZE`** |
| YOLO 线程数 | **`YOLO_WORKER_THREADS`** |
| 画质与输出帧率档位 | **`AI_VIDEO_QUALITY_PROFILE`** 及 **`AI_*` / `VIEW_*`** 相关 FFmpeg、分辨率变量 |

完整模板见 **`VIDEO/services/realtime_algorithm_service/env.example`** 及 **`VIDEO/.env*`**。

---

## 小结

本次 **`run_deploy.py`** 侧针对卡顿的核心手段是：**把「匀速推流」从主循环剥离为独立线程**，并在 **读源、异步解码、队列与 GPU** 等层面减少积压与节拍错乱；对 GB28181 等场景则强调 **按真实帧率消费** 与 **可选 FIFO**，避免快进与跳秒两种极端观感问题。

---

## 相关文档

- **`VIDEO/docs/realtime_algorithm_rtsp_async_read.md`**：RTSP/RTMP 异步拉流与 **`AsyncVideoStream`**
- **`VIDEO/docs/fix_stream_busy_error.md`**：推流冲突与 **StreamBusy** 类问题
