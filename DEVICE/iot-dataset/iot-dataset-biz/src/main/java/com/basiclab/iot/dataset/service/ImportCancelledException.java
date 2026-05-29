package com.basiclab.iot.dataset.service;

/**
 * 导入任务被用户取消
 */
public class ImportCancelledException extends RuntimeException {

    public ImportCancelledException() {
        super("导入已取消");
    }
}
