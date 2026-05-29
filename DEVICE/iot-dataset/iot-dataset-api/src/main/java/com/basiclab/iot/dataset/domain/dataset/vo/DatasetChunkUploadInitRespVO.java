package com.basiclab.iot.dataset.domain.dataset.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.util.ArrayList;
import java.util.List;

@Schema(description = "分片上传初始化响应")
@Data
public class DatasetChunkUploadInitRespVO {

    @Schema(description = "上传会话 ID")
    private String uploadId;

    @Schema(description = "已上传的分片序号（从 0 开始）")
    private List<Integer> uploadedChunks = new ArrayList<>();

    @Schema(description = "是否为续传会话")
    private Boolean resumed;
}
