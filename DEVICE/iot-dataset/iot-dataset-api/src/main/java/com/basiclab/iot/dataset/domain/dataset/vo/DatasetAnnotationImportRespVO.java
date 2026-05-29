package com.basiclab.iot.dataset.domain.dataset.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.util.ArrayList;
import java.util.List;

/**
 * 标注工具 — 数据集导入结果（与前端 DatasetAnnotationImportResult 对齐）
 */
@Schema(description = "标注数据集导入结果")
@Data
public class DatasetAnnotationImportRespVO {

    @Schema(description = "导入/复制的图片数量")
    private Integer imagesCopied = 0;

    @Schema(description = "LabelMe 标注图片数")
    private Integer labelmeImages = 0;

    @Schema(description = "COCO 标注图片数")
    private Integer cocoImages = 0;

    @Schema(description = "YOLO 标注图片数")
    private Integer yoloImages = 0;

    @Schema(description = "本次新建的标签数量")
    private Integer tagsCreated = 0;

    @Schema(description = "导入涉及的类别名称（有序）")
    private List<String> classes = new ArrayList<>();

    @Schema(description = "补充说明")
    private String hint;

    @Schema(description = "新建图片数量（云平台导出）")
    private Integer createdImages;

    @Schema(description = "云平台新数据集 ID")
    private Long cloudDatasetId;
}
