/**
 * 告警列表/卡片中的图片展示地址：仅使用后台返回的 image_url（MinIO 下载路径）。
 * 相对路径（含 /api/v1/buckets/...）补全为当前站点 origin，便于 dev 代理访问。
 */
export function resolveAlertImageDisplayUrl(imageUrl: string | null | undefined): string {
  if (imageUrl == null || String(imageUrl).trim() === '') return '';
  const u = String(imageUrl).trim();
  if (u.startsWith('http://') || u.startsWith('https://')) return u;
  if (u.startsWith('/')) return `${window.location.origin}${u}`;
  return u;
}
