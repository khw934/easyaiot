package com.basiclab.iot.dataset.domain.dataset.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import javax.validation.constraints.NotNull;

@Schema(description = "从其他数据集导入")
@Data
public class DatasetAnnotationCloudImportReqVO {

    @NotNull(message = "源数据集 ID 不能为空")
    @Schema(description = "源数据集 ID")
    private Long sourceDatasetId;
}
