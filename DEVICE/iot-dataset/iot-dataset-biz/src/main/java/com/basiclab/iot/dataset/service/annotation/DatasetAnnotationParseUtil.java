package com.basiclab.iot.dataset.service.annotation;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.Stream;

/**
 * LabelMe / YOLO / COCO 解析为标注工具 JSON（label=shortcut，points 四点归一化坐标）
 */
public final class DatasetAnnotationParseUtil {

    private static final ObjectMapper MAPPER = new ObjectMapper();

    private DatasetAnnotationParseUtil() {
    }

    public static boolean isImageFile(String name) {
        if (name == null) return false;
        String lower = name.toLowerCase(Locale.ROOT);
        return lower.endsWith(".jpg") || lower.endsWith(".jpeg") || lower.endsWith(".png")
                || lower.endsWith(".bmp") || lower.endsWith(".gif") || lower.endsWith(".webp");
    }

    public static List<String> readClassNamesFromYoloRoot(Path root) throws IOException {
        Path classesTxt = root.resolve("classes.txt");
        if (Files.isRegularFile(classesTxt)) {
            return Files.readAllLines(classesTxt, StandardCharsets.UTF_8).stream()
                    .map(String::trim).filter(s -> !s.isEmpty()).collect(Collectors.toList());
        }
        Path dataYaml = root.resolve("data.yaml");
        if (Files.isRegularFile(dataYaml)) {
            String content = Files.readString(dataYaml, StandardCharsets.UTF_8);
            for (String line : content.split("\n")) {
                String trimmed = line.trim();
                if (trimmed.startsWith("names:")) {
                    int lb = trimmed.indexOf('[');
                    int rb = trimmed.indexOf(']');
                    if (lb >= 0 && rb > lb) {
                        String inner = trimmed.substring(lb + 1, rb);
                        return Arrays.stream(inner.split(","))
                                .map(s -> s.trim().replaceAll("^['\"]|['\"]$", ""))
                                .filter(s -> !s.isEmpty())
                                .collect(Collectors.toList());
                    }
                }
            }
        }
        return Collections.emptyList();
    }

    public static Map<String, String> buildNameToShortcut(Map<String, String> nameToShortcut,
                                                          List<String> classNames,
                                                          java.util.function.BiFunction<String, Integer, String> shortcutResolver) {
        Map<String, String> map = new LinkedHashMap<>(nameToShortcut);
        for (int i = 0; i < classNames.size(); i++) {
            String name = classNames.get(i).trim();
            if (!name.isEmpty() && !map.containsKey(name)) {
                map.put(name, shortcutResolver.apply(name, i));
            }
        }
        return map;
    }

    public static String parseLabelmeJson(byte[] jsonBytes, Map<String, String> nameToShortcut,
                                        int imgW, int imgH) throws IOException {
        JsonNode root = MAPPER.readTree(jsonBytes);
        ArrayNode shapes = root.has("shapes") && root.get("shapes").isArray()
                ? (ArrayNode) root.get("shapes") : MAPPER.createArrayNode();
        if (root.has("imageWidth") && root.get("imageWidth").isInt()) {
            imgW = root.get("imageWidth").asInt(imgW);
        }
        if (root.has("imageHeight") && root.get("imageHeight").isInt()) {
            imgH = root.get("imageHeight").asInt(imgH);
        }
        if (imgW <= 0 || imgH <= 0) {
            return null;
        }
        ArrayNode annotations = MAPPER.createArrayNode();
        int idx = 0;
        for (JsonNode shape : shapes) {
            String labelName = shape.has("label") ? shape.get("label").asText("").trim() : "";
            if (labelName.isEmpty()) continue;
            String shortcut = nameToShortcut.getOrDefault(labelName, labelName);
            JsonNode pointsNode = shape.get("points");
            if (pointsNode == null || !pointsNode.isArray() || pointsNode.size() < 2) continue;
            double minX = Double.MAX_VALUE, minY = Double.MAX_VALUE;
            double maxX = Double.MIN_VALUE, maxY = Double.MIN_VALUE;
            for (JsonNode pt : pointsNode) {
                if (!pt.isArray() || pt.size() < 2) continue;
                double px = pt.get(0).asDouble();
                double py = pt.get(1).asDouble();
                minX = Math.min(minX, px);
                minY = Math.min(minY, py);
                maxX = Math.max(maxX, px);
                maxY = Math.max(maxY, py);
            }
            if (minX == Double.MAX_VALUE) continue;
            ObjectNode ann = buildRectAnnotation(shortcut, minX / imgW, minY / imgH, maxX / imgW, maxY / imgH, idx++);
            annotations.add(ann);
        }
        if (annotations.isEmpty()) return null;
        return MAPPER.writeValueAsString(annotations);
    }

