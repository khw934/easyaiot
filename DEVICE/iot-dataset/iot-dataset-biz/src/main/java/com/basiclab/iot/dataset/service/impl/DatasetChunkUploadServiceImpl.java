package com.basiclab.iot.dataset.service.impl;

import com.basiclab.iot.dataset.dal.dataobject.DatasetDO;
import com.basiclab.iot.dataset.dal.pgsql.DatasetMapper;
import com.basiclab.iot.dataset.domain.dataset.vo.DatasetChunkUploadInitReqVO;
import com.basiclab.iot.dataset.domain.dataset.vo.DatasetChunkUploadInitRespVO;
import com.basiclab.iot.dataset.domain.dataset.vo.DatasetChunkUploadStatusRespVO;
import com.basiclab.iot.dataset.domain.dataset.vo.DatasetImageUploadRespVO;
import com.basiclab.iot.dataset.service.DatasetChunkUploadService;
import com.basiclab.iot.dataset.service.DatasetImageImportTaskService;
import com.basiclab.iot.dataset.service.DatasetImageService;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.Resource;
import java.io.IOException;
import java.io.OutputStream;
import java.nio.charset.StandardCharsets;
import java.nio.file.*;
import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

import static com.basiclab.iot.common.exception.util.ServiceExceptionUtil.exception;
import static com.basiclab.iot.dataset.enums.ErrorCodeConstants.*;

@Service
public class DatasetChunkUploadServiceImpl implements DatasetChunkUploadService {

    private static final Logger logger = LoggerFactory.getLogger(DatasetChunkUploadServiceImpl.class);
    private static final String META_FILE = "meta.json";
    private static final String MERGED_FILE = "merged";

    @Resource
    private DatasetMapper datasetMapper;

    @Resource
    private DatasetImageService datasetImageService;

    @Resource
    private DatasetImageImportTaskService datasetImageImportTaskService;

    @Value("${dataset.upload.chunk-dir:${java.io.tmpdir}/dataset-chunk-upload}")
    private String chunkDir;

    @Value("${dataset.upload.max-file-size:214748364800}")
    private long maxFileSize;

    private final ObjectMapper objectMapper = new ObjectMapper();

    @Override
    public DatasetChunkUploadInitRespVO initUpload(DatasetChunkUploadInitReqVO reqVO) {
        validateDataset(reqVO.getDatasetId());
        validateFileSize(reqVO.getFileSize());
        validateFileName(reqVO.getFileName(), reqVO.getIsZip());

        String existingUploadId = findResumableUploadId(reqVO);
        if (existingUploadId != null) {
            ChunkUploadMeta meta = readMeta(existingUploadId);
            if (meta != null && Objects.equals(meta.getTotalChunks(), reqVO.getTotalChunks())) {
                DatasetChunkUploadInitRespVO resp = new DatasetChunkUploadInitRespVO();
                resp.setUploadId(existingUploadId);
                resp.setUploadedChunks(listUploadedChunks(existingUploadId, meta.getTotalChunks()));
                resp.setResumed(true);
                return resp;
            }
        }

        String uploadId = UUID.randomUUID().toString().replace("-", "");
        ChunkUploadMeta meta = new ChunkUploadMeta();
        meta.setUploadId(uploadId);
        meta.setDatasetId(reqVO.getDatasetId());
        meta.setFileName(reqVO.getFileName());
        meta.setFileSize(reqVO.getFileSize());
        meta.setIsZip(reqVO.getIsZip());
        meta.setTotalChunks(reqVO.getTotalChunks());
        meta.setChunkSize(reqVO.getChunkSize());
        meta.setFileKey(reqVO.getFileKey());
        meta.setCreatedAt(System.currentTimeMillis());

        try {
            Path uploadDir = resolveUploadDir(uploadId);
            Files.createDirectories(uploadDir);
            writeMeta(uploadId, meta);
            if (StringUtils.isNotBlank(reqVO.getFileKey())) {
                writeResumeIndex(reqVO.getDatasetId(), reqVO.getFileKey(), uploadId);
            }
        } catch (IOException e) {
            throw exception(FILE_UPLOAD_FAILED, "初始化分片上传失败: " + e.getMessage());
        }

        DatasetChunkUploadInitRespVO resp = new DatasetChunkUploadInitRespVO();
        resp.setUploadId(uploadId);
        resp.setUploadedChunks(Collections.emptyList());
        resp.setResumed(false);
        return resp;
    }

    @Override
    public void uploadChunk(String uploadId, Integer chunkIndex, MultipartFile chunk) {
        ChunkUploadMeta meta = requireMeta(uploadId);
        if (chunkIndex == null || chunkIndex < 0 || chunkIndex >= meta.getTotalChunks()) {
            throw exception(CHUNK_INDEX_INVALID);
        }
        if (chunk == null || chunk.isEmpty()) {
            throw exception(FILE_UPLOAD_FAILED, "分片内容不能为空");
        }

        try {
            Path chunkPath = resolveChunkPath(uploadId, chunkIndex);
            Files.createDirectories(chunkPath.getParent());
            chunk.transferTo(chunkPath.toFile());
        } catch (IOException e) {
            throw exception(FILE_UPLOAD_FAILED, "保存分片失败: " + e.getMessage());
        }
    }

