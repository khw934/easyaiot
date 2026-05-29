package com.basiclab.iot.dataset.domain.dataset.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.util.ArrayList;
import java.util.List;

@Schema(description = "数据集图片上传结果")
@Data
public class DatasetImageUploadRespVO {

    @Schema(description = "成功数量")
    private int successCount;

    @Schema(description = "失败数量")
    private int failedCount;

    @Schema(description = "跳过数量")
    private int skippedCount;

    @Schema(description = "覆盖数量（同名图片）")
    private int overwrittenCount;

    @Schema(description = "失败文件列表")
    private List<String> failedFiles = new ArrayList<>();

    @Schema(description = "异步导入任务 ID（importStatus=processing 时返回）")
    private String importTaskId;

    @Schema(description = "导入状态：processing / completed")
    private String importStatus;
}
