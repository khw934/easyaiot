package com.basiclab.iot.dataset.service.annotation;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.TimeUnit;

import static com.basiclab.iot.common.exception.util.ServiceExceptionUtil.exception;
import static com.basiclab.iot.dataset.enums.ErrorCodeConstants.FILE_UPLOAD_FAILED;

@Component
public class DatasetVideoFrameExtractor {

    private static final Logger log = LoggerFactory.getLogger(DatasetVideoFrameExtractor.class);

    public List<Path> extractFrames(MultipartFile video, int frameInterval) throws IOException {
        if (frameInterval < 1) {
            frameInterval = 1;
        }
        Path tempDir = Files.createTempDirectory("dataset-video-frames-");
        Path inputVideo = tempDir.resolve("input" + guessExtension(video.getOriginalFilename()));
        Files.write(inputVideo, video.getBytes());

        Path outputPattern = tempDir.resolve("frame_%06d.jpg");
        List<String> cmd = new ArrayList<>();
        cmd.add("ffmpeg");
        cmd.add("-y");
        cmd.add("-i");
        cmd.add(inputVideo.toAbsolutePath().toString());
        cmd.add("-vf");
        cmd.add("select='not(mod(n\\," + frameInterval + "))'");
        cmd.add("-vsync");
        cmd.add("vfr");
        cmd.add(outputPattern.toAbsolutePath().toString());

        ProcessBuilder pb = new ProcessBuilder(cmd);
        pb.redirectErrorStream(true);
        Process process;
        try {
            process = pb.start();
        } catch (IOException e) {
            cleanupDir(tempDir);
            throw exception(FILE_UPLOAD_FAILED, "无法启动 ffmpeg，请确认服务器已安装并在 PATH 中");
        }

        StringBuilder output = new StringBuilder();
        try (BufferedReader reader = new BufferedReader(
                new InputStreamReader(process.getInputStream(), StandardCharsets.UTF_8))) {
            String line;
            while ((line = reader.readLine()) != null) {
                output.append(line).append('\n');
            }
        }

        boolean finished;
        try {
            finished = process.waitFor(5, TimeUnit.MINUTES);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            process.destroyForcibly();
            cleanupDir(tempDir);
            throw exception(FILE_UPLOAD_FAILED, "视频抽帧被中断");
        }
        if (!finished) {
            process.destroyForcibly();
            cleanupDir(tempDir);
            throw exception(FILE_UPLOAD_FAILED, "视频抽帧超时");
        }
        if (process.exitValue() != 0) {
            log.warn("ffmpeg exit {}: {}", process.exitValue(), output);
            cleanupDir(tempDir);
            throw exception(FILE_UPLOAD_FAILED, "视频抽帧失败，请检查视频格式与 ffmpeg");
        }

        List<Path> frames = new ArrayList<>();
        try (var stream = Files.list(tempDir)) {
            stream.filter(p -> p.getFileName().toString().startsWith("frame_")
                            && p.getFileName().toString().endsWith(".jpg"))
                    .sorted()
                    .forEach(frames::add);
        }
        if (frames.isEmpty()) {
            cleanupDir(tempDir);
            throw exception(FILE_UPLOAD_FAILED, "未抽取到有效帧");
        }
        return frames;
    }

    private static String guessExtension(String name) {
        if (name == null) return ".mp4";
        int dot = name.lastIndexOf('.');
        if (dot > 0 && dot < name.length() - 1) {
            return name.substring(dot);
        }
        return ".mp4";
    }

    public static void cleanupDir(Path dir) {
        if (dir == null) return;
        try {
            Files.walk(dir)
                    .sorted(java.util.Comparator.reverseOrder())
                    .forEach(p -> {
                        try {
                            Files.deleteIfExists(p);
                        } catch (IOException ignored) {
                        }
                    });
        } catch (IOException ignored) {
        }
    }
}
