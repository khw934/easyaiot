package com.basiclab.iot.dataset.domain.dataset.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import javax.validation.constraints.NotBlank;

@Schema(description = "服务器本地路径导入请求")
@Data
public class DatasetAnnotationPathReqVO {

    @NotBlank(message = "路径不能为空")
    @Schema(description = "服务器本地绝对路径")
    private String path;
}
