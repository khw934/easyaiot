package com.basiclab.iot.dataset.service.annotation;

import com.basiclab.iot.dataset.dal.dataobject.DatasetImageDO;
import com.basiclab.iot.dataset.dal.dataobject.DatasetTagDO;
import com.basiclab.iot.dataset.domain.dataset.vo.DatasetAnnotationExportReqVO;
import com.basiclab.iot.dataset.service.DatasetTagService;
import io.minio.GetObjectArgs;
import io.minio.MinioClient;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.yaml.snakeyaml.Yaml;

import javax.annotation.Resource;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.math.BigDecimal;
import java.net.URI;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.*;
import java.util.stream.Collectors;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

@Component
public class DatasetYoloPackager {

    private static final Logger log = LoggerFactory.getLogger(DatasetYoloPackager.class);

    @Resource
    private MinioClient minioClient;
    @Resource
    private DatasetTagService datasetTagService;

    @Value("${minio.bucket}")
    private String minioBucket;

    public byte[] buildZip(Long datasetId, List<DatasetImageDO> allImages,
                            DatasetAnnotationExportReqVO req) throws Exception {
        Map<String, String> nameToShortcut = DatasetAnnotationParseUtil.nameToShortcutFromTags(
                datasetTagService.listTagsByDatasetId(datasetId));
        Set<String> selected = new HashSet<>(req.getSelectedClasses() != null
                ? req.getSelectedClasses() : Collections.emptyList());

        List<DatasetImageDO> filtered = allImages.stream()
                .filter(img -> matchSampleSelection(img, req.getSampleSelection()))
                .filter(img -> hasSelectedClass(img, selected, nameToShortcut))
                .collect(Collectors.toList());

        BigDecimal trainR = nz(req.getTrainRatio(), new BigDecimal("0.7"));
        BigDecimal valR = nz(req.getValRatio(), new BigDecimal("0.2"));
        BigDecimal testR = nz(req.getTestRatio(), new BigDecimal("0.1"));
        if (trainR.add(valR).add(testR).compareTo(BigDecimal.ONE) != 0) {
            trainR = new BigDecimal("0.7");
            valR = new BigDecimal("0.2");
            testR = new BigDecimal("0.1");
        }

        List<DatasetImageDO> needSplit = filtered.stream()
                .filter(img -> img.getIsTrain() == 0 && img.getIsValidation() == 0 && img.getIsTest() == 0)
                .collect(Collectors.toList());
        Map<Long, String> tempUsage = assignTempUsage(needSplit, trainR, valR, testR);

        Path tempDir = Files.createTempDirectory("export-dataset-" + datasetId);
        try {
            for (String split : Arrays.asList("train", "val", "test")) {
                Files.createDirectories(tempDir.resolve("images/" + split));
                Files.createDirectories(tempDir.resolve("labels/" + split));
            }

            List<String> classNames = datasetTagService.listTagsByDatasetId(datasetId).stream()
                    .map(DatasetTagDO::getName)
                    .filter(Objects::nonNull)
                    .sorted()
                    .collect(Collectors.toList());

            String prefix = req.getExportPrefix() != null ? req.getExportPrefix().trim() : "";

            for (DatasetImageDO image : filtered) {
                String usage = resolveUsage(image, tempUsage);
                String baseName = stripExtension(image.getName());
                String fileName = prefix.isEmpty() ? baseName : prefix + "_" + baseName;
                Path imagePath = tempDir.resolve("images/" + usage + "/" + fileName + extensionOf(image.getName()));
                Path labelPath = tempDir.resolve("labels/" + usage + "/" + fileName + ".txt");
                try {
                    downloadImage(image, imagePath);
                    String labelContent = toYoloLabelContent(image.getAnnotations(), nameToShortcut, selected);
                    Files.writeString(labelPath, labelContent, StandardCharsets.UTF_8);
                } catch (Exception e) {
                    log.warn("导出跳过 {}: {}", image.getName(), e.getMessage());
                }
            }

            Map<String, Object> yaml = new LinkedHashMap<>();
            yaml.put("names", classNames);
            yaml.put("nc", classNames.size());
            yaml.put("train", "images/train");
            yaml.put("val", "images/val");
            yaml.put("test", "images/test");
            Files.writeString(tempDir.resolve("data.yaml"), new Yaml().dump(yaml), StandardCharsets.UTF_8);

            return zipDirectory(tempDir);
        } finally {
            deleteRecursive(tempDir);
        }
    }

    private static boolean matchSampleSelection(DatasetImageDO img, String selection) {
        if (selection == null || "all".equalsIgnoreCase(selection)) return true;
        boolean completed = img.getCompleted() != null && img.getCompleted() == 1;
        if ("annotated".equalsIgnoreCase(selection)) return completed;
        if ("unannotated".equalsIgnoreCase(selection)) return !completed;
        return true;
    }

    private static boolean hasSelectedClass(DatasetImageDO img, Set<String> selected,
                                            Map<String, String> nameToShortcut) {
        if (selected.isEmpty()) return true;
        if (img.getAnnotations() == null || img.getAnnotations().isEmpty()) return false;
        try {
            com.fasterxml.jackson.databind.ObjectMapper mapper = new com.fasterxml.jackson.databind.ObjectMapper();
            List<Map<String, Object>> anns = mapper.readValue(img.getAnnotations(),
                    new com.fasterxml.jackson.core.type.TypeReference<List<Map<String, Object>>>() {});
            for (Map<String, Object> ann : anns) {
                Object labelObj = ann.get("label");
                if (labelObj == null) continue;
                String shortcut = labelObj.toString();
                for (Map.Entry<String, String> e : nameToShortcut.entrySet()) {
                    if (e.getValue().equals(shortcut) && selected.contains(e.getKey())) {
                        return true;
                    }
                }
                if (selected.contains(shortcut)) return true;
            }
        } catch (Exception e) {
            return false;
        }
        return false;
    }

