package com.basiclab.iot.dataset.service.impl;

import com.basiclab.iot.dataset.domain.dataset.vo.DatasetAnnotationCocoImportReqVO;
import com.basiclab.iot.dataset.domain.dataset.vo.DatasetAnnotationImportResultVO;
import com.basiclab.iot.dataset.domain.dataset.vo.DatasetImageImportTaskRespVO;
import com.basiclab.iot.dataset.domain.dataset.vo.DatasetImageUploadRespVO;
import com.basiclab.iot.dataset.service.DatasetAnnotationService;
import com.basiclab.iot.dataset.service.DatasetImageImportTaskService;
import com.basiclab.iot.dataset.service.DatasetImageService;
import com.basiclab.iot.dataset.service.ImportCancelChecker;
import com.basiclab.iot.dataset.service.ImportCancelledException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.nio.file.Path;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.Executor;
import java.util.function.Supplier;

import static com.basiclab.iot.common.exception.util.ServiceExceptionUtil.exception;
import static com.basiclab.iot.dataset.enums.ErrorCodeConstants.FILE_UPLOAD_FAILED;

@Service
public class DatasetImageImportTaskServiceImpl implements DatasetImageImportTaskService {

    private static final Logger logger = LoggerFactory.getLogger(DatasetImageImportTaskServiceImpl.class);

    @Resource
    @Qualifier("uploadExecutor")
    private Executor uploadExecutor;

    @Resource
    private DatasetImageService datasetImageService;

    @Resource
    private DatasetAnnotationService datasetAnnotationService;

    private final Map<String, ImportTaskState> tasks = new ConcurrentHashMap<>();

    @Override
    public String submitZipImport(Path zipPath, Long datasetId, Runnable onFinished) {
        ImportTaskState state = createTask();
        uploadExecutor.execute(() -> runZipImport(state, zipPath, datasetId, onFinished));
        return state.taskId;
    }

    @Override
    public String submitAnnotationImport(Supplier<DatasetAnnotationImportResultVO> importer) {
        ImportTaskState state = createTask();
        uploadExecutor.execute(() -> runAnnotationImport(state, importer));
        return state.taskId;
    }

    @Override
    public String submitYoloPathImport(Long datasetId, String path) {
        ImportTaskState state = createTask();
        uploadExecutor.execute(() -> runAnnotationImport(state, () ->
                datasetAnnotationService.importYoloPath(datasetId, path, state.asCancelChecker(), state::setProcessedCount)));
        return state.taskId;
    }

    @Override
    public String submitImageFolderPathImport(Long datasetId, String path) {
        ImportTaskState state = createTask();
        uploadExecutor.execute(() -> runAnnotationImport(state, () ->
                datasetAnnotationService.importImageFolderPath(datasetId, path, state.asCancelChecker(), state::setProcessedCount)));
        return state.taskId;
    }

    @Override
    public String submitCocoPathImport(Long datasetId, DatasetAnnotationCocoImportReqVO reqVO) {
        ImportTaskState state = createTask();
        uploadExecutor.execute(() -> runAnnotationImport(state, () ->
                datasetAnnotationService.importCocoPath(datasetId, reqVO, state.asCancelChecker(), state::setProcessedCount)));
        return state.taskId;
    }

    private ImportTaskState createTask() {
        ImportTaskState state = new ImportTaskState();
        state.taskId = UUID.randomUUID().toString().replace("-", "");
        state.status = "processing";
        tasks.put(state.taskId, state);
        return state;
    }

    private void runZipImport(ImportTaskState state, Path zipPath, Long datasetId, Runnable onFinished) {
        try {
            DatasetImageUploadRespVO result = datasetImageService.importZipFromPath(
                    datasetId, zipPath, state::setProcessedCount, state.asCancelChecker());
            state.result = result;
            state.status = "completed";
            logger.info("异步 ZIP 导入完成 taskId={}, 成功={}, 覆盖={}, 失败={}",
                    state.taskId, result.getSuccessCount(), result.getOverwrittenCount(), result.getFailedCount());
        } catch (ImportCancelledException e) {
            state.status = "cancelled";
            logger.info("异步 ZIP 导入已取消 taskId={}", state.taskId);
        } catch (Exception e) {
            state.status = "failed";
            state.errorMessage = e.getMessage();
            logger.error("异步 ZIP 导入失败 taskId={}: {}", state.taskId, e.getMessage(), e);
        } finally {
            if (onFinished != null) {
                try {
                    onFinished.run();
                } catch (Exception e) {
                    logger.warn("导入任务清理回调失败 taskId={}: {}", state.taskId, e.getMessage());
                }
            }
        }
    }

    private void runAnnotationImport(ImportTaskState state, Supplier<DatasetAnnotationImportResultVO> importer) {
        try {
            DatasetAnnotationImportResultVO result = importer.get();
            state.annotationResult = result;
            state.status = "completed";
            logger.info("异步标注导入完成 taskId={}, images={}", state.taskId,
                    result != null ? result.getImagesCopied() : 0);
        } catch (ImportCancelledException e) {
            state.status = "cancelled";
            logger.info("异步标注导入已取消 taskId={}", state.taskId);
        } catch (Exception e) {
            state.status = "failed";
            state.errorMessage = e.getMessage();
            logger.error("异步标注导入失败 taskId={}: {}", state.taskId, e.getMessage(), e);
        }
    }

    @Override
    public DatasetImageImportTaskRespVO getTask(String taskId) {
        ImportTaskState state = tasks.get(taskId);
        if (state == null) {
            throw exception(FILE_UPLOAD_FAILED, "导入任务不存在或已过期");
        }
        DatasetImageImportTaskRespVO resp = new DatasetImageImportTaskRespVO();
        resp.setTaskId(state.taskId);
        resp.setStatus(state.status);
        resp.setProcessedCount(state.processedCount);
        resp.setResult(state.result);
        resp.setAnnotationResult(state.annotationResult);
        resp.setErrorMessage(state.errorMessage);
        return resp;
    }

    @Override
    public void cancelTask(String taskId) {
        ImportTaskState state = tasks.get(taskId);
        if (state != null) {
            state.cancelled = true;
            logger.info("导入任务收到取消请求 taskId={}", taskId);
        }
    }

    private static class ImportTaskState {
        private String taskId;
        private volatile String status;
        private volatile boolean cancelled;
        private volatile int processedCount;
        private volatile DatasetImageUploadRespVO result;
        private volatile DatasetAnnotationImportResultVO annotationResult;
        private volatile String errorMessage;

        void setProcessedCount(int count) {
            this.processedCount = count;
        }

        ImportCancelChecker asCancelChecker() {
            return () -> cancelled;
        }
    }
}
