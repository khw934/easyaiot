--
-- PostgreSQL database dump
--

\restrict yFN15qrM4VaMwHFJsmljT5DBRLIW8AOVZSagKd4cUGeMB25t7hza3ID3EJlVPGF

-- Dumped from database version 18.4 (Debian 18.4-1.pgdg13+1)
-- Dumped by pg_dump version 18.4 (Debian 18.4-1.pgdg13+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

DROP DATABASE IF EXISTS "iot-video20";
--
-- Name: iot-video20; Type: DATABASE; Schema: -; Owner: -
--

CREATE DATABASE "iot-video20" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.utf8';


\unrestrict yFN15qrM4VaMwHFJsmljT5DBRLIW8AOVZSagKd4cUGeMB25t7hza3ID3EJlVPGF
\encoding SQL_ASCII
\connect -reuse-previous=on "dbname='iot-video20'"
\restrict yFN15qrM4VaMwHFJsmljT5DBRLIW8AOVZSagKd4cUGeMB25t7hza3ID3EJlVPGF

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: alert; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.alert (
    id integer NOT NULL,
    object character varying(30) NOT NULL,
    event character varying(30) NOT NULL,
    region character varying(30),
    information text,
    "time" timestamp with time zone DEFAULT now() NOT NULL,
    device_id character varying(100) NOT NULL,
    device_name character varying(100) NOT NULL,
    image_path character varying(500),
    image_url character varying(500),
    record_path character varying(200),
    task_type character varying(20),
    task_id integer,
    task_name character varying(255),
    notify_users text,
    channels text,
    notification_sent boolean NOT NULL,
    notification_sent_time timestamp without time zone
);


--
-- Name: COLUMN alert.image_path; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.alert.image_path IS '本地图片路径（算法落盘）';


--
-- Name: COLUMN alert.image_url; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.alert.image_url IS 'MinIO 下载路径（/api/v1/buckets/.../objects/download?prefix=...）';


--
-- Name: COLUMN alert.task_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.alert.task_type IS '告警事件类型[realtime:实时算法任务,snap:抓拍算法任务]';


--
-- Name: COLUMN alert.task_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.alert.task_id IS '关联的任务ID';


--
-- Name: COLUMN alert.task_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.alert.task_name IS '关联的任务名称';


--
-- Name: COLUMN alert.notify_users; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.alert.notify_users IS '通知人列表（JSON格式，格式：[{"phone": "xxx", "email": "xxx", "name": "xxx"}, ...]）';


--
-- Name: COLUMN alert.channels; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.alert.channels IS '通知渠道配置（JSON格式，格式：[{"method": "sms", "template_id": "xxx"}, ...]）';


--
-- Name: COLUMN alert.notification_sent; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.alert.notification_sent IS '是否已发送通知';


--
-- Name: COLUMN alert.notification_sent_time; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.alert.notification_sent_time IS '通知发送时间';


--
-- Name: alert_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.alert_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: alert_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.alert_id_seq OWNED BY public.alert.id;


--
-- Name: algorithm_model_service; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.algorithm_model_service (
    id integer NOT NULL,
    task_id integer NOT NULL,
    service_name character varying(255) NOT NULL,
    service_url character varying(500) NOT NULL,
    service_type character varying(100),
    model_id integer,
    threshold double precision,
    request_method character varying(10) NOT NULL,
    request_headers text,
    request_body_template text,
    timeout integer NOT NULL,
    is_enabled boolean NOT NULL,
    sort_order integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: COLUMN algorithm_model_service.task_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.algorithm_model_service.task_id IS '所属算法任务ID';


--
-- Name: COLUMN algorithm_model_service.service_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.algorithm_model_service.service_name IS '服务名称';


--
-- Name: COLUMN algorithm_model_service.service_url; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.algorithm_model_service.service_url IS 'AI模型服务请求接口URL';


--
-- Name: COLUMN algorithm_model_service.service_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.algorithm_model_service.service_type IS '服务类型[FIRE:火焰烟雾检测,CROWD:人群聚集计数,SMOKE:吸烟检测等]';


--
-- Name: COLUMN algorithm_model_service.model_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.algorithm_model_service.model_id IS '关联的模型ID';


--
-- Name: COLUMN algorithm_model_service.threshold; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.algorithm_model_service.threshold IS '检测阈值';


--
-- Name: COLUMN algorithm_model_service.request_method; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.algorithm_model_service.request_method IS '请求方法[GET,POST]';


--
-- Name: COLUMN algorithm_model_service.request_headers; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.algorithm_model_service.request_headers IS '请求头（JSON格式）';


--
-- Name: COLUMN algorithm_model_service.request_body_template; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.algorithm_model_service.request_body_template IS '请求体模板（JSON格式，支持变量替换）';


--
-- Name: COLUMN algorithm_model_service.timeout; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.algorithm_model_service.timeout IS '请求超时时间（秒）';


--
-- Name: COLUMN algorithm_model_service.is_enabled; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.algorithm_model_service.is_enabled IS '是否启用';


--
-- Name: COLUMN algorithm_model_service.sort_order; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.algorithm_model_service.sort_order IS '排序顺序';


--
-- Name: algorithm_model_service_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.algorithm_model_service_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: algorithm_model_service_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.algorithm_model_service_id_seq OWNED BY public.algorithm_model_service.id;


--
-- Name: algorithm_task; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.algorithm_task (
    id integer NOT NULL,
    task_name character varying(255) NOT NULL,
    task_code character varying(255) NOT NULL,
    task_type character varying(20) NOT NULL,
    model_ids text,
    model_names text,
    extract_interval integer NOT NULL,
    rtmp_input_url character varying(500),
    rtmp_output_url character varying(500),
    tracking_enabled boolean NOT NULL,
    tracking_similarity_threshold double precision NOT NULL,
    tracking_max_age integer NOT NULL,
    tracking_smooth_alpha double precision NOT NULL,
    alert_event_enabled boolean NOT NULL,
    alert_event_suppress_time integer NOT NULL,
    face_detection_enabled boolean NOT NULL,
    plate_detection_enabled boolean NOT NULL,
    alert_notification_enabled boolean NOT NULL,
    alert_notification_config text,
    alarm_suppress_time integer NOT NULL,
    last_notify_time timestamp without time zone,
    space_id integer,
    cron_expression character varying(255),
    frame_skip integer NOT NULL,
    status smallint NOT NULL,
    is_enabled boolean NOT NULL,
    run_status character varying(20) NOT NULL,
    exception_reason character varying(500),
    service_server_ip character varying(45),
    service_port integer,
    service_process_id integer,
    service_last_heartbeat timestamp without time zone,
    service_log_path character varying(500),
    total_frames integer NOT NULL,
    total_detections integer NOT NULL,
    total_captures integer NOT NULL,
    last_process_time timestamp without time zone,
    last_success_time timestamp without time zone,
    last_capture_time timestamp without time zone,
    description character varying(500),
    defense_mode character varying(20) NOT NULL,
    defense_schedule text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: COLUMN algorithm_task.task_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.algorithm_task.task_name IS '任务名称';


--
-- Name: COLUMN algorithm_task.task_code; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.algorithm_task.task_code IS '任务编号（唯一标识）';


--
-- Name: COLUMN algorithm_task.task_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.algorithm_task.task_type IS '任务类型[realtime:实时算法任务,snap:抓拍算法任务]';


--
-- Name: COLUMN algorithm_task.model_ids; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.algorithm_task.model_ids IS '关联的模型ID列表（JSON格式，如[1,2,3]）';


--
-- Name: COLUMN algorithm_task.model_names; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.algorithm_task.model_names IS '关联的模型名称列表（逗号分隔，冗余字段，用于快速显示）';


--
-- Name: COLUMN algorithm_task.extract_interval; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.algorithm_task.extract_interval IS '抽帧间隔（每N帧抽一次，仅实时算法任务）';


--
-- Name: COLUMN algorithm_task.rtmp_input_url; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.algorithm_task.rtmp_input_url IS 'RTMP输入流地址（仅实时算法任务）';


--
-- Name: COLUMN algorithm_task.rtmp_output_url; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.algorithm_task.rtmp_output_url IS 'RTMP输出流地址（仅实时算法任务）';


--
-- Name: COLUMN algorithm_task.tracking_enabled; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.algorithm_task.tracking_enabled IS '是否启用目标追踪';


--
-- Name: COLUMN algorithm_task.tracking_similarity_threshold; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.algorithm_task.tracking_similarity_threshold IS '追踪相似度阈值';


--
-- Name: COLUMN algorithm_task.tracking_max_age; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.algorithm_task.tracking_max_age IS '追踪目标最大存活帧数';


--
-- Name: COLUMN algorithm_task.tracking_smooth_alpha; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.algorithm_task.tracking_smooth_alpha IS '追踪平滑系数';


--
-- Name: COLUMN algorithm_task.alert_event_enabled; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.algorithm_task.alert_event_enabled IS '是否启用告警事件';


--
-- Name: COLUMN algorithm_task.alert_event_suppress_time; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.algorithm_task.alert_event_suppress_time IS '告警事件抑制时间（秒），同一设备两次上报告警事件的最小间隔，减轻Kafka积压，默认5秒';


--
-- Name: COLUMN algorithm_task.face_detection_enabled; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.algorithm_task.face_detection_enabled IS '是否启用人脸检测';


--
-- Name: COLUMN algorithm_task.plate_detection_enabled; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.algorithm_task.plate_detection_enabled IS '是否启用车牌检测';


--
-- Name: COLUMN algorithm_task.alert_notification_enabled; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.algorithm_task.alert_notification_enabled IS '是否启用告警通知';


--
-- Name: COLUMN algorithm_task.alert_notification_config; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.algorithm_task.alert_notification_config IS '告警通知配置（JSON格式，包含通知渠道和模板配置，格式：{"channels": [{"method": "sms", "template_id": "xxx", "template_name": "xxx"}, ...]}）';


--
-- Name: COLUMN algorithm_task.alarm_suppress_time; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.algorithm_task.alarm_suppress_time IS '告警通知抑制时间（秒），防止频繁通知，默认5分钟';


--
-- Name: COLUMN algorithm_task.last_notify_time; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.algorithm_task.last_notify_time IS '最后通知时间';


--
-- Name: COLUMN algorithm_task.space_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.algorithm_task.space_id IS '所属抓拍空间ID（仅抓拍算法任务）';


--
-- Name: COLUMN algorithm_task.cron_expression; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.algorithm_task.cron_expression IS 'Cron表达式（仅抓拍算法任务）';


--
-- Name: COLUMN algorithm_task.frame_skip; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.algorithm_task.frame_skip IS '抽帧间隔（每N帧抓一次，仅抓拍算法任务）';


--
-- Name: COLUMN algorithm_task.status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.algorithm_task.status IS '状态[0:正常,1:异常]';


--
-- Name: COLUMN algorithm_task.is_enabled; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.algorithm_task.is_enabled IS '是否启用[0:停用,1:启用]';


--
-- Name: COLUMN algorithm_task.run_status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.algorithm_task.run_status IS '运行状态[running:运行中,stopped:已停止,restarting:重启中]';


--
-- Name: COLUMN algorithm_task.exception_reason; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.algorithm_task.exception_reason IS '异常原因';


--
-- Name: COLUMN algorithm_task.service_server_ip; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.algorithm_task.service_server_ip IS '服务运行服务器IP';


--
-- Name: COLUMN algorithm_task.service_port; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.algorithm_task.service_port IS '服务端口';


--
-- Name: COLUMN algorithm_task.service_process_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.algorithm_task.service_process_id IS '服务进程ID';


--
-- Name: COLUMN algorithm_task.service_last_heartbeat; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.algorithm_task.service_last_heartbeat IS '服务最后心跳时间';


--
-- Name: COLUMN algorithm_task.service_log_path; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.algorithm_task.service_log_path IS '服务日志路径';


--
-- Name: COLUMN algorithm_task.total_frames; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.algorithm_task.total_frames IS '总处理帧数';


--
-- Name: COLUMN algorithm_task.total_detections; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.algorithm_task.total_detections IS '总检测次数';


--
-- Name: COLUMN algorithm_task.total_captures; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.algorithm_task.total_captures IS '总抓拍次数（仅抓拍算法任务）';


--
-- Name: COLUMN algorithm_task.last_process_time; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.algorithm_task.last_process_time IS '最后处理时间';


--
-- Name: COLUMN algorithm_task.last_success_time; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.algorithm_task.last_success_time IS '最后成功时间';


--
-- Name: COLUMN algorithm_task.last_capture_time; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.algorithm_task.last_capture_time IS '最后抓拍时间（仅抓拍算法任务）';


--
-- Name: COLUMN algorithm_task.description; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.algorithm_task.description IS '任务描述';


--
-- Name: COLUMN algorithm_task.defense_mode; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.algorithm_task.defense_mode IS '布防模式[full:全防模式,half:半防模式,day:白天模式,night:夜间模式]';


--
-- Name: COLUMN algorithm_task.defense_schedule; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.algorithm_task.defense_schedule IS '布防时段配置（JSON格式，7天×24小时的二维数组）';


--
-- Name: algorithm_task_device; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.algorithm_task_device (
    task_id integer NOT NULL,
    device_id character varying(100) NOT NULL,
    created_at timestamp without time zone
);


--
-- Name: COLUMN algorithm_task_device.task_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.algorithm_task_device.task_id IS '算法任务ID';


--
-- Name: COLUMN algorithm_task_device.device_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.algorithm_task_device.device_id IS '摄像头ID';


--
-- Name: COLUMN algorithm_task_device.created_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.algorithm_task_device.created_at IS '创建时间';


--
-- Name: algorithm_task_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.algorithm_task_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: algorithm_task_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.algorithm_task_id_seq OWNED BY public.algorithm_task.id;


--
-- Name: detection_region; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.detection_region (
    id integer NOT NULL,
    task_id integer NOT NULL,
    region_name character varying(255) NOT NULL,
    region_type character varying(50) NOT NULL,
    points text NOT NULL,
    image_id integer,
    algorithm_type character varying(255),
    algorithm_model_id integer,
    algorithm_threshold double precision,
    algorithm_enabled boolean NOT NULL,
    color character varying(20) NOT NULL,
    opacity double precision NOT NULL,
    is_enabled boolean NOT NULL,
    sort_order integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: COLUMN detection_region.task_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.detection_region.task_id IS '所属任务ID（关联到algorithm_task或snap_task）';


--
-- Name: COLUMN detection_region.region_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.detection_region.region_name IS '区域名称';


--
-- Name: COLUMN detection_region.region_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.detection_region.region_type IS '区域类型[polygon:多边形,rectangle:矩形]';


--
-- Name: COLUMN detection_region.points; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.detection_region.points IS '区域坐标点(JSON格式，归一化坐标0-1)';


--
-- Name: COLUMN detection_region.image_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.detection_region.image_id IS '参考图片ID（用于绘制区域的基准图片）';


--
-- Name: COLUMN detection_region.algorithm_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.detection_region.algorithm_type IS '绑定的算法类型[FIRE:火焰烟雾检测,CROWD:人群聚集计数,SMOKE:吸烟检测等]';


--
-- Name: COLUMN detection_region.algorithm_model_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.detection_region.algorithm_model_id IS '绑定的算法模型ID';


--
-- Name: COLUMN detection_region.algorithm_threshold; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.detection_region.algorithm_threshold IS '算法阈值';


--
-- Name: COLUMN detection_region.algorithm_enabled; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.detection_region.algorithm_enabled IS '是否启用该区域的算法';


--
-- Name: COLUMN detection_region.color; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.detection_region.color IS '区域显示颜色';


--
-- Name: COLUMN detection_region.opacity; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.detection_region.opacity IS '区域透明度(0-1)';


--
-- Name: COLUMN detection_region.is_enabled; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.detection_region.is_enabled IS '是否启用该区域';


--
-- Name: COLUMN detection_region.sort_order; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.detection_region.sort_order IS '排序顺序';


--
-- Name: detection_region_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.detection_region_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: detection_region_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.detection_region_id_seq OWNED BY public.detection_region.id;


--
-- Name: device; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.device (
    id character varying(100) NOT NULL,
    name character varying(100),
    source text NOT NULL,
    rtmp_stream text NOT NULL,
    http_stream text NOT NULL,
    ai_rtmp_stream text,
    ai_http_stream text,
    stream smallint,
    ip character varying(45),
    port smallint,
    username character varying(100),
    password character varying(100),
    mac character varying(17),
    manufacturer character varying(100) NOT NULL,
    model character varying(100) NOT NULL,
    firmware_version character varying(100),
    serial_number character varying(300),
    hardware_id character varying(100),
    support_move boolean,
    support_zoom boolean,
    nvr_id integer,
    nvr_channel smallint NOT NULL,
    rtsp_direct text,
    channel_online boolean,
    connection_status character varying(100),
    enable_forward boolean,
    auto_snap_enabled boolean NOT NULL,
    directory_id integer,
    cover_image_path character varying(500),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: COLUMN device.ai_rtmp_stream; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.device.ai_rtmp_stream IS 'AI推流地址（用于算法任务）';


--
-- Name: COLUMN device.ai_http_stream; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.device.ai_http_stream IS 'AI HTTP地址（用于算法任务）';


--
-- Name: COLUMN device.nvr_channel; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.device.nvr_channel IS 'NVR 通道号，0 表示非 NVR 挂载';


--
-- Name: COLUMN device.rtsp_direct; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.device.rtsp_direct IS '摄像头直连 RTSP（经 NVR 枚举时 rtsp_direct）';


--
-- Name: COLUMN device.channel_online; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.device.channel_online IS 'NVR 通道在线状态';


--
-- Name: COLUMN device.connection_status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.device.connection_status IS 'NVR 通道连接状态/探测备注';


--
-- Name: COLUMN device.auto_snap_enabled; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.device.auto_snap_enabled IS '是否开启自动抓拍[默认不开启]';


--
-- Name: COLUMN device.directory_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.device.directory_id IS '所属目录ID';


--
-- Name: COLUMN device.cover_image_path; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.device.cover_image_path IS '摄像头封面展示图路径';


--
-- Name: device_detection_region; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.device_detection_region (
    id integer NOT NULL,
    device_id character varying(100) NOT NULL,
    region_name character varying(255) NOT NULL,
    region_type character varying(50) NOT NULL,
    points text NOT NULL,
    image_id integer,
    color character varying(20) NOT NULL,
    opacity double precision NOT NULL,
    is_enabled boolean NOT NULL,
    sort_order integer NOT NULL,
    model_ids text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: COLUMN device_detection_region.device_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.device_detection_region.device_id IS '设备ID';


--
-- Name: COLUMN device_detection_region.region_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.device_detection_region.region_name IS '区域名称';


--
-- Name: COLUMN device_detection_region.region_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.device_detection_region.region_type IS '区域类型[polygon:多边形,line:线条]';


--
-- Name: COLUMN device_detection_region.points; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.device_detection_region.points IS '区域坐标点(JSON格式，归一化坐标0-1)';


--
-- Name: COLUMN device_detection_region.image_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.device_detection_region.image_id IS '参考图片ID（用于绘制区域的基准图片）';


--
-- Name: COLUMN device_detection_region.color; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.device_detection_region.color IS '区域显示颜色';


--
-- Name: COLUMN device_detection_region.opacity; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.device_detection_region.opacity IS '区域透明度(0-1)';


--
-- Name: COLUMN device_detection_region.is_enabled; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.device_detection_region.is_enabled IS '是否启用该区域';


--
-- Name: COLUMN device_detection_region.sort_order; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.device_detection_region.sort_order IS '排序顺序';


--
-- Name: COLUMN device_detection_region.model_ids; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.device_detection_region.model_ids IS '关联的算法模型ID列表（JSON格式，如[1,2,3]）';


--
-- Name: device_detection_region_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.device_detection_region_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: device_detection_region_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.device_detection_region_id_seq OWNED BY public.device_detection_region.id;


--
-- Name: device_directory; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.device_directory (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    parent_id integer,
    description character varying(500),
    sort_order integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: COLUMN device_directory.name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.device_directory.name IS '目录名称';


--
-- Name: COLUMN device_directory.parent_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.device_directory.parent_id IS '父目录ID，NULL表示根目录';


--
-- Name: COLUMN device_directory.description; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.device_directory.description IS '目录描述';


--
-- Name: COLUMN device_directory.sort_order; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.device_directory.sort_order IS '排序顺序';


--
-- Name: device_directory_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.device_directory_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: device_directory_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.device_directory_id_seq OWNED BY public.device_directory.id;


--
-- Name: device_storage_config; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.device_storage_config (
    id integer NOT NULL,
    device_id character varying(100) NOT NULL,
    snap_storage_bucket character varying(255),
    snap_storage_max_size bigint,
    snap_storage_cleanup_enabled boolean NOT NULL,
    snap_storage_cleanup_threshold double precision NOT NULL,
    snap_storage_cleanup_ratio double precision NOT NULL,
    video_storage_bucket character varying(255),
    video_storage_max_size bigint,
    video_storage_cleanup_enabled boolean NOT NULL,
    video_storage_cleanup_threshold double precision NOT NULL,
    video_storage_cleanup_ratio double precision NOT NULL,
    last_snap_cleanup_time timestamp without time zone,
    last_video_cleanup_time timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: COLUMN device_storage_config.device_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.device_storage_config.device_id IS '设备ID';


--
-- Name: COLUMN device_storage_config.snap_storage_bucket; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.device_storage_config.snap_storage_bucket IS '抓拍图片存储bucket名称';


--
-- Name: COLUMN device_storage_config.snap_storage_max_size; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.device_storage_config.snap_storage_max_size IS '抓拍图片存储最大空间（字节），0表示不限制';


--
-- Name: COLUMN device_storage_config.snap_storage_cleanup_enabled; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.device_storage_config.snap_storage_cleanup_enabled IS '是否启用抓拍图片自动清理';


--
-- Name: COLUMN device_storage_config.snap_storage_cleanup_threshold; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.device_storage_config.snap_storage_cleanup_threshold IS '抓拍图片清理阈值（使用率超过此值触发清理）';


--
-- Name: COLUMN device_storage_config.snap_storage_cleanup_ratio; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.device_storage_config.snap_storage_cleanup_ratio IS '抓拍图片清理比例（清理最老的30%）';


--
-- Name: COLUMN device_storage_config.video_storage_bucket; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.device_storage_config.video_storage_bucket IS '录像存储bucket名称';


--
-- Name: COLUMN device_storage_config.video_storage_max_size; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.device_storage_config.video_storage_max_size IS '录像存储最大空间（字节），0表示不限制';


--
-- Name: COLUMN device_storage_config.video_storage_cleanup_enabled; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.device_storage_config.video_storage_cleanup_enabled IS '是否启用录像自动清理';


--
-- Name: COLUMN device_storage_config.video_storage_cleanup_threshold; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.device_storage_config.video_storage_cleanup_threshold IS '录像清理阈值（使用率超过此值触发清理）';


--
-- Name: COLUMN device_storage_config.video_storage_cleanup_ratio; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.device_storage_config.video_storage_cleanup_ratio IS '录像清理比例（清理最老的30%）';


--
-- Name: COLUMN device_storage_config.last_snap_cleanup_time; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.device_storage_config.last_snap_cleanup_time IS '最后抓拍图片清理时间';


--
-- Name: COLUMN device_storage_config.last_video_cleanup_time; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.device_storage_config.last_video_cleanup_time IS '最后录像清理时间';


--
-- Name: device_storage_config_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.device_storage_config_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: device_storage_config_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.device_storage_config_id_seq OWNED BY public.device_storage_config.id;


--
-- Name: frame_extractor; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.frame_extractor (
    id integer NOT NULL,
    extractor_name character varying(255) NOT NULL,
    extractor_code character varying(255) NOT NULL,
    extractor_type character varying(50) NOT NULL,
    "interval" integer NOT NULL,
    description character varying(500),
    is_enabled boolean NOT NULL,
    status character varying(20) NOT NULL,
    server_ip character varying(50),
    port integer,
    process_id integer,
    last_heartbeat timestamp without time zone,
    log_path character varying(500),
    task_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: COLUMN frame_extractor.extractor_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.frame_extractor.extractor_name IS '抽帧器名称';


--
-- Name: COLUMN frame_extractor.extractor_code; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.frame_extractor.extractor_code IS '抽帧器编号（唯一标识）';


--
-- Name: COLUMN frame_extractor.extractor_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.frame_extractor.extractor_type IS '抽帧类型[interval:按间隔,time:按时间]';


--
-- Name: COLUMN frame_extractor."interval"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.frame_extractor."interval" IS '抽帧间隔（每N帧抽一次，或每N秒抽一次）';


--
-- Name: COLUMN frame_extractor.description; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.frame_extractor.description IS '描述';


--
-- Name: COLUMN frame_extractor.is_enabled; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.frame_extractor.is_enabled IS '是否启用';


--
-- Name: COLUMN frame_extractor.status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.frame_extractor.status IS '运行状态[running:运行中,stopped:已停止,error:错误]';


--
-- Name: COLUMN frame_extractor.server_ip; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.frame_extractor.server_ip IS '部署的服务器IP';


--
-- Name: COLUMN frame_extractor.port; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.frame_extractor.port IS '服务端口';


--
-- Name: COLUMN frame_extractor.process_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.frame_extractor.process_id IS '进程ID';


--
-- Name: COLUMN frame_extractor.last_heartbeat; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.frame_extractor.last_heartbeat IS '最后上报时间';


--
-- Name: COLUMN frame_extractor.log_path; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.frame_extractor.log_path IS '日志文件路径';


--
-- Name: COLUMN frame_extractor.task_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.frame_extractor.task_id IS '关联的算法任务ID';


--
-- Name: frame_extractor_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.frame_extractor_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: frame_extractor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.frame_extractor_id_seq OWNED BY public.frame_extractor.id;


--
-- Name: image; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.image (
    id integer NOT NULL,
    filename character varying(255) NOT NULL,
    original_filename character varying(255) NOT NULL,
    path character varying(500) NOT NULL,
    width integer NOT NULL,
    height integer NOT NULL,
    created_at timestamp without time zone,
    device_id character varying(100)
);


--
-- Name: image_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.image_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: image_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.image_id_seq OWNED BY public.image.id;


--
-- Name: nvr; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.nvr (
    id integer NOT NULL,
    ip character varying(45) NOT NULL,
    port smallint NOT NULL,
    username character varying(100),
    password character varying(100),
    name character varying(100),
    model character varying(100),
    vendor character varying(32),
    serial_number character varying(300),
    firmware_version character varying(100),
    device_type character varying(100),
    mac character varying(17),
    scheme character varying(8),
    rtsp_url text,
    source character varying(32),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: COLUMN nvr.vendor; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.nvr.vendor IS 'hikvision/dahua 等';


--
-- Name: COLUMN nvr.scheme; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.nvr.scheme IS 'http/https';


--
-- Name: COLUMN nvr.rtsp_url; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.nvr.rtsp_url IS 'NVR 预览/取流 RTSP（对齐 hiktools）';


--
-- Name: COLUMN nvr.source; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.nvr.source IS '探测来源 isapi/dahua_cgi 等';


--
-- Name: nvr_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.nvr_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: nvr_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.nvr_id_seq OWNED BY public.nvr.id;


--
-- Name: playback; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.playback (
    id integer NOT NULL,
    file_path character varying(500) NOT NULL,
    event_time timestamp with time zone NOT NULL,
    device_id character varying(100) NOT NULL,
    device_name character varying(100) NOT NULL,
    duration smallint NOT NULL,
    thumbnail_path character varying(500),
    file_size bigint,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


--
-- Name: playback_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.playback_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: playback_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.playback_id_seq OWNED BY public.playback.id;


--
-- Name: pusher; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pusher (
    id integer NOT NULL,
    pusher_name character varying(255) NOT NULL,
    pusher_code character varying(255) NOT NULL,
    video_stream_enabled boolean NOT NULL,
    video_stream_url character varying(500),
    device_rtmp_mapping text,
    video_stream_format character varying(50) NOT NULL,
    video_stream_quality character varying(50) NOT NULL,
    event_alert_enabled boolean NOT NULL,
    event_alert_url character varying(500),
    event_alert_method character varying(20) NOT NULL,
    event_alert_format character varying(50) NOT NULL,
    event_alert_headers text,
    event_alert_template text,
    description character varying(500),
    is_enabled boolean NOT NULL,
    status character varying(20) NOT NULL,
    server_ip character varying(50),
    port integer,
    process_id integer,
    last_heartbeat timestamp without time zone,
    log_path character varying(500),
    task_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: COLUMN pusher.pusher_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pusher.pusher_name IS '推送器名称';


--
-- Name: COLUMN pusher.pusher_code; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pusher.pusher_code IS '推送器编号（唯一标识）';


--
-- Name: COLUMN pusher.video_stream_enabled; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pusher.video_stream_enabled IS '是否启用推送视频流';


--
-- Name: COLUMN pusher.video_stream_url; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pusher.video_stream_url IS '视频流推送地址（RTMP/RTSP等，单摄像头时使用）';


--
-- Name: COLUMN pusher.device_rtmp_mapping; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pusher.device_rtmp_mapping IS '多摄像头RTMP推送映射（JSON格式，device_id -> rtmp_url）';


--
-- Name: COLUMN pusher.video_stream_format; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pusher.video_stream_format IS '视频流格式[rtmp:RTMP,rtsp:RTSP,webrtc:WebRTC]';


--
-- Name: COLUMN pusher.video_stream_quality; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pusher.video_stream_quality IS '视频流质量[low:低,medium:中,high:高]';


--
-- Name: COLUMN pusher.event_alert_enabled; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pusher.event_alert_enabled IS '是否启用推送事件告警';


--
-- Name: COLUMN pusher.event_alert_url; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pusher.event_alert_url IS '事件告警推送地址（HTTP/WebSocket/Kafka等）';


--
-- Name: COLUMN pusher.event_alert_method; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pusher.event_alert_method IS '事件告警推送方式[http:HTTP,websocket:WebSocket,kafka:Kafka]';


--
-- Name: COLUMN pusher.event_alert_format; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pusher.event_alert_format IS '事件告警数据格式[json:JSON,xml:XML]';


--
-- Name: COLUMN pusher.event_alert_headers; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pusher.event_alert_headers IS '事件告警请求头（JSON格式）';


--
-- Name: COLUMN pusher.event_alert_template; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pusher.event_alert_template IS '事件告警数据模板（JSON格式，支持变量替换）';


--
-- Name: COLUMN pusher.description; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pusher.description IS '描述';


--
-- Name: COLUMN pusher.is_enabled; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pusher.is_enabled IS '是否启用';


--
-- Name: COLUMN pusher.status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pusher.status IS '运行状态[running:运行中,stopped:已停止,error:错误]';


--
-- Name: COLUMN pusher.server_ip; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pusher.server_ip IS '部署的服务器IP';


--
-- Name: COLUMN pusher.port; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pusher.port IS '服务端口';


--
-- Name: COLUMN pusher.process_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pusher.process_id IS '进程ID';


--
-- Name: COLUMN pusher.last_heartbeat; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pusher.last_heartbeat IS '最后上报时间';


--
-- Name: COLUMN pusher.log_path; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pusher.log_path IS '日志文件路径';


--
-- Name: COLUMN pusher.task_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pusher.task_id IS '关联的算法任务ID';


--
-- Name: pusher_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pusher_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pusher_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pusher_id_seq OWNED BY public.pusher.id;


--
-- Name: record_space; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.record_space (
    id integer NOT NULL,
    space_name character varying(255) NOT NULL,
    space_code character varying(255) NOT NULL,
    bucket_name character varying(255) NOT NULL,
    save_mode smallint NOT NULL,
    save_time integer NOT NULL,
    description character varying(500),
    device_id character varying(100),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: COLUMN record_space.space_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.record_space.space_name IS '空间名称';


--
-- Name: COLUMN record_space.space_code; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.record_space.space_code IS '空间编号（唯一标识）';


--
-- Name: COLUMN record_space.bucket_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.record_space.bucket_name IS 'MinIO bucket名称';


--
-- Name: COLUMN record_space.save_mode; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.record_space.save_mode IS '文件保存模式[0:标准存储,1:归档存储]';


--
-- Name: COLUMN record_space.save_time; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.record_space.save_time IS '文件保存时间[0:永久保存,>=7(单位:天)]';


--
-- Name: COLUMN record_space.description; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.record_space.description IS '空间描述';


--
-- Name: COLUMN record_space.device_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.record_space.device_id IS '关联的设备ID（一对一关系）';


--
-- Name: record_space_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.record_space_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: record_space_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.record_space_id_seq OWNED BY public.record_space.id;


--
-- Name: region_model_service; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.region_model_service (
    id integer NOT NULL,
    region_id integer NOT NULL,
    service_name character varying(255) NOT NULL,
    service_url character varying(500) NOT NULL,
    service_type character varying(100),
    model_id integer,
    threshold double precision,
    request_method character varying(10) NOT NULL,
    request_headers text,
    request_body_template text,
    timeout integer NOT NULL,
    is_enabled boolean NOT NULL,
    sort_order integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: COLUMN region_model_service.region_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.region_model_service.region_id IS '所属检测区域ID';


--
-- Name: COLUMN region_model_service.service_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.region_model_service.service_name IS '服务名称';


--
-- Name: COLUMN region_model_service.service_url; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.region_model_service.service_url IS 'AI模型服务请求接口URL';


--
-- Name: COLUMN region_model_service.service_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.region_model_service.service_type IS '服务类型[FIRE:火焰烟雾检测,CROWD:人群聚集计数,SMOKE:吸烟检测等]';


--
-- Name: COLUMN region_model_service.model_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.region_model_service.model_id IS '关联的模型ID';


--
-- Name: COLUMN region_model_service.threshold; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.region_model_service.threshold IS '检测阈值';


--
-- Name: COLUMN region_model_service.request_method; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.region_model_service.request_method IS '请求方法[GET,POST]';


--
-- Name: COLUMN region_model_service.request_headers; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.region_model_service.request_headers IS '请求头（JSON格式）';


--
-- Name: COLUMN region_model_service.request_body_template; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.region_model_service.request_body_template IS '请求体模板（JSON格式，支持变量替换）';


--
-- Name: COLUMN region_model_service.timeout; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.region_model_service.timeout IS '请求超时时间（秒）';


--
-- Name: COLUMN region_model_service.is_enabled; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.region_model_service.is_enabled IS '是否启用';


--
-- Name: COLUMN region_model_service.sort_order; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.region_model_service.sort_order IS '排序顺序';


--
-- Name: region_model_service_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.region_model_service_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: region_model_service_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.region_model_service_id_seq OWNED BY public.region_model_service.id;


--
-- Name: snap_space; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.snap_space (
    id integer NOT NULL,
    space_name character varying(255) NOT NULL,
    space_code character varying(255) NOT NULL,
    bucket_name character varying(255) NOT NULL,
    save_mode smallint NOT NULL,
    save_time integer NOT NULL,
    description character varying(500),
    device_id character varying(100),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: COLUMN snap_space.space_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.snap_space.space_name IS '空间名称';


--
-- Name: COLUMN snap_space.space_code; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.snap_space.space_code IS '空间编号（唯一标识）';


--
-- Name: COLUMN snap_space.bucket_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.snap_space.bucket_name IS 'MinIO bucket名称';


--
-- Name: COLUMN snap_space.save_mode; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.snap_space.save_mode IS '文件保存模式[0:标准存储,1:归档存储]';


--
-- Name: COLUMN snap_space.save_time; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.snap_space.save_time IS '文件保存时间[0:永久保存,>=7(单位:天)]';


--
-- Name: COLUMN snap_space.description; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.snap_space.description IS '空间描述';


--
-- Name: COLUMN snap_space.device_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.snap_space.device_id IS '关联的设备ID（一对一关系）';


--
-- Name: snap_space_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.snap_space_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: snap_space_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.snap_space_id_seq OWNED BY public.snap_space.id;


--
-- Name: snap_task; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.snap_task (
    id integer NOT NULL,
    task_name character varying(255) NOT NULL,
    task_code character varying(255) NOT NULL,
    space_id integer NOT NULL,
    device_id character varying(100) NOT NULL,
    pusher_id integer,
    capture_type smallint NOT NULL,
    cron_expression character varying(255) NOT NULL,
    frame_skip integer NOT NULL,
    algorithm_enabled boolean NOT NULL,
    algorithm_type character varying(255),
    algorithm_model_id integer,
    algorithm_threshold double precision,
    algorithm_night_mode boolean NOT NULL,
    alarm_enabled boolean NOT NULL,
    alarm_type smallint NOT NULL,
    phone_number character varying(500),
    email character varying(500),
    notify_users text,
    notify_methods character varying(100),
    alarm_suppress_time integer NOT NULL,
    last_notify_time timestamp without time zone,
    auto_filename boolean NOT NULL,
    custom_filename_prefix character varying(255),
    status smallint NOT NULL,
    is_enabled boolean NOT NULL,
    exception_reason character varying(500),
    run_status character varying(20) NOT NULL,
    total_captures integer NOT NULL,
    last_capture_time timestamp without time zone,
    last_success_time timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: COLUMN snap_task.task_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.snap_task.task_name IS '任务名称';


--
-- Name: COLUMN snap_task.task_code; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.snap_task.task_code IS '任务编号（唯一标识）';


--
-- Name: COLUMN snap_task.space_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.snap_task.space_id IS '所属抓拍空间ID';


--
-- Name: COLUMN snap_task.device_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.snap_task.device_id IS '设备ID';


--
-- Name: COLUMN snap_task.pusher_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.snap_task.pusher_id IS '关联的推送器ID';


--
-- Name: COLUMN snap_task.capture_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.snap_task.capture_type IS '抓拍类型[0:抽帧,1:抓拍]';


--
-- Name: COLUMN snap_task.cron_expression; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.snap_task.cron_expression IS 'Cron表达式';


--
-- Name: COLUMN snap_task.frame_skip; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.snap_task.frame_skip IS '抽帧间隔（每N帧抓一次）';


--
-- Name: COLUMN snap_task.algorithm_enabled; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.snap_task.algorithm_enabled IS '是否启用算法推理';


--
-- Name: COLUMN snap_task.algorithm_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.snap_task.algorithm_type IS '算法类型[FIRE:火焰烟雾检测,CROWD:人群聚集计数,SMOKE:吸烟检测等]';


--
-- Name: COLUMN snap_task.algorithm_model_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.snap_task.algorithm_model_id IS '算法模型ID（关联AI模块的Model表）';


--
-- Name: COLUMN snap_task.algorithm_threshold; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.snap_task.algorithm_threshold IS '算法阈值';


--
-- Name: COLUMN snap_task.algorithm_night_mode; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.snap_task.algorithm_night_mode IS '是否仅夜间(23点~8点)启用算法';


--
-- Name: COLUMN snap_task.alarm_enabled; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.snap_task.alarm_enabled IS '是否启用告警';


--
-- Name: COLUMN snap_task.alarm_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.snap_task.alarm_type IS '告警类型[0:短信告警,1:邮箱告警,2:短信+邮箱]';


--
-- Name: COLUMN snap_task.phone_number; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.snap_task.phone_number IS '告警手机号[多个用英文逗号分割]';


--
-- Name: COLUMN snap_task.email; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.snap_task.email IS '告警邮箱[多个用英文逗号分割]';


--
-- Name: COLUMN snap_task.notify_users; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.snap_task.notify_users IS '通知人列表（JSON格式，包含用户ID、姓名、手机号、邮箱等）';


--
-- Name: COLUMN snap_task.notify_methods; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.snap_task.notify_methods IS '通知方式[sms:短信,email:邮箱,app:应用内通知，多个用逗号分割]';


--
-- Name: COLUMN snap_task.alarm_suppress_time; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.snap_task.alarm_suppress_time IS '告警通知抑制时间（秒），防止频繁通知，默认5分钟';


--
-- Name: COLUMN snap_task.last_notify_time; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.snap_task.last_notify_time IS '最后通知时间';


--
-- Name: COLUMN snap_task.auto_filename; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.snap_task.auto_filename IS '是否自动命名[0:否,1:是]';


--
-- Name: COLUMN snap_task.custom_filename_prefix; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.snap_task.custom_filename_prefix IS '自定义文件前缀';


--
-- Name: COLUMN snap_task.status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.snap_task.status IS '状态[0:正常,1:异常]';


--
-- Name: COLUMN snap_task.is_enabled; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.snap_task.is_enabled IS '是否启用[0:停用,1:启用]';


--
-- Name: COLUMN snap_task.exception_reason; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.snap_task.exception_reason IS '异常原因';


--
-- Name: COLUMN snap_task.run_status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.snap_task.run_status IS '运行状态[running:运行中,stopped:已停止,restarting:重启中]';


--
-- Name: COLUMN snap_task.total_captures; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.snap_task.total_captures IS '总抓拍次数';


--
-- Name: COLUMN snap_task.last_capture_time; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.snap_task.last_capture_time IS '最后抓拍时间';


--
-- Name: COLUMN snap_task.last_success_time; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.snap_task.last_success_time IS '最后成功时间';


--
-- Name: snap_task_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.snap_task_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: snap_task_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.snap_task_id_seq OWNED BY public.snap_task.id;


--
-- Name: sorter; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sorter (
    id integer NOT NULL,
    sorter_name character varying(255) NOT NULL,
    sorter_code character varying(255) NOT NULL,
    sorter_type character varying(50) NOT NULL,
    sort_order character varying(10) NOT NULL,
    description character varying(500),
    is_enabled boolean NOT NULL,
    status character varying(20) NOT NULL,
    server_ip character varying(50),
    port integer,
    process_id integer,
    last_heartbeat timestamp without time zone,
    log_path character varying(500),
    task_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: COLUMN sorter.sorter_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.sorter.sorter_name IS '排序器名称';


--
-- Name: COLUMN sorter.sorter_code; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.sorter.sorter_code IS '排序器编号（唯一标识）';


--
-- Name: COLUMN sorter.sorter_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.sorter.sorter_type IS '排序类型[confidence:置信度,time:时间,score:分数]';


--
-- Name: COLUMN sorter.sort_order; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.sorter.sort_order IS '排序顺序[asc:升序,desc:降序]';


--
-- Name: COLUMN sorter.description; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.sorter.description IS '描述';


--
-- Name: COLUMN sorter.is_enabled; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.sorter.is_enabled IS '是否启用';


--
-- Name: COLUMN sorter.status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.sorter.status IS '运行状态[running:运行中,stopped:已停止,error:错误]';


--
-- Name: COLUMN sorter.server_ip; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.sorter.server_ip IS '部署的服务器IP';


--
-- Name: COLUMN sorter.port; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.sorter.port IS '服务端口';


--
-- Name: COLUMN sorter.process_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.sorter.process_id IS '进程ID';


--
-- Name: COLUMN sorter.last_heartbeat; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.sorter.last_heartbeat IS '最后上报时间';


--
-- Name: COLUMN sorter.log_path; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.sorter.log_path IS '日志文件路径';


--
-- Name: COLUMN sorter.task_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.sorter.task_id IS '关联的算法任务ID';


--
-- Name: sorter_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sorter_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sorter_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sorter_id_seq OWNED BY public.sorter.id;


--
-- Name: stream_forward_task; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stream_forward_task (
    id integer NOT NULL,
    task_name character varying(255) NOT NULL,
    task_code character varying(255) NOT NULL,
    output_format character varying(50) NOT NULL,
    output_quality character varying(50) NOT NULL,
    output_bitrate character varying(50),
    status smallint NOT NULL,
    is_enabled boolean NOT NULL,
    exception_reason character varying(500),
    service_server_ip character varying(45),
    service_port integer,
    service_process_id integer,
    service_last_heartbeat timestamp without time zone,
    service_log_path character varying(500),
    total_streams integer NOT NULL,
    last_process_time timestamp without time zone,
    last_success_time timestamp without time zone,
    description character varying(500),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: COLUMN stream_forward_task.task_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.stream_forward_task.task_name IS '任务名称';


--
-- Name: COLUMN stream_forward_task.task_code; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.stream_forward_task.task_code IS '任务编号（唯一标识）';


--
-- Name: COLUMN stream_forward_task.output_format; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.stream_forward_task.output_format IS '输出格式[rtmp:RTMP,rtsp:RTSP]';


--
-- Name: COLUMN stream_forward_task.output_quality; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.stream_forward_task.output_quality IS '输出质量[low:低,medium:中,high:高]';


--
-- Name: COLUMN stream_forward_task.output_bitrate; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.stream_forward_task.output_bitrate IS '输出码率（如512k,1M等，为空则使用默认值）';


--
-- Name: COLUMN stream_forward_task.status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.stream_forward_task.status IS '状态[0:正常,1:异常]';


--
-- Name: COLUMN stream_forward_task.is_enabled; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.stream_forward_task.is_enabled IS '是否启用[0:停用,1:启用]';


--
-- Name: COLUMN stream_forward_task.exception_reason; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.stream_forward_task.exception_reason IS '异常原因';


--
-- Name: COLUMN stream_forward_task.service_server_ip; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.stream_forward_task.service_server_ip IS '服务运行服务器IP';


--
-- Name: COLUMN stream_forward_task.service_port; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.stream_forward_task.service_port IS '服务端口';


--
-- Name: COLUMN stream_forward_task.service_process_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.stream_forward_task.service_process_id IS '服务进程ID';


--
-- Name: COLUMN stream_forward_task.service_last_heartbeat; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.stream_forward_task.service_last_heartbeat IS '服务最后心跳时间';


--
-- Name: COLUMN stream_forward_task.service_log_path; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.stream_forward_task.service_log_path IS '服务日志路径';


--
-- Name: COLUMN stream_forward_task.total_streams; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.stream_forward_task.total_streams IS '总推流数';


--
-- Name: COLUMN stream_forward_task.last_process_time; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.stream_forward_task.last_process_time IS '最后处理时间';


--
-- Name: COLUMN stream_forward_task.last_success_time; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.stream_forward_task.last_success_time IS '最后成功时间';


--
-- Name: COLUMN stream_forward_task.description; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.stream_forward_task.description IS '任务描述';


--
-- Name: stream_forward_task_device; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stream_forward_task_device (
    stream_forward_task_id integer NOT NULL,
    device_id character varying(100) NOT NULL,
    created_at timestamp without time zone
);


--
-- Name: COLUMN stream_forward_task_device.stream_forward_task_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.stream_forward_task_device.stream_forward_task_id IS '推流转发任务ID';


--
-- Name: COLUMN stream_forward_task_device.device_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.stream_forward_task_device.device_id IS '摄像头ID';


--
-- Name: COLUMN stream_forward_task_device.created_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.stream_forward_task_device.created_at IS '创建时间';


--
-- Name: stream_forward_task_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.stream_forward_task_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: stream_forward_task_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.stream_forward_task_id_seq OWNED BY public.stream_forward_task.id;


--
-- Name: tracking_target; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tracking_target (
    id integer NOT NULL,
    task_id integer NOT NULL,
    device_id character varying(100) NOT NULL,
    device_name character varying(255),
    track_id integer NOT NULL,
    class_id integer,
    class_name character varying(100),
    first_seen_time timestamp without time zone NOT NULL,
    last_seen_time timestamp without time zone,
    leave_time timestamp without time zone,
    duration double precision,
    first_seen_frame integer,
    last_seen_frame integer,
    total_detections integer NOT NULL,
    information text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: COLUMN tracking_target.task_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.tracking_target.task_id IS '所属算法任务ID';


--
-- Name: COLUMN tracking_target.device_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.tracking_target.device_id IS '设备ID';


--
-- Name: COLUMN tracking_target.device_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.tracking_target.device_name IS '设备名称';


--
-- Name: COLUMN tracking_target.track_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.tracking_target.track_id IS '追踪ID（同一任务内唯一）';


--
-- Name: COLUMN tracking_target.class_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.tracking_target.class_id IS '类别ID';


--
-- Name: COLUMN tracking_target.class_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.tracking_target.class_name IS '类别名称';


--
-- Name: COLUMN tracking_target.first_seen_time; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.tracking_target.first_seen_time IS '首次出现时间';


--
-- Name: COLUMN tracking_target.last_seen_time; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.tracking_target.last_seen_time IS '最后出现时间';


--
-- Name: COLUMN tracking_target.leave_time; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.tracking_target.leave_time IS '离开时间';


--
-- Name: COLUMN tracking_target.duration; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.tracking_target.duration IS '停留时长（秒）';


--
-- Name: COLUMN tracking_target.first_seen_frame; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.tracking_target.first_seen_frame IS '首次出现帧号';


--
-- Name: COLUMN tracking_target.last_seen_frame; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.tracking_target.last_seen_frame IS '最后出现帧号';


--
-- Name: COLUMN tracking_target.total_detections; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.tracking_target.total_detections IS '总检测次数';


--
-- Name: COLUMN tracking_target.information; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.tracking_target.information IS '详细信息（JSON格式）';


--
-- Name: tracking_target_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tracking_target_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tracking_target_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tracking_target_id_seq OWNED BY public.tracking_target.id;


--
-- Name: alert id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alert ALTER COLUMN id SET DEFAULT nextval('public.alert_id_seq'::regclass);


--
-- Name: algorithm_model_service id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.algorithm_model_service ALTER COLUMN id SET DEFAULT nextval('public.algorithm_model_service_id_seq'::regclass);


--
-- Name: algorithm_task id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.algorithm_task ALTER COLUMN id SET DEFAULT nextval('public.algorithm_task_id_seq'::regclass);


--
-- Name: detection_region id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.detection_region ALTER COLUMN id SET DEFAULT nextval('public.detection_region_id_seq'::regclass);


--
-- Name: device_detection_region id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.device_detection_region ALTER COLUMN id SET DEFAULT nextval('public.device_detection_region_id_seq'::regclass);


--
-- Name: device_directory id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.device_directory ALTER COLUMN id SET DEFAULT nextval('public.device_directory_id_seq'::regclass);


--
-- Name: device_storage_config id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.device_storage_config ALTER COLUMN id SET DEFAULT nextval('public.device_storage_config_id_seq'::regclass);


--
-- Name: frame_extractor id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.frame_extractor ALTER COLUMN id SET DEFAULT nextval('public.frame_extractor_id_seq'::regclass);


--
-- Name: image id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.image ALTER COLUMN id SET DEFAULT nextval('public.image_id_seq'::regclass);


--
-- Name: nvr id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nvr ALTER COLUMN id SET DEFAULT nextval('public.nvr_id_seq'::regclass);


--
-- Name: playback id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.playback ALTER COLUMN id SET DEFAULT nextval('public.playback_id_seq'::regclass);


--
-- Name: pusher id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pusher ALTER COLUMN id SET DEFAULT nextval('public.pusher_id_seq'::regclass);


--
-- Name: record_space id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.record_space ALTER COLUMN id SET DEFAULT nextval('public.record_space_id_seq'::regclass);


--
-- Name: region_model_service id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.region_model_service ALTER COLUMN id SET DEFAULT nextval('public.region_model_service_id_seq'::regclass);


--
-- Name: snap_space id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.snap_space ALTER COLUMN id SET DEFAULT nextval('public.snap_space_id_seq'::regclass);


--
-- Name: snap_task id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.snap_task ALTER COLUMN id SET DEFAULT nextval('public.snap_task_id_seq'::regclass);


--
-- Name: sorter id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sorter ALTER COLUMN id SET DEFAULT nextval('public.sorter_id_seq'::regclass);


--
-- Name: stream_forward_task id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stream_forward_task ALTER COLUMN id SET DEFAULT nextval('public.stream_forward_task_id_seq'::regclass);


--
-- Name: tracking_target id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tracking_target ALTER COLUMN id SET DEFAULT nextval('public.tracking_target_id_seq'::regclass);


--
-- Data for Name: alert; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.alert (id, object, event, region, information, "time", device_id, device_name, image_path, image_url, record_path, task_type, task_id, task_name, notify_users, channels, notification_sent, notification_sent_time) FROM stdin;
\.


--
-- Data for Name: algorithm_model_service; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.algorithm_model_service (id, task_id, service_name, service_url, service_type, model_id, threshold, request_method, request_headers, request_body_template, timeout, is_enabled, sort_order, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: algorithm_task; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.algorithm_task (id, task_name, task_code, task_type, model_ids, model_names, extract_interval, rtmp_input_url, rtmp_output_url, tracking_enabled, tracking_similarity_threshold, tracking_max_age, tracking_smooth_alpha, alert_event_enabled, alert_event_suppress_time, face_detection_enabled, plate_detection_enabled, alert_notification_enabled, alert_notification_config, alarm_suppress_time, last_notify_time, space_id, cron_expression, frame_skip, status, is_enabled, run_status, exception_reason, service_server_ip, service_port, service_process_id, service_last_heartbeat, service_log_path, total_frames, total_detections, total_captures, last_process_time, last_success_time, last_capture_time, description, defense_mode, defense_schedule, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: algorithm_task_device; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.algorithm_task_device (task_id, device_id, created_at) FROM stdin;
\.


--
-- Data for Name: detection_region; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.detection_region (id, task_id, region_name, region_type, points, image_id, algorithm_type, algorithm_model_id, algorithm_threshold, algorithm_enabled, color, opacity, is_enabled, sort_order, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: device; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.device (id, name, source, rtmp_stream, http_stream, ai_rtmp_stream, ai_http_stream, stream, ip, port, username, password, mac, manufacturer, model, firmware_version, serial_number, hardware_id, support_move, support_zoom, nvr_id, nvr_channel, rtsp_direct, channel_online, connection_status, enable_forward, auto_snap_enabled, directory_id, cover_image_path, created_at, updated_at) FROM stdin;
gb28181_44010200491534643182_34020000001320000001	Camera 01	gb28181://44010200491534643182/34020000001320000001			rtmp://172.16.13.220:1935/ai/gb28181_44010200491534643182_34020000001320000001	http://172.16.13.220:8080/ai/gb28181_44010200491534643182_34020000001320000001.flv	\N	\N	\N	\N	\N	\N	GB28181	GB28181-Channel	\N	44010200491534643182	34020000001320000001	\N	\N	\N	0	\N	\N	\N	\N	f	1	\N	2026-05-22 02:57:35.540365	2026-05-22 02:57:35.540367
1779420864892554342	CH1-192.168.1.64	rtsp://admin:fiytagroup1703@10.200.231.1:554/Streaming/Channels/101	rtmp://172.16.13.220:1935/live/1779420864892554342	http://172.16.13.220:8080/live/1779420864892554342.flv	rtmp://172.16.13.220:1935/ai/1779420864892554342	http://172.16.13.220:8080/ai/1779420864892554342.flv	0	192.168.1.64	8000	admin	fiytagroup1703		海康	NVR-Channel				f	f	\N	1	rtsp://admin:fiytagroup1703@192.168.1.64:554/Streaming/Channels/101	t	connect	\N	f	1	\N	2026-05-22 03:36:39.452983	2026-05-22 05:48:24.07228
1779421736545666241	CH2-192.168.1.2	rtsp://admin:fiytagroup1703@10.200.231.1:554/Streaming/Channels/201	rtmp://172.16.13.220:1935/live/1779421736545666241	http://172.16.13.220:8080/live/1779421736545666241.flv	rtmp://172.16.13.220:1935/ai/1779421736545666241	http://172.16.13.220:8080/ai/1779421736545666241.flv	0	192.168.1.2	8000	admin	fiytagroup1703		海康	NVR-Channel				f	f	\N	2	rtsp://admin:fiytagroup1703@192.168.1.2:554/Streaming/Channels/101	t	connect	\N	f	1	\N	2026-05-22 03:51:11.899326	2026-05-22 05:48:24.072283
1779421873137166368	CH3-192.168.1.3	rtsp://admin:fiytagroup1703@10.200.231.1:554/Streaming/Channels/301	rtmp://172.16.13.220:1935/live/1779421873137166368	http://172.16.13.220:8080/live/1779421873137166368.flv	rtmp://172.16.13.220:1935/ai/1779421873137166368	http://172.16.13.220:8080/ai/1779421873137166368.flv	0	192.168.1.3	8000	admin	fiytagroup1703		海康	NVR-Channel				f	f	\N	3	rtsp://admin:fiytagroup1703@192.168.1.3:554/Streaming/Channels/101	t	connect	\N	f	1	\N	2026-05-22 03:53:27.060263	2026-05-22 05:48:24.072284
1779422008175793403	CH4-192.168.1.4	rtsp://admin:fiytagroup1703@10.200.231.1:554/Streaming/Channels/401	rtmp://172.16.13.220:1935/live/1779422008175793403	http://172.16.13.220:8080/live/1779422008175793403.flv	rtmp://172.16.13.220:1935/ai/1779422008175793403	http://172.16.13.220:8080/ai/1779422008175793403.flv	0	192.168.1.4	8000	admin	fiytagroup1703		海康	NVR-Channel				f	f	\N	4	rtsp://admin:fiytagroup1703@192.168.1.4:554/Streaming/Channels/101	t	connect	\N	f	1	\N	2026-05-22 03:53:28.179781	2026-05-22 05:48:24.072284
1779422165722056155	CH5-192.168.1.5	rtsp://admin:fiytagroup1703@10.200.231.1:554/Streaming/Channels/501	rtmp://172.16.13.220:1935/live/1779422165722056155	http://172.16.13.220:8080/live/1779422165722056155.flv	rtmp://172.16.13.220:1935/ai/1779422165722056155	http://172.16.13.220:8080/ai/1779422165722056155.flv	0	192.168.1.5	8000	admin	fiytagroup1703		海康	NVR-Channel			\N	\N	\N	\N	5	rtsp://admin:fiytagroup1703@192.168.1.5:554/Streaming/Channels/101	t	connect	\N	f	1	\N	2026-05-22 03:56:05.739687	2026-05-22 05:48:24.072284
1779422165746455491	CH6-192.168.1.6	rtsp://admin:fiytagroup1703@10.200.231.1:554/Streaming/Channels/601	rtmp://172.16.13.220:1935/live/1779422165746455491	http://172.16.13.220:8080/live/1779422165746455491.flv	rtmp://172.16.13.220:1935/ai/1779422165746455491	http://172.16.13.220:8080/ai/1779422165746455491.flv	0	192.168.1.6	8000	admin	fiytagroup1703		海康	NVR-Channel			\N	\N	\N	\N	6	rtsp://admin:fiytagroup1703@192.168.1.6:554/Streaming/Channels/101	t	connect	\N	f	1	\N	2026-05-22 03:56:05.76827	2026-05-22 05:48:24.072285
1779422165775518450	CH7-192.168.1.7	rtsp://admin:fiytagroup1703@10.200.231.1:554/Streaming/Channels/701	rtmp://172.16.13.220:1935/live/1779422165775518450	http://172.16.13.220:8080/live/1779422165775518450.flv	rtmp://172.16.13.220:1935/ai/1779422165775518450	http://172.16.13.220:8080/ai/1779422165775518450.flv	0	192.168.1.7	8000	admin	fiytagroup1703		海康	NVR-Channel			\N	\N	\N	\N	7	rtsp://admin:fiytagroup1703@192.168.1.7:554/Streaming/Channels/101	t	connect	\N	f	1	\N	2026-05-22 03:56:05.793023	2026-05-22 05:48:24.072285
1779422166082993126	IPdome	rtsp://admin:fiytagroup1703@10.200.231.1:554/Streaming/Channels/2001	rtmp://172.16.13.220:1935/live/1779422166082993126	http://172.16.13.220:8080/live/1779422166082993126.flv	rtmp://172.16.13.220:1935/ai/1779422166082993126	http://172.16.13.220:8080/ai/1779422166082993126.flv	0	192.168.1.25	8000	admin	fiytagroup1703		海康	NVR-Channel			\N	\N	\N	\N	20	rtsp://admin:fiytagroup1703@192.168.1.25:554/Streaming/Channels/101	t	connect	\N	f	1	\N	2026-05-22 03:56:06.098868	2026-05-22 05:48:24.07229
1779422166104469817	IPdome	rtsp://admin:fiytagroup1703@10.200.231.1:554/Streaming/Channels/2101	rtmp://172.16.13.220:1935/live/1779422166104469817	http://172.16.13.220:8080/live/1779422166104469817.flv	rtmp://172.16.13.220:1935/ai/1779422166104469817	http://172.16.13.220:8080/ai/1779422166104469817.flv	0	192.168.1.26	8000	admin	fiytagroup1703		海康	NVR-Channel			\N	\N	\N	\N	21	rtsp://admin:fiytagroup1703@192.168.1.26:554/Streaming/Channels/101	t	connect	\N	f	1	\N	2026-05-22 03:56:06.122381	2026-05-22 05:48:24.07229
1779422165801460442	CH8-192.168.1.8	rtsp://admin:fiytagroup1703@10.200.231.1:554/Streaming/Channels/801	rtmp://172.16.13.220:1935/live/1779422165801460442	http://172.16.13.220:8080/live/1779422165801460442.flv	rtmp://172.16.13.220:1935/ai/1779422165801460442	http://172.16.13.220:8080/ai/1779422165801460442.flv	0	192.168.1.8	8000	admin	fiytagroup1703		海康	NVR-Channel			\N	\N	\N	\N	8	rtsp://admin:fiytagroup1703@192.168.1.8:554/Streaming/Channels/101	t	connect	\N	f	1	\N	2026-05-22 03:56:05.821475	2026-05-22 05:48:24.072286
1779422165828467470	CH9-192.168.1.9	rtsp://admin:fiytagroup1703@10.200.231.1:554/Streaming/Channels/901	rtmp://172.16.13.220:1935/live/1779422165828467470	http://172.16.13.220:8080/live/1779422165828467470.flv	rtmp://172.16.13.220:1935/ai/1779422165828467470	http://172.16.13.220:8080/ai/1779422165828467470.flv	0	192.168.1.9	8000	admin	fiytagroup1703		海康	NVR-Channel			\N	\N	\N	\N	9	rtsp://admin:fiytagroup1703@192.168.1.9:554/Streaming/Channels/101	t	connect	\N	f	1	\N	2026-05-22 03:56:05.843349	2026-05-22 05:48:24.072286
1779422165849403860	CH10-192.168.1.10	rtsp://admin:fiytagroup1703@10.200.231.1:554/Streaming/Channels/1001	rtmp://172.16.13.220:1935/live/1779422165849403860	http://172.16.13.220:8080/live/1779422165849403860.flv	rtmp://172.16.13.220:1935/ai/1779422165849403860	http://172.16.13.220:8080/ai/1779422165849403860.flv	0	192.168.1.10	8000	admin	fiytagroup1703		海康	NVR-Channel			\N	\N	\N	\N	10	rtsp://admin:fiytagroup1703@192.168.1.10:554/Streaming/Channels/101	t	connect	\N	f	1	\N	2026-05-22 03:56:05.868035	2026-05-22 05:48:24.072286
1779422165875846125	CH11-192.168.1.11	rtsp://admin:fiytagroup1703@10.200.231.1:554/Streaming/Channels/1101	rtmp://172.16.13.220:1935/live/1779422165875846125	http://172.16.13.220:8080/live/1779422165875846125.flv	rtmp://172.16.13.220:1935/ai/1779422165875846125	http://172.16.13.220:8080/ai/1779422165875846125.flv	0	192.168.1.11	8000	admin	fiytagroup1703		海康	NVR-Channel			\N	\N	\N	\N	11	rtsp://admin:fiytagroup1703@192.168.1.11:554/Streaming/Channels/101	t	connect	\N	f	1	\N	2026-05-22 03:56:05.896291	2026-05-22 05:48:24.072287
1779422165904284120	CH12-192.168.1.12	rtsp://admin:fiytagroup1703@10.200.231.1:554/Streaming/Channels/1201	rtmp://172.16.13.220:1935/live/1779422165904284120	http://172.16.13.220:8080/live/1779422165904284120.flv	rtmp://172.16.13.220:1935/ai/1779422165904284120	http://172.16.13.220:8080/ai/1779422165904284120.flv	0	192.168.1.12	8000	admin	fiytagroup1703		海康	NVR-Channel			\N	\N	\N	\N	12	rtsp://admin:fiytagroup1703@192.168.1.12:554/Streaming/Channels/101	t	connect	\N	f	1	\N	2026-05-22 03:56:05.927287	2026-05-22 05:48:24.072287
1779422165933917600	CH13-192.168.1.13	rtsp://admin:fiytagroup1703@10.200.231.1:554/Streaming/Channels/1301	rtmp://172.16.13.220:1935/live/1779422165933917600	http://172.16.13.220:8080/live/1779422165933917600.flv	rtmp://172.16.13.220:1935/ai/1779422165933917600	http://172.16.13.220:8080/ai/1779422165933917600.flv	0	192.168.1.13	8000	admin	fiytagroup1703		海康	NVR-Channel			\N	\N	\N	\N	13	rtsp://admin:fiytagroup1703@192.168.1.13:554/Streaming/Channels/101	t	connect	\N	f	1	\N	2026-05-22 03:56:05.950152	2026-05-22 05:48:24.072287
1779422165955706874	CH14-192.168.1.14	rtsp://admin:fiytagroup1703@10.200.231.1:554/Streaming/Channels/1401	rtmp://172.16.13.220:1935/live/1779422165955706874	http://172.16.13.220:8080/live/1779422165955706874.flv	rtmp://172.16.13.220:1935/ai/1779422165955706874	http://172.16.13.220:8080/ai/1779422165955706874.flv	0	192.168.1.14	8000	admin	fiytagroup1703		海康	NVR-Channel			\N	\N	\N	\N	14	rtsp://admin:fiytagroup1703@192.168.1.14:554/Streaming/Channels/101	t	connect	\N	f	1	\N	2026-05-22 03:56:05.973912	2026-05-22 05:48:24.072288
1779422165979283705	CH15-192.168.1.15	rtsp://admin:fiytagroup1703@10.200.231.1:554/Streaming/Channels/1501	rtmp://172.16.13.220:1935/live/1779422165979283705	http://172.16.13.220:8080/live/1779422165979283705.flv	rtmp://172.16.13.220:1935/ai/1779422165979283705	http://172.16.13.220:8080/ai/1779422165979283705.flv	0	192.168.1.15	8000	admin	fiytagroup1703		海康	NVR-Channel			\N	\N	\N	\N	15	rtsp://admin:fiytagroup1703@192.168.1.15:554/Streaming/Channels/101	t	connect	\N	f	1	\N	2026-05-22 03:56:05.995099	2026-05-22 05:48:24.072288
1779422166002269874	CH16-192.168.1.16	rtsp://admin:fiytagroup1703@10.200.231.1:554/Streaming/Channels/1601	rtmp://172.16.13.220:1935/live/1779422166002269874	http://172.16.13.220:8080/live/1779422166002269874.flv	rtmp://172.16.13.220:1935/ai/1779422166002269874	http://172.16.13.220:8080/ai/1779422166002269874.flv	0	192.168.1.16	8000	admin	fiytagroup1703		海康	NVR-Channel			\N	\N	\N	\N	16	rtsp://admin:fiytagroup1703@192.168.1.16:554/Streaming/Channels/101	t	connect	\N	f	1	\N	2026-05-22 03:56:06.016277	2026-05-22 05:48:24.072289
1779422166021660540	CH17-192.168.1.17	rtsp://admin:fiytagroup1703@10.200.231.1:554/Streaming/Channels/1701	rtmp://172.16.13.220:1935/live/1779422166021660540	http://172.16.13.220:8080/live/1779422166021660540.flv	rtmp://172.16.13.220:1935/ai/1779422166021660540	http://172.16.13.220:8080/ai/1779422166021660540.flv	0	192.168.1.17	8000	admin	fiytagroup1703		海康	NVR-Channel			\N	\N	\N	\N	17	rtsp://admin:fiytagroup1703@192.168.1.17:554/Streaming/Channels/101	t	connect	\N	f	1	\N	2026-05-22 03:56:06.036051	2026-05-22 05:48:24.072289
1779422166041205920	CH18-192.168.1.18	rtsp://admin:fiytagroup1703@10.200.231.1:554/Streaming/Channels/1801	rtmp://172.16.13.220:1935/live/1779422166041205920	http://172.16.13.220:8080/live/1779422166041205920.flv	rtmp://172.16.13.220:1935/ai/1779422166041205920	http://172.16.13.220:8080/ai/1779422166041205920.flv	0	192.168.1.18	8000	admin	fiytagroup1703		海康	NVR-Channel			\N	\N	\N	\N	18	rtsp://admin:fiytagroup1703@192.168.1.18:554/Streaming/Channels/101	t	connect	\N	f	1	\N	2026-05-22 03:56:06.057418	2026-05-22 05:48:24.072289
1779422166062972206	CH19-192.168.1.19	rtsp://admin:fiytagroup1703@10.200.231.1:554/Streaming/Channels/1901	rtmp://172.16.13.220:1935/live/1779422166062972206	http://172.16.13.220:8080/live/1779422166062972206.flv	rtmp://172.16.13.220:1935/ai/1779422166062972206	http://172.16.13.220:8080/ai/1779422166062972206.flv	0	192.168.1.19	8000	admin	fiytagroup1703		海康	NVR-Channel			\N	\N	\N	\N	19	rtsp://admin:fiytagroup1703@192.168.1.19:554/Streaming/Channels/101	t	connect	\N	f	1	\N	2026-05-22 03:56:06.076843	2026-05-22 05:48:24.07229
1779422166129430057	CH22-192.168.1.20	rtsp://admin:fiytagroup1703@10.200.231.1:554/Streaming/Channels/2201	rtmp://172.16.13.220:1935/live/1779422166129430057	http://172.16.13.220:8080/live/1779422166129430057.flv	rtmp://172.16.13.220:1935/ai/1779422166129430057	http://172.16.13.220:8080/ai/1779422166129430057.flv	0	192.168.1.20	8000	admin	fiytagroup1703		海康	NVR-Channel			\N	\N	\N	\N	22	rtsp://admin:fiytagroup1703@192.168.1.20:554/Streaming/Channels/101	t	connect	\N	f	1	\N	2026-05-22 03:56:06.145915	2026-05-22 05:48:24.072291
1779422166154192033	CH23-192.168.1.21	rtsp://admin:fiytagroup1703@10.200.231.1:554/Streaming/Channels/2301	rtmp://172.16.13.220:1935/live/1779422166154192033	http://172.16.13.220:8080/live/1779422166154192033.flv	rtmp://172.16.13.220:1935/ai/1779422166154192033	http://172.16.13.220:8080/ai/1779422166154192033.flv	0	192.168.1.21	8000	admin	fiytagroup1703		海康	NVR-Channel			\N	\N	\N	\N	23	rtsp://admin:fiytagroup1703@192.168.1.21:554/Streaming/Channels/101	t	connect	\N	f	1	\N	2026-05-22 03:56:06.167457	2026-05-22 05:48:24.072291
\.


--
-- Data for Name: device_detection_region; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.device_detection_region (id, device_id, region_name, region_type, points, image_id, color, opacity, is_enabled, sort_order, model_ids, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: device_directory; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.device_directory (id, name, parent_id, description, sort_order, created_at, updated_at) FROM stdin;
1	默认分组	\N	未手动分组的摄像头（含直连与国标）	-1000	2026-05-22 02:43:58.702873	2026-05-22 02:43:58.702875
\.


--
-- Data for Name: device_storage_config; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.device_storage_config (id, device_id, snap_storage_bucket, snap_storage_max_size, snap_storage_cleanup_enabled, snap_storage_cleanup_threshold, snap_storage_cleanup_ratio, video_storage_bucket, video_storage_max_size, video_storage_cleanup_enabled, video_storage_cleanup_threshold, video_storage_cleanup_ratio, last_snap_cleanup_time, last_video_cleanup_time, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: frame_extractor; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.frame_extractor (id, extractor_name, extractor_code, extractor_type, "interval", description, is_enabled, status, server_ip, port, process_id, last_heartbeat, log_path, task_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: image; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.image (id, filename, original_filename, path, width, height, created_at, device_id) FROM stdin;
\.


--
-- Data for Name: nvr; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.nvr (id, ip, port, username, password, name, model, vendor, serial_number, firmware_version, device_type, mac, scheme, rtsp_url, source, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: playback; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.playback (id, file_path, event_time, device_id, device_name, duration, thumbnail_path, file_size, created_at, updated_at) FROM stdin;
1	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421006193.flv	2026-05-22 11:36:51.131455+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421006193.jpg	13624995	2026-05-22 11:36:51.684234+08	2026-05-22 11:36:51.684234+08
2	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421011132.flv	2026-05-22 11:36:56.205505+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421011132.jpg	18533510	2026-05-22 11:36:56.943341+08	2026-05-22 11:36:56.943341+08
3	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421016206.flv	2026-05-22 11:37:01.419556+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421016206.jpg	16586337	2026-05-22 11:37:02.112084+08	2026-05-22 11:37:02.112084+08
4	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421021421.flv	2026-05-22 11:37:06.841609+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421021421.jpg	17524371	2026-05-22 11:37:07.543234+08	2026-05-22 11:37:07.543234+08
5	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421026842.flv	2026-05-22 11:37:11.99766+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421026842.jpg	16275466	2026-05-22 11:37:12.719614+08	2026-05-22 11:37:12.719614+08
6	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421031998.flv	2026-05-22 11:37:17.13871+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421031998.jpg	16709334	2026-05-22 11:37:17.903564+08	2026-05-22 11:37:17.903564+08
7	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421037139.flv	2026-05-22 11:37:22.563764+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421037139.jpg	15275313	2026-05-22 11:37:23.276488+08	2026-05-22 11:37:23.276488+08
8	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421042564.flv	2026-05-22 11:37:27.899816+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421042564.jpg	16305996	2026-05-22 11:37:28.568348+08	2026-05-22 11:37:28.568348+08
9	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421047900.flv	2026-05-22 11:37:33.275869+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421047900.jpg	16179114	2026-05-22 11:37:33.983686+08	2026-05-22 11:37:33.983686+08
10	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421053276.flv	2026-05-22 11:37:38.561921+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421053276.jpg	15616071	2026-05-22 11:37:39.250681+08	2026-05-22 11:37:39.250681+08
11	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421058564.flv	2026-05-22 11:37:43.639971+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421058564.jpg	13681839	2026-05-22 11:37:44.342789+08	2026-05-22 11:37:44.342789+08
12	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421063641.flv	2026-05-22 11:37:48.793021+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421063641.jpg	14534821	2026-05-22 11:37:49.477802+08	2026-05-22 11:37:49.477802+08
13	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421068794.flv	2026-05-22 11:37:53.892072+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421068794.jpg	14701404	2026-05-22 11:37:54.59112+08	2026-05-22 11:37:54.59112+08
14	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421073893.flv	2026-05-22 11:37:58.900121+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421073893.jpg	14451695	2026-05-22 11:37:59.568499+08	2026-05-22 11:37:59.568499+08
15	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421078901.flv	2026-05-22 11:38:04.078172+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421078901.jpg	13948856	2026-05-22 11:38:04.739692+08	2026-05-22 11:38:04.739692+08
16	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421084079.flv	2026-05-22 11:38:09.503225+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421084079.jpg	14503395	2026-05-22 11:38:10.179635+08	2026-05-22 11:38:10.179635+08
17	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421089504.flv	2026-05-22 11:38:14.520274+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421089504.jpg	13781287	2026-05-22 11:38:15.188953+08	2026-05-22 11:38:15.188953+08
18	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421094521.flv	2026-05-22 11:38:19.861327+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421094521.jpg	13324743	2026-05-22 11:38:20.564417+08	2026-05-22 11:38:20.564417+08
19	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421099862.flv	2026-05-22 11:38:25.085378+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421099862.jpg	13841115	2026-05-22 11:38:25.806442+08	2026-05-22 11:38:25.806442+08
20	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421105086.flv	2026-05-22 11:38:30.208428+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421105086.jpg	14109247	2026-05-22 11:38:30.857568+08	2026-05-22 11:38:30.857568+08
21	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421110209.flv	2026-05-22 11:38:35.578481+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421110209.jpg	14688008	2026-05-22 11:38:36.247784+08	2026-05-22 11:38:36.247784+08
22	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421115579.flv	2026-05-22 11:38:40.999534+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421115579.jpg	14074704	2026-05-22 11:38:41.656635+08	2026-05-22 11:38:41.656635+08
23	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421121000.flv	2026-05-22 11:38:46.332587+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421121000.jpg	14113655	2026-05-22 11:38:47.04466+08	2026-05-22 11:38:47.04466+08
24	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421126333.flv	2026-05-22 11:38:51.796641+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421126333.jpg	13726722	2026-05-22 11:38:52.490546+08	2026-05-22 11:38:52.490546+08
25	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421131797.flv	2026-05-22 11:38:57.036692+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421131797.jpg	14193260	2026-05-22 11:38:57.735605+08	2026-05-22 11:38:57.735605+08
26	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421137037.flv	2026-05-22 11:39:02.396745+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421137037.jpg	14226305	2026-05-22 11:39:03.079359+08	2026-05-22 11:39:03.079359+08
29	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421153816.flv	2026-05-22 11:39:18.926907+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421153816.jpg	14360547	2026-05-22 11:39:19.672795+08	2026-05-22 11:39:19.672795+08
30	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421158928.flv	2026-05-22 11:39:24.552962+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421158928.jpg	14008059	2026-05-22 11:39:25.25771+08	2026-05-22 11:39:25.25771+08
36	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421194355.flv	2026-05-22 11:40:00.203313+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421194355.jpg	14743853	2026-05-22 11:40:00.96628+08	2026-05-22 11:40:00.96628+08
37	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421200204.flv	2026-05-22 11:40:06.582375+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421200204.jpg	14405814	2026-05-22 11:40:07.312642+08	2026-05-22 11:40:07.312642+08
38	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421206583.flv	2026-05-22 11:40:12.913438+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421206583.jpg	14978387	2026-05-22 11:40:13.555381+08	2026-05-22 11:40:13.555381+08
27	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421142397.flv	2026-05-22 11:39:08.219802+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421142397.jpg	15261175	2026-05-22 11:39:08.979625+08	2026-05-22 11:39:08.979625+08
28	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421148220.flv	2026-05-22 11:39:13.815857+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421148220.jpg	13872333	2026-05-22 11:39:14.501416+08	2026-05-22 11:39:14.501416+08
31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421164554.flv	2026-05-22 11:39:29.810014+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421164554.jpg	14156993	2026-05-22 11:39:30.502602+08	2026-05-22 11:39:30.502602+08
34	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421182247.flv	2026-05-22 11:39:47.928192+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421182247.jpg	14869740	2026-05-22 11:39:48.627864+08	2026-05-22 11:39:48.627864+08
35	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421187929.flv	2026-05-22 11:39:54.354255+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421187929.jpg	14725307	2026-05-22 11:39:55.0634+08	2026-05-22 11:39:55.0634+08
40	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421218692.flv	2026-05-22 11:40:24.856555+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421218692.jpg	14427458	2026-05-22 11:40:25.543881+08	2026-05-22 11:40:25.543881+08
43	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421235854.flv	2026-05-22 11:40:41.129715+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421235854.jpg	14085111	2026-05-22 11:40:41.785859+08	2026-05-22 11:40:41.785859+08
32	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421169811.flv	2026-05-22 11:39:36.369078+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421169811.jpg	14907148	2026-05-22 11:39:37.213133+08	2026-05-22 11:39:37.213133+08
33	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421176370.flv	2026-05-22 11:39:42.246136+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421176370.jpg	14829207	2026-05-22 11:39:42.949371+08	2026-05-22 11:39:42.949371+08
41	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421224857.flv	2026-05-22 11:40:30.164607+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421224857.jpg	14335707	2026-05-22 11:40:30.839819+08	2026-05-22 11:40:30.839819+08
42	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421230165.flv	2026-05-22 11:40:35.853663+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421230165.jpg	13862932	2026-05-22 11:40:36.550533+08	2026-05-22 11:40:36.550533+08
39	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421212914.flv	2026-05-22 11:40:18.691494+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421212914.jpg	14250376	2026-05-22 11:40:19.387514+08	2026-05-22 11:40:19.387514+08
44	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421241130.flv	2026-05-22 11:40:46.198765+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421241130.jpg	13449399	2026-05-22 11:40:46.863118+08	2026-05-22 11:40:46.863118+08
45	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421262548.flv	2026-05-22 11:41:07.547974+08	1779420864892554342	Camera 01	30	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421262548.jpg	12423558	2026-05-22 11:41:08.111459+08	2026-05-22 11:41:08.111459+08
46	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421267549.flv	2026-05-22 11:41:12.496023+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421267549.jpg	18583173	2026-05-22 11:41:13.220554+08	2026-05-22 11:41:13.220554+08
47	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421272497.flv	2026-05-22 11:41:17.450072+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421272497.jpg	16580414	2026-05-22 11:41:18.144526+08	2026-05-22 11:41:18.144526+08
48	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421277451.flv	2026-05-22 11:41:22.447121+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421277451.jpg	16802947	2026-05-22 11:41:23.16907+08	2026-05-22 11:41:23.16907+08
49	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421282448.flv	2026-05-22 11:41:27.45317+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421282448.jpg	16669744	2026-05-22 11:41:28.176459+08	2026-05-22 11:41:28.176459+08
50	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421287454.flv	2026-05-22 11:41:32.415219+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421287454.jpg	16544721	2026-05-22 11:41:33.152932+08	2026-05-22 11:41:33.152932+08
51	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421292416.flv	2026-05-22 11:41:37.363267+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421292416.jpg	16247146	2026-05-22 11:41:38.252747+08	2026-05-22 11:41:38.252747+08
52	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421297364.flv	2026-05-22 11:41:42.76132+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421297364.jpg	17150809	2026-05-22 11:41:43.489016+08	2026-05-22 11:41:43.489016+08
53	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421302762.flv	2026-05-22 11:41:48.081373+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421302762.jpg	15470267	2026-05-22 11:41:48.807985+08	2026-05-22 11:41:48.807985+08
54	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421308082.flv	2026-05-22 11:41:53.323424+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421308082.jpg	16259638	2026-05-22 11:41:54.037584+08	2026-05-22 11:41:54.037584+08
55	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421313324.flv	2026-05-22 11:41:58.294473+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421313324.jpg	16048988	2026-05-22 11:41:58.997569+08	2026-05-22 11:41:58.997569+08
56	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421318295.flv	2026-05-22 11:42:03.254522+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421318295.jpg	16512003	2026-05-22 11:42:03.971189+08	2026-05-22 11:42:03.971189+08
57	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421323255.flv	2026-05-22 11:42:08.12857+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421323255.jpg	15977868	2026-05-22 11:42:08.852081+08	2026-05-22 11:42:08.852081+08
58	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421328129.flv	2026-05-22 11:42:12.976617+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421328129.jpg	16151874	2026-05-22 11:42:13.711584+08	2026-05-22 11:42:13.711584+08
59	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421332977.flv	2026-05-22 11:42:17.749664+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421332977.jpg	15522166	2026-05-22 11:42:18.454233+08	2026-05-22 11:42:18.454233+08
60	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421337750.flv	2026-05-22 11:42:22.851714+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421337750.jpg	16356821	2026-05-22 11:42:23.546594+08	2026-05-22 11:42:23.546594+08
61	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421342852.flv	2026-05-22 11:42:27.907764+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421342852.jpg	16698385	2026-05-22 11:42:28.601514+08	2026-05-22 11:42:28.601514+08
62	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421347908.flv	2026-05-22 11:42:32.955814+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421347908.jpg	16862121	2026-05-22 11:42:33.634643+08	2026-05-22 11:42:33.634643+08
63	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421352956.flv	2026-05-22 11:42:38.010863+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421352956.jpg	15613716	2026-05-22 11:42:38.69971+08	2026-05-22 11:42:38.69971+08
64	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421358012.flv	2026-05-22 11:42:42.940912+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421358012.jpg	15869347	2026-05-22 11:42:43.639019+08	2026-05-22 11:42:43.639019+08
65	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421362942.flv	2026-05-22 11:42:47.934961+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421362942.jpg	15769088	2026-05-22 11:42:48.643812+08	2026-05-22 11:42:48.643812+08
66	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421367936.flv	2026-05-22 11:42:52.99801+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421367936.jpg	16046644	2026-05-22 11:42:53.690548+08	2026-05-22 11:42:53.690548+08
67	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421372999.flv	2026-05-22 11:42:57.805058+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421372999.jpg	15294323	2026-05-22 11:42:58.486847+08	2026-05-22 11:42:58.486847+08
68	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421377806.flv	2026-05-22 11:43:02.656105+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421377806.jpg	15642246	2026-05-22 11:43:03.356904+08	2026-05-22 11:43:03.356904+08
69	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421382657.flv	2026-05-22 11:43:07.617154+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421382657.jpg	14516666	2026-05-22 11:43:08.296612+08	2026-05-22 11:43:08.296612+08
78	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421428682.flv	2026-05-22 11:43:53.793608+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421428682.jpg	14660318	2026-05-22 11:43:54.473676+08	2026-05-22 11:43:54.473676+08
85	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421465000.flv	2026-05-22 11:44:30.67897+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421465000.jpg	15578695	2026-05-22 11:44:31.408481+08	2026-05-22 11:44:31.408481+08
86	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421470681.flv	2026-05-22 11:44:36.065023+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421470681.jpg	15304818	2026-05-22 11:44:36.760166+08	2026-05-22 11:44:36.760166+08
87	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421476066.flv	2026-05-22 11:44:41.466076+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421476066.jpg	14524831	2026-05-22 11:44:42.16207+08	2026-05-22 11:44:42.16207+08
88	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421481468.flv	2026-05-22 11:44:46.750128+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421481468.jpg	15530263	2026-05-22 11:44:47.467314+08	2026-05-22 11:44:47.467314+08
89	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421486751.flv	2026-05-22 11:44:52.203182+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421486751.jpg	15291326	2026-05-22 11:44:52.942104+08	2026-05-22 11:44:52.942104+08
93	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421508991.flv	2026-05-22 11:45:14.568402+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421508991.jpg	15453085	2026-05-22 11:45:15.283824+08	2026-05-22 11:45:15.283824+08
95	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421520605.flv	2026-05-22 11:45:27.045524+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421520605.jpg	15829239	2026-05-22 11:45:27.720347+08	2026-05-22 11:45:27.720347+08
100	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421549921.flv	2026-05-22 11:45:55.506804+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421549921.jpg	15362095	2026-05-22 11:45:56.188632+08	2026-05-22 11:45:56.188632+08
108	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421593099.flv	2026-05-22 11:46:38.115222+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421593099.jpg	14632138	2026-05-22 11:46:38.771303+08	2026-05-22 11:46:38.771303+08
70	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421387618.flv	2026-05-22 11:43:12.616203+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421387618.jpg	15419511	2026-05-22 11:43:13.307784+08	2026-05-22 11:43:13.307784+08
71	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421392618.flv	2026-05-22 11:43:17.608252+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421392618.jpg	14800343	2026-05-22 11:43:18.313335+08	2026-05-22 11:43:18.313335+08
72	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421397609.flv	2026-05-22 11:43:22.933305+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421397609.jpg	15814253	2026-05-22 11:43:23.621527+08	2026-05-22 11:43:23.621527+08
73	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421402934.flv	2026-05-22 11:43:28.161356+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421402934.jpg	15672434	2026-05-22 11:43:28.855891+08	2026-05-22 11:43:28.855891+08
74	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421408162.flv	2026-05-22 11:43:33.200406+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421408162.jpg	15389889	2026-05-22 11:43:33.923918+08	2026-05-22 11:43:33.923918+08
75	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421413201.flv	2026-05-22 11:43:38.289455+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421413201.jpg	14852406	2026-05-22 11:43:38.969534+08	2026-05-22 11:43:38.969534+08
76	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421418290.flv	2026-05-22 11:43:43.333505+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421418290.jpg	14232694	2026-05-22 11:43:44.045217+08	2026-05-22 11:43:44.045217+08
77	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421423334.flv	2026-05-22 11:43:48.681558+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421423334.jpg	15131989	2026-05-22 11:43:49.389049+08	2026-05-22 11:43:49.389049+08
79	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421433794.flv	2026-05-22 11:43:59.08166+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421433794.jpg	15116770	2026-05-22 11:43:59.797417+08	2026-05-22 11:43:59.797417+08
80	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421439082.flv	2026-05-22 11:44:04.326711+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421439082.jpg	14708955	2026-05-22 11:44:05.022285+08	2026-05-22 11:44:05.022285+08
81	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421444327.flv	2026-05-22 11:44:09.630764+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421444327.jpg	15159808	2026-05-22 11:44:10.334265+08	2026-05-22 11:44:10.334265+08
82	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421449632.flv	2026-05-22 11:44:14.763814+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421449632.jpg	15002497	2026-05-22 11:44:15.446228+08	2026-05-22 11:44:15.446228+08
83	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421454764.flv	2026-05-22 11:44:19.877864+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421454764.jpg	14401719	2026-05-22 11:44:20.561313+08	2026-05-22 11:44:20.561313+08
84	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421459878.flv	2026-05-22 11:44:24.998914+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421459878.jpg	14560524	2026-05-22 11:44:25.758042+08	2026-05-22 11:44:25.758042+08
90	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421492204.flv	2026-05-22 11:44:57.606235+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421492204.jpg	16016084	2026-05-22 11:44:58.313609+08	2026-05-22 11:44:58.313609+08
91	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421497607.flv	2026-05-22 11:45:02.970288+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421497607.jpg	15054331	2026-05-22 11:45:03.640416+08	2026-05-22 11:45:03.640416+08
92	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421502971.flv	2026-05-22 11:45:08.990347+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421502971.jpg	15950070	2026-05-22 11:45:09.678403+08	2026-05-22 11:45:09.678403+08
94	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421514569.flv	2026-05-22 11:45:20.604461+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421514569.jpg	14964392	2026-05-22 11:45:21.449912+08	2026-05-22 11:45:21.449912+08
96	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421527046.flv	2026-05-22 11:45:32.676579+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421527046.jpg	14414372	2026-05-22 11:45:33.371308+08	2026-05-22 11:45:33.371308+08
97	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421532677.flv	2026-05-22 11:45:38.741639+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421532677.jpg	15150460	2026-05-22 11:45:39.47364+08	2026-05-22 11:45:39.47364+08
98	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421538742.flv	2026-05-22 11:45:44.425695+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421538742.jpg	14847842	2026-05-22 11:45:45.107264+08	2026-05-22 11:45:45.107264+08
99	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421544426.flv	2026-05-22 11:45:49.920749+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421544426.jpg	14485857	2026-05-22 11:45:50.641642+08	2026-05-22 11:45:50.641642+08
101	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421555507.flv	2026-05-22 11:46:00.943857+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421555507.jpg	14404380	2026-05-22 11:46:01.646311+08	2026-05-22 11:46:01.646311+08
102	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421560944.flv	2026-05-22 11:46:06.421911+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421560944.jpg	15215791	2026-05-22 11:46:07.130099+08	2026-05-22 11:46:07.130099+08
103	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421566423.flv	2026-05-22 11:46:12.261968+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421566423.jpg	14709262	2026-05-22 11:46:12.926843+08	2026-05-22 11:46:12.926843+08
104	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421572263.flv	2026-05-22 11:46:17.574021+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421572263.jpg	14908568	2026-05-22 11:46:18.291891+08	2026-05-22 11:46:18.291891+08
106	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421582637.flv	2026-05-22 11:46:28.084124+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421582637.jpg	14779440	2026-05-22 11:46:28.750782+08	2026-05-22 11:46:28.750782+08
107	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421588086.flv	2026-05-22 11:46:33.098173+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421588086.jpg	13575738	2026-05-22 11:46:33.789058+08	2026-05-22 11:46:33.789058+08
105	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421577575.flv	2026-05-22 11:46:22.63607+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421577575.jpg	14530817	2026-05-22 11:46:23.379296+08	2026-05-22 11:46:23.379296+08
109	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421598116.flv	2026-05-22 11:46:43.151272+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421598116.jpg	14092087	2026-05-22 11:46:43.894929+08	2026-05-22 11:46:43.894929+08
110	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421620800.flv	2026-05-22 11:47:06.003496+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421620800.jpg	12451675	2026-05-22 11:47:06.569039+08	2026-05-22 11:47:06.569039+08
111	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421626004.flv	2026-05-22 11:47:11.218548+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421626004.jpg	18229549	2026-05-22 11:47:11.925103+08	2026-05-22 11:47:11.925103+08
112	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421631219.flv	2026-05-22 11:47:16.222597+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421631219.jpg	17765601	2026-05-22 11:47:16.976794+08	2026-05-22 11:47:16.976794+08
113	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421636223.flv	2026-05-22 11:47:21.484648+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421636223.jpg	16517757	2026-05-22 11:47:22.21538+08	2026-05-22 11:47:22.21538+08
114	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421641485.flv	2026-05-22 11:47:26.7427+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421641485.jpg	17049817	2026-05-22 11:47:27.46837+08	2026-05-22 11:47:27.46837+08
115	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421646743.flv	2026-05-22 11:47:32.203754+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421646743.jpg	16388722	2026-05-22 11:47:32.924913+08	2026-05-22 11:47:32.924913+08
116	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421652204.flv	2026-05-22 11:47:37.725808+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421652204.jpg	17070250	2026-05-22 11:47:38.43666+08	2026-05-22 11:47:38.43666+08
117	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421657726.flv	2026-05-22 11:47:43.102861+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421657726.jpg	16555563	2026-05-22 11:47:43.822841+08	2026-05-22 11:47:43.822841+08
118	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421663103.flv	2026-05-22 11:47:48.500915+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421663103.jpg	16296106	2026-05-22 11:47:49.225527+08	2026-05-22 11:47:49.225527+08
119	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421668502.flv	2026-05-22 11:47:53.782967+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421668502.jpg	16146117	2026-05-22 11:47:54.484344+08	2026-05-22 11:47:54.484344+08
120	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421673784.flv	2026-05-22 11:47:59.139019+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421673784.jpg	16446846	2026-05-22 11:47:59.842262+08	2026-05-22 11:47:59.842262+08
121	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421679140.flv	2026-05-22 11:48:04.383071+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421679140.jpg	16497554	2026-05-22 11:48:05.126064+08	2026-05-22 11:48:05.126064+08
122	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421684384.flv	2026-05-22 11:48:09.717124+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421684384.jpg	16191307	2026-05-22 11:48:10.436758+08	2026-05-22 11:48:10.436758+08
123	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421689718.flv	2026-05-22 11:48:15.006176+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421689718.jpg	15895804	2026-05-22 11:48:15.710524+08	2026-05-22 11:48:15.710524+08
124	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421695007.flv	2026-05-22 11:48:20.222228+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421695007.jpg	15860757	2026-05-22 11:48:20.911572+08	2026-05-22 11:48:20.911572+08
125	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421700223.flv	2026-05-22 11:48:25.687282+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421700223.jpg	16301079	2026-05-22 11:48:26.391227+08	2026-05-22 11:48:26.391227+08
126	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421705688.flv	2026-05-22 11:48:30.992334+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421705688.jpg	15910970	2026-05-22 11:48:31.721917+08	2026-05-22 11:48:31.721917+08
127	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421710993.flv	2026-05-22 11:48:36.277386+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421710993.jpg	16025621	2026-05-22 11:48:36.996693+08	2026-05-22 11:48:36.996693+08
128	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421716278.flv	2026-05-22 11:48:41.895442+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421716278.jpg	16218536	2026-05-22 11:48:42.630873+08	2026-05-22 11:48:42.630873+08
129	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421721896.flv	2026-05-22 11:48:47.169494+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421721896.jpg	15673154	2026-05-22 11:48:47.869996+08	2026-05-22 11:48:47.869996+08
130	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421727170.flv	2026-05-22 11:48:52.548547+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421727170.jpg	15913780	2026-05-22 11:48:53.286786+08	2026-05-22 11:48:53.286786+08
131	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421732549.flv	2026-05-22 11:48:58.189602+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421732549.jpg	15013769	2026-05-22 11:48:58.932782+08	2026-05-22 11:48:58.932782+08
132	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421738190.flv	2026-05-22 11:49:03.793658+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421738190.jpg	15344634	2026-05-22 11:49:04.522669+08	2026-05-22 11:49:04.522669+08
133	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421743794.flv	2026-05-22 11:49:09.859718+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421743794.jpg	16269033	2026-05-22 11:49:10.603798+08	2026-05-22 11:49:10.603798+08
134	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421749861.flv	2026-05-22 11:49:15.383772+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421749861.jpg	14886839	2026-05-22 11:49:16.059799+08	2026-05-22 11:49:16.059799+08
135	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421755384.flv	2026-05-22 11:49:20.613824+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421755384.jpg	15277324	2026-05-22 11:49:21.28059+08	2026-05-22 11:49:21.28059+08
136	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421760614.flv	2026-05-22 11:49:25.961877+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421760614.jpg	15335112	2026-05-22 11:49:26.637676+08	2026-05-22 11:49:26.637676+08
137	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421765962.flv	2026-05-22 11:49:31.245929+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421765962.jpg	15070627	2026-05-22 11:49:31.930482+08	2026-05-22 11:49:31.930482+08
138	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421771247.flv	2026-05-22 11:49:36.40898+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421771247.jpg	15017857	2026-05-22 11:49:37.067414+08	2026-05-22 11:49:37.067414+08
139	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421776410.flv	2026-05-22 11:49:41.772033+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421776410.jpg	15193971	2026-05-22 11:49:42.494891+08	2026-05-22 11:49:42.494891+08
140	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421781773.flv	2026-05-22 11:49:47.101085+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421781773.jpg	14283685	2026-05-22 11:49:47.828137+08	2026-05-22 11:49:47.828137+08
141	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421787102.flv	2026-05-22 11:49:52.408138+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421787102.jpg	14493269	2026-05-22 11:49:53.087585+08	2026-05-22 11:49:53.087585+08
142	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421792409.flv	2026-05-22 11:49:57.835191+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421792409.jpg	14444327	2026-05-22 11:49:58.506777+08	2026-05-22 11:49:58.506777+08
143	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421797836.flv	2026-05-22 11:50:03.130244+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421797836.jpg	15049326	2026-05-22 11:50:03.822863+08	2026-05-22 11:50:03.822863+08
144	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421803131.flv	2026-05-22 11:50:08.707299+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421803131.jpg	14526696	2026-05-22 11:50:09.386137+08	2026-05-22 11:50:09.386137+08
145	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421808708.flv	2026-05-22 11:50:14.392355+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421808708.jpg	15400206	2026-05-22 11:50:15.10318+08	2026-05-22 11:50:15.10318+08
146	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421814393.flv	2026-05-22 11:50:19.845408+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421814393.jpg	14781075	2026-05-22 11:50:20.535246+08	2026-05-22 11:50:20.535246+08
147	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421819846.flv	2026-05-22 11:50:25.285462+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421819846.jpg	15005495	2026-05-22 11:50:26.037394+08	2026-05-22 11:50:26.037394+08
148	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421825286.flv	2026-05-22 11:50:30.850517+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421825286.jpg	14945275	2026-05-22 11:50:31.594655+08	2026-05-22 11:50:31.594655+08
149	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421830851.flv	2026-05-22 11:50:36.346571+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421830851.jpg	14411208	2026-05-22 11:50:37.020186+08	2026-05-22 11:50:37.020186+08
150	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421836347.flv	2026-05-22 11:50:41.828626+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421836347.jpg	15181703	2026-05-22 11:50:42.573534+08	2026-05-22 11:50:42.573534+08
151	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421841829.flv	2026-05-22 11:50:47.434681+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421841829.jpg	14519259	2026-05-22 11:50:48.154507+08	2026-05-22 11:50:48.154507+08
152	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421847435.flv	2026-05-22 11:50:52.702733+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421847435.jpg	13839058	2026-05-22 11:50:53.357739+08	2026-05-22 11:50:53.357739+08
153	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421852703.flv	2026-05-22 11:50:57.826783+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421852703.jpg	14217433	2026-05-22 11:50:58.539672+08	2026-05-22 11:50:58.539672+08
154	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421857827.flv	2026-05-22 11:51:02.871833+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421857827.jpg	14579234	2026-05-22 11:51:03.561494+08	2026-05-22 11:51:03.561494+08
155	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421862872.flv	2026-05-22 11:51:07.990884+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421862872.jpg	14401439	2026-05-22 11:51:08.690105+08	2026-05-22 11:51:08.690105+08
156	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421867991.flv	2026-05-22 11:51:13.152935+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421867991.jpg	14746675	2026-05-22 11:51:13.86498+08	2026-05-22 11:51:13.86498+08
157	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421873155.flv	2026-05-22 11:51:20.390006+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421873155.jpg	15569162	2026-05-22 11:51:21.260505+08	2026-05-22 11:51:21.260505+08
158	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779421876236.flv	2026-05-22 11:51:24.973052+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779421876236.jpg	14974006	2026-05-22 11:51:25.826595+08	2026-05-22 11:51:25.826595+08
159	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421880391.flv	2026-05-22 11:51:29.241094+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421880391.jpg	16988953	2026-05-22 11:51:30.170182+08	2026-05-22 11:51:30.170182+08
160	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779421884974.flv	2026-05-22 11:51:33.610137+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779421884974.jpg	14698163	2026-05-22 11:51:34.441658+08	2026-05-22 11:51:34.441658+08
161	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421889242.flv	2026-05-22 11:51:38.300183+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421889242.jpg	17193959	2026-05-22 11:51:39.195556+08	2026-05-22 11:51:39.195556+08
162	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779421893611.flv	2026-05-22 11:51:42.561225+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779421893611.jpg	14436581	2026-05-22 11:51:43.39052+08	2026-05-22 11:51:43.39052+08
163	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421898301.flv	2026-05-22 11:51:47.268272+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421898301.jpg	16443078	2026-05-22 11:51:48.163979+08	2026-05-22 11:51:48.163979+08
165	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421907270.flv	2026-05-22 11:51:56.483363+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421907270.jpg	17005660	2026-05-22 11:51:57.466683+08	2026-05-22 11:51:57.466683+08
166	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779421911427.flv	2026-05-22 11:52:00.767405+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779421911427.jpg	14296212	2026-05-22 11:52:01.643909+08	2026-05-22 11:52:01.643909+08
167	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421916485.flv	2026-05-22 11:52:05.907456+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421916485.jpg	16731235	2026-05-22 11:52:06.835889+08	2026-05-22 11:52:06.835889+08
168	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779421920769.flv	2026-05-22 11:52:10.024496+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779421920769.jpg	14671853	2026-05-22 11:52:10.872577+08	2026-05-22 11:52:10.872577+08
169	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421925908.flv	2026-05-22 11:52:15.008545+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421925908.jpg	16558839	2026-05-22 11:52:15.932523+08	2026-05-22 11:52:15.932523+08
170	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779421930025.flv	2026-05-22 11:52:19.171587+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779421930025.jpg	14563074	2026-05-22 11:52:20.039376+08	2026-05-22 11:52:20.039376+08
171	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421935009.flv	2026-05-22 11:52:24.029634+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421935009.jpg	16656272	2026-05-22 11:52:24.871968+08	2026-05-22 11:52:24.871968+08
172	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779421939172.flv	2026-05-22 11:52:28.049674+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779421939172.jpg	13862521	2026-05-22 11:52:28.837746+08	2026-05-22 11:52:28.837746+08
178	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779421967064.flv	2026-05-22 11:52:56.193952+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779421967064.jpg	13875321	2026-05-22 11:52:57.043928+08	2026-05-22 11:52:57.043928+08
179	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421972375.flv	2026-05-22 11:53:01.536005+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421972375.jpg	16220505	2026-05-22 11:53:02.536273+08	2026-05-22 11:53:02.536273+08
180	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779421976195.flv	2026-05-22 11:53:05.888048+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779421976195.jpg	14640342	2026-05-22 11:53:06.715655+08	2026-05-22 11:53:06.715655+08
181	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421981537.flv	2026-05-22 11:53:11.590104+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421981537.jpg	16550169	2026-05-22 11:53:12.789716+08	2026-05-22 11:53:12.789716+08
182	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779421985889.flv	2026-05-22 11:53:15.905147+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779421985889.jpg	14168090	2026-05-22 11:53:16.747925+08	2026-05-22 11:53:16.747925+08
183	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421991591.flv	2026-05-22 11:53:21.087198+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421991591.jpg	16099439	2026-05-22 11:53:21.968838+08	2026-05-22 11:53:21.968838+08
164	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779421902562.flv	2026-05-22 11:51:51.426313+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779421902562.jpg	14488018	2026-05-22 11:51:52.28376+08	2026-05-22 11:51:52.28376+08
173	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421944030.flv	2026-05-22 11:52:33.352726+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421944030.jpg	16289535	2026-05-22 11:52:34.284341+08	2026-05-22 11:52:34.284341+08
174	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779421948050.flv	2026-05-22 11:52:37.447767+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779421948050.jpg	14656200	2026-05-22 11:52:38.257366+08	2026-05-22 11:52:38.257366+08
175	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421953353.flv	2026-05-22 11:52:42.915821+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421953353.jpg	16773108	2026-05-22 11:52:43.842287+08	2026-05-22 11:52:43.842287+08
176	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779421957448.flv	2026-05-22 11:52:47.063862+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779421957448.jpg	14479182	2026-05-22 11:52:47.919771+08	2026-05-22 11:52:47.919771+08
177	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421962917.flv	2026-05-22 11:52:52.372914+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779421962917.jpg	15787420	2026-05-22 11:52:53.258992+08	2026-05-22 11:52:53.258992+08
184	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422105615.flv	2026-05-22 11:55:16.886341+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422105615.jpg	15288738	2026-05-22 11:55:17.950061+08	2026-05-22 11:55:17.950061+08
185	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422106159.flv	2026-05-22 11:55:17.79135+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422106159.jpg	14892534	2026-05-22 11:55:19.054504+08	2026-05-22 11:55:19.054504+08
186	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422109476.flv	2026-05-22 11:55:22.146393+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422109476.jpg	15571553	2026-05-22 11:55:23.207258+08	2026-05-22 11:55:23.207258+08
187	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422116888.flv	2026-05-22 11:55:29.043461+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422116888.jpg	14561191	2026-05-22 11:55:30.019387+08	2026-05-22 11:55:30.019387+08
188	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422117792.flv	2026-05-22 11:55:30.097471+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422117792.jpg	14550165	2026-05-22 11:55:31.181227+08	2026-05-22 11:55:31.181227+08
189	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422122147.flv	2026-05-22 11:55:34.664516+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422122147.jpg	15516300	2026-05-22 11:55:35.776239+08	2026-05-22 11:55:35.776239+08
190	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422129044.flv	2026-05-22 11:55:41.864588+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422129044.jpg	14448070	2026-05-22 11:55:42.935948+08	2026-05-22 11:55:42.935948+08
191	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422130098.flv	2026-05-22 11:55:42.886598+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422130098.jpg	14512669	2026-05-22 11:55:43.990281+08	2026-05-22 11:55:43.990281+08
192	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422134665.flv	2026-05-22 11:55:47.037639+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422134665.jpg	14974018	2026-05-22 11:55:48.111198+08	2026-05-22 11:55:48.111198+08
193	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422141866.flv	2026-05-22 11:55:54.550713+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422141866.jpg	14552639	2026-05-22 11:55:55.719924+08	2026-05-22 11:55:55.719924+08
194	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422142887.flv	2026-05-22 11:55:55.530722+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422142887.jpg	14361011	2026-05-22 11:55:56.792289+08	2026-05-22 11:55:56.792289+08
195	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422147038.flv	2026-05-22 11:55:59.659763+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422147038.jpg	14971700	2026-05-22 11:56:00.740324+08	2026-05-22 11:56:00.740324+08
196	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422154552.flv	2026-05-22 11:56:07.153837+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422154552.jpg	14060143	2026-05-22 11:56:08.245619+08	2026-05-22 11:56:08.245619+08
197	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422155532.flv	2026-05-22 11:56:08.272848+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422155532.jpg	14264930	2026-05-22 11:56:09.296705+08	2026-05-22 11:56:09.296705+08
198	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422159660.flv	2026-05-22 11:56:12.227887+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422159660.jpg	14345641	2026-05-22 11:56:13.333402+08	2026-05-22 11:56:13.333402+08
199	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422167154.flv	2026-05-22 11:56:19.653961+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422167154.jpg	14442129	2026-05-22 11:56:20.642523+08	2026-05-22 11:56:20.642523+08
200	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422168273.flv	2026-05-22 11:56:20.518969+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422168273.jpg	14179169	2026-05-22 11:56:21.719787+08	2026-05-22 11:56:21.719787+08
201	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422172228.flv	2026-05-22 11:56:24.455008+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422172228.jpg	14629255	2026-05-22 11:56:25.561219+08	2026-05-22 11:56:25.561219+08
202	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422179655.flv	2026-05-22 11:56:31.634079+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422179655.jpg	14294999	2026-05-22 11:56:32.71789+08	2026-05-22 11:56:32.71789+08
203	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422180521.flv	2026-05-22 11:56:32.700089+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422180521.jpg	14090662	2026-05-22 11:56:33.816512+08	2026-05-22 11:56:33.816512+08
204	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422184456.flv	2026-05-22 11:56:36.429126+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422184456.jpg	14804497	2026-05-22 11:56:37.5591+08	2026-05-22 11:56:37.5591+08
205	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422191635.flv	2026-05-22 11:56:44.201203+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422191635.jpg	14289005	2026-05-22 11:56:45.290344+08	2026-05-22 11:56:45.290344+08
206	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422192701.flv	2026-05-22 11:56:45.115212+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422192701.jpg	14583181	2026-05-22 11:56:46.319076+08	2026-05-22 11:56:46.319076+08
207	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422196431.flv	2026-05-22 11:56:48.746248+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422196431.jpg	15111987	2026-05-22 11:56:49.718834+08	2026-05-22 11:56:49.718834+08
208	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422204202.flv	2026-05-22 11:56:56.586325+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422204202.jpg	14212029	2026-05-22 11:56:57.703981+08	2026-05-22 11:56:57.703981+08
209	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422205116.flv	2026-05-22 11:56:57.571335+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422205116.jpg	14151971	2026-05-22 11:56:58.714773+08	2026-05-22 11:56:58.714773+08
210	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422208748.flv	2026-05-22 11:57:01.12937+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422208748.jpg	14723807	2026-05-22 11:57:02.227677+08	2026-05-22 11:57:02.227677+08
211	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422216587.flv	2026-05-22 11:57:09.291451+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422216587.jpg	14241732	2026-05-22 11:57:10.465576+08	2026-05-22 11:57:10.465576+08
212	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422217572.flv	2026-05-22 11:57:10.710465+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422217572.jpg	14561166	2026-05-22 11:57:11.812496+08	2026-05-22 11:57:11.812496+08
213	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422221131.flv	2026-05-22 11:57:13.957497+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422221131.jpg	14968315	2026-05-22 11:57:15.206091+08	2026-05-22 11:57:15.206091+08
214	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422229293.flv	2026-05-22 11:57:23.512591+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422229293.jpg	14458263	2026-05-22 11:57:24.533947+08	2026-05-22 11:57:24.533947+08
215	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422230712.flv	2026-05-22 11:57:24.781604+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422230712.jpg	14121221	2026-05-22 11:57:25.814324+08	2026-05-22 11:57:25.814324+08
216	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422233958.flv	2026-05-22 11:57:27.795633+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422233958.jpg	14333329	2026-05-22 11:57:28.857069+08	2026-05-22 11:57:28.857069+08
217	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422243514.flv	2026-05-22 11:57:36.067715+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422243514.jpg	13958771	2026-05-22 11:57:37.061417+08	2026-05-22 11:57:37.061417+08
218	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422244782.flv	2026-05-22 11:57:37.276727+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422244782.jpg	14221230	2026-05-22 11:57:38.325192+08	2026-05-22 11:57:38.325192+08
219	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422247796.flv	2026-05-22 11:57:39.996754+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422247796.jpg	14594069	2026-05-22 11:57:41.077639+08	2026-05-22 11:57:41.077639+08
220	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422256068.flv	2026-05-22 11:57:48.373837+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422256068.jpg	14324057	2026-05-22 11:57:49.420225+08	2026-05-22 11:57:49.420225+08
221	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422257277.flv	2026-05-22 11:57:49.645849+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422257277.jpg	13934000	2026-05-22 11:57:50.733493+08	2026-05-22 11:57:50.733493+08
222	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422259997.flv	2026-05-22 11:57:52.157874+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422259997.jpg	14458522	2026-05-22 11:57:53.264311+08	2026-05-22 11:57:53.264311+08
223	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422268374.flv	2026-05-22 11:58:01.000961+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422268374.jpg	14236630	2026-05-22 11:58:02.013683+08	2026-05-22 11:58:02.013683+08
224	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422269647.flv	2026-05-22 11:58:02.092972+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422269647.jpg	14288588	2026-05-22 11:58:02.997395+08	2026-05-22 11:58:02.997395+08
225	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422272158.flv	2026-05-22 11:58:04.578996+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422272158.jpg	13970752	2026-05-22 11:58:05.673736+08	2026-05-22 11:58:05.673736+08
226	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422281002.flv	2026-05-22 11:58:13.597085+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422281002.jpg	14290737	2026-05-22 11:58:14.620681+08	2026-05-22 11:58:14.620681+08
227	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422282095.flv	2026-05-22 11:58:14.799097+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422282095.jpg	13984380	2026-05-22 11:58:15.900494+08	2026-05-22 11:58:15.900494+08
228	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422284580.flv	2026-05-22 11:58:17.680126+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422284580.jpg	14504454	2026-05-22 11:58:18.775054+08	2026-05-22 11:58:18.775054+08
229	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422293598.flv	2026-05-22 11:58:26.476213+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422293598.jpg	14272646	2026-05-22 11:58:27.476455+08	2026-05-22 11:58:27.476455+08
230	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422294800.flv	2026-05-22 11:58:27.282221+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422294800.jpg	14303624	2026-05-22 11:58:28.556692+08	2026-05-22 11:58:28.556692+08
231	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422297682.flv	2026-05-22 11:58:30.127249+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422297682.jpg	14544050	2026-05-22 11:58:31.149717+08	2026-05-22 11:58:31.149717+08
238	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422332587.flv	2026-05-22 11:59:04.794591+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422332587.jpg	14329285	2026-05-22 11:59:05.79524+08	2026-05-22 11:59:05.79524+08
239	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422333419.flv	2026-05-22 11:59:05.492598+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422333419.jpg	13703628	2026-05-22 11:59:06.834896+08	2026-05-22 11:59:06.834896+08
240	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422335698.flv	2026-05-22 11:59:07.68962+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422335698.jpg	13513308	2026-05-22 11:59:08.729946+08	2026-05-22 11:59:08.729946+08
250	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422383804.flv	2026-05-22 11:59:56.242099+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422383804.jpg	14088242	2026-05-22 11:59:57.194518+08	2026-05-22 11:59:57.194518+08
251	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422384758.flv	2026-05-22 11:59:57.003106+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422384758.jpg	14195302	2026-05-22 11:59:58.261223+08	2026-05-22 11:59:58.261223+08
252	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422386018.flv	2026-05-22 11:59:58.198118+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422386018.jpg	14166601	2026-05-22 11:59:59.357538+08	2026-05-22 11:59:59.357538+08
256	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422408708.flv	2026-05-22 12:00:21.512348+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422408708.jpg	14249471	2026-05-22 12:00:22.610002+08	2026-05-22 12:00:22.610002+08
257	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422409533.flv	2026-05-22 12:00:22.511358+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422409533.jpg	14224773	2026-05-22 12:00:23.511115+08	2026-05-22 12:00:23.511115+08
258	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422410374.flv	2026-05-22 12:00:22.771361+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422410374.jpg	13794015	2026-05-22 12:00:24.582825+08	2026-05-22 12:00:24.582825+08
268	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422458770.flv	2026-05-22 12:01:11.160838+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422458770.jpg	14139567	2026-05-22 12:01:12.216004+08	2026-05-22 12:01:12.216004+08
269	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422459562.flv	2026-05-22 12:01:11.397841+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422459562.jpg	14359104	2026-05-22 12:01:13.319523+08	2026-05-22 12:01:13.319523+08
270	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422460217.flv	2026-05-22 12:01:12.456851+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422460217.jpg	14429718	2026-05-22 12:01:14.332942+08	2026-05-22 12:01:14.332942+08
271	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422471399.flv	2026-05-22 12:01:23.350959+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422471399.jpg	14443000	2026-05-22 12:01:24.471437+08	2026-05-22 12:01:24.471437+08
272	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422471161.flv	2026-05-22 12:01:23.381959+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422471161.jpg	14120663	2026-05-22 12:01:25.512493+08	2026-05-22 12:01:25.512493+08
273	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422472458.flv	2026-05-22 12:01:24.699972+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422472458.jpg	14188869	2026-05-22 12:01:26.589748+08	2026-05-22 12:01:26.589748+08
274	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422483352.flv	2026-05-22 12:01:36.006084+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422483352.jpg	14564377	2026-05-22 12:01:37.016594+08	2026-05-22 12:01:37.016594+08
232	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422306477.flv	2026-05-22 11:58:39.685343+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422306477.jpg	14171651	2026-05-22 11:58:40.744691+08	2026-05-22 11:58:40.744691+08
233	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422307283.flv	2026-05-22 11:58:40.37835+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422307283.jpg	14326624	2026-05-22 11:58:41.833346+08	2026-05-22 11:58:41.833346+08
234	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422310128.flv	2026-05-22 11:58:42.886375+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422310128.jpg	14644151	2026-05-22 11:58:43.904698+08	2026-05-22 11:58:43.904698+08
235	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422319686.flv	2026-05-22 11:58:52.58647+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422319686.jpg	14168739	2026-05-22 11:58:53.546496+08	2026-05-22 11:58:53.546496+08
236	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422320379.flv	2026-05-22 11:58:53.418479+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422320379.jpg	14353548	2026-05-22 11:58:54.521248+08	2026-05-22 11:58:54.521248+08
237	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422322888.flv	2026-05-22 11:58:55.696501+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422322888.jpg	14756265	2026-05-22 11:58:56.746521+08	2026-05-22 11:58:56.746521+08
241	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422344795.flv	2026-05-22 11:59:17.610718+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422344795.jpg	14255230	2026-05-22 11:59:18.594784+08	2026-05-22 11:59:18.594784+08
242	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422345494.flv	2026-05-22 11:59:18.406725+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422345494.jpg	14362377	2026-05-22 11:59:19.567436+08	2026-05-22 11:59:19.567436+08
243	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422347690.flv	2026-05-22 11:59:20.107742+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422347690.jpg	14583163	2026-05-22 11:59:21.215385+08	2026-05-22 11:59:21.215385+08
244	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422357611.flv	2026-05-22 11:59:30.830848+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422357611.jpg	14138246	2026-05-22 11:59:31.83628+08	2026-05-22 11:59:31.83628+08
245	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422358407.flv	2026-05-22 11:59:31.690856+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422358407.jpg	14550067	2026-05-22 11:59:33.145993+08	2026-05-22 11:59:33.145993+08
246	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422360108.flv	2026-05-22 11:59:33.766877+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422360108.jpg	15191084	2026-05-22 11:59:34.911086+08	2026-05-22 11:59:34.911086+08
247	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422370831.flv	2026-05-22 11:59:43.802976+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422370831.jpg	13992049	2026-05-22 11:59:44.825031+08	2026-05-22 11:59:44.825031+08
248	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422371691.flv	2026-05-22 11:59:44.756985+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422371691.jpg	14182204	2026-05-22 11:59:45.855192+08	2026-05-22 11:59:45.855192+08
249	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422373768.flv	2026-05-22 11:59:46.016998+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422373768.jpg	14478918	2026-05-22 11:59:47.045144+08	2026-05-22 11:59:47.045144+08
253	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422396244.flv	2026-05-22 12:00:08.707222+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422396244.jpg	14190500	2026-05-22 12:00:09.755407+08	2026-05-22 12:00:09.755407+08
254	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422397005.flv	2026-05-22 12:00:09.53223+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422397005.jpg	13983499	2026-05-22 12:00:10.82612+08	2026-05-22 12:00:10.82612+08
255	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422398199.flv	2026-05-22 12:00:10.372238+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422398199.jpg	14401713	2026-05-22 12:00:11.890972+08	2026-05-22 12:00:11.890972+08
259	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422421513.flv	2026-05-22 12:00:34.226474+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422421513.jpg	13975790	2026-05-22 12:00:35.274792+08	2026-05-22 12:00:35.274792+08
260	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422422512.flv	2026-05-22 12:00:35.361485+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422422512.jpg	13961802	2026-05-22 12:00:36.365835+08	2026-05-22 12:00:36.365835+08
261	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422422772.flv	2026-05-22 12:00:35.378485+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422422772.jpg	13907538	2026-05-22 12:00:37.412387+08	2026-05-22 12:00:37.412387+08
262	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422434227.flv	2026-05-22 12:00:46.853598+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422434227.jpg	14500105	2026-05-22 12:00:47.880658+08	2026-05-22 12:00:47.880658+08
263	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422435379.flv	2026-05-22 12:00:47.891609+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422435379.jpg	14263191	2026-05-22 12:00:48.927303+08	2026-05-22 12:00:48.927303+08
264	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422435362.flv	2026-05-22 12:00:48.092611+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422435362.jpg	14016279	2026-05-22 12:00:50.006738+08	2026-05-22 12:00:50.006738+08
265	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422446854.flv	2026-05-22 12:00:58.769716+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422446854.jpg	14183993	2026-05-22 12:00:59.737033+08	2026-05-22 12:00:59.737033+08
266	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422447893.flv	2026-05-22 12:00:59.560724+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422447893.jpg	13940550	2026-05-22 12:01:00.840866+08	2026-05-22 12:01:00.840866+08
267	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422448093.flv	2026-05-22 12:01:00.21673+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422448093.jpg	14026047	2026-05-22 12:01:01.824992+08	2026-05-22 12:01:01.824992+08
275	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422483383.flv	2026-05-22 12:01:36.277086+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422483383.jpg	13907344	2026-05-22 12:01:38.029827+08	2026-05-22 12:01:38.029827+08
276	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422484702.flv	2026-05-22 12:01:37.405097+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422484702.jpg	14228545	2026-05-22 12:01:39.08725+08	2026-05-22 12:01:39.08725+08
277	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422496007.flv	2026-05-22 12:01:48.84621+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422496007.jpg	14426781	2026-05-22 12:01:49.9866+08	2026-05-22 12:01:49.9866+08
278	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422496279.flv	2026-05-22 12:01:49.456217+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422496279.jpg	13924052	2026-05-22 12:01:51.029755+08	2026-05-22 12:01:51.029755+08
279	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422497407.flv	2026-05-22 12:01:50.587228+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422497407.jpg	13974403	2026-05-22 12:01:52.054165+08	2026-05-22 12:01:52.054165+08
280	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422508848.flv	2026-05-22 12:02:01.185332+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422508848.jpg	14358821	2026-05-22 12:02:02.299942+08	2026-05-22 12:02:02.299942+08
281	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422509457.flv	2026-05-22 12:02:02.02634+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422509457.jpg	14388119	2026-05-22 12:02:03.261932+08	2026-05-22 12:02:03.261932+08
282	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422510589.flv	2026-05-22 12:02:02.787348+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422510589.jpg	14072999	2026-05-22 12:02:04.2984+08	2026-05-22 12:02:04.2984+08
283	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422521187.flv	2026-05-22 12:02:13.197451+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422521187.jpg	14080056	2026-05-22 12:02:14.30232+08	2026-05-22 12:02:14.30232+08
284	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422522027.flv	2026-05-22 12:02:14.293462+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422522027.jpg	14318014	2026-05-22 12:02:15.376315+08	2026-05-22 12:02:15.376315+08
285	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422522789.flv	2026-05-22 12:02:14.873467+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422522789.jpg	13817503	2026-05-22 12:02:16.447806+08	2026-05-22 12:02:16.447806+08
286	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422533198.flv	2026-05-22 12:02:25.843576+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422533198.jpg	14619833	2026-05-22 12:02:26.908435+08	2026-05-22 12:02:26.908435+08
287	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422534294.flv	2026-05-22 12:02:26.917586+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422534294.jpg	14177014	2026-05-22 12:02:27.926217+08	2026-05-22 12:02:27.926217+08
288	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422534874.flv	2026-05-22 12:02:27.361591+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422534874.jpg	14078617	2026-05-22 12:02:28.957515+08	2026-05-22 12:02:28.957515+08
289	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422545844.flv	2026-05-22 12:02:38.947705+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422545844.jpg	14700702	2026-05-22 12:02:40.11786+08	2026-05-22 12:02:40.11786+08
290	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422546919.flv	2026-05-22 12:02:40.318719+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422546919.jpg	14448616	2026-05-22 12:02:41.335064+08	2026-05-22 12:02:41.335064+08
291	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422547362.flv	2026-05-22 12:02:41.084726+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422547362.jpg	14537500	2026-05-22 12:02:42.433948+08	2026-05-22 12:02:42.433948+08
292	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422558948.flv	2026-05-22 12:02:51.911833+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422558948.jpg	14658956	2026-05-22 12:02:52.915514+08	2026-05-22 12:02:52.915514+08
293	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422560319.flv	2026-05-22 12:02:53.279847+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422560319.jpg	13865003	2026-05-22 12:02:54.353633+08	2026-05-22 12:02:54.353633+08
294	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422561085.flv	2026-05-22 12:02:53.769851+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422561085.jpg	14157532	2026-05-22 12:02:55.387408+08	2026-05-22 12:02:55.387408+08
295	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422571913.flv	2026-05-22 12:03:03.76395+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422571913.jpg	13847569	2026-05-22 12:03:04.804408+08	2026-05-22 12:03:04.804408+08
296	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422573280.flv	2026-05-22 12:03:05.79497+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422573280.jpg	14149058	2026-05-22 12:03:06.864128+08	2026-05-22 12:03:06.864128+08
297	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422573770.flv	2026-05-22 12:03:05.971972+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422573770.jpg	14183027	2026-05-22 12:03:07.849441+08	2026-05-22 12:03:07.849441+08
298	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422583765.flv	2026-05-22 12:03:15.89807+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422583765.jpg	13882678	2026-05-22 12:03:16.952419+08	2026-05-22 12:03:16.952419+08
299	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422585796.flv	2026-05-22 12:03:17.853089+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422585796.jpg	14117354	2026-05-22 12:03:18.882348+08	2026-05-22 12:03:18.882348+08
300	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422585974.flv	2026-05-22 12:03:18.045091+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422585974.jpg	14147439	2026-05-22 12:03:20.050744+08	2026-05-22 12:03:20.050744+08
301	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422595899.flv	2026-05-22 12:03:28.12219+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422595899.jpg	14038626	2026-05-22 12:03:29.147817+08	2026-05-22 12:03:29.147817+08
302	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422597855.flv	2026-05-22 12:03:30.05121+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422597855.jpg	14445728	2026-05-22 12:03:31.069316+08	2026-05-22 12:03:31.069316+08
303	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422598046.flv	2026-05-22 12:03:30.314212+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422598046.jpg	13994374	2026-05-22 12:03:32.085891+08	2026-05-22 12:03:32.085891+08
304	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422608124.flv	2026-05-22 12:03:40.340311+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422608124.jpg	14137482	2026-05-22 12:03:41.422235+08	2026-05-22 12:03:41.422235+08
305	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422610053.flv	2026-05-22 12:03:42.29433+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422610053.jpg	14043106	2026-05-22 12:03:43.281441+08	2026-05-22 12:03:43.281441+08
306	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422610315.flv	2026-05-22 12:03:42.628334+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422610315.jpg	14426859	2026-05-22 12:03:44.372961+08	2026-05-22 12:03:44.372961+08
310	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422632337.flv	2026-05-22 12:04:04.658551+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422632337.jpg	14195196	2026-05-22 12:04:05.81297+08	2026-05-22 12:04:05.81297+08
311	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422634538.flv	2026-05-22 12:04:07.357578+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422634538.jpg	14128414	2026-05-22 12:04:08.514769+08	2026-05-22 12:04:08.514769+08
312	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422634736.flv	2026-05-22 12:04:07.642581+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422634736.jpg	13992825	2026-05-22 12:04:09.628133+08	2026-05-22 12:04:09.628133+08
313	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422644660.flv	2026-05-22 12:04:18.081684+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422644660.jpg	14547855	2026-05-22 12:04:19.127668+08	2026-05-22 12:04:19.127668+08
314	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422647359.flv	2026-05-22 12:04:20.79371+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422647359.jpg	14449303	2026-05-22 12:04:21.787204+08	2026-05-22 12:04:21.787204+08
315	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422647643.flv	2026-05-22 12:04:21.127714+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422647643.jpg	14401058	2026-05-22 12:04:22.894262+08	2026-05-22 12:04:22.894262+08
322	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422683633.flv	2026-05-22 12:04:56.151061+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422683633.jpg	14469107	2026-05-22 12:04:57.240787+08	2026-05-22 12:04:57.240787+08
323	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422686190.flv	2026-05-22 12:04:58.700086+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422686190.jpg	14086408	2026-05-22 12:04:59.616761+08	2026-05-22 12:04:59.616761+08
324	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422686507.flv	2026-05-22 12:04:59.238092+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422686507.jpg	14035442	2026-05-22 12:05:00.683157+08	2026-05-22 12:05:00.683157+08
326	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422698701.flv	2026-05-22 12:05:10.955209+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422698701.jpg	13977608	2026-05-22 12:05:11.90806+08	2026-05-22 12:05:11.90806+08
327	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422699239.flv	2026-05-22 12:05:11.573215+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422699239.jpg	14051067	2026-05-22 12:05:13.045403+08	2026-05-22 12:05:13.045403+08
328	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422708434.flv	2026-05-22 12:05:20.495304+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422708434.jpg	14324600	2026-05-22 12:05:21.48699+08	2026-05-22 12:05:21.48699+08
329	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422710956.flv	2026-05-22 12:05:23.310332+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422710956.jpg	14022456	2026-05-22 12:05:24.284848+08	2026-05-22 12:05:24.284848+08
330	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422711574.flv	2026-05-22 12:05:23.898338+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422711574.jpg	13675676	2026-05-22 12:05:25.306579+08	2026-05-22 12:05:25.306579+08
331	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422720496.flv	2026-05-22 12:05:32.408423+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422720496.jpg	14171664	2026-05-22 12:05:33.388086+08	2026-05-22 12:05:33.388086+08
332	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422723311.flv	2026-05-22 12:05:35.700456+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422723311.jpg	14071707	2026-05-22 12:05:36.710349+08	2026-05-22 12:05:36.710349+08
307	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422620341.flv	2026-05-22 12:03:52.33543+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422620341.jpg	13926241	2026-05-22 12:03:53.426758+08	2026-05-22 12:03:53.426758+08
308	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422622295.flv	2026-05-22 12:03:54.536451+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422622295.jpg	14065304	2026-05-22 12:03:55.563684+08	2026-05-22 12:03:55.563684+08
309	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422622629.flv	2026-05-22 12:03:54.735453+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422622629.jpg	14232799	2026-05-22 12:03:56.583329+08	2026-05-22 12:03:56.583329+08
316	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422658083.flv	2026-05-22 12:04:31.202813+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422658083.jpg	14608166	2026-05-22 12:04:32.306383+08	2026-05-22 12:04:32.306383+08
317	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422660794.flv	2026-05-22 12:04:33.779839+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422660794.jpg	14077086	2026-05-22 12:04:34.739619+08	2026-05-22 12:04:34.739619+08
318	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422661128.flv	2026-05-22 12:04:33.978841+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422661128.jpg	13922890	2026-05-22 12:04:35.846403+08	2026-05-22 12:04:35.846403+08
319	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422671203.flv	2026-05-22 12:04:43.631936+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422671203.jpg	14227424	2026-05-22 12:04:44.710762+08	2026-05-22 12:04:44.710762+08
320	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422673780.flv	2026-05-22 12:04:46.188962+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422673780.jpg	13927470	2026-05-22 12:04:47.257747+08	2026-05-22 12:04:47.257747+08
321	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422673980.flv	2026-05-22 12:04:46.505965+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422673980.jpg	14019750	2026-05-22 12:04:48.245493+08	2026-05-22 12:04:48.245493+08
325	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422696152.flv	2026-05-22 12:05:08.433184+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422696152.jpg	14474390	2026-05-22 12:05:09.523599+08	2026-05-22 12:05:09.523599+08
337	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422745020.flv	2026-05-22 12:05:57.356672+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422745020.jpg	14328738	2026-05-22 12:05:58.357515+08	2026-05-22 12:05:58.357515+08
338	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422748361.flv	2026-05-22 12:06:00.690706+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422748361.jpg	14224200	2026-05-22 12:06:01.690878+08	2026-05-22 12:06:01.690878+08
339	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422748533.flv	2026-05-22 12:06:00.778707+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422748533.jpg	14406731	2026-05-22 12:06:02.788363+08	2026-05-22 12:06:02.788363+08
340	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422757357.flv	2026-05-22 12:06:09.424793+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422757357.jpg	14517762	2026-05-22 12:06:10.527557+08	2026-05-22 12:06:10.527557+08
341	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422760691.flv	2026-05-22 12:06:13.13183+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422760691.jpg	13788527	2026-05-22 12:06:14.194174+08	2026-05-22 12:06:14.194174+08
342	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422760779.flv	2026-05-22 12:06:13.307832+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422760779.jpg	14191661	2026-05-22 12:06:15.318009+08	2026-05-22 12:06:15.318009+08
343	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422769425.flv	2026-05-22 12:06:22.13392+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422769425.jpg	15038514	2026-05-22 12:06:23.186095+08	2026-05-22 12:06:23.186095+08
344	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422773308.flv	2026-05-22 12:06:26.15496+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422773308.jpg	14336452	2026-05-22 12:06:27.185356+08	2026-05-22 12:06:27.185356+08
345	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422773133.flv	2026-05-22 12:06:26.17096+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422773133.jpg	14573084	2026-05-22 12:06:28.229448+08	2026-05-22 12:06:28.229448+08
353	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422811778.flv	2026-05-22 12:07:04.529343+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422811778.jpg	14082083	2026-05-22 12:07:05.484309+08	2026-05-22 12:07:05.484309+08
354	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422811963.flv	2026-05-22 12:07:04.699345+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422811963.jpg	14032069	2026-05-22 12:07:06.572587+08	2026-05-22 12:07:06.572587+08
333	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422723899.flv	2026-05-22 12:05:36.046459+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422723899.jpg	13914832	2026-05-22 12:05:37.770302+08	2026-05-22 12:05:37.770302+08
334	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422732409.flv	2026-05-22 12:05:45.019549+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422732409.jpg	14467637	2026-05-22 12:05:46.094914+08	2026-05-22 12:05:46.094914+08
335	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422735701.flv	2026-05-22 12:05:48.360582+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422735701.jpg	14477265	2026-05-22 12:05:49.406414+08	2026-05-22 12:05:49.406414+08
336	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422736048.flv	2026-05-22 12:05:48.532584+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422736048.jpg	14445714	2026-05-22 12:05:50.474277+08	2026-05-22 12:05:50.474277+08
346	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422782135.flv	2026-05-22 12:06:34.972048+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422782135.jpg	14115764	2026-05-22 12:06:36.036744+08	2026-05-22 12:06:36.036744+08
347	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422786156.flv	2026-05-22 12:06:39.22209+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422786156.jpg	14178434	2026-05-22 12:06:40.338174+08	2026-05-22 12:06:40.338174+08
348	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422786172.flv	2026-05-22 12:06:39.382092+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422786172.jpg	14149958	2026-05-22 12:06:41.403428+08	2026-05-22 12:06:41.403428+08
349	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422794973.flv	2026-05-22 12:06:47.650175+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422794973.jpg	13627478	2026-05-22 12:06:48.636658+08	2026-05-22 12:06:48.636658+08
350	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422799223.flv	2026-05-22 12:06:51.777216+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422799223.jpg	14109457	2026-05-22 12:06:52.864188+08	2026-05-22 12:06:52.864188+08
351	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422799384.flv	2026-05-22 12:06:51.962218+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422799384.jpg	14292756	2026-05-22 12:06:54.027017+08	2026-05-22 12:06:54.027017+08
352	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422807651.flv	2026-05-22 12:07:00.402302+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422807651.jpg	14293712	2026-05-22 12:07:01.410053+08	2026-05-22 12:07:01.410053+08
355	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422820403.flv	2026-05-22 12:07:12.537423+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422820403.jpg	13973096	2026-05-22 12:07:13.599769+08	2026-05-22 12:07:13.599769+08
356	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422824531.flv	2026-05-22 12:07:16.964468+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422824531.jpg	14011003	2026-05-22 12:07:17.983065+08	2026-05-22 12:07:17.983065+08
357	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422824700.flv	2026-05-22 12:07:17.21047+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422824700.jpg	13888935	2026-05-22 12:07:18.97629+08	2026-05-22 12:07:18.97629+08
358	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422832539.flv	2026-05-22 12:07:24.778546+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422832539.jpg	13817905	2026-05-22 12:07:25.82585+08	2026-05-22 12:07:25.82585+08
359	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422836965.flv	2026-05-22 12:07:29.548593+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422836965.jpg	13930995	2026-05-22 12:07:30.581279+08	2026-05-22 12:07:30.581279+08
360	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422837211.flv	2026-05-22 12:07:29.859596+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422837211.jpg	14151425	2026-05-22 12:07:31.536411+08	2026-05-22 12:07:31.536411+08
361	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422844779.flv	2026-05-22 12:07:37.146669+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422844779.jpg	13807615	2026-05-22 12:07:38.318199+08	2026-05-22 12:07:38.318199+08
362	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422849549.flv	2026-05-22 12:07:42.662724+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422849549.jpg	14096918	2026-05-22 12:07:43.708563+08	2026-05-22 12:07:43.708563+08
363	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422849860.flv	2026-05-22 12:07:42.943727+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422849860.jpg	13977227	2026-05-22 12:07:44.704664+08	2026-05-22 12:07:44.704664+08
364	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422857147.flv	2026-05-22 12:07:50.109799+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422857147.jpg	14388596	2026-05-22 12:07:51.11898+08	2026-05-22 12:07:51.11898+08
365	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422862945.flv	2026-05-22 12:07:55.23685+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422862945.jpg	14022014	2026-05-22 12:07:56.230701+08	2026-05-22 12:07:56.230701+08
366	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422862663.flv	2026-05-22 12:07:55.25285+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422862663.jpg	13933167	2026-05-22 12:07:57.28799+08	2026-05-22 12:07:57.28799+08
367	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422870110.flv	2026-05-22 12:08:02.20592+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422870110.jpg	14234440	2026-05-22 12:08:03.288714+08	2026-05-22 12:08:03.288714+08
368	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422875237.flv	2026-05-22 12:08:07.466972+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422875237.jpg	14327210	2026-05-22 12:08:08.440737+08	2026-05-22 12:08:08.440737+08
369	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422875253.flv	2026-05-22 12:08:07.483972+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422875253.jpg	14198353	2026-05-22 12:08:09.466597+08	2026-05-22 12:08:09.466597+08
370	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422882208.flv	2026-05-22 12:08:14.340041+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422882208.jpg	14423068	2026-05-22 12:08:15.38924+08	2026-05-22 12:08:15.38924+08
371	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422887485.flv	2026-05-22 12:08:19.655094+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422887485.jpg	14387546	2026-05-22 12:08:20.636831+08	2026-05-22 12:08:20.636831+08
372	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422887468.flv	2026-05-22 12:08:19.969097+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422887468.jpg	13884195	2026-05-22 12:08:21.736698+08	2026-05-22 12:08:21.736698+08
373	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422894342.flv	2026-05-22 12:08:26.33216+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422894342.jpg	14548116	2026-05-22 12:08:27.410638+08	2026-05-22 12:08:27.410638+08
382	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422930666.flv	2026-05-22 12:09:02.610523+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422930666.jpg	14303338	2026-05-22 12:09:03.655222+08	2026-05-22 12:09:03.655222+08
383	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422936542.flv	2026-05-22 12:09:09.202589+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422936542.jpg	14385593	2026-05-22 12:09:10.217027+08	2026-05-22 12:09:10.217027+08
384	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422937311.flv	2026-05-22 12:09:10.003597+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422937311.jpg	13854128	2026-05-22 12:09:11.212503+08	2026-05-22 12:09:11.212503+08
385	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422942611.flv	2026-05-22 12:09:15.058647+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422942611.jpg	14419875	2026-05-22 12:09:16.094311+08	2026-05-22 12:09:16.094311+08
386	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422949203.flv	2026-05-22 12:09:21.736714+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422949203.jpg	14262992	2026-05-22 12:09:22.71826+08	2026-05-22 12:09:22.71826+08
387	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422950004.flv	2026-05-22 12:09:22.34772+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422950004.jpg	14191403	2026-05-22 12:09:23.748084+08	2026-05-22 12:09:23.748084+08
388	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422955059.flv	2026-05-22 12:09:27.37477+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422955059.jpg	14289658	2026-05-22 12:09:28.357988+08	2026-05-22 12:09:28.357988+08
389	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422961737.flv	2026-05-22 12:09:33.942836+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422961737.jpg	14182893	2026-05-22 12:09:34.854854+08	2026-05-22 12:09:34.854854+08
390	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422962348.flv	2026-05-22 12:09:34.624843+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422962348.jpg	14227211	2026-05-22 12:09:35.821647+08	2026-05-22 12:09:35.821647+08
391	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422967375.flv	2026-05-22 12:09:39.39789+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422967375.jpg	14061543	2026-05-22 12:09:40.426678+08	2026-05-22 12:09:40.426678+08
392	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422973943.flv	2026-05-22 12:09:46.130957+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422973943.jpg	13764867	2026-05-22 12:09:47.10522+08	2026-05-22 12:09:47.10522+08
393	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422974625.flv	2026-05-22 12:09:46.799964+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422974625.jpg	13950955	2026-05-22 12:09:48.064365+08	2026-05-22 12:09:48.064365+08
397	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422991525.flv	2026-05-22 12:10:03.243128+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422991525.jpg	13812252	2026-05-22 12:10:04.24735+08	2026-05-22 12:10:04.24735+08
398	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422997994.flv	2026-05-22 12:10:10.052197+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422997994.jpg	14152923	2026-05-22 12:10:11.10925+08	2026-05-22 12:10:11.10925+08
399	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422998931.flv	2026-05-22 12:10:10.928205+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422998931.jpg	13960077	2026-05-22 12:10:12.095034+08	2026-05-22 12:10:12.095034+08
400	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423003244.flv	2026-05-22 12:10:15.133247+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423003244.jpg	14113873	2026-05-22 12:10:16.157452+08	2026-05-22 12:10:16.157452+08
401	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423010053.flv	2026-05-22 12:10:21.956315+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423010053.jpg	13570011	2026-05-22 12:10:22.864131+08	2026-05-22 12:10:22.864131+08
402	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423010929.flv	2026-05-22 12:10:22.858324+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423010929.jpg	14215242	2026-05-22 12:10:23.791022+08	2026-05-22 12:10:23.791022+08
403	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423015134.flv	2026-05-22 12:10:27.082366+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423015134.jpg	14602855	2026-05-22 12:10:28.169403+08	2026-05-22 12:10:28.169403+08
417	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423073030.flv	2026-05-22 12:11:25.965955+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423073030.jpg	14396544	2026-05-22 12:11:27.109406+08	2026-05-22 12:11:27.109406+08
374	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422899656.flv	2026-05-22 12:08:32.25622+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422899656.jpg	14302193	2026-05-22 12:08:33.345181+08	2026-05-22 12:08:33.345181+08
375	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422899970.flv	2026-05-22 12:08:32.636223+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422899970.jpg	14361278	2026-05-22 12:08:34.376599+08	2026-05-22 12:08:34.376599+08
376	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422906333.flv	2026-05-22 12:08:38.564283+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422906333.jpg	14387906	2026-05-22 12:08:39.64001+08	2026-05-22 12:08:39.64001+08
377	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422912257.flv	2026-05-22 12:08:44.569343+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422912257.jpg	14109938	2026-05-22 12:08:45.573634+08	2026-05-22 12:08:45.573634+08
378	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422912638.flv	2026-05-22 12:08:45.115348+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422912638.jpg	13896989	2026-05-22 12:08:46.543743+08	2026-05-22 12:08:46.543743+08
379	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422918566.flv	2026-05-22 12:08:50.664403+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422918566.jpg	14217025	2026-05-22 12:08:51.703389+08	2026-05-22 12:08:51.703389+08
380	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422924571.flv	2026-05-22 12:08:56.541462+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422924571.jpg	14046313	2026-05-22 12:08:57.554331+08	2026-05-22 12:08:57.554331+08
381	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422925116.flv	2026-05-22 12:08:57.31047+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422925116.jpg	14318090	2026-05-22 12:08:58.585199+08	2026-05-22 12:08:58.585199+08
394	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422979399.flv	2026-05-22 12:09:51.524011+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779422979399.jpg	14123026	2026-05-22 12:09:52.518803+08	2026-05-22 12:09:52.518803+08
395	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422986132.flv	2026-05-22 12:09:57.993076+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779422986132.jpg	13782480	2026-05-22 12:09:58.953828+08	2026-05-22 12:09:58.953828+08
396	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422986801.flv	2026-05-22 12:09:58.929085+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779422986801.jpg	14276344	2026-05-22 12:09:59.972992+08	2026-05-22 12:09:59.972992+08
404	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423021957.flv	2026-05-22 12:10:34.541441+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423021957.jpg	14489075	2026-05-22 12:10:35.609035+08	2026-05-22 12:10:35.609035+08
405	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423022860.flv	2026-05-22 12:10:35.630452+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423022860.jpg	14401431	2026-05-22 12:10:36.7533+08	2026-05-22 12:10:36.7533+08
406	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423027083.flv	2026-05-22 12:10:40.223498+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423027083.jpg	14683175	2026-05-22 12:10:41.294656+08	2026-05-22 12:10:41.294656+08
407	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423034542.flv	2026-05-22 12:10:47.48757+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423034542.jpg	14523615	2026-05-22 12:10:48.577191+08	2026-05-22 12:10:48.577191+08
408	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423035631.flv	2026-05-22 12:10:48.41258+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423035631.jpg	14009383	2026-05-22 12:10:49.630205+08	2026-05-22 12:10:49.630205+08
409	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423040224.flv	2026-05-22 12:10:52.46462+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423040224.jpg	14078977	2026-05-22 12:10:53.554989+08	2026-05-22 12:10:53.554989+08
410	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423047488.flv	2026-05-22 12:10:59.708693+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423047488.jpg	13922089	2026-05-22 12:11:00.702382+08	2026-05-22 12:11:00.702382+08
411	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423048413.flv	2026-05-22 12:11:00.871704+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423048413.jpg	14420279	2026-05-22 12:11:01.825834+08	2026-05-22 12:11:01.825834+08
412	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423052466.flv	2026-05-22 12:11:04.648742+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423052466.jpg	14048991	2026-05-22 12:11:05.669822+08	2026-05-22 12:11:05.669822+08
413	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423059710.flv	2026-05-22 12:11:12.013815+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423059710.jpg	14355749	2026-05-22 12:11:13.044282+08	2026-05-22 12:11:13.044282+08
414	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423060873.flv	2026-05-22 12:11:13.029825+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423060873.jpg	13584850	2026-05-22 12:11:14.13156+08	2026-05-22 12:11:14.13156+08
415	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423064649.flv	2026-05-22 12:11:17.336869+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423064649.jpg	14445836	2026-05-22 12:11:19.535473+08	2026-05-22 12:11:19.535473+08
416	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423072014.flv	2026-05-22 12:11:25.046946+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423072014.jpg	14009272	2026-05-22 12:11:26.023833+08	2026-05-22 12:11:26.023833+08
418	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423077338.flv	2026-05-22 12:11:29.886994+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423077338.jpg	14735421	2026-05-22 12:11:30.898788+08	2026-05-22 12:11:30.898788+08
419	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423085048.flv	2026-05-22 12:11:37.219067+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423085048.jpg	14030219	2026-05-22 12:11:38.233845+08	2026-05-22 12:11:38.233845+08
425	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423109469.flv	2026-05-22 12:12:01.895314+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423109469.jpg	14093802	2026-05-22 12:12:02.896746+08	2026-05-22 12:12:02.896746+08
428	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423121896.flv	2026-05-22 12:12:13.965434+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423121896.jpg	14292178	2026-05-22 12:12:14.998153+08	2026-05-22 12:12:14.998153+08
431	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423133966.flv	2026-05-22 12:12:26.109555+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423133966.jpg	13973006	2026-05-22 12:12:27.119322+08	2026-05-22 12:12:27.119322+08
448	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423198652.flv	2026-05-22 12:13:31.089205+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423198652.jpg	15007361	2026-05-22 12:13:32.117522+08	2026-05-22 12:13:32.117522+08
420	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423085967.flv	2026-05-22 12:11:38.243077+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423085967.jpg	14159145	2026-05-22 12:11:39.31721+08	2026-05-22 12:11:39.31721+08
429	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423122878.flv	2026-05-22 12:12:14.803442+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423122878.jpg	14042770	2026-05-22 12:12:16.115416+08	2026-05-22 12:12:16.115416+08
432	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423134804.flv	2026-05-22 12:12:27.430569+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423134804.jpg	14174390	2026-05-22 12:12:28.492835+08	2026-05-22 12:12:28.492835+08
434	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423146111.flv	2026-05-22 12:12:38.658681+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423146111.jpg	13738710	2026-05-22 12:12:39.751463+08	2026-05-22 12:12:39.751463+08
444	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423184401.flv	2026-05-22 12:13:16.571059+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423184401.jpg	13970800	2026-05-22 12:13:17.603133+08	2026-05-22 12:13:17.603133+08
421	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423089888.flv	2026-05-22 12:11:41.709112+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423089888.jpg	14003366	2026-05-22 12:11:42.697132+08	2026-05-22 12:11:42.697132+08
424	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423101710.flv	2026-05-22 12:11:53.962234+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423101710.jpg	14032541	2026-05-22 12:11:55.055613+08	2026-05-22 12:11:55.055613+08
426	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423110599.flv	2026-05-22 12:12:02.876323+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423110599.jpg	14045613	2026-05-22 12:12:03.925808+08	2026-05-22 12:12:03.925808+08
433	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423138218.flv	2026-05-22 12:12:30.493599+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423138218.jpg	14082910	2026-05-22 12:12:31.664128+08	2026-05-22 12:12:31.664128+08
435	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423147431.flv	2026-05-22 12:12:40.003694+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423147431.jpg	14138258	2026-05-22 12:12:40.920759+08	2026-05-22 12:12:40.920759+08
438	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423160004.flv	2026-05-22 12:12:52.220816+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423160004.jpg	13958644	2026-05-22 12:12:53.163712+08	2026-05-22 12:12:53.163712+08
441	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423172221.flv	2026-05-22 12:13:04.399938+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423172221.jpg	13977241	2026-05-22 12:13:05.387652+08	2026-05-22 12:13:05.387652+08
447	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423196572.flv	2026-05-22 12:13:29.173185+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423196572.jpg	14389869	2026-05-22 12:13:30.125192+08	2026-05-22 12:13:30.125192+08
422	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423097220.flv	2026-05-22 12:11:49.468189+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423097220.jpg	14017004	2026-05-22 12:11:50.500476+08	2026-05-22 12:11:50.500476+08
423	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423098244.flv	2026-05-22 12:11:50.597201+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423098244.jpg	14023296	2026-05-22 12:11:51.565946+08	2026-05-22 12:11:51.565946+08
436	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423150495.flv	2026-05-22 12:12:42.850723+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423150495.jpg	14215519	2026-05-22 12:12:43.887509+08	2026-05-22 12:12:43.887509+08
437	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423158660.flv	2026-05-22 12:12:50.915803+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423158660.jpg	14335613	2026-05-22 12:12:51.895138+08	2026-05-22 12:12:51.895138+08
440	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423170917.flv	2026-05-22 12:13:03.069925+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423170917.jpg	13990019	2026-05-22 12:13:04.098698+08	2026-05-22 12:13:04.098698+08
442	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423174877.flv	2026-05-22 12:13:06.722961+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423174877.jpg	13794284	2026-05-22 12:13:07.778729+08	2026-05-22 12:13:07.778729+08
443	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423183071.flv	2026-05-22 12:13:15.109045+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423183071.jpg	13854114	2026-05-22 12:13:16.140508+08	2026-05-22 12:13:16.140508+08
445	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423186725.flv	2026-05-22 12:13:18.65108+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423186725.jpg	14366262	2026-05-22 12:13:19.754969+08	2026-05-22 12:13:19.754969+08
446	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423195110.flv	2026-05-22 12:13:27.532169+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423195110.jpg	14331487	2026-05-22 12:13:28.519011+08	2026-05-22 12:13:28.519011+08
427	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423113963.flv	2026-05-22 12:12:06.152356+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423113963.jpg	14127622	2026-05-22 12:12:07.156385+08	2026-05-22 12:12:07.156385+08
430	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423126154.flv	2026-05-22 12:12:18.216477+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423126154.jpg	14317108	2026-05-22 12:12:19.251287+08	2026-05-22 12:12:19.251287+08
439	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423162851.flv	2026-05-22 12:12:54.876843+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423162851.jpg	14534172	2026-05-22 12:12:55.930991+08	2026-05-22 12:12:55.930991+08
449	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423207534.flv	2026-05-22 12:13:39.396287+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423207534.jpg	14184759	2026-05-22 12:13:40.386694+08	2026-05-22 12:13:40.386694+08
450	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423209174.flv	2026-05-22 12:13:41.243306+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423209174.jpg	14202197	2026-05-22 12:13:42.219847+08	2026-05-22 12:13:42.219847+08
451	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423211090.flv	2026-05-22 12:13:42.941323+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423211090.jpg	13754321	2026-05-22 12:13:44.035247+08	2026-05-22 12:13:44.035247+08
452	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423219397.flv	2026-05-22 12:13:51.329407+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423219397.jpg	13843009	2026-05-22 12:13:52.388976+08	2026-05-22 12:13:52.388976+08
453	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423221244.flv	2026-05-22 12:13:53.170425+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423221244.jpg	14116818	2026-05-22 12:13:54.152374+08	2026-05-22 12:13:54.152374+08
454	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423222942.flv	2026-05-22 12:13:54.755441+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423222942.jpg	13940276	2026-05-22 12:13:55.797695+08	2026-05-22 12:13:55.797695+08
455	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423231330.flv	2026-05-22 12:14:03.616529+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423231330.jpg	14359353	2026-05-22 12:14:04.656826+08	2026-05-22 12:14:04.656826+08
456	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423233171.flv	2026-05-22 12:14:05.179545+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423233171.jpg	14320847	2026-05-22 12:14:06.151046+08	2026-05-22 12:14:06.151046+08
457	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423234757.flv	2026-05-22 12:14:06.65256+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423234757.jpg	14135560	2026-05-22 12:14:07.689245+08	2026-05-22 12:14:07.689245+08
458	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423243618.flv	2026-05-22 12:14:15.63365+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423243618.jpg	14149127	2026-05-22 12:14:16.605191+08	2026-05-22 12:14:16.605191+08
459	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423245180.flv	2026-05-22 12:14:17.228665+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423245180.jpg	13943987	2026-05-22 12:14:18.263726+08	2026-05-22 12:14:18.263726+08
460	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423246653.flv	2026-05-22 12:14:18.494678+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423246653.jpg	13933619	2026-05-22 12:14:19.584496+08	2026-05-22 12:14:19.584496+08
461	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423255634.flv	2026-05-22 12:14:27.841771+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423255634.jpg	13697967	2026-05-22 12:14:28.867699+08	2026-05-22 12:14:28.867699+08
462	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423257229.flv	2026-05-22 12:14:29.433787+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423257229.jpg	13902001	2026-05-22 12:14:30.465853+08	2026-05-22 12:14:30.465853+08
463	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423258496.flv	2026-05-22 12:14:30.804801+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423258496.jpg	14317144	2026-05-22 12:14:31.886631+08	2026-05-22 12:14:31.886631+08
464	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423267843.flv	2026-05-22 12:14:39.817891+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423267843.jpg	14274641	2026-05-22 12:14:40.944499+08	2026-05-22 12:14:40.944499+08
465	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423269434.flv	2026-05-22 12:14:41.608909+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423269434.jpg	13887508	2026-05-22 12:14:42.611946+08	2026-05-22 12:14:42.611946+08
466	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423270806.flv	2026-05-22 12:14:42.887922+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423270806.jpg	14307749	2026-05-22 12:14:43.980316+08	2026-05-22 12:14:43.980316+08
467	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423279818.flv	2026-05-22 12:14:52.479017+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423279818.jpg	14238972	2026-05-22 12:14:53.537179+08	2026-05-22 12:14:53.537179+08
468	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423281610.flv	2026-05-22 12:14:54.335036+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423281610.jpg	14495741	2026-05-22 12:14:55.446446+08	2026-05-22 12:14:55.446446+08
469	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423282889.flv	2026-05-22 12:14:55.450047+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423282889.jpg	14090088	2026-05-22 12:14:56.555186+08	2026-05-22 12:14:56.555186+08
470	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423292480.flv	2026-05-22 12:15:05.087143+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423292480.jpg	14263749	2026-05-22 12:15:06.137108+08	2026-05-22 12:15:06.137108+08
471	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423294337.flv	2026-05-22 12:15:06.835161+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423294337.jpg	14314908	2026-05-22 12:15:07.846409+08	2026-05-22 12:15:07.846409+08
474	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423306837.flv	2026-05-22 12:15:19.349286+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423306837.jpg	13995262	2026-05-22 12:15:20.343621+08	2026-05-22 12:15:20.343621+08
481	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423332540.flv	2026-05-22 12:15:45.173544+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423332540.jpg	14211822	2026-05-22 12:15:47.115754+08	2026-05-22 12:15:47.115754+08
482	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423343222.flv	2026-05-22 12:15:55.78565+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423343222.jpg	14253645	2026-05-22 12:15:56.764327+08	2026-05-22 12:15:56.764327+08
486	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423357472.flv	2026-05-22 12:16:09.660789+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423357472.jpg	13873631	2026-05-22 12:16:10.702971+08	2026-05-22 12:16:10.702971+08
491	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423380537.flv	2026-05-22 12:16:33.064022+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423380537.jpg	13990421	2026-05-22 12:16:34.088157+08	2026-05-22 12:16:34.088157+08
504	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423430396.flv	2026-05-22 12:17:23.020521+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423430396.jpg	14227714	2026-05-22 12:17:24.147027+08	2026-05-22 12:17:24.147027+08
506	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423442027.flv	2026-05-22 12:17:34.644637+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423442027.jpg	13726434	2026-05-22 12:17:35.746526+08	2026-05-22 12:17:35.746526+08
512	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423467860.flv	2026-05-22 12:18:00.226893+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423467860.jpg	13824895	2026-05-22 12:18:01.214989+08	2026-05-22 12:18:01.214989+08
517	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423482650.flv	2026-05-22 12:18:15.767048+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423482650.jpg	13940248	2026-05-22 12:18:16.891508+08	2026-05-22 12:18:16.891508+08
519	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423493578.flv	2026-05-22 12:18:27.725168+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423493578.jpg	15334890	2026-05-22 12:18:29.740272+08	2026-05-22 12:18:29.740272+08
522	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423507726.flv	2026-05-22 12:18:42.168312+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423507726.jpg	14846464	2026-05-22 12:18:44.204554+08	2026-05-22 12:18:44.204554+08
525	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423522169.flv	2026-05-22 12:18:55.603446+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423522169.jpg	14288937	2026-05-22 12:18:57.476832+08	2026-05-22 12:18:57.476832+08
530	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423548387.flv	2026-05-22 12:19:21.601706+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423548387.jpg	13750254	2026-05-22 12:19:22.613492+08	2026-05-22 12:19:22.613492+08
533	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423561602.flv	2026-05-22 12:19:33.975829+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423561602.jpg	13926330	2026-05-22 12:19:34.959437+08	2026-05-22 12:19:34.959437+08
539	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423586142.flv	2026-05-22 12:19:57.951069+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423586142.jpg	13880567	2026-05-22 12:20:01.288916+08	2026-05-22 12:20:01.288916+08
541	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423589432.flv	2026-05-22 12:20:02.03311+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423589432.jpg	13769846	2026-05-22 12:20:03.464153+08	2026-05-22 12:20:03.464153+08
546	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423611779.flv	2026-05-22 12:20:24.287332+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423611779.jpg	14164511	2026-05-22 12:20:25.357992+08	2026-05-22 12:20:25.357992+08
472	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423295452.flv	2026-05-22 12:15:07.848171+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423295452.jpg	14986827	2026-05-22 12:15:08.972143+08	2026-05-22 12:15:08.972143+08
475	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423307849.flv	2026-05-22 12:15:19.886291+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423307849.jpg	14106952	2026-05-22 12:15:21.425194+08	2026-05-22 12:15:21.425194+08
476	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423317607.flv	2026-05-22 12:15:30.356396+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423317607.jpg	14436909	2026-05-22 12:15:31.520656+08	2026-05-22 12:15:31.520656+08
478	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423319887.flv	2026-05-22 12:15:32.539418+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423319887.jpg	14922524	2026-05-22 12:15:34.459873+08	2026-05-22 12:15:34.459873+08
480	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423332266.flv	2026-05-22 12:15:45.029542+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423332266.jpg	14430886	2026-05-22 12:15:46.091942+08	2026-05-22 12:15:46.091942+08
490	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423370397.flv	2026-05-22 12:16:22.77992+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423370397.jpg	13924236	2026-05-22 12:16:24.149242+08	2026-05-22 12:16:24.149242+08
493	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423382781.flv	2026-05-22 12:16:35.482046+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423382781.jpg	14151209	2026-05-22 12:16:36.485709+08	2026-05-22 12:16:36.485709+08
494	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423393065.flv	2026-05-22 12:16:45.213144+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423393065.jpg	13713597	2026-05-22 12:16:46.211816+08	2026-05-22 12:16:46.211816+08
496	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423395483.flv	2026-05-22 12:16:47.804169+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423395483.jpg	14076398	2026-05-22 12:16:48.810426+08	2026-05-22 12:16:48.810426+08
497	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423405214.flv	2026-05-22 12:16:57.296264+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423405214.jpg	13852559	2026-05-22 12:16:58.357505+08	2026-05-22 12:16:58.357505+08
500	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423417297.flv	2026-05-22 12:17:09.387385+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423417297.jpg	14381043	2026-05-22 12:17:10.411047+08	2026-05-22 12:17:10.411047+08
503	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423429389.flv	2026-05-22 12:17:22.025511+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423429389.jpg	14278289	2026-05-22 12:17:23.024043+08	2026-05-22 12:17:23.024043+08
528	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423535402.flv	2026-05-22 12:19:08.386574+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423535402.jpg	14194835	2026-05-22 12:19:10.50985+08	2026-05-22 12:19:10.50985+08
531	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423548374.flv	2026-05-22 12:19:21.887709+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423548374.jpg	14648935	2026-05-22 12:19:23.72963+08	2026-05-22 12:19:23.72963+08
534	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423561888.flv	2026-05-22 12:19:34.131831+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423561888.jpg	13939539	2026-05-22 12:19:35.985862+08	2026-05-22 12:19:35.985862+08
536	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423574132.flv	2026-05-22 12:19:46.139951+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423574132.jpg	13963142	2026-05-22 12:19:47.212452+08	2026-05-22 12:19:47.212452+08
540	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423586366.flv	2026-05-22 12:19:58.700076+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423586366.jpg	13542087	2026-05-22 12:20:02.387074+08	2026-05-22 12:20:02.387074+08
542	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423597952.flv	2026-05-22 12:20:10.766197+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423597952.jpg	14522747	2026-05-22 12:20:11.870689+08	2026-05-22 12:20:11.870689+08
544	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423602034.flv	2026-05-22 12:20:14.851238+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423602034.jpg	14072453	2026-05-22 12:20:15.944259+08	2026-05-22 12:20:15.944259+08
473	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423305088.flv	2026-05-22 12:15:17.606268+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423305088.jpg	14069047	2026-05-22 12:15:18.61457+08	2026-05-22 12:15:18.61457+08
477	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423319350.flv	2026-05-22 12:15:32.265415+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423319350.jpg	13961255	2026-05-22 12:15:33.338677+08	2026-05-22 12:15:33.338677+08
479	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423330358.flv	2026-05-22 12:15:43.221524+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423330358.jpg	14055078	2026-05-22 12:15:44.25285+08	2026-05-22 12:15:44.25285+08
487	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423357656.flv	2026-05-22 12:16:10.395796+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423357656.jpg	13744470	2026-05-22 12:16:11.696793+08	2026-05-22 12:16:11.696793+08
499	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423407805.flv	2026-05-22 12:16:59.983291+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423407805.jpg	13848717	2026-05-22 12:17:00.95697+08	2026-05-22 12:17:00.95697+08
515	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423480227.flv	2026-05-22 12:18:13.116022+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423480227.jpg	13994688	2026-05-22 12:18:14.099907+08	2026-05-22 12:18:14.099907+08
521	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423507519.flv	2026-05-22 12:18:41.929309+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423507519.jpg	14391110	2026-05-22 12:18:43.051936+08	2026-05-22 12:18:43.051936+08
526	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423524844.flv	2026-05-22 12:18:58.093471+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423524844.jpg	14164385	2026-05-22 12:18:59.173093+08	2026-05-22 12:18:59.173093+08
527	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423535604.flv	2026-05-22 12:19:08.373574+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423535604.jpg	14377457	2026-05-22 12:19:09.363254+08	2026-05-22 12:19:09.363254+08
529	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423538094.flv	2026-05-22 12:19:11.128601+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423538094.jpg	14043076	2026-05-22 12:19:12.152614+08	2026-05-22 12:19:12.152614+08
532	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423551129.flv	2026-05-22 12:19:24.347733+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423551129.jpg	14334157	2026-05-22 12:19:25.379258+08	2026-05-22 12:19:25.379258+08
535	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423564348.flv	2026-05-22 12:19:36.892859+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423564348.jpg	14164786	2026-05-22 12:19:37.991204+08	2026-05-22 12:19:37.991204+08
537	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423573977.flv	2026-05-22 12:19:46.363953+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423573977.jpg	13865413	2026-05-22 12:19:48.235004+08	2026-05-22 12:19:48.235004+08
483	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423345174.flv	2026-05-22 12:15:57.471667+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423345174.jpg	14014249	2026-05-22 12:15:58.465438+08	2026-05-22 12:15:58.465438+08
485	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423355786.flv	2026-05-22 12:16:08.135773+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423355786.jpg	13874172	2026-05-22 12:16:09.111088+08	2026-05-22 12:16:09.111088+08
488	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423368136.flv	2026-05-22 12:16:20.536897+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423368136.jpg	14264307	2026-05-22 12:16:21.501444+08	2026-05-22 12:16:21.501444+08
489	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423369661.flv	2026-05-22 12:16:22.141913+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423369661.jpg	14649079	2026-05-22 12:16:23.159305+08	2026-05-22 12:16:23.159305+08
492	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423382143.flv	2026-05-22 12:16:34.318035+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423382143.jpg	14308009	2026-05-22 12:16:35.438741+08	2026-05-22 12:16:35.438741+08
498	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423406193.flv	2026-05-22 12:16:58.218273+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423406193.jpg	14151249	2026-05-22 12:16:59.497478+08	2026-05-22 12:16:59.497478+08
501	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423418219.flv	2026-05-22 12:17:10.395395+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423418219.jpg	13866599	2026-05-22 12:17:11.412558+08	2026-05-22 12:17:11.412558+08
502	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423419984.flv	2026-05-22 12:17:12.194413+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423419984.jpg	14414804	2026-05-22 12:17:13.153636+08	2026-05-22 12:17:13.153636+08
505	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423432195.flv	2026-05-22 12:17:24.691538+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423432195.jpg	14375686	2026-05-22 12:17:25.650588+08	2026-05-22 12:17:25.650588+08
507	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423443021.flv	2026-05-22 12:17:35.572647+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423443021.jpg	14485760	2026-05-22 12:17:36.867727+08	2026-05-22 12:17:36.867727+08
509	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423454645.flv	2026-05-22 12:17:47.859769+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423454645.jpg	14123981	2026-05-22 12:17:48.96035+08	2026-05-22 12:17:48.96035+08
511	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423457454.flv	2026-05-22 12:17:50.187793+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423457454.jpg	14184106	2026-05-22 12:17:51.290506+08	2026-05-22 12:17:51.290506+08
513	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423468290.flv	2026-05-22 12:18:00.625897+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423468290.jpg	13951288	2026-05-22 12:18:02.345263+08	2026-05-22 12:18:02.345263+08
516	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423480627.flv	2026-05-22 12:18:13.577026+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423480627.jpg	14165779	2026-05-22 12:18:15.233803+08	2026-05-22 12:18:15.233803+08
518	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423493117.flv	2026-05-22 12:18:27.518166+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423493117.jpg	14416681	2026-05-22 12:18:28.559368+08	2026-05-22 12:18:28.559368+08
538	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423576893.flv	2026-05-22 12:19:49.430984+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423576893.jpg	13900037	2026-05-22 12:19:50.42171+08	2026-05-22 12:19:50.42171+08
543	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423598701.flv	2026-05-22 12:20:11.777207+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423598701.jpg	14659310	2026-05-22 12:20:12.933828+08	2026-05-22 12:20:12.933828+08
545	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423610767.flv	2026-05-22 12:20:23.05232+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423610767.jpg	14064449	2026-05-22 12:20:24.174129+08	2026-05-22 12:20:24.174129+08
548	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423623053.flv	2026-05-22 12:20:35.501444+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423623053.jpg	13512378	2026-05-22 12:20:36.593504+08	2026-05-22 12:20:36.593504+08
484	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423345030.flv	2026-05-22 12:15:57.655668+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423345030.jpg	13966994	2026-05-22 12:15:59.555921+08	2026-05-22 12:15:59.555921+08
495	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423394319.flv	2026-05-22 12:16:46.191153+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423394319.jpg	13745181	2026-05-22 12:16:47.311952+08	2026-05-22 12:16:47.311952+08
508	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423444693.flv	2026-05-22 12:17:37.452665+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423444693.jpg	14133470	2026-05-22 12:17:38.4486+08	2026-05-22 12:17:38.4486+08
510	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423455573.flv	2026-05-22 12:17:48.288774+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423455573.jpg	14092913	2026-05-22 12:17:50.032792+08	2026-05-22 12:17:50.032792+08
514	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423470188.flv	2026-05-22 12:18:02.647917+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423470188.jpg	14368688	2026-05-22 12:18:03.595005+08	2026-05-22 12:18:03.595005+08
520	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423495769.flv	2026-05-22 12:18:30.431195+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423495769.jpg	13880005	2026-05-22 12:18:31.539836+08	2026-05-22 12:18:31.539836+08
523	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423510432.flv	2026-05-22 12:18:44.843338+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423510432.jpg	14419099	2026-05-22 12:18:45.875172+08	2026-05-22 12:18:45.875172+08
524	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423521930.flv	2026-05-22 12:18:55.401444+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423521930.jpg	14107713	2026-05-22 12:18:56.464384+08	2026-05-22 12:18:56.464384+08
547	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423614853.flv	2026-05-22 12:20:27.272362+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423614853.jpg	14060919	2026-05-22 12:20:28.250627+08	2026-05-22 12:20:28.250627+08
549	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423624288.flv	2026-05-22 12:20:36.712456+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423624288.jpg	14109248	2026-05-22 12:20:37.820505+08	2026-05-22 12:20:37.820505+08
550	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423627273.flv	2026-05-22 12:20:39.636485+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423627273.jpg	14041552	2026-05-22 12:20:40.592083+08	2026-05-22 12:20:40.592083+08
551	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423635502.flv	2026-05-22 12:20:48.15957+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423635502.jpg	14121350	2026-05-22 12:20:50.318592+08	2026-05-22 12:20:50.318592+08
552	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423636713.flv	2026-05-22 12:20:49.351582+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423636713.jpg	14202330	2026-05-22 12:20:51.39975+08	2026-05-22 12:20:51.39975+08
553	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423639637.flv	2026-05-22 12:20:52.666615+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423639637.jpg	14069280	2026-05-22 12:20:53.634549+08	2026-05-22 12:20:53.634549+08
554	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423648160.flv	2026-05-22 12:21:01.004699+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423648160.jpg	14286573	2026-05-22 12:21:02.118035+08	2026-05-22 12:21:02.118035+08
555	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423649352.flv	2026-05-22 12:21:02.223711+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423649352.jpg	14712424	2026-05-22 12:21:03.179122+08	2026-05-22 12:21:03.179122+08
556	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423652667.flv	2026-05-22 12:21:05.642745+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423652667.jpg	13927479	2026-05-22 12:21:06.649683+08	2026-05-22 12:21:06.649683+08
557	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423661005.flv	2026-05-22 12:21:13.487823+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423661005.jpg	14212803	2026-05-22 12:21:14.496168+08	2026-05-22 12:21:14.496168+08
558	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423662224.flv	2026-05-22 12:21:14.644835+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423662224.jpg	13992876	2026-05-22 12:21:15.586365+08	2026-05-22 12:21:15.586365+08
559	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423665644.flv	2026-05-22 12:21:18.19887+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423665644.jpg	14403859	2026-05-22 12:21:19.229557+08	2026-05-22 12:21:19.229557+08
560	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423673489.flv	2026-05-22 12:21:25.406942+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423673489.jpg	14079669	2026-05-22 12:21:26.505841+08	2026-05-22 12:21:26.505841+08
561	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423674645.flv	2026-05-22 12:21:26.617954+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423674645.jpg	13877662	2026-05-22 12:21:27.597455+08	2026-05-22 12:21:27.597455+08
562	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423678199.flv	2026-05-22 12:21:30.476993+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423678199.jpg	14112849	2026-05-22 12:21:31.439622+08	2026-05-22 12:21:31.439622+08
563	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423685409.flv	2026-05-22 12:21:37.552064+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423685409.jpg	13912155	2026-05-22 12:21:38.550522+08	2026-05-22 12:21:38.550522+08
564	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423686619.flv	2026-05-22 12:21:38.885077+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423686619.jpg	14106379	2026-05-22 12:21:39.903229+08	2026-05-22 12:21:39.903229+08
565	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423690479.flv	2026-05-22 12:21:42.810116+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423690479.jpg	13897997	2026-05-22 12:21:43.846768+08	2026-05-22 12:21:43.846768+08
568	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423702812.flv	2026-05-22 12:21:55.339242+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423702812.jpg	14195098	2026-05-22 12:21:56.42849+08	2026-05-22 12:21:56.42849+08
569	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423709760.flv	2026-05-22 12:22:02.22431+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423709760.jpg	14326717	2026-05-22 12:22:03.298632+08	2026-05-22 12:22:03.298632+08
571	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423715340.flv	2026-05-22 12:22:07.582364+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423715340.jpg	14020233	2026-05-22 12:22:08.673085+08	2026-05-22 12:22:08.673085+08
580	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423753068.flv	2026-05-22 12:22:45.656743+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423753068.jpg	14071312	2026-05-22 12:22:46.73503+08	2026-05-22 12:22:46.73503+08
587	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423786509.flv	2026-05-22 12:23:19.810084+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423786509.jpg	14496918	2026-05-22 12:23:20.986095+08	2026-05-22 12:23:20.986095+08
566	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423697553.flv	2026-05-22 12:21:49.759186+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423697553.jpg	14086595	2026-05-22 12:21:50.832058+08	2026-05-22 12:21:50.832058+08
570	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423711096.flv	2026-05-22 12:22:03.711325+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423711096.jpg	14650037	2026-05-22 12:22:04.739422+08	2026-05-22 12:22:04.739422+08
572	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423722225.flv	2026-05-22 12:22:14.708435+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423722225.jpg	14396885	2026-05-22 12:22:15.843954+08	2026-05-22 12:22:15.843954+08
578	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423747353.flv	2026-05-22 12:22:39.858685+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423747353.jpg	14237378	2026-05-22 12:22:40.921398+08	2026-05-22 12:22:40.921398+08
585	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423773739.flv	2026-05-22 12:23:08.552972+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423773739.jpg	14217736	2026-05-22 12:23:09.562673+08	2026-05-22 12:23:09.562673+08
589	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423792839.flv	2026-05-22 12:23:25.700143+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423792839.jpg	13801518	2026-05-22 12:23:26.678474+08	2026-05-22 12:23:26.678474+08
567	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423698886.flv	2026-05-22 12:21:51.095199+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423698886.jpg	13917699	2026-05-22 12:21:52.09497+08	2026-05-22 12:21:52.09497+08
581	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423759859.flv	2026-05-22 12:22:52.218809+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423759859.jpg	13888427	2026-05-22 12:22:53.196618+08	2026-05-22 12:22:53.196618+08
583	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423765657.flv	2026-05-22 12:22:58.140868+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423765657.jpg	14105778	2026-05-22 12:22:59.217777+08	2026-05-22 12:22:59.217777+08
584	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423772219.flv	2026-05-22 12:23:06.507951+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423772219.jpg	15102545	2026-05-22 12:23:07.759407+08	2026-05-22 12:23:07.759407+08
586	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423778142.flv	2026-05-22 12:23:12.838014+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423778142.jpg	14057729	2026-05-22 12:23:13.878048+08	2026-05-22 12:23:13.878048+08
588	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423788554.flv	2026-05-22 12:23:21.620102+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423788554.jpg	14231442	2026-05-22 12:23:22.686851+08	2026-05-22 12:23:22.686851+08
573	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423723712.flv	2026-05-22 12:22:16.19245+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423723712.jpg	14238253	2026-05-22 12:22:17.297099+08	2026-05-22 12:22:17.297099+08
575	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423734709.flv	2026-05-22 12:22:27.352561+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423734709.jpg	14095767	2026-05-22 12:22:28.390574+08	2026-05-22 12:22:28.390574+08
577	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423740435.flv	2026-05-22 12:22:33.067618+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423740435.jpg	14141333	2026-05-22 12:22:34.142806+08	2026-05-22 12:22:34.142806+08
579	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423748707.flv	2026-05-22 12:22:41.085698+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423748707.jpg	13786967	2026-05-22 12:22:42.195595+08	2026-05-22 12:22:42.195595+08
574	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423727583.flv	2026-05-22 12:22:20.434492+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423727583.jpg	14445413	2026-05-22 12:22:21.454688+08	2026-05-22 12:22:21.454688+08
576	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423736193.flv	2026-05-22 12:22:28.706574+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423736193.jpg	13717405	2026-05-22 12:22:29.730753+08	2026-05-22 12:22:29.730753+08
582	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423761087.flv	2026-05-22 12:22:53.738824+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423761087.jpg	14221504	2026-05-22 12:22:54.791444+08	2026-05-22 12:22:54.791444+08
590	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423855584.flv	2026-05-22 12:24:27.333757+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423855584.jpg	14986723	2026-05-22 12:24:28.386769+08	2026-05-22 12:24:28.386769+08
591	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423855672.flv	2026-05-22 12:24:27.57476+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423855672.jpg	15110354	2026-05-22 12:24:29.441117+08	2026-05-22 12:24:29.441117+08
592	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423859028.flv	2026-05-22 12:24:30.955793+08	1779420864892554342	Camera 01	30	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423859028.jpg	14617891	2026-05-22 12:24:31.999972+08	2026-05-22 12:24:31.999972+08
593	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423867334.flv	2026-05-22 12:24:39.356877+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423867334.jpg	14368998	2026-05-22 12:24:40.425886+08	2026-05-22 12:24:40.425886+08
594	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423867575.flv	2026-05-22 12:24:39.517879+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423867575.jpg	14568934	2026-05-22 12:24:41.398043+08	2026-05-22 12:24:41.398043+08
595	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423870957.flv	2026-05-22 12:24:43.052914+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423870957.jpg	16032124	2026-05-22 12:24:44.154531+08	2026-05-22 12:24:44.154531+08
596	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423879357.flv	2026-05-22 12:24:51.955003+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423879357.jpg	14361080	2026-05-22 12:24:53.926143+08	2026-05-22 12:24:53.926143+08
597	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423879519.flv	2026-05-22 12:24:52.017004+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423879519.jpg	14508260	2026-05-22 12:24:54.98916+08	2026-05-22 12:24:54.98916+08
598	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423883055.flv	2026-05-22 12:24:55.811041+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423883055.jpg	15290247	2026-05-22 12:24:56.770987+08	2026-05-22 12:24:56.770987+08
599	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423891956.flv	2026-05-22 12:25:04.060123+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423891956.jpg	14400605	2026-05-22 12:25:05.058074+08	2026-05-22 12:25:05.058074+08
600	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423892018.flv	2026-05-22 12:25:04.266126+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423892018.jpg	14288532	2026-05-22 12:25:06.077966+08	2026-05-22 12:25:06.077966+08
601	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423895812.flv	2026-05-22 12:25:07.656159+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423895812.jpg	14628090	2026-05-22 12:25:08.707512+08	2026-05-22 12:25:08.707512+08
602	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423904061.flv	2026-05-22 12:25:16.609249+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423904061.jpg	14554057	2026-05-22 12:25:17.617002+08	2026-05-22 12:25:17.617002+08
603	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423904268.flv	2026-05-22 12:25:16.78425+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423904268.jpg	14538890	2026-05-22 12:25:18.625764+08	2026-05-22 12:25:18.625764+08
604	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423907657.flv	2026-05-22 12:25:20.301286+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423907657.jpg	15120857	2026-05-22 12:25:21.337554+08	2026-05-22 12:25:21.337554+08
605	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423916610.flv	2026-05-22 12:25:29.469377+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423916610.jpg	14354200	2026-05-22 12:25:30.436567+08	2026-05-22 12:25:30.436567+08
606	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423916786.flv	2026-05-22 12:25:29.928381+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423916786.jpg	14414051	2026-05-22 12:25:31.517496+08	2026-05-22 12:25:31.517496+08
607	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423920302.flv	2026-05-22 12:25:33.115413+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423920302.jpg	14891790	2026-05-22 12:25:34.138153+08	2026-05-22 12:25:34.138153+08
608	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423929470.flv	2026-05-22 12:25:41.8125+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423929470.jpg	14050950	2026-05-22 12:25:42.749194+08	2026-05-22 12:25:42.749194+08
609	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423929930.flv	2026-05-22 12:25:42.279505+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423929930.jpg	14220912	2026-05-22 12:25:43.76917+08	2026-05-22 12:25:43.76917+08
610	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423933116.flv	2026-05-22 12:25:45.330535+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423933116.jpg	14047033	2026-05-22 12:25:46.439256+08	2026-05-22 12:25:46.439256+08
611	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423941813.flv	2026-05-22 12:25:54.339625+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423941813.jpg	14345102	2026-05-22 12:25:55.435044+08	2026-05-22 12:25:55.435044+08
612	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423942280.flv	2026-05-22 12:25:54.631628+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423942280.jpg	14335037	2026-05-22 12:25:56.56126+08	2026-05-22 12:25:56.56126+08
615	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423954632.flv	2026-05-22 12:26:07.017751+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423954632.jpg	14376063	2026-05-22 12:26:08.831125+08	2026-05-22 12:26:08.831125+08
619	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423970112.flv	2026-05-22 12:26:21.9159+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423970112.jpg	14540748	2026-05-22 12:26:22.993056+08	2026-05-22 12:26:22.993056+08
620	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423978750.flv	2026-05-22 12:26:31.108992+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423978750.jpg	14266883	2026-05-22 12:26:32.072891+08	2026-05-22 12:26:32.072891+08
627	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779424003716.flv	2026-05-22 12:26:56.04924+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779424003716.jpg	14094650	2026-05-22 12:26:57.989693+08	2026-05-22 12:26:57.989693+08
631	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779424018734.flv	2026-05-22 12:27:10.942389+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779424018734.jpg	14462097	2026-05-22 12:27:12.044607+08	2026-05-22 12:27:12.044607+08
632	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779424028297.flv	2026-05-22 12:27:20.438483+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779424028297.jpg	14009601	2026-05-22 12:27:21.492297+08	2026-05-22 12:27:21.492297+08
634	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779424030943.flv	2026-05-22 12:27:23.349513+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779424030943.jpg	14135084	2026-05-22 12:27:24.369341+08	2026-05-22 12:27:24.369341+08
635	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779424040439.flv	2026-05-22 12:27:33.160146+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779424040439.jpg	14278674	2026-05-22 12:27:34.131006+08	2026-05-22 12:27:34.131006+08
642	/api/v1/buckets/record-space/objects/download?prefix=1779422166154192033%2F2026%2F05%2F22%2F1779424173939.flv	2026-05-22 12:32:05.982331+08	1779422166154192033	CH23-192.168.1.21	3	/api/v1/buckets/record-space/objects/download?prefix=1779422166154192033%2F2026%2F05%2F22%2F1779424173939.jpg	1521382	2026-05-22 12:32:06.43004+08	2026-05-22 12:32:06.43004+08
644	/api/v1/buckets/record-space/objects/download?prefix=1779422166082993126%2F2026%2F05%2F22%2F1779424177639.flv	2026-05-22 12:32:05.984331+08	1779422166082993126	IPdome	3	/api/v1/buckets/record-space/objects/download?prefix=1779422166082993126%2F2026%2F05%2F22%2F1779424177639.jpg	2317113	2026-05-22 12:32:07.287858+08	2026-05-22 12:32:07.287858+08
646	/api/v1/buckets/record-space/objects/download?prefix=1779422165955706874%2F2026%2F05%2F22%2F1779424161879.flv	2026-05-22 12:32:05.984331+08	1779422165955706874	CH14-192.168.1.14	3	/api/v1/buckets/record-space/objects/download?prefix=1779422165955706874%2F2026%2F05%2F22%2F1779424161879.jpg	1828854	2026-05-22 12:32:08.162545+08	2026-05-22 12:32:08.162545+08
648	/api/v1/buckets/record-space/objects/download?prefix=1779422166104469817%2F2026%2F05%2F22%2F1779424156943.flv	2026-05-22 12:32:05.986331+08	1779422166104469817	IPdome	4	/api/v1/buckets/record-space/objects/download?prefix=1779422166104469817%2F2026%2F05%2F22%2F1779424156943.jpg	2677084	2026-05-22 12:32:09.041223+08	2026-05-22 12:32:09.041223+08
650	/api/v1/buckets/record-space/objects/download?prefix=1779422165875846125%2F2026%2F05%2F22%2F1779424178739.flv	2026-05-22 12:32:05.986331+08	1779422165875846125	CH11-192.168.1.11	3	/api/v1/buckets/record-space/objects/download?prefix=1779422165875846125%2F2026%2F05%2F22%2F1779424178739.jpg	1601290	2026-05-22 12:32:09.965083+08	2026-05-22 12:32:09.965083+08
652	/api/v1/buckets/record-space/objects/download?prefix=1779422165849403860%2F2026%2F05%2F22%2F1779424159972.flv	2026-05-22 12:32:05.987331+08	1779422165849403860	CH10-192.168.1.10	3	/api/v1/buckets/record-space/objects/download?prefix=1779422165849403860%2F2026%2F05%2F22%2F1779424159972.jpg	2137829	2026-05-22 12:32:10.819171+08	2026-05-22 12:32:10.819171+08
654	/api/v1/buckets/record-space/objects/download?prefix=1779422165933917600%2F2026%2F05%2F22%2F1779424170289.flv	2026-05-22 12:32:05.988331+08	1779422165933917600	CH13-192.168.1.13	3	/api/v1/buckets/record-space/objects/download?prefix=1779422165933917600%2F2026%2F05%2F22%2F1779424170289.jpg	1557752	2026-05-22 12:32:11.677381+08	2026-05-22 12:32:11.677381+08
656	/api/v1/buckets/record-space/objects/download?prefix=1779422166021660540%2F2026%2F05%2F22%2F1779424170896.flv	2026-05-22 12:32:05.988331+08	1779422166021660540	CH17-192.168.1.17	3	/api/v1/buckets/record-space/objects/download?prefix=1779422166021660540%2F2026%2F05%2F22%2F1779424170896.jpg	1509535	2026-05-22 12:32:12.550181+08	2026-05-22 12:32:12.550181+08
658	/api/v1/buckets/record-space/objects/download?prefix=1779422165746455491%2F2026%2F05%2F22%2F1779424157940.flv	2026-05-22 12:32:05.989331+08	1779422165746455491	CH6-192.168.1.6	3	/api/v1/buckets/record-space/objects/download?prefix=1779422165746455491%2F2026%2F05%2F22%2F1779424157940.jpg	2258713	2026-05-22 12:32:13.456525+08	2026-05-22 12:32:13.456525+08
660	/api/v1/buckets/record-space/objects/download?prefix=1779422166041205920%2F2026%2F05%2F22%2F1779424163867.flv	2026-05-22 12:32:05.989331+08	1779422166041205920	CH18-192.168.1.18	3	/api/v1/buckets/record-space/objects/download?prefix=1779422166041205920%2F2026%2F05%2F22%2F1779424163867.jpg	1801457	2026-05-22 12:32:14.328278+08	2026-05-22 12:32:14.328278+08
662	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779424154695.flv	2026-05-22 12:32:05.991331+08	1779420864892554342	CH1-192.168.1.64	5	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779424154695.jpg	2477384	2026-05-22 12:32:15.19321+08	2026-05-22 12:32:15.19321+08
664	/api/v1/buckets/record-space/objects/download?prefix=1779422165722056155%2F2026%2F05%2F22%2F1779424168183.flv	2026-05-22 12:32:05.992331+08	1779422165722056155	CH5-192.168.1.5	3	/api/v1/buckets/record-space/objects/download?prefix=1779422165722056155%2F2026%2F05%2F22%2F1779424168183.jpg	1699382	2026-05-22 12:32:16.06338+08	2026-05-22 12:32:16.06338+08
613	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423945332.flv	2026-05-22 12:25:57.86566+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423945332.jpg	14634620	2026-05-22 12:25:58.943964+08	2026-05-22 12:25:58.943964+08
616	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423957866.flv	2026-05-22 12:26:10.110782+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423957866.jpg	14614560	2026-05-22 12:26:11.206897+08	2026-05-22 12:26:11.206897+08
617	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423966722.flv	2026-05-22 12:26:18.749868+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423966722.jpg	14107865	2026-05-22 12:26:19.825049+08	2026-05-22 12:26:19.825049+08
621	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423979092.flv	2026-05-22 12:26:31.381994+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423979092.jpg	14549882	2026-05-22 12:26:33.106323+08	2026-05-22 12:26:33.106323+08
623	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423991110.flv	2026-05-22 12:26:43.611116+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423991110.jpg	14193744	2026-05-22 12:26:44.633612+08	2026-05-22 12:26:44.633612+08
625	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423994376.flv	2026-05-22 12:26:46.506145+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423994376.jpg	14466716	2026-05-22 12:26:47.591773+08	2026-05-22 12:26:47.591773+08
630	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779424016051.flv	2026-05-22 12:27:08.428364+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779424016051.jpg	14559192	2026-05-22 12:27:10.355044+08	2026-05-22 12:27:10.355044+08
633	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779424028429.flv	2026-05-22 12:27:20.857488+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779424028429.jpg	14121242	2026-05-22 12:27:22.662431+08	2026-05-22 12:27:22.662431+08
636	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779424040858.flv	2026-05-22 12:27:33.455613+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779424040858.jpg	14188803	2026-05-22 12:27:35.14119+08	2026-05-22 12:27:35.14119+08
643	/api/v1/buckets/record-space/objects/download?prefix=1779422165775518450%2F2026%2F05%2F22%2F1779424175105.flv	2026-05-22 12:32:05.984331+08	1779422165775518450	CH7-192.168.1.7	3	/api/v1/buckets/record-space/objects/download?prefix=1779422165775518450%2F2026%2F05%2F22%2F1779424175105.jpg	1675567	2026-05-22 12:32:06.831538+08	2026-05-22 12:32:06.831538+08
645	/api/v1/buckets/record-space/objects/download?prefix=1779422166062972206%2F2026%2F05%2F22%2F1779424179864.flv	2026-05-22 12:32:05.984331+08	1779422166062972206	CH19-192.168.1.19	3	/api/v1/buckets/record-space/objects/download?prefix=1779422166062972206%2F2026%2F05%2F22%2F1779424179864.jpg	1489365	2026-05-22 12:32:07.73118+08	2026-05-22 12:32:07.73118+08
647	/api/v1/buckets/record-space/objects/download?prefix=1779422166129430057%2F2026%2F05%2F22%2F1779424166209.flv	2026-05-22 12:32:05.985331+08	1779422166129430057	CH22-192.168.1.20	3	/api/v1/buckets/record-space/objects/download?prefix=1779422166129430057%2F2026%2F05%2F22%2F1779424166209.jpg	1740157	2026-05-22 12:32:08.582146+08	2026-05-22 12:32:08.582146+08
649	/api/v1/buckets/record-space/objects/download?prefix=1779422165801460442%2F2026%2F05%2F22%2F1779424158880.flv	2026-05-22 12:32:05.986331+08	1779422165801460442	CH8-192.168.1.8	3	/api/v1/buckets/record-space/objects/download?prefix=1779422165801460442%2F2026%2F05%2F22%2F1779424158880.jpg	2356048	2026-05-22 12:32:09.539793+08	2026-05-22 12:32:09.539793+08
651	/api/v1/buckets/record-space/objects/download?prefix=1779422166002269874%2F2026%2F05%2F22%2F1779424163038.flv	2026-05-22 12:32:05.986331+08	1779422166002269874	CH16-192.168.1.16	3	/api/v1/buckets/record-space/objects/download?prefix=1779422166002269874%2F2026%2F05%2F22%2F1779424163038.jpg	2132549	2026-05-22 12:32:10.410732+08	2026-05-22 12:32:10.410732+08
657	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779424166911.flv	2026-05-22 12:32:05.988331+08	1779421873137166368	CH3-192.168.1.3	3	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779424166911.jpg	1696878	2026-05-22 12:32:12.98767+08	2026-05-22 12:32:12.98767+08
659	/api/v1/buckets/record-space/objects/download?prefix=1779422165828467470%2F2026%2F05%2F22%2F1779424169595.flv	2026-05-22 12:32:05.989331+08	1779422165828467470	CH9-192.168.1.9	3	/api/v1/buckets/record-space/objects/download?prefix=1779422165828467470%2F2026%2F05%2F22%2F1779424169595.jpg	2104502	2026-05-22 12:32:13.895191+08	2026-05-22 12:32:13.895191+08
661	/api/v1/buckets/record-space/objects/download?prefix=1779422008175793403%2F2026%2F05%2F22%2F1779424155228.flv	2026-05-22 12:32:05.990331+08	1779422008175793403	CH4-192.168.1.4	5	/api/v1/buckets/record-space/objects/download?prefix=1779422008175793403%2F2026%2F05%2F22%2F1779424155228.jpg	2788560	2026-05-22 12:32:14.769314+08	2026-05-22 12:32:14.769314+08
663	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779424153918.flv	2026-05-22 12:32:05.991331+08	1779421736545666241	CH2-192.168.1.2	5	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779424153918.jpg	2874802	2026-05-22 12:32:15.636187+08	2026-05-22 12:32:15.636187+08
614	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423954340.flv	2026-05-22 12:26:06.721748+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779423954340.jpg	14425757	2026-05-22 12:26:07.718328+08	2026-05-22 12:26:07.718328+08
618	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423967019.flv	2026-05-22 12:26:19.091872+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423967019.jpg	13820668	2026-05-22 12:26:20.866307+08	2026-05-22 12:26:20.866307+08
622	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423981916.flv	2026-05-22 12:26:34.375024+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779423981916.jpg	14718730	2026-05-22 12:26:36.810046+08	2026-05-22 12:26:36.810046+08
624	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423991383.flv	2026-05-22 12:26:43.714117+08	1779421736545666241	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779423991383.jpg	14263242	2026-05-22 12:26:45.718672+08	2026-05-22 12:26:45.718672+08
626	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779424003612.flv	2026-05-22 12:26:55.834238+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779424003612.jpg	14304912	2026-05-22 12:26:56.885361+08	2026-05-22 12:26:56.885361+08
628	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779424006508.flv	2026-05-22 12:26:58.733267+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779424006508.jpg	14885408	2026-05-22 12:26:59.867518+08	2026-05-22 12:26:59.867518+08
629	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779424015836.flv	2026-05-22 12:27:08.296362+08	1779421873137166368	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779424015836.jpg	13955110	2026-05-22 12:27:09.307033+08	2026-05-22 12:27:09.307033+08
637	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779424043350.flv	2026-05-22 12:27:36.13264+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779424043350.jpg	14189373	2026-05-22 12:27:37.197621+08	2026-05-22 12:27:37.197621+08
638	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779424053160.flv	2026-05-22 12:27:41.869697+08	1779421873137166368	Camera 01	22	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779424053160.jpg	10065779	2026-05-22 12:27:42.677169+08	2026-05-22 12:27:42.677169+08
639	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779424053456.flv	2026-05-22 12:27:43.241711+08	1779421736545666241	Camera 01	25	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779424053456.jpg	11396063	2026-05-22 12:27:43.818624+08	2026-05-22 12:27:43.818624+08
640	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779424056133.flv	2026-05-22 12:27:45.078729+08	1779420864892554342	Camera 01	31	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779424056133.jpg	12975247	2026-05-22 12:27:45.742687+08	2026-05-22 12:27:45.742687+08
641	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779424065079.flv	2026-05-22 12:27:48.301761+08	1779420864892554342	Camera 01	21	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779424065079.jpg	8665163	2026-05-22 12:27:48.780082+08	2026-05-22 12:27:48.780082+08
653	/api/v1/buckets/record-space/objects/download?prefix=1779422165979283705%2F2026%2F05%2F22%2F1779424175915.flv	2026-05-22 12:32:05.987331+08	1779422165979283705	CH15-192.168.1.15	3	/api/v1/buckets/record-space/objects/download?prefix=1779422165979283705%2F2026%2F05%2F22%2F1779424175915.jpg	1970427	2026-05-22 12:32:11.281238+08	2026-05-22 12:32:11.281238+08
655	/api/v1/buckets/record-space/objects/download?prefix=1779422165904284120%2F2026%2F05%2F22%2F1779424160783.flv	2026-05-22 12:32:05.988331+08	1779422165904284120	CH12-192.168.1.12	3	/api/v1/buckets/record-space/objects/download?prefix=1779422165904284120%2F2026%2F05%2F22%2F1779424160783.jpg	2104568	2026-05-22 12:32:12.092941+08	2026-05-22 12:32:12.092941+08
665	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779428447699.flv	2026-05-22 13:42:07.02321+08	1779421736545666241	CH2-192.168.1.2	3	/api/v1/buckets/record-space/objects/download?prefix=1779421736545666241%2F2026%2F05%2F22%2F1779428447699.jpg	1609524	2026-05-22 13:42:07.433357+08	2026-05-22 13:42:07.433357+08
666	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779428448220.flv	2026-05-22 13:42:07.03821+08	1779420864892554342	CH1-192.168.1.64	3	/api/v1/buckets/record-space/objects/download?prefix=1779420864892554342%2F2026%2F05%2F22%2F1779428448220.jpg	1867754	2026-05-22 13:42:07.879488+08	2026-05-22 13:42:07.879488+08
667	/api/v1/buckets/record-space/objects/download?prefix=1779422008175793403%2F2026%2F05%2F22%2F1779428448748.flv	2026-05-22 13:42:07.05921+08	1779422008175793403	CH4-192.168.1.4	3	/api/v1/buckets/record-space/objects/download?prefix=1779422008175793403%2F2026%2F05%2F22%2F1779428448748.jpg	1855528	2026-05-22 13:42:08.31128+08	2026-05-22 13:42:08.31128+08
668	/api/v1/buckets/record-space/objects/download?prefix=1779422166104469817%2F2026%2F05%2F22%2F1779428450652.flv	2026-05-22 13:42:08.332222+08	1779422166104469817	IPdome	2	/api/v1/buckets/record-space/objects/download?prefix=1779422166104469817%2F2026%2F05%2F22%2F1779428450652.jpg	1288124	2026-05-22 13:42:08.760198+08	2026-05-22 13:42:08.760198+08
669	/api/v1/buckets/record-space/objects/download?prefix=1779422166082993126%2F2026%2F05%2F22%2F1779428474547.flv	2026-05-22 13:42:08.333222+08	1779422166082993126	IPdome	1	/api/v1/buckets/record-space/objects/download?prefix=1779422166082993126%2F2026%2F05%2F22%2F1779428474547.jpg	908796	2026-05-22 13:42:09.180967+08	2026-05-22 13:42:09.180967+08
670	/api/v1/buckets/record-space/objects/download?prefix=1779422166154192033%2F2026%2F05%2F22%2F1779428468436.flv	2026-05-22 13:42:08.333222+08	1779422166154192033	CH23-192.168.1.21	1	/api/v1/buckets/record-space/objects/download?prefix=1779422166154192033%2F2026%2F05%2F22%2F1779428468436.jpg	702154	2026-05-22 13:42:09.643078+08	2026-05-22 13:42:09.643078+08
671	/api/v1/buckets/record-space/objects/download?prefix=1779422166129430057%2F2026%2F05%2F22%2F1779428459794.flv	2026-05-22 13:42:08.333222+08	1779422166129430057	CH22-192.168.1.20	1	/api/v1/buckets/record-space/objects/download?prefix=1779422166129430057%2F2026%2F05%2F22%2F1779428459794.jpg	672866	2026-05-22 13:42:10.049281+08	2026-05-22 13:42:10.049281+08
672	/api/v1/buckets/record-space/objects/download?prefix=1779422165722056155%2F2026%2F05%2F22%2F1779428462472.flv	2026-05-22 13:42:08.333222+08	1779422165722056155	CH5-192.168.1.5	1	/api/v1/buckets/record-space/objects/download?prefix=1779422165722056155%2F2026%2F05%2F22%2F1779428462472.jpg	603106	2026-05-22 13:42:10.464417+08	2026-05-22 13:42:10.464417+08
673	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779428461027.flv	2026-05-22 13:42:08.333222+08	1779421873137166368	CH3-192.168.1.3	1	/api/v1/buckets/record-space/objects/download?prefix=1779421873137166368%2F2026%2F05%2F22%2F1779428461027.jpg	584739	2026-05-22 13:42:10.872756+08	2026-05-22 13:42:10.872756+08
674	/api/v1/buckets/record-space/objects/download?prefix=1779422165828467470%2F2026%2F05%2F22%2F1779428463056.flv	2026-05-22 13:42:08.333222+08	1779422165828467470	CH9-192.168.1.9	1	/api/v1/buckets/record-space/objects/download?prefix=1779422165828467470%2F2026%2F05%2F22%2F1779428463056.jpg	702450	2026-05-22 13:42:11.284959+08	2026-05-22 13:42:11.284959+08
675	/api/v1/buckets/record-space/objects/download?prefix=1779422165801460442%2F2026%2F05%2F22%2F1779428452649.flv	2026-05-22 13:42:08.334223+08	1779422165801460442	CH8-192.168.1.8	1	/api/v1/buckets/record-space/objects/download?prefix=1779422165801460442%2F2026%2F05%2F22%2F1779428452649.jpg	1026656	2026-05-22 13:42:11.711982+08	2026-05-22 13:42:11.711982+08
677	/api/v1/buckets/record-space/objects/download?prefix=1779422166041205920%2F2026%2F05%2F22%2F1779428457595.flv	2026-05-22 13:42:08.334223+08	1779422166041205920	CH18-192.168.1.18	1	/api/v1/buckets/record-space/objects/download?prefix=1779422166041205920%2F2026%2F05%2F22%2F1779428457595.jpg	757546	2026-05-22 13:42:12.5786+08	2026-05-22 13:42:12.5786+08
679	/api/v1/buckets/record-space/objects/download?prefix=1779422165955706874%2F2026%2F05%2F22%2F1779428455601.flv	2026-05-22 13:42:08.335222+08	1779422165955706874	CH14-192.168.1.14	1	/api/v1/buckets/record-space/objects/download?prefix=1779422165955706874%2F2026%2F05%2F22%2F1779428455601.jpg	747263	2026-05-22 13:42:13.436866+08	2026-05-22 13:42:13.436866+08
681	/api/v1/buckets/record-space/objects/download?prefix=1779422165979283705%2F2026%2F05%2F22%2F1779428470686.flv	2026-05-22 13:42:08.335222+08	1779422165979283705	CH15-192.168.1.15	1	/api/v1/buckets/record-space/objects/download?prefix=1779422165979283705%2F2026%2F05%2F22%2F1779428470686.jpg	709881	2026-05-22 13:42:14.272391+08	2026-05-22 13:42:14.272391+08
683	/api/v1/buckets/record-space/objects/download?prefix=1779422166002269874%2F2026%2F05%2F22%2F1779428456425.flv	2026-05-22 13:42:08.336222+08	1779422166002269874	CH16-192.168.1.16	1	/api/v1/buckets/record-space/objects/download?prefix=1779422166002269874%2F2026%2F05%2F22%2F1779428456425.jpg	972641	2026-05-22 13:42:15.119925+08	2026-05-22 13:42:15.119925+08
685	/api/v1/buckets/record-space/objects/download?prefix=1779422166062972206%2F2026%2F05%2F22%2F1779428473260.flv	2026-05-22 13:42:08.336222+08	1779422166062972206	CH19-192.168.1.19	1	/api/v1/buckets/record-space/objects/download?prefix=1779422166062972206%2F2026%2F05%2F22%2F1779428473260.jpg	627931	2026-05-22 13:42:15.908644+08	2026-05-22 13:42:15.908644+08
687	/api/v1/buckets/record-space/objects/download?prefix=1779422165904284120%2F2026%2F05%2F22%2F1779428454573.flv	2026-05-22 13:42:08.336222+08	1779422165904284120	CH12-192.168.1.12	1	/api/v1/buckets/record-space/objects/download?prefix=1779422165904284120%2F2026%2F05%2F22%2F1779428454573.jpg	842356	2026-05-22 13:42:16.793733+08	2026-05-22 13:42:16.793733+08
676	/api/v1/buckets/record-space/objects/download?prefix=1779422165875846125%2F2026%2F05%2F22%2F1779428475532.flv	2026-05-22 13:42:08.334223+08	1779422165875846125	CH11-192.168.1.11	1	/api/v1/buckets/record-space/objects/download?prefix=1779422165875846125%2F2026%2F05%2F22%2F1779428475532.jpg	537227	2026-05-22 13:42:12.121985+08	2026-05-22 13:42:12.121985+08
678	/api/v1/buckets/record-space/objects/download?prefix=1779422165849403860%2F2026%2F05%2F22%2F1779428453610.flv	2026-05-22 13:42:08.335222+08	1779422165849403860	CH10-192.168.1.10	1	/api/v1/buckets/record-space/objects/download?prefix=1779422165849403860%2F2026%2F05%2F22%2F1779428453610.jpg	965160	2026-05-22 13:42:12.984609+08	2026-05-22 13:42:12.984609+08
680	/api/v1/buckets/record-space/objects/download?prefix=1779422165775518450%2F2026%2F05%2F22%2F1779428469629.flv	2026-05-22 13:42:08.335222+08	1779422165775518450	CH7-192.168.1.7	1	/api/v1/buckets/record-space/objects/download?prefix=1779422165775518450%2F2026%2F05%2F22%2F1779428469629.jpg	514756	2026-05-22 13:42:13.859282+08	2026-05-22 13:42:13.859282+08
682	/api/v1/buckets/record-space/objects/download?prefix=1779422165746455491%2F2026%2F05%2F22%2F1779428451853.flv	2026-05-22 13:42:08.335222+08	1779422165746455491	CH6-192.168.1.6	1	/api/v1/buckets/record-space/objects/download?prefix=1779422165746455491%2F2026%2F05%2F22%2F1779428451853.jpg	963480	2026-05-22 13:42:14.699779+08	2026-05-22 13:42:14.699779+08
684	/api/v1/buckets/record-space/objects/download?prefix=1779422166021660540%2F2026%2F05%2F22%2F1779428465232.flv	2026-05-22 13:42:08.336222+08	1779422166021660540	CH17-192.168.1.17	1	/api/v1/buckets/record-space/objects/download?prefix=1779422166021660540%2F2026%2F05%2F22%2F1779428465232.jpg	615018	2026-05-22 13:42:15.504297+08	2026-05-22 13:42:15.504297+08
686	/api/v1/buckets/record-space/objects/download?prefix=1779422165933917600%2F2026%2F05%2F22%2F1779428464512.flv	2026-05-22 13:42:08.336222+08	1779422165933917600	CH13-192.168.1.13	1	/api/v1/buckets/record-space/objects/download?prefix=1779422165933917600%2F2026%2F05%2F22%2F1779428464512.jpg	628858	2026-05-22 13:42:16.345281+08	2026-05-22 13:42:16.345281+08
\.


--
-- Data for Name: pusher; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.pusher (id, pusher_name, pusher_code, video_stream_enabled, video_stream_url, device_rtmp_mapping, video_stream_format, video_stream_quality, event_alert_enabled, event_alert_url, event_alert_method, event_alert_format, event_alert_headers, event_alert_template, description, is_enabled, status, server_ip, port, process_id, last_heartbeat, log_path, task_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: record_space; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.record_space (id, space_name, space_code, bucket_name, save_mode, save_time, description, device_id, created_at, updated_at) FROM stdin;
1	Camera 01	RECORD_E2133743	record-space	0	0	设备 gb28181_44010200491534643182_34020000001320000001 的自动创建监控录像空间	gb28181_44010200491534643182_34020000001320000001	2026-05-22 02:57:42.203452	2026-05-22 02:57:42.203453
2	Camera 01	RECORD_AF02E866	record-space	0	0	设备 1779420864892554342 的自动创建监控录像空间	1779420864892554342	2026-05-22 03:36:40.518301	2026-05-22 03:36:40.518309
3	Camera 01	RECORD_E9370965	record-space	0	0	设备 1779421736545666241 的自动创建监控录像空间	1779421736545666241	2026-05-22 03:51:12.945351	2026-05-22 03:51:12.945354
4	Camera 01	RECORD_E1E791CE	record-space	0	0	设备 1779421873137166368 的自动创建监控录像空间	1779421873137166368	2026-05-22 03:53:28.084633	2026-05-22 03:53:28.084635
5	Camera 01	RECORD_60207A26	record-space	0	0	设备 1779422008175793403 的自动创建监控录像空间	1779422008175793403	2026-05-22 03:55:12.191812	2026-05-22 03:55:12.191831
6	Camera 01	RECORD_503AE24D	record-space	0	0	设备 1779422166154192033 的自动创建监控录像空间	1779422166154192033	2026-05-22 03:56:06.40286	2026-05-22 03:56:06.402883
7	Camera 01	RECORD_0F2440DA	record-space	0	0	设备 1779422166129430057 的自动创建监控录像空间	1779422166129430057	2026-05-22 03:56:06.531157	2026-05-22 03:56:06.531174
8	IPdome	RECORD_62642963	record-space	0	0	设备 1779422166104469817 的自动创建监控录像空间	1779422166104469817	2026-05-22 03:56:06.681164	2026-05-22 03:56:06.681189
9	IPdome	RECORD_3C370971	record-space	0	0	设备 1779422166082993126 的自动创建监控录像空间	1779422166082993126	2026-05-22 03:56:06.825574	2026-05-22 03:56:06.825589
10	Camera 01	RECORD_5879D5D9	record-space	0	0	设备 1779422166062972206 的自动创建监控录像空间	1779422166062972206	2026-05-22 03:56:06.95801	2026-05-22 03:56:06.958024
11	Camera 01	RECORD_1C20D569	record-space	0	0	设备 1779422166041205920 的自动创建监控录像空间	1779422166041205920	2026-05-22 03:56:07.086274	2026-05-22 03:56:07.0863
12	Camera 01	RECORD_4973CD7B	record-space	0	0	设备 1779422166021660540 的自动创建监控录像空间	1779422166021660540	2026-05-22 03:56:07.207682	2026-05-22 03:56:07.207697
13	Camera 01	RECORD_EB40AA70	record-space	0	0	设备 1779422166002269874 的自动创建监控录像空间	1779422166002269874	2026-05-22 03:56:07.343161	2026-05-22 03:56:07.343175
14	Camera 01	RECORD_3842AF8C	record-space	0	0	设备 1779422165979283705 的自动创建监控录像空间	1779422165979283705	2026-05-22 03:56:07.483327	2026-05-22 03:56:07.483341
15	Camera 01	RECORD_5CCB5E20	record-space	0	0	设备 1779422165955706874 的自动创建监控录像空间	1779422165955706874	2026-05-22 03:56:07.615382	2026-05-22 03:56:07.615394
16	Camera 01	RECORD_C2B4ACA7	record-space	0	0	设备 1779422165933917600 的自动创建监控录像空间	1779422165933917600	2026-05-22 03:56:07.730639	2026-05-22 03:56:07.730669
17	Camera 01	RECORD_8851C408	record-space	0	0	设备 1779422165904284120 的自动创建监控录像空间	1779422165904284120	2026-05-22 03:56:07.850778	2026-05-22 03:56:07.850797
18	Camera 01	RECORD_48A368C6	record-space	0	0	设备 1779422165875846125 的自动创建监控录像空间	1779422165875846125	2026-05-22 03:56:07.994449	2026-05-22 03:56:07.994478
19	Camera 01	RECORD_3E5A593F	record-space	0	0	设备 1779422165849403860 的自动创建监控录像空间	1779422165849403860	2026-05-22 03:56:08.141143	2026-05-22 03:56:08.141162
20	Camera 01	RECORD_70FA705A	record-space	0	0	设备 1779422165828467470 的自动创建监控录像空间	1779422165828467470	2026-05-22 03:56:08.258077	2026-05-22 03:56:08.258088
21	Camera 01	RECORD_20FA8BB7	record-space	0	0	设备 1779422165801460442 的自动创建监控录像空间	1779422165801460442	2026-05-22 03:56:08.3838	2026-05-22 03:56:08.383858
22	Camera 01	RECORD_150E8F43	record-space	0	0	设备 1779422165775518450 的自动创建监控录像空间	1779422165775518450	2026-05-22 03:56:08.500376	2026-05-22 03:56:08.500385
23	Camera 01	RECORD_2F931C02	record-space	0	0	设备 1779422165746455491 的自动创建监控录像空间	1779422165746455491	2026-05-22 03:56:08.655815	2026-05-22 03:56:08.655837
24	Camera 01	RECORD_191B7253	record-space	0	0	设备 1779422165722056155 的自动创建监控录像空间	1779422165722056155	2026-05-22 03:56:08.781055	2026-05-22 03:56:08.781066
\.


--
-- Data for Name: region_model_service; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.region_model_service (id, region_id, service_name, service_url, service_type, model_id, threshold, request_method, request_headers, request_body_template, timeout, is_enabled, sort_order, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: snap_space; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.snap_space (id, space_name, space_code, bucket_name, save_mode, save_time, description, device_id, created_at, updated_at) FROM stdin;
1	Camera 01	SPACE_86D065B3	snap-space	0	0	设备 gb28181_44010200491534643182_34020000001320000001 的自动创建抓拍空间	gb28181_44010200491534643182_34020000001320000001	2026-05-22 02:57:42.185568	2026-05-22 02:57:42.185569
2	Camera 01	SPACE_EBD5CFDE	snap-space	0	0	设备 1779420864892554342 的自动创建抓拍空间	1779420864892554342	2026-05-22 03:36:40.485338	2026-05-22 03:36:40.485342
3	Camera 01	SPACE_410BD2E7	snap-space	0	0	设备 1779421736545666241 的自动创建抓拍空间	1779421736545666241	2026-05-22 03:51:12.922475	2026-05-22 03:51:12.922481
4	Camera 01	SPACE_A0C6D73D	snap-space	0	0	设备 1779421873137166368 的自动创建抓拍空间	1779421873137166368	2026-05-22 03:53:28.073276	2026-05-22 03:53:28.073278
5	Camera 01	SPACE_90D475B9	snap-space	0	0	设备 1779422008175793403 的自动创建抓拍空间	1779422008175793403	2026-05-22 03:55:12.118244	2026-05-22 03:55:12.118253
6	Camera 01	SPACE_3F8C87D6	snap-space	0	0	设备 1779422166154192033 的自动创建抓拍空间	1779422166154192033	2026-05-22 03:56:06.33206	2026-05-22 03:56:06.332079
7	Camera 01	SPACE_81BB7DD1	snap-space	0	0	设备 1779422166129430057 的自动创建抓拍空间	1779422166129430057	2026-05-22 03:56:06.464589	2026-05-22 03:56:06.464602
8	IPdome	SPACE_7AB6AB88	snap-space	0	0	设备 1779422166104469817 的自动创建抓拍空间	1779422166104469817	2026-05-22 03:56:06.613985	2026-05-22 03:56:06.613997
9	IPdome	SPACE_34359567	snap-space	0	0	设备 1779422166082993126 的自动创建抓拍空间	1779422166082993126	2026-05-22 03:56:06.760944	2026-05-22 03:56:06.760964
10	Camera 01	SPACE_15DACFB4	snap-space	0	0	设备 1779422166062972206 的自动创建抓拍空间	1779422166062972206	2026-05-22 03:56:06.893132	2026-05-22 03:56:06.893148
11	Camera 01	SPACE_EB9FDC48	snap-space	0	0	设备 1779422166041205920 的自动创建抓拍空间	1779422166041205920	2026-05-22 03:56:07.020951	2026-05-22 03:56:07.020959
12	Camera 01	SPACE_2DB36BA9	snap-space	0	0	设备 1779422166021660540 的自动创建抓拍空间	1779422166021660540	2026-05-22 03:56:07.141852	2026-05-22 03:56:07.141864
13	Camera 01	SPACE_7BF0738C	snap-space	0	0	设备 1779422166002269874 的自动创建抓拍空间	1779422166002269874	2026-05-22 03:56:07.273039	2026-05-22 03:56:07.273064
14	Camera 01	SPACE_B6D9111C	snap-space	0	0	设备 1779422165979283705 的自动创建抓拍空间	1779422165979283705	2026-05-22 03:56:07.409246	2026-05-22 03:56:07.40926
15	Camera 01	SPACE_192C9B25	snap-space	0	0	设备 1779422165955706874 的自动创建抓拍空间	1779422165955706874	2026-05-22 03:56:07.552031	2026-05-22 03:56:07.552056
16	Camera 01	SPACE_1EB77E13	snap-space	0	0	设备 1779422165933917600 的自动创建抓拍空间	1779422165933917600	2026-05-22 03:56:07.676076	2026-05-22 03:56:07.676092
17	Camera 01	SPACE_2BC6A249	snap-space	0	0	设备 1779422165904284120 的自动创建抓拍空间	1779422165904284120	2026-05-22 03:56:07.791593	2026-05-22 03:56:07.791605
18	Camera 01	SPACE_E40E85C9	snap-space	0	0	设备 1779422165875846125 的自动创建抓拍空间	1779422165875846125	2026-05-22 03:56:07.926652	2026-05-22 03:56:07.926668
19	Camera 01	SPACE_ABD8BA8E	snap-space	0	0	设备 1779422165849403860 的自动创建抓拍空间	1779422165849403860	2026-05-22 03:56:08.065456	2026-05-22 03:56:08.065476
20	Camera 01	SPACE_343ED991	snap-space	0	0	设备 1779422165828467470 的自动创建抓拍空间	1779422165828467470	2026-05-22 03:56:08.199455	2026-05-22 03:56:08.199466
21	Camera 01	SPACE_0104D241	snap-space	0	0	设备 1779422165801460442 的自动创建抓拍空间	1779422165801460442	2026-05-22 03:56:08.317338	2026-05-22 03:56:08.317358
22	Camera 01	SPACE_5C221023	snap-space	0	0	设备 1779422165775518450 的自动创建抓拍空间	1779422165775518450	2026-05-22 03:56:08.441015	2026-05-22 03:56:08.44103
23	Camera 01	SPACE_9D3436AD	snap-space	0	0	设备 1779422165746455491 的自动创建抓拍空间	1779422165746455491	2026-05-22 03:56:08.578315	2026-05-22 03:56:08.57835
24	Camera 01	SPACE_111C3A57	snap-space	0	0	设备 1779422165722056155 的自动创建抓拍空间	1779422165722056155	2026-05-22 03:56:08.712148	2026-05-22 03:56:08.712161
\.


--
-- Data for Name: snap_task; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.snap_task (id, task_name, task_code, space_id, device_id, pusher_id, capture_type, cron_expression, frame_skip, algorithm_enabled, algorithm_type, algorithm_model_id, algorithm_threshold, algorithm_night_mode, alarm_enabled, alarm_type, phone_number, email, notify_users, notify_methods, alarm_suppress_time, last_notify_time, auto_filename, custom_filename_prefix, status, is_enabled, exception_reason, run_status, total_captures, last_capture_time, last_success_time, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: sorter; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.sorter (id, sorter_name, sorter_code, sorter_type, sort_order, description, is_enabled, status, server_ip, port, process_id, last_heartbeat, log_path, task_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: stream_forward_task; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.stream_forward_task (id, task_name, task_code, output_format, output_quality, output_bitrate, status, is_enabled, exception_reason, service_server_ip, service_port, service_process_id, service_last_heartbeat, service_log_path, total_streams, last_process_time, last_success_time, description, created_at, updated_at) FROM stdin;
4	Network Video Recorder-推流转发	STREAM_FORWARD_BF8A93DA	rtmp	high	\N	0	f	\N	172.16.13.220	6000	1275108	2026-05-22 05:42:03.851927	/projects/easyaiot/VIDEO/logs/stream_forward_task_4	23	\N	2026-05-22 05:40:41.781623	NVR Network Video Recorder 下属通道自动推流转发 (nvr_stream_forward:nvr_id:1)	2026-05-22 04:29:03.789116	2026-05-22 05:42:08.423085
\.


--
-- Data for Name: stream_forward_task_device; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.stream_forward_task_device (stream_forward_task_id, device_id, created_at) FROM stdin;
4	1779422165722056155	2026-05-22 04:29:03.791834
4	1779422008175793403	2026-05-22 04:29:03.791835
4	1779422166082993126	2026-05-22 04:29:03.791836
4	1779422165979283705	2026-05-22 04:29:03.791836
4	1779422166002269874	2026-05-22 04:29:03.791836
4	1779422165746455491	2026-05-22 04:29:03.791836
4	1779422165849403860	2026-05-22 04:29:03.791836
4	1779420864892554342	2026-05-22 04:29:03.791837
4	1779422165775518450	2026-05-22 04:29:03.791837
4	1779422165875846125	2026-05-22 04:29:03.791837
4	1779422165801460442	2026-05-22 04:29:03.791837
4	1779422166021660540	2026-05-22 04:29:03.791838
4	1779422166041205920	2026-05-22 04:29:03.791838
4	1779422166154192033	2026-05-22 04:29:03.791838
4	1779421736545666241	2026-05-22 04:29:03.791838
4	1779422166104469817	2026-05-22 04:29:03.791838
4	1779422166129430057	2026-05-22 04:29:03.791839
4	1779422166062972206	2026-05-22 04:29:03.791839
4	1779422165828467470	2026-05-22 04:29:03.791839
4	1779422165904284120	2026-05-22 04:29:03.791839
4	1779422165955706874	2026-05-22 04:29:03.791839
4	1779422165933917600	2026-05-22 04:29:03.79184
4	1779421873137166368	2026-05-22 04:29:03.79184
\.


--
-- Data for Name: tracking_target; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.tracking_target (id, task_id, device_id, device_name, track_id, class_id, class_name, first_seen_time, last_seen_time, leave_time, duration, first_seen_frame, last_seen_frame, total_detections, information, created_at, updated_at) FROM stdin;
\.


--
-- Name: alert_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.alert_id_seq', 1, false);


--
-- Name: algorithm_model_service_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.algorithm_model_service_id_seq', 1, false);


--
-- Name: algorithm_task_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.algorithm_task_id_seq', 1, false);


--
-- Name: detection_region_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.detection_region_id_seq', 1, false);


--
-- Name: device_detection_region_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.device_detection_region_id_seq', 1, false);


--
-- Name: device_directory_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.device_directory_id_seq', 1, true);


--
-- Name: device_storage_config_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.device_storage_config_id_seq', 1, false);


--
-- Name: frame_extractor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.frame_extractor_id_seq', 1, false);


--
-- Name: image_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.image_id_seq', 1, false);


--
-- Name: nvr_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.nvr_id_seq', 1, true);


--
-- Name: playback_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.playback_id_seq', 687, true);


--
-- Name: pusher_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.pusher_id_seq', 1, false);


--
-- Name: record_space_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.record_space_id_seq', 24, true);


--
-- Name: region_model_service_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.region_model_service_id_seq', 1, false);


--
-- Name: snap_space_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.snap_space_id_seq', 24, true);


--
-- Name: snap_task_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.snap_task_id_seq', 1, false);


--
-- Name: sorter_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sorter_id_seq', 1, false);


--
-- Name: stream_forward_task_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.stream_forward_task_id_seq', 4, true);


--
-- Name: tracking_target_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.tracking_target_id_seq', 1, false);


--
-- Name: alert alert_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alert
    ADD CONSTRAINT alert_pkey PRIMARY KEY (id);


--
-- Name: algorithm_model_service algorithm_model_service_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.algorithm_model_service
    ADD CONSTRAINT algorithm_model_service_pkey PRIMARY KEY (id);


--
-- Name: algorithm_task_device algorithm_task_device_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.algorithm_task_device
    ADD CONSTRAINT algorithm_task_device_pkey PRIMARY KEY (task_id, device_id);


--
-- Name: algorithm_task algorithm_task_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.algorithm_task
    ADD CONSTRAINT algorithm_task_pkey PRIMARY KEY (id);


--
-- Name: algorithm_task algorithm_task_task_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.algorithm_task
    ADD CONSTRAINT algorithm_task_task_code_key UNIQUE (task_code);


--
-- Name: detection_region detection_region_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.detection_region
    ADD CONSTRAINT detection_region_pkey PRIMARY KEY (id);


--
-- Name: device_detection_region device_detection_region_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.device_detection_region
    ADD CONSTRAINT device_detection_region_pkey PRIMARY KEY (id);


--
-- Name: device_directory device_directory_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.device_directory
    ADD CONSTRAINT device_directory_pkey PRIMARY KEY (id);


--
-- Name: device device_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.device
    ADD CONSTRAINT device_pkey PRIMARY KEY (id);


--
-- Name: device_storage_config device_storage_config_device_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.device_storage_config
    ADD CONSTRAINT device_storage_config_device_id_key UNIQUE (device_id);


--
-- Name: device_storage_config device_storage_config_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.device_storage_config
    ADD CONSTRAINT device_storage_config_pkey PRIMARY KEY (id);


--
-- Name: frame_extractor frame_extractor_extractor_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.frame_extractor
    ADD CONSTRAINT frame_extractor_extractor_code_key UNIQUE (extractor_code);


--
-- Name: frame_extractor frame_extractor_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.frame_extractor
    ADD CONSTRAINT frame_extractor_pkey PRIMARY KEY (id);


--
-- Name: image image_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.image
    ADD CONSTRAINT image_pkey PRIMARY KEY (id);


--
-- Name: nvr nvr_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nvr
    ADD CONSTRAINT nvr_pkey PRIMARY KEY (id);


--
-- Name: playback playback_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.playback
    ADD CONSTRAINT playback_pkey PRIMARY KEY (id);


--
-- Name: pusher pusher_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pusher
    ADD CONSTRAINT pusher_pkey PRIMARY KEY (id);


--
-- Name: pusher pusher_pusher_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pusher
    ADD CONSTRAINT pusher_pusher_code_key UNIQUE (pusher_code);


--
-- Name: record_space record_space_device_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.record_space
    ADD CONSTRAINT record_space_device_id_key UNIQUE (device_id);


--
-- Name: record_space record_space_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.record_space
    ADD CONSTRAINT record_space_pkey PRIMARY KEY (id);


--
-- Name: record_space record_space_space_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.record_space
    ADD CONSTRAINT record_space_space_code_key UNIQUE (space_code);


--
-- Name: region_model_service region_model_service_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.region_model_service
    ADD CONSTRAINT region_model_service_pkey PRIMARY KEY (id);


--
-- Name: snap_space snap_space_device_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.snap_space
    ADD CONSTRAINT snap_space_device_id_key UNIQUE (device_id);


--
-- Name: snap_space snap_space_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.snap_space
    ADD CONSTRAINT snap_space_pkey PRIMARY KEY (id);


--
-- Name: snap_space snap_space_space_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.snap_space
    ADD CONSTRAINT snap_space_space_code_key UNIQUE (space_code);


--
-- Name: snap_task snap_task_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.snap_task
    ADD CONSTRAINT snap_task_pkey PRIMARY KEY (id);


--
-- Name: snap_task snap_task_task_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.snap_task
    ADD CONSTRAINT snap_task_task_code_key UNIQUE (task_code);


--
-- Name: sorter sorter_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sorter
    ADD CONSTRAINT sorter_pkey PRIMARY KEY (id);


--
-- Name: sorter sorter_sorter_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sorter
    ADD CONSTRAINT sorter_sorter_code_key UNIQUE (sorter_code);


--
-- Name: stream_forward_task_device stream_forward_task_device_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stream_forward_task_device
    ADD CONSTRAINT stream_forward_task_device_pkey PRIMARY KEY (stream_forward_task_id, device_id);


--
-- Name: stream_forward_task stream_forward_task_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stream_forward_task
    ADD CONSTRAINT stream_forward_task_pkey PRIMARY KEY (id);


--
-- Name: stream_forward_task stream_forward_task_task_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stream_forward_task
    ADD CONSTRAINT stream_forward_task_task_code_key UNIQUE (task_code);


--
-- Name: tracking_target tracking_target_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tracking_target
    ADD CONSTRAINT tracking_target_pkey PRIMARY KEY (id);


--
-- Name: ix_nvr_ip; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_nvr_ip ON public.nvr USING btree (ip);


--
-- Name: algorithm_model_service algorithm_model_service_task_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.algorithm_model_service
    ADD CONSTRAINT algorithm_model_service_task_id_fkey FOREIGN KEY (task_id) REFERENCES public.algorithm_task(id) ON DELETE CASCADE;


--
-- Name: algorithm_task_device algorithm_task_device_device_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.algorithm_task_device
    ADD CONSTRAINT algorithm_task_device_device_id_fkey FOREIGN KEY (device_id) REFERENCES public.device(id) ON DELETE CASCADE;


--
-- Name: algorithm_task_device algorithm_task_device_task_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.algorithm_task_device
    ADD CONSTRAINT algorithm_task_device_task_id_fkey FOREIGN KEY (task_id) REFERENCES public.algorithm_task(id) ON DELETE CASCADE;


--
-- Name: algorithm_task algorithm_task_space_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.algorithm_task
    ADD CONSTRAINT algorithm_task_space_id_fkey FOREIGN KEY (space_id) REFERENCES public.snap_space(id) ON DELETE CASCADE;


--
-- Name: detection_region detection_region_image_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.detection_region
    ADD CONSTRAINT detection_region_image_id_fkey FOREIGN KEY (image_id) REFERENCES public.image(id) ON DELETE SET NULL;


--
-- Name: device_detection_region device_detection_region_device_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.device_detection_region
    ADD CONSTRAINT device_detection_region_device_id_fkey FOREIGN KEY (device_id) REFERENCES public.device(id) ON DELETE CASCADE;


--
-- Name: device_detection_region device_detection_region_image_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.device_detection_region
    ADD CONSTRAINT device_detection_region_image_id_fkey FOREIGN KEY (image_id) REFERENCES public.image(id) ON DELETE SET NULL;


--
-- Name: device device_directory_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.device
    ADD CONSTRAINT device_directory_id_fkey FOREIGN KEY (directory_id) REFERENCES public.device_directory(id) ON DELETE SET NULL;


--
-- Name: device_directory device_directory_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.device_directory
    ADD CONSTRAINT device_directory_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.device_directory(id) ON DELETE CASCADE;


--
-- Name: device device_nvr_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.device
    ADD CONSTRAINT device_nvr_id_fkey FOREIGN KEY (nvr_id) REFERENCES public.nvr(id) ON DELETE SET NULL;


--
-- Name: device_storage_config device_storage_config_device_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.device_storage_config
    ADD CONSTRAINT device_storage_config_device_id_fkey FOREIGN KEY (device_id) REFERENCES public.device(id) ON DELETE CASCADE;


--
-- Name: image image_device_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.image
    ADD CONSTRAINT image_device_id_fkey FOREIGN KEY (device_id) REFERENCES public.device(id);


--
-- Name: record_space record_space_device_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.record_space
    ADD CONSTRAINT record_space_device_id_fkey FOREIGN KEY (device_id) REFERENCES public.device(id) ON DELETE SET NULL;


--
-- Name: region_model_service region_model_service_region_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.region_model_service
    ADD CONSTRAINT region_model_service_region_id_fkey FOREIGN KEY (region_id) REFERENCES public.detection_region(id) ON DELETE CASCADE;


--
-- Name: snap_space snap_space_device_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.snap_space
    ADD CONSTRAINT snap_space_device_id_fkey FOREIGN KEY (device_id) REFERENCES public.device(id) ON DELETE SET NULL;


--
-- Name: snap_task snap_task_device_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.snap_task
    ADD CONSTRAINT snap_task_device_id_fkey FOREIGN KEY (device_id) REFERENCES public.device(id) ON DELETE CASCADE;


--
-- Name: snap_task snap_task_pusher_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.snap_task
    ADD CONSTRAINT snap_task_pusher_id_fkey FOREIGN KEY (pusher_id) REFERENCES public.pusher(id) ON DELETE SET NULL;


--
-- Name: snap_task snap_task_space_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.snap_task
    ADD CONSTRAINT snap_task_space_id_fkey FOREIGN KEY (space_id) REFERENCES public.snap_space(id) ON DELETE CASCADE;


--
-- Name: stream_forward_task_device stream_forward_task_device_device_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stream_forward_task_device
    ADD CONSTRAINT stream_forward_task_device_device_id_fkey FOREIGN KEY (device_id) REFERENCES public.device(id) ON DELETE CASCADE;


--
-- Name: stream_forward_task_device stream_forward_task_device_stream_forward_task_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stream_forward_task_device
    ADD CONSTRAINT stream_forward_task_device_stream_forward_task_id_fkey FOREIGN KEY (stream_forward_task_id) REFERENCES public.stream_forward_task(id) ON DELETE CASCADE;


--
-- Name: tracking_target tracking_target_task_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tracking_target
    ADD CONSTRAINT tracking_target_task_id_fkey FOREIGN KEY (task_id) REFERENCES public.algorithm_task(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict yFN15qrM4VaMwHFJsmljT5DBRLIW8AOVZSagKd4cUGeMB25t7hza3ID3EJlVPGF

