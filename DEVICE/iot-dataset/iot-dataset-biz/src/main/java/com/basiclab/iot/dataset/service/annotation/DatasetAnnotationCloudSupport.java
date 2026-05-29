package com.basiclab.iot.dataset.service.annotation;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.basiclab.iot.dataset.dal.dataobject.DatasetDO;
import com.basiclab.iot.dataset.dal.dataobject.DatasetImageDO;
import com.basiclab.iot.dataset.dal.dataobject.DatasetTagDO;
import com.basiclab.iot.dataset.dal.pgsql.DatasetImageMapper;
import com.basiclab.iot.dataset.dal.pgsql.DatasetMapper;
import com.basiclab.iot.dataset.domain.dataset.vo.DatasetAnnotationCloudExportReqVO;
import com.basiclab.iot.dataset.domain.dataset.vo.DatasetAnnotationImportRespVO;
import com.basiclab.iot.dataset.domain.dataset.vo.DatasetCloudDatasetItemVO;
import com.basiclab.iot.dataset.domain.dataset.vo.DatasetSaveReqVO;
import com.basiclab.iot.dataset.service.DatasetImageService;
import com.basiclab.iot.dataset.service.DatasetService;
import com.basiclab.iot.dataset.service.DatasetTagService;
import io.minio.GetObjectArgs;
import io.minio.MinioClient;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.annotation.Resource;
import java.io.InputStream;
import java.net.URI;
import java.util.*;
import java.util.stream.Collectors;

import static com.basiclab.iot.common.exception.util.ServiceExceptionUtil.exception;
import static com.basiclab.iot.dataset.enums.ErrorCodeConstants.DATASET_NOT_EXISTS;

@Component
public class DatasetAnnotationCloudSupport {

    @Resource
    private DatasetMapper datasetMapper;
    @Resource
    private DatasetImageMapper datasetImageMapper;
    @Resource
    private DatasetService datasetService;
    @Resource
    private DatasetImageService datasetImageService;
    @Resource
    private DatasetTagService datasetTagService;
    @Resource
    private MinioClient minioClient;

    @Value("${minio.bucket}")
    private String minioBucket;

    public List<DatasetCloudDatasetItemVO> listImageDatasets(Long excludeId) {
        LambdaQueryWrapper<DatasetDO> w = new LambdaQueryWrapper<>();
        w.eq(DatasetDO::getDatasetType, 0);
        if (excludeId != null) {
            w.ne(DatasetDO::getId, excludeId);
        }
        w.orderByDesc(DatasetDO::getUpdateTime);
        return datasetMapper.selectList(w).stream().map(d -> {
            DatasetCloudDatasetItemVO vo = new DatasetCloudDatasetItemVO();
            vo.setId(d.getId());
            vo.setName(d.getName());
            vo.setVersion(d.getVersion());
            return vo;
        }).collect(Collectors.toList());
    }

    public DatasetAnnotationImportRespVO copyFromDataset(Long targetDatasetId, Long sourceDatasetId) {
        validateDataset(sourceDatasetId);
        validateDataset(targetDatasetId);
        if (Objects.equals(targetDatasetId, sourceDatasetId)) {
            DatasetAnnotationImportRespVO resp = new DatasetAnnotationImportRespVO();
            resp.setHint("源与目标相同，已跳过");
            return resp;
        }

        List<DatasetTagDO> sourceTags = datasetTagService.listTagsByDatasetId(sourceDatasetId);
        List<String> classNames = sourceTags.stream()
                .map(DatasetTagDO::getName)
                .filter(Objects::nonNull)
                .collect(Collectors.toList());
        int tagsCreated = datasetTagService.ensureTagsForDataset(targetDatasetId, classNames);

        List<DatasetImageDO> images = datasetImageMapper.selectList(
                new LambdaQueryWrapper<DatasetImageDO>().eq(DatasetImageDO::getDatasetId, sourceDatasetId));

        int copied = 0;
        for (DatasetImageDO src : images) {
            try {
                byte[] data = downloadBytes(src.getPath());
                if (data == null || data.length == 0) continue;
                Integer completed = src.getCompleted();
                datasetImageService.saveImportedImage(
                        targetDatasetId,
                        src.getName(),
                        data,
                        src.getAnnotations(),
                        src.getWidth(),
                        src.getHeigh(),
                        completed);
                copied++;
            } catch (Exception ignored) {
            }
        }

        DatasetAnnotationImportRespVO resp = new DatasetAnnotationImportRespVO();
        resp.setImagesCopied(copied);
        resp.setTagsCreated(tagsCreated);
        resp.setClasses(classNames);
        resp.setHint("已从数据集 " + sourceDatasetId + " 复制");
        return resp;
    }

    public DatasetAnnotationImportRespVO exportToNewDataset(Long sourceDatasetId,
                                                            DatasetAnnotationCloudExportReqVO req) {
        validateDataset(sourceDatasetId);
        DatasetSaveReqVO create = new DatasetSaveReqVO();
        create.setName(req.getName());
        create.setVersion(req.getVersion());
        create.setDatasetType(0);
        create.setDescription("从数据集 " + sourceDatasetId + " 导出");
        Long newId = datasetService.createDataset(create);
        DatasetAnnotationImportRespVO resp = copyFromDataset(newId, sourceDatasetId);
        resp.setCloudDatasetId(newId);
        resp.setCreatedImages(resp.getImagesCopied());
        return resp;
    }

    private void validateDataset(Long id) {
        if (datasetMapper.selectById(id) == null) {
            throw exception(DATASET_NOT_EXISTS);
        }
    }

    private byte[] downloadBytes(String path) throws Exception {
        String object = parseObjectName(path);
        try (InputStream in = minioClient.getObject(GetObjectArgs.builder()
                .bucket(minioBucket).object(object).build())) {
            return in.readAllBytes();
        }
    }

    private static String parseObjectName(String path) {
        try {
            URI uri = new URI(path);
            String query = uri.getQuery();
            if (query != null) {
                return Arrays.stream(query.split("&"))
                        .filter(p -> p.startsWith("prefix="))
                        .map(p -> p.substring(7))
                        .findFirst()
                        .orElse(path);
            }
        } catch (Exception ignored) {
        }
        int start = path.indexOf("prefix=");
        return start >= 0 ? path.substring(start + 7) : path;
    }
}
