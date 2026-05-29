package com.basiclab.iot.dataset.domain.dataset.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Builder;
import lombok.Data;

@Schema(description = "数据集同步前置检查")
@Data
@Builder
public class DatasetSyncCheckRespVO {

    @Schema(description = "用途是否已划分")
    private Boolean usageAllocated;

    @Schema(description = "标注是否全部完成")
    private Boolean annotationCompleted;

    @Schema(description = "是否满足同步条件")
    private Boolean syncReady;

    @Schema(description = "图片总数")
    private Integer totalImages;

    @Schema(description = "未划分用途数量")
    private Integer unallocatedCount;

    @Schema(description = "未完成标注数量")
    private Integer unannotatedCount;
}
