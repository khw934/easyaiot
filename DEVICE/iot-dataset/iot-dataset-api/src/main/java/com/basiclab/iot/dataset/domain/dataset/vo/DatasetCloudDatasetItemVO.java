package com.basiclab.iot.dataset.domain.dataset.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Schema(description = "可选的源数据集（云平台列表）")
@Data
public class DatasetCloudDatasetItemVO {

    private Long id;
    private String name;
    private String version;
}
