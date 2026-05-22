import { getDeviceChannels, queryAllVideoList } from '@/api/device/gb28181';
import { resolveGbChannelPlayIds } from './gb28181Channel';

/** 提交给 VIDEO /directory/sync-gb28181 的国标通道项 */
export interface Gb28181ChannelSyncItem {
  sipDeviceId: string;
  channelId: string;
  name?: string;
}

/**
 * 经 dev-api/gb28181 拉取 WVP 设备与通道（与分屏监控相同网关），供设备目录同步入库。
 */
export async function collectWvpGbChannelsForSync(): Promise<{
  channels: Gb28181ChannelSyncItem[];
  wvpDeviceCount: number;
}> {
  const { data: devices } = await queryAllVideoList();
  const sipList = (devices || [])
    .map((d) => String(d.deviceIdentification || d.deviceId || '').trim())
    .filter(Boolean);

  const channels: Gb28181ChannelSyncItem[] = [];
  for (const sip of sipList) {
    const { data: chList } = await getDeviceChannels(sip);
    for (const ch of chList || []) {
      const ids = resolveGbChannelPlayIds(ch, sip);
      if (!ids) continue;
      channels.push({
        sipDeviceId: ids.sipDeviceId,
        channelId: ids.channelId,
        name: String(ch.name || '').trim() || undefined,
      });
    }
  }

  return { channels, wvpDeviceCount: sipList.length };
}
