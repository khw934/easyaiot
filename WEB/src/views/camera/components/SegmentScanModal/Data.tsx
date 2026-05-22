import { BasicColumn } from '@/components/Table';

export function getCameraScanColumns(): BasicColumn[] {
  return [
    { title: 'IP', dataIndex: 'ip', width: 130 },
    { title: '端口', dataIndex: 'port', width: 70 },
    { title: '品牌', dataIndex: 'vendor_label', width: 90 },
    { title: '角色', dataIndex: 'role_label', width: 90 },
    { title: '型号', dataIndex: 'model', width: 140, ellipsis: true },
    { title: '名称', dataIndex: 'device_name', width: 140, ellipsis: true },
    { title: 'MAC', dataIndex: 'mac', width: 140, ellipsis: true },
    { title: 'RTSP', dataIndex: 'rtsp_url', width: 280, ellipsis: true },
    { title: '操作', dataIndex: 'action', width: 90, fixed: 'right' },
  ];
}

export function getNvrScanColumns(): BasicColumn[] {
  return [
    { title: 'IP', dataIndex: 'ip', width: 130 },
    { title: '端口', dataIndex: 'port', width: 70 },
    { title: '品牌', dataIndex: 'vendor_label', width: 90 },
    { title: '角色', dataIndex: 'role_label', width: 90 },
    { title: '型号', dataIndex: 'model', width: 150, ellipsis: true },
    { title: '名称', dataIndex: 'device_name', width: 150, ellipsis: true },
    { title: 'RTSP', dataIndex: 'rtsp_url', width: 280, ellipsis: true },
    { title: '操作', dataIndex: 'action', width: 120, fixed: 'right' },
  ];
}
