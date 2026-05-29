# 数据集标注 — 前后端接口对照

本文档描述 `WEB` 标注工具（`ImportDatasetModal` / `ExportDatasetModal` / `AnnotationTool`）与 `DEVICE/iot-dataset` 后端接口的对应关系。

## 服务与路径前缀

| 模块 | 服务 | 路径前缀 |
|------|------|----------|
| 数据集 CRUD、划分、同步 Minio | `iot-dataset` | `/dataset`、`/dataset/image` |
| 标签 CRUD | `iot-dataset` | `/dataset/tag` |
| 标注导入/导出 | `iot-dataset` | `/dataset/{datasetId}/annotation/*` |

网关需将上述路径转发至 `iot-dataset` 服务（与现有 `/dataset/image/upload` 一致）。

---

## 标注导入

| 前端 API | 方法 | 后端实现 | 说明 |
|----------|------|----------|------|
| `importAnnotationImageFolder` | POST | `/{id}/annotation/import-folder` | 多文件上传；图片 + 同名 `.json`（LabelMe）；**自动创建标签** |
| `importAnnotationLabelme` | POST | `/{id}/annotation/import-labelme` | 与 import-folder 相同 |
| `importAnnotationImageFolderPath` | POST | `/{id}/annotation/import-path` | 服务器本地目录（body: `{ path }`） |
| `importAnnotationYoloPath` | POST | `/{id}/annotation/import-yolo-path` | YOLO 目录（`classes.txt` / `data.yaml` + labels） |
| `importAnnotationCocoPath` | POST | `/{id}/annotation/import-coco-path` | COCO instances JSON |
| `extractAnnotationFrames` | POST | `/{id}/annotation/extract-frames` | 上传视频 + `frame_interval`；**需服务器安装 ffmpeg** |
| `importAnnotationFromCloud` | POST | `/{id}/annotation/cloud-import` | 从另一数据集复制图片/标注/标签 |

### 导入响应 `DatasetAnnotationImportRespVO`

```json
{
  "imagesCopied": 100,
  "labelmeImages": 80,
  "yoloImages": 0,
  "cocoImages": 0,
  "tagsCreated": 5,
  "classes": ["person", "car"],
  "hint": "可选说明",
  "createdImages": 50,
  "cloudDatasetId": 12345
}
```

前端在 `onImportSuccess` 中应优先使用 `tagsCreated` / `classes` 刷新标签列表；仅在后端未返回类别时，才用前端 `syncTagsFromImport` 扫描兜底。

---

## 标注导出

| 前端 API | 方法 | 后端实现 | 说明 |
|----------|------|----------|------|
| `exportAnnotationDataset` | POST | `/{id}/annotation/export` | 返回 **ZIP 二进制**（YOLO 结构） |
| `exportAnnotationToCloud` | POST | `/{id}/annotation/cloud-export` | 新建数据集并复制（body: `name`, `version`） |

导出请求体 `DatasetAnnotationExportReqVO`：

- `trainRatio` / `valRatio` / `testRatio`：未划分用途时，导出阶段临时按比例分桶
- `sampleSelection`：`all` | `annotated` | `unannotated`
- `selectedClasses`：类别名称列表（必填）
- `exportPrefix`：文件名前缀（可选）

---

## 云平台

| 前端 API | 方法 | 后端实现 | 说明 |
|----------|------|----------|------|
| `listAnnotationCloudDatasets` | GET | `/annotation/cloud-datasets` | 本系统内图片数据集列表（id/name/version） |

「云平台」在本项目中指 **同一 iot-dataset 服务内的其他数据集**，用于跨数据集复制，非外部 SaaS。

---

## 标签

| 前端 API | 方法 | 后端 | 说明 |
|----------|------|------|------|
| `getDatasetTagPage` | GET | `/dataset/tag/page` | 标注页加载标签 |
| `createDatasetTag` | POST | `/dataset/tag/create` | 手动/面板快速添加 |
| （导入时） | — | `DatasetTagService.ensureTagsForDataset` | 导入 YOLO/COCO/LabelMe 时按类别名自动创建 |

**不再使用**前端默认标签（人物/车辆/动物）。无标签时列表为空，需用户添加或先导入带标注的数据。

---

## 图片与训练流程（已有接口）

| 能力 | 路径 |
|------|------|
| 单图/压缩包上传 | `POST /dataset/image/upload` |
| 更新标注 | `PUT /dataset/image/update` |
| 划分用途 | `POST /dataset/{id}/split` |
| 检查同步条件 | `GET /dataset/image/{id}/check-sync-condition` |
| 同步 Minio 训练包 | `POST /dataset/image/{id}/sync-to-minio` |

---

## 部署检查清单

1. 重新构建并部署 **iot-dataset**（含本次 `DatasetAnnotationController`）。
2. 确认网关路由包含 `/dataset/**` → iot-dataset。
3. 视频抽帧：目标机器安装 `ffmpeg` 并在 PATH 中可用。
4. 路径导入（YOLO/COCO/ImageFolder）：路径为 **iot-dataset 进程所在服务器** 的本地绝对路径。

---

## 前端主要文件

- `WEB/src/api/device/dataset.ts` — API 定义
- `WEB/src/views/dataset/components/AutoLabel/ImportDatasetModal` — 导入
- `WEB/src/views/dataset/components/AutoLabel/ExportDatasetModal` — 导出
- `WEB/src/views/dataset/components/AnnotationTool/` — 标注工作台
- `WEB/src/views/dataset/components/AnnotationTool/datasetTagUtils.ts` — 标签兜底同步（后端未返回 classes 时）

## 后端主要文件

- `DatasetAnnotationController.java` — HTTP 入口
- `DatasetAnnotationServiceImpl.java` — 导入解析
- `DatasetTagServiceImpl.ensureTagsForDataset` — 自动建标签
- `DatasetYoloPackager.java` — YOLO ZIP 导出
- `DatasetAnnotationCloudSupport.java` — 数据集间复制
- `DatasetVideoFrameExtractor.java` — 视频抽帧
