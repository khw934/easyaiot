package com.basiclab.iot.dataset.domain.dataset.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.util.ArrayList;
import java.util.List;

@Schema(description = "分片上传进度")
@Data
public class DatasetChunkUploadStatusRespVO {

    @Schema(description = "上传会话 ID")
    private String uploadId;

    @Schema(description = "分片总数")
    private Integer totalChunks;

    @Schema(description = "已上传的分片序号")
    private List<Integer> uploadedChunks = new ArrayList<>();
}
