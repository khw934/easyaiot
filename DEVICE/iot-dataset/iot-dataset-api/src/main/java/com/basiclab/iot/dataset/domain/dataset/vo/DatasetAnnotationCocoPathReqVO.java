package com.basiclab.iot.dataset.domain.dataset.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import javax.validation.constraints.NotBlank;

@Schema(description = "COCO 路径导入请求")
@Data
public class DatasetAnnotationCocoPathReqVO {

    @NotBlank(message = "COCO JSON 路径不能为空")
    @Schema(description = "instances JSON 绝对路径")
    private String cocoJson;

    @Schema(description = "图片根目录（可选，默认同 JSON 所在目录）")
    private String imagesRoot;
}
