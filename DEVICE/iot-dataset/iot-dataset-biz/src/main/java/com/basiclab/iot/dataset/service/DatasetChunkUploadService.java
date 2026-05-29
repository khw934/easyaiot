package com.basiclab.iot.dataset.service;

import com.basiclab.iot.dataset.domain.dataset.vo.DatasetChunkUploadInitReqVO;
import com.basiclab.iot.dataset.domain.dataset.vo.DatasetChunkUploadInitRespVO;
import com.basiclab.iot.dataset.domain.dataset.vo.DatasetChunkUploadStatusRespVO;
import com.basiclab.iot.dataset.domain.dataset.vo.DatasetImageUploadRespVO;
import org.springframework.web.multipart.MultipartFile;

public interface DatasetChunkUploadService {

    DatasetChunkUploadInitRespVO initUpload(DatasetChunkUploadInitReqVO reqVO);

    void uploadChunk(String uploadId, Integer chunkIndex, MultipartFile chunk);

    DatasetChunkUploadStatusRespVO getUploadStatus(String uploadId);

    DatasetImageUploadRespVO completeUpload(String uploadId);

    void abortUpload(String uploadId);
}