    @Override
    public DatasetChunkUploadStatusRespVO getUploadStatus(String uploadId) {
        ChunkUploadMeta meta = requireMeta(uploadId);
        DatasetChunkUploadStatusRespVO resp = new DatasetChunkUploadStatusRespVO();
        resp.setUploadId(uploadId);
        resp.setTotalChunks(meta.getTotalChunks());
        resp.setUploadedChunks(listUploadedChunks(uploadId, meta.getTotalChunks()));
        return resp;
    }

    @Override
    public DatasetImageUploadRespVO completeUpload(String uploadId) {
        ChunkUploadMeta meta = requireMeta(uploadId);
        List<Integer> uploaded = listUploadedChunks(uploadId, meta.getTotalChunks());
        if (uploaded.size() != meta.getTotalChunks()) {
            throw exception(CHUNK_UPLOAD_INCOMPLETE);
        }

        Path mergedPath = null;
        try {
            mergedPath = mergeChunks(uploadId, meta);
            if (Boolean.TRUE.equals(meta.getIsZip())) {
                Path zipPath = mergedPath;
                String taskId = datasetImageImportTaskService.submitZipImport(
                        zipPath, meta.getDatasetId(), () -> cleanupUpload(uploadId, meta));
                DatasetImageUploadRespVO asyncResp = new DatasetImageUploadRespVO();
                asyncResp.setImportTaskId(taskId);
                asyncResp.setImportStatus("processing");
                return asyncResp;
            }
            DatasetImageUploadRespVO result = datasetImageService.processUploadFromPath(
                    mergedPath, meta.getFileName(), meta.getDatasetId(), meta.getIsZip());
            cleanupUpload(uploadId, meta);
            return result;
        } catch (Exception e) {
            logger.error("分片合并或入库失败 uploadId={}: {}", uploadId, e.getMessage(), e);
            throw exception(FILE_UPLOAD_FAILED, e.getMessage());
        }
    }

    @Override
    public void abortUpload(String uploadId) {
        ChunkUploadMeta meta = readMeta(uploadId);
        if (meta != null) {
            cleanupUpload(uploadId, meta);
        }
    }

    private void validateDataset(Long datasetId) {
        DatasetDO dataset = datasetMapper.selectById(datasetId);
        if (dataset == null) {
            throw exception(DATASET_NOT_EXISTS);
        }
    }

    private void validateFileSize(Long fileSize) {
        if (fileSize == null || fileSize <= 0) {
            throw exception(FILE_SIZE_EXCEEDED, "文件大小无效");
        }
        if (fileSize > maxFileSize) {
            throw exception(FILE_SIZE_EXCEEDED, "文件大小不能超过 200GB");
        }
    }

    private void validateFileName(String fileName, Boolean isZip) {
        if (StringUtils.isBlank(fileName)) {
            throw exception(INVALID_FILE_TYPE, "文件名不能为空");
        }
        if (Boolean.TRUE.equals(isZip)) {
            if (!fileName.toLowerCase(Locale.ROOT).endsWith(".zip")) {
                throw exception(INVALID_FILE_TYPE, "仅支持 ZIP 格式");
            }
            return;
        }
        String lower = fileName.toLowerCase(Locale.ROOT);
        if (!(lower.endsWith(".jpg") || lower.endsWith(".jpeg") || lower.endsWith(".png"))) {
            throw exception(INVALID_FILE_TYPE, "仅支持 JPG/PNG/JPEG 图片格式");
        }
    }

    private String findResumableUploadId(DatasetChunkUploadInitReqVO reqVO) {
        if (StringUtils.isBlank(reqVO.getFileKey())) {
            return null;
        }
        try {
            Path indexPath = resolveResumeIndexPath(reqVO.getDatasetId(), reqVO.getFileKey());
            if (!Files.exists(indexPath)) {
                return null;
            }
            String uploadId = Files.readString(indexPath, StandardCharsets.UTF_8).trim();
            ChunkUploadMeta meta = readMeta(uploadId);
            if (meta == null) {
                Files.deleteIfExists(indexPath);
                return null;
            }
            if (!Objects.equals(meta.getFileSize(), reqVO.getFileSize())
                    || !Objects.equals(meta.getFileName(), reqVO.getFileName())
                    || !Objects.equals(meta.getIsZip(), reqVO.getIsZip())) {
                return null;
            }
            return uploadId;
        } catch (IOException e) {
            logger.warn("读取断点续传索引失败: {}", e.getMessage());
            return null;
        }
    }

    private ChunkUploadMeta requireMeta(String uploadId) {
        ChunkUploadMeta meta = readMeta(uploadId);
        if (meta == null) {
            throw exception(CHUNK_UPLOAD_NOT_FOUND);
        }
        return meta;
    }

