package com.basiclab.iot.dataset.service;

/**
 * 导入任务协作式取消检查
 */
@FunctionalInterface
public interface ImportCancelChecker {

    ImportCancelChecker NONE = () -> false;

    boolean isCancelled();

    default void throwIfCancelled() {
        if (isCancelled()) {
            throw new ImportCancelledException();
        }
    }
}