    public static String parseYoloLabelFile(byte[] txtBytes, Map<String, String> classIndexToShortcut,
                                            int classCount) throws IOException {
        String content = new String(txtBytes, StandardCharsets.UTF_8);
        ArrayNode annotations = MAPPER.createArrayNode();
        int idx = 0;
        for (String line : content.split("\n")) {
            line = line.trim();
            if (line.isEmpty()) continue;
            String[] parts = line.split("\\s+");
            if (parts.length < 5) continue;
            int classId = Integer.parseInt(parts[0]);
            double cx = Double.parseDouble(parts[1]);
            double cy = Double.parseDouble(parts[2]);
            double w = Double.parseDouble(parts[3]);
            double h = Double.parseDouble(parts[4]);
            String shortcut = classIndexToShortcut.getOrDefault(String.valueOf(classId),
                    classId < classCount ? String.valueOf(classId + 1) : String.valueOf(classId));
            double minX = cx - w / 2.0;
            double minY = cy - h / 2.0;
            double maxX = cx + w / 2.0;
            double maxY = cy + h / 2.0;
            annotations.add(buildRectAnnotation(shortcut, minX, minY, maxX, maxY, idx++));
        }
        if (annotations.isEmpty()) return null;
        return MAPPER.writeValueAsString(annotations);
    }

    public static Map<String, String> buildClassIndexToShortcut(List<String> classNames,
                                                                Map<String, String> nameToShortcut) {
        Map<String, String> map = new HashMap<>();
        for (int i = 0; i < classNames.size(); i++) {
            String name = classNames.get(i).trim();
            String shortcut = nameToShortcut.get(name);
            if (shortcut == null) {
                shortcut = String.valueOf(i + 1);
            }
            map.put(String.valueOf(i), shortcut);
        }
        return map;
    }

    public static Map<String, String> nameToShortcutFromTags(List<com.basiclab.iot.dataset.dal.dataobject.DatasetTagDO> tags) {
        Map<String, String> map = new LinkedHashMap<>();
        for (com.basiclab.iot.dataset.dal.dataobject.DatasetTagDO t : tags) {
            if (t.getName() != null && t.getShortcut() != null) {
                map.put(t.getName().trim(), String.valueOf(t.getShortcut()));
            }
        }
        return map;
    }

    public static List<String> parseCocoAndCollectClasses(Path cocoJson) throws IOException {
        JsonNode root = MAPPER.readTree(Files.readAllBytes(cocoJson));
        Set<String> names = new LinkedHashSet<>();
        if (root.has("categories") && root.get("categories").isArray()) {
            for (JsonNode cat : root.get("categories")) {
                if (cat.has("name")) {
                    names.add(cat.get("name").asText().trim());
                }
            }
        }
        return new ArrayList<>(names);
    }

    public static Map<Long, String> cocoCategoryIdToName(Path cocoJson) throws IOException {
        JsonNode root = MAPPER.readTree(Files.readAllBytes(cocoJson));
        Map<Long, String> map = new HashMap<>();
        if (root.has("categories") && root.get("categories").isArray()) {
            for (JsonNode cat : root.get("categories")) {
                map.put(cat.get("id").asLong(), cat.get("name").asText("").trim());
            }
        }
        return map;
    }