    private ChunkUploadMeta readMeta(String uploadId) {
        try {
            Path metaPath = resolveUploadDir(uploadId).resolve(META_FILE);
            if (!Files.exists(metaPath)) {
                return null;
            }
            return objectMapper.readValue(metaPath.toFile(), ChunkUploadMeta.class);
        } catch (IOException e) {
            logger.warn("读取分片元数据失败 uploadId={}: {}", uploadId, e.getMessage());
            return null;
        }
    }

    private void writeMeta(String uploadId, ChunkUploadMeta meta) throws IOException {
        Path metaPath = resolveUploadDir(uploadId).resolve(META_FILE);
        objectMapper.writeValue(metaPath.toFile(), meta);
    }

    private void writeResumeIndex(Long datasetId, String fileKey, String uploadId) throws IOException {
        Path indexPath = resolveResumeIndexPath(datasetId, fileKey);
        Files.createDirectories(indexPath.getParent());
        Files.writeString(indexPath, uploadId, StandardCharsets.UTF_8,
                StandardOpenOption.CREATE, StandardOpenOption.TRUNCATE_EXISTING);
    }

    private List<Integer> listUploadedChunks(String uploadId, int totalChunks) {
        return IntStream.range(0, totalChunks)
                .filter(i -> Files.exists(resolveChunkPath(uploadId, i)))
                .boxed()
                .collect(Collectors.toList());
    }

    private Path mergeChunks(String uploadId, ChunkUploadMeta meta) throws IOException {
        Path uploadDir = resolveUploadDir(uploadId);
        Path mergedPath = uploadDir.resolve(MERGED_FILE);
        try (OutputStream out = Files.newOutputStream(mergedPath, StandardOpenOption.CREATE, StandardOpenOption.TRUNCATE_EXISTING)) {
            for (int i = 0; i < meta.getTotalChunks(); i++) {
                Path chunkPath = resolveChunkPath(uploadId, i);
                if (!Files.exists(chunkPath)) {
                    throw exception(CHUNK_UPLOAD_INCOMPLETE, "分片 " + i + " 缺失");
                }
                Files.copy(chunkPath, out);
            }
        }
        return mergedPath;
    }

    private void cleanupUpload(String uploadId, ChunkUploadMeta meta) {
        try {
            if (StringUtils.isNotBlank(meta.getFileKey())) {
                Files.deleteIfExists(resolveResumeIndexPath(meta.getDatasetId(), meta.getFileKey()));
            }
            Path uploadDir = resolveUploadDir(uploadId);
            if (Files.exists(uploadDir)) {
                Files.walk(uploadDir)
                        .sorted(Comparator.reverseOrder())
                        .forEach(path -> {
                            try {
                                Files.deleteIfExists(path);
                            } catch (IOException ignored) {
                            }
                        });
            }
        } catch (IOException e) {
            logger.warn("清理分片上传目录失败 uploadId={}: {}", uploadId, e.getMessage());
        }
    }

    private Path resolveUploadDir(String uploadId) {
        return Paths.get(chunkDir, uploadId);
    }

    private Path resolveChunkPath(String uploadId, int chunkIndex) {
        return resolveUploadDir(uploadId).resolve(String.valueOf(chunkIndex));
    }

    private Path resolveResumeIndexPath(Long datasetId, String fileKey) {
        String safeKey = Integer.toHexString(fileKey.hashCode());
        return Paths.get(chunkDir, "_resume", String.valueOf(datasetId), safeKey + ".id");
    }

    public static class ChunkUploadMeta {
        private String uploadId;
        private Long datasetId;
        private String fileName;
        private Long fileSize;
        private Boolean isZip;
        private Integer totalChunks;
        private Integer chunkSize;
        private String fileKey;
        private Long createdAt;

        public String getUploadId() { return uploadId; }
        public void setUploadId(String uploadId) { this.uploadId = uploadId; }
        public Long getDatasetId() { return datasetId; }
        public void setDatasetId(Long datasetId) { this.datasetId = datasetId; }
        public String getFileName() { return fileName; }
        public void setFileName(String fileName) { this.fileName = fileName; }
        public Long getFileSize() { return fileSize; }
        public void setFileSize(Long fileSize) { this.fileSize = fileSize; }
        public Boolean getIsZip() { return isZip; }
        public void setIsZip(Boolean isZip) { this.isZip = isZip; }
        public Integer getTotalChunks() { return totalChunks; }
        public void setTotalChunks(Integer totalChunks) { this.totalChunks = totalChunks; }
        public Integer getChunkSize() { return chunkSize; }
        public void setChunkSize(Integer chunkSize) { this.chunkSize = chunkSize; }
        public String getFileKey() { return fileKey; }
        public void setFileKey(String fileKey) { this.fileKey = fileKey; }
        public Long getCreatedAt() { return createdAt; }
        public void setCreatedAt(Long createdAt) { this.createdAt = createdAt; }
    }
}
