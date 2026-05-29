package com.basiclab.iot.dataset.domain.dataset.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import javax.validation.constraints.NotBlank;

@Schema(description = "导出为新数据集")
@Data
public class DatasetAnnotationCloudExportReqVO {

    @NotBlank(message = "数据集名称不能为空")
    private String name;

    @NotBlank(message = "版本号不能为空")
    private String version;
}
