import defaultLogo from '@/assets/images/logo.png'
import defaultLightBg from '@/assets/images/light-bg.png'
import defaultDarkBg from '@/assets/images/dark-bg.png'

export const PLATFORM_BRANDING_STORAGE_KEY = 'PLATFORM_BRANDING_CONFIG'
export const PLATFORM_BRANDING_FAB_HIDDEN_KEY = 'PLATFORM_BRANDING_FAB_HIDDEN'

export interface PlatformBrandingConfig {
  /** 管理后台平台名称（侧边栏、浏览器标题等） */
  platformName: string
  /** 管理后台平台 Logo */
  platformLogo: string
  /** 大屏顶部标题 */
  dashboardTitle: string
  /** 登录页左侧名称 */
  loginName: string
  /** 登录页 Logo */
  loginLogo: string
  /** 登录表单标题，留空则使用 i18n 默认文案 */
  loginFormTitle: string
  /** 登录页浅色背景 */
  loginBgLight: string
  /** 登录页深色背景 */
  loginBgDark: string
}

export function getDefaultPlatformBranding(): PlatformBrandingConfig {
  const envTitle = import.meta.env.VITE_GLOB_APP_TITLE || '云边端一体化智能算法应用平台'
  return {
    platformName: envTitle,
    platformLogo: defaultLogo,
    dashboardTitle: '云边端一体算法预警监控平台',
    loginName: envTitle,
    loginLogo: defaultLogo,
    loginFormTitle: '',
    loginBgLight: defaultLightBg,
    loginBgDark: defaultDarkBg,
  }
}

export function loadPlatformBrandingConfig(): PlatformBrandingConfig {
  const defaults = getDefaultPlatformBranding()
  const raw = readJson(PLATFORM_BRANDING_STORAGE_KEY)
  if (!raw || typeof raw !== 'object') {
    return { ...defaults }
  }
  const data = raw as Partial<PlatformBrandingConfig>
  return {
    platformName: pickString(data.platformName, defaults.platformName),
    platformLogo: pickString(data.platformLogo, defaults.platformLogo),
    dashboardTitle: pickString(data.dashboardTitle, defaults.dashboardTitle),
    loginName: pickString(data.loginName, defaults.loginName),
    loginLogo: pickString(data.loginLogo, defaults.loginLogo),
    loginFormTitle: typeof data.loginFormTitle === 'string' ? data.loginFormTitle : defaults.loginFormTitle,
    loginBgLight: pickString(data.loginBgLight, defaults.loginBgLight),
    loginBgDark: pickString(data.loginBgDark, defaults.loginBgDark),
  }
}

/** @returns 是否写入成功（空间不足等场景会返回 false） */
export function savePlatformBrandingConfig(config: PlatformBrandingConfig): boolean {
  return writeJson(PLATFORM_BRANDING_STORAGE_KEY, config)
}

export function clearPlatformBrandingConfig(): void {
  try {
    window.localStorage.removeItem(PLATFORM_BRANDING_STORAGE_KEY)
  }
  catch (error) {
    console.error(error)
  }
}

export function loadFabHiddenState(): boolean {
  return readJson(PLATFORM_BRANDING_FAB_HIDDEN_KEY) === true
}

export function saveFabHiddenState(hidden: boolean): void {
  writeJson(PLATFORM_BRANDING_FAB_HIDDEN_KEY, hidden)
}

function pickString(value: unknown, fallback: string): string {
  return typeof value === 'string' && value.trim() ? value : fallback
}

/** 使用原生 JSON，避免通用 storage 工具在退出登录时被一并清空后的二次解析问题 */
function readJson(key: string): unknown {
  try {
    const item = window.localStorage.getItem(key)
    if (!item)
      return null
    return JSON.parse(item)
  }
  catch (error) {
    console.error(error)
    return null
  }
}

function writeJson(key: string, value: unknown): boolean {
  try {
    window.localStorage.setItem(key, JSON.stringify(value))
    return true
  }
  catch (error) {
    console.error(error)
    return false
  }
}
