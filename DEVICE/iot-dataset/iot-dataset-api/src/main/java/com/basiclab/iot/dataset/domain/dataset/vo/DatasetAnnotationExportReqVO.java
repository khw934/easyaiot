package com.basiclab.iot.dataset.domain.dataset.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import javax.validation.constraints.NotEmpty;
import java.math.BigDecimal;
import java.util.List;

@Schema(description = "标注数据集导出请求")
@Data
public class DatasetAnnotationExportReqVO {

    @Schema(description = "训练集比例")
    private BigDecimal trainRatio;

    @Schema(description = "验证集比例")
    private BigDecimal valRatio;

    @Schema(description = "测试集比例")
    private BigDecimal testRatio;

    @Schema(description = "样本选择：all | annotated | unannotated")
    private String sampleSelection;

    @Schema(description = "导出的类别名称列表")
    @NotEmpty(message = "请至少选择一个类别")
    private List<String> selectedClasses;

    @Schema(description = "导出文件名前缀")
    private String exportPrefix;
}