    public static Map<String, Long> cocoFileNameToImageId(Path cocoJson) throws IOException {
        JsonNode root = MAPPER.readTree(Files.readAllBytes(cocoJson));
        Map<String, Long> map = new HashMap<>();
        if (root.has("images") && root.get("images").isArray()) {
            for (JsonNode img : root.get("images")) {
                String fileName = img.has("file_name") ? img.get("file_name").asText() : "";
                map.put(fileName, img.get("id").asLong());
                int slash = Math.max(fileName.lastIndexOf('/'), fileName.lastIndexOf('\\'));
                if (slash >= 0) {
                    map.put(fileName.substring(slash + 1), img.get("id").asLong());
                }
            }
        }
        return map;
    }

    public static Map<Long, List<JsonNode>> cocoAnnotationsByImageId(Path cocoJson) throws IOException {
        JsonNode root = MAPPER.readTree(Files.readAllBytes(cocoJson));
        Map<Long, List<JsonNode>> map = new HashMap<>();
        if (root.has("annotations") && root.get("annotations").isArray()) {
            for (JsonNode ann : root.get("annotations")) {
                long imageId = ann.get("image_id").asLong();
                map.computeIfAbsent(imageId, k -> new ArrayList<>()).add(ann);
            }
        }
        return map;
    }

    public static String cocoAnnotationsToJson(List<JsonNode> anns, Map<Long, String> catIdToName,
                                               Map<String, String> nameToShortcut,
                                               int imgW, int imgH) throws IOException {
        ArrayNode annotations = MAPPER.createArrayNode();
        int idx = 0;
        for (JsonNode ann : anns) {
            if (!ann.has("bbox")) continue;
            JsonNode bbox = ann.get("bbox");
            if (bbox == null || bbox.size() < 4) continue;
            double x = bbox.get(0).asDouble();
            double y = bbox.get(1).asDouble();
            double w = bbox.get(2).asDouble();
            double h = bbox.get(3).asDouble();
            long catId = ann.get("category_id").asLong();
            String labelName = catIdToName.getOrDefault(catId, String.valueOf(catId));
            String shortcut = nameToShortcut.getOrDefault(labelName, labelName);
            if (imgW <= 0 || imgH <= 0) continue;
            annotations.add(buildRectAnnotation(shortcut, x / imgW, y / imgH, (x + w) / imgW, (y + h) / imgH, idx++));
        }
        if (annotations.isEmpty()) return null;
        return MAPPER.writeValueAsString(annotations);
    }

    public static ObjectNode buildRectAnnotation(String shortcut, double minX, double minY,
                                                 double maxX, double maxY, int id) {
        ObjectNode ann = MAPPER.createObjectNode();
        ann.put("id", "import-" + id);
        ann.put("type", "rectangle");
        ann.put("label", shortcut);
        ArrayNode points = MAPPER.createArrayNode();
        points.add(point(minX, minY));
        points.add(point(maxX, minY));
        points.add(point(maxX, maxY));
        points.add(point(minX, maxY));
        ann.set("points", points);
        return ann;
    }

    private static ObjectNode point(double x, double y) {
        ObjectNode p = MAPPER.createObjectNode();
        p.put("x", clamp01(x));
        p.put("y", clamp01(y));
        return p;
    }

    private static double clamp01(double v) {
        return Math.max(0, Math.min(1, v));
    }

    public static Stream<Path> walkImages(Path root) throws IOException {
        if (!Files.isDirectory(root)) {
            return Stream.empty();
        }
        return Files.walk(root)
                .filter(Files::isRegularFile)
                .filter(p -> isImageFile(p.getFileName().toString()));
    }

    public static Path findCocoJson(Path root) throws IOException {
        try (Stream<Path> s = Files.walk(root, 4)) {
            return s.filter(Files::isRegularFile)
                    .filter(p -> {
                        String n = p.getFileName().toString().toLowerCase(Locale.ROOT);
                        return n.contains("instances") && n.endsWith(".json");
                    })
                    .findFirst()
                    .orElse(null);
        }
    }

    public static int[] readImageDimensions(byte[] imageBytes) {
        try {
            java.io.ByteArrayInputStream bis = new java.io.ByteArrayInputStream(imageBytes);
            java.awt.image.BufferedImage img = javax.imageio.ImageIO.read(bis);
            if (img != null) {
                return new int[]{img.getWidth(), img.getHeight()};
            }
        } catch (Exception ignored) {
        }
        return new int[]{0, 0};
    }
}