    private String toYoloLabelContent(String annotationsJson, Map<String, String> nameToShortcut,
                                      Set<String> selected) throws Exception {
        if (annotationsJson == null || annotationsJson.isEmpty()) return "";
        com.fasterxml.jackson.databind.ObjectMapper mapper = new com.fasterxml.jackson.databind.ObjectMapper();
        List<Map<String, Object>> annotations = mapper.readValue(annotationsJson,
                new com.fasterxml.jackson.core.type.TypeReference<List<Map<String, Object>>>() {});
        StringBuilder sb = new StringBuilder();
        for (Map<String, Object> annotation : annotations) {
            Object labelObj = annotation.get("label");
            if (labelObj == null) continue;
            int classId;
            try {
                classId = Integer.parseInt(labelObj.toString());
            } catch (NumberFormatException e) {
                continue;
            }
            boolean classSelected = false;
            for (Map.Entry<String, String> entry : nameToShortcut.entrySet()) {
                if (entry.getValue().equals(String.valueOf(classId)) && selected.contains(entry.getKey())) {
                    classSelected = true;
                    break;
                }
            }
            if (!selected.isEmpty() && !classSelected) continue;

            @SuppressWarnings("unchecked")
            List<Map<String, Double>> points = (List<Map<String, Double>>) annotation.get("points");
            if (points == null || points.size() != 4) continue;
            double[] xs = new double[4];
            double[] ys = new double[4];
            for (int i = 0; i < 4; i++) {
                xs[i] = points.get(i).get("x");
                ys[i] = points.get(i).get("y");
            }
            double minX = Arrays.stream(xs).min().orElse(0);
            double minY = Arrays.stream(ys).min().orElse(0);
            double maxX = Arrays.stream(xs).max().orElse(0);
            double maxY = Arrays.stream(ys).max().orElse(0);
            double cx = (minX + maxX) / 2.0;
            double cy = (minY + maxY) / 2.0;
            double w = maxX - minX;
            double h = maxY - minY;
            sb.append(String.format(Locale.ROOT, "%d %.5f %.5f %.5f %.5f%n", classId, cx, cy, w, h));
        }
        return sb.toString();
    }

    private void downloadImage(DatasetImageDO image, Path target) throws Exception {
        String object = parseObjectName(image.getPath());
        Files.createDirectories(target.getParent());
        try (InputStream in = minioClient.getObject(GetObjectArgs.builder()
                .bucket(minioBucket).object(object).build())) {
            Files.copy(in, target, java.nio.file.StandardCopyOption.REPLACE_EXISTING);
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

    private static Map<Long, String> assignTempUsage(List<DatasetImageDO> images,
                                                     BigDecimal trainR, BigDecimal valR, BigDecimal testR) {
        Map<Long, String> map = new HashMap<>();
        int total = images.size();
        if (total == 0) return map;
        int trainCount = trainR.multiply(BigDecimal.valueOf(total)).intValue();
        int valCount = valR.multiply(BigDecimal.valueOf(total)).intValue();
        Collections.shuffle(images);
        for (int i = 0; i < images.size(); i++) {
            String usage;
            if (i < trainCount) usage = "train";
            else if (i < trainCount + valCount) usage = "val";
            else usage = "test";
            map.put(images.get(i).getId(), usage);
        }
        return map;
    }

    private static String resolveUsage(DatasetImageDO image, Map<Long, String> temp) {
        if (image.getIsTrain() != null && image.getIsTrain() == 1) return "train";
        if (image.getIsValidation() != null && image.getIsValidation() == 1) return "val";
        if (image.getIsTest() != null && image.getIsTest() == 1) return "test";
        return temp.getOrDefault(image.getId(), "train");
    }

    private static byte[] zipDirectory(Path dir) throws Exception {
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        try (ZipOutputStream zos = new ZipOutputStream(baos)) {
            Files.walk(dir).filter(Files::isRegularFile).forEach(file -> {
                try {
                    String entryName = dir.relativize(file).toString().replace('\\', '/');
                    zos.putNextEntry(new ZipEntry(entryName));
                    Files.copy(file, zos);
                    zos.closeEntry();
                } catch (Exception e) {
                    throw new RuntimeException(e);
                }
            });
        }
        return baos.toByteArray();
    }

    private static void deleteRecursive(Path path) {
        try {
            Files.walk(path).sorted(Comparator.reverseOrder()).forEach(p -> {
                try {
                    Files.deleteIfExists(p);
                } catch (Exception ignored) {
                }
            });
        } catch (Exception ignored) {
        }
    }

    private static BigDecimal nz(BigDecimal v, BigDecimal d) {
        return v != null ? v : d;
    }

    private static String stripExtension(String name) {
        int dot = name.lastIndexOf('.');
        return dot > 0 ? name.substring(0, dot) : name;
    }

    private static String extensionOf(String name) {
        int dot = name.lastIndexOf('.');
        return dot > 0 ? name.substring(dot) : ".jpg";
    }
}
