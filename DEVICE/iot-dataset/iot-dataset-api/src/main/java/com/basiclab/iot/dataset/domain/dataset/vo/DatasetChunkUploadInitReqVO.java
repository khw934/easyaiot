package com.basiclab.iot.dataset.domain.dataset.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Positive;

@Schema(description = "分片上传初始化请求")
@Data
public class DatasetChunkUploadInitReqVO {

    @Schema(description = "数据集 ID", requiredMode = Schema.RequiredMode.REQUIRED)
    @NotNull(message = "数据集 ID 不能为空")
    private Long datasetId;

    @Schema(description = "原始文件名", requiredMode = Schema.RequiredMode.REQUIRED)
    @NotBlank(message = "文件名不能为空")
    private String fileName;

    @Schema(description = "文件总大小（字节）", requiredMode = Schema.RequiredMode.REQUIRED)
    @Positive(message = "文件大小必须大于 0")
    private Long fileSize;

    @Schema(description = "是否为 ZIP 压缩包", requiredMode = Schema.RequiredMode.REQUIRED)
    @NotNull(message = "isZip 不能为空")
    private Boolean isZip;

    @Schema(description = "分片总数", requiredMode = Schema.RequiredMode.REQUIRED)
    @Positive(message = "分片总数必须大于 0")
    private Integer totalChunks;

    @Schema(description = "分片大小（字节）", requiredMode = Schema.RequiredMode.REQUIRED)
    @Positive(message = "分片大小必须大于 0")
    private Integer chunkSize;

    @Schema(description = "文件指纹，用于断点续传（建议 name+size+lastModified 的 hash）")
    private String fileKey;
}
