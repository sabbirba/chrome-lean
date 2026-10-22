#!/bin/zsh
set -euo pipefail
source "${0:A:h}/lib.sh"

require_macos
require_chrome

D=$CHROME_DOMAIN
b() { local v=$1; shift; for k in "$@"; do defaults write $D $k -bool $v; done }
i() { local v=$1; shift; for k in "$@"; do defaults write $D $k -int $v; done }
s() { defaults write $D $1 -string $2 }

info "Applying policies for Chrome $(chrome_version)"

i 2 AutofillPredictionSettings CreateThemesSettings DevToolsGenAiSettings HelpMeWriteSettings HistorySearchSettings TabCompareSettings
i 1 AIModeSettings GeminiSettings GeminiActOnWebSettings GeminiSparkSettings GeminiChromeFileUploadSettings FindAndFillWithGeminiSettings \
    GenAILocalFoundationalModelSettings ThirdPartyAiChatSettings ChromeSuggestionsSettings SearchContentSharingSettings
b false BuiltInAIAPIsEnabled TranslatorAPIAllowed BrowserLabsEnabled
ok "AI features off"

b false PromotionsEnabled ShoppingListEnabled FeedbackSurveysEnabled SafeBrowsingSurveysEnabled UserFeedbackAllowed \
  MediaRecommendationsEnabled NTPCardsVisible NTPCustomBackgroundEnabled NTPFooterExtensionAttributionEnabled \
  NTPOutlookCardVisible NTPSharepointCardVisible SideSearchEnabled GoogleSearchSidePanelEnabled HistoryClustersVisible \
  AccessibilityImageLabelsEnabled DesktopSharingHubEnabled ShowCastIconInToolbar ShowCastSessionsStartedByOtherDevices \
  EnableMediaRouter AccessCodeCastEnabled LiveCaptionEnabled LiveTranslateEnabled TranslateEnabled SpellcheckEnabled \
  SpellCheckServiceEnabled SearchSuggestEnabled AutofillAddressEnabled AutofillCreditCardEnabled PaymentMethodQueryEnabled \
  ShowHomeButton QRCodeGeneratorEnabled AllowDinosaurEasterEgg ExtensionReviewPromptsEnabled SigninInterceptionEnabled \
  PromptForDownloadLocation AutoplayAllowed SafeBrowsingDeepScanningEnabled BrowserAddPersonEnabled BrowserGuestModeEnabled \
  ComponentUpdatesEnabled
b true HideWebStoreIcon SuppressUnsupportedOSWarning
i 2 AdsSettingForIntrusiveAdsSites
i 1 ChromeVariations
ok "Bloat off"

b true HighEfficiencyModeEnabled BackgroundTabFreezingEnabled IntensiveWakeUpThrottlingEnabled HardwareAccelerationModeEnabled \
  BuiltInDnsClientEnabled QuicAllowed TLS13EarlyDataEnabled HappyEyeballsV3Enabled CompressionDictionaryTransportEnabled \
  AdditionalDnsQueryTypesEnabled AbusiveExperienceInterventionEnforce
i 2 MemorySaverModeSavings
i 1 BatterySaverModeAvailability
b false PrefetchWithServiceWorkerEnabled ServiceWorkerAutoPreloadEnabled
i 2 NetworkPredictionOptions
i 52428800 DiskCacheSize
i $(( $(sysctl -n hw.memsize) / 1048576 / 8 )) TotalMemoryLimitMb
ok "Speed and memory tuned"

b false UrlKeyedAnonymizedDataCollectionEnabled UrlKeyedMetricsAllowed DomainReliabilityAllowed AlternateErrorPagesEnabled \
  WebRtcEventLogCollectionAllowed WebRtcTextLogCollectionAllowed SafeBrowsingExtendedReportingEnabled \
  SafeBrowsingProxiedRealTimeChecksAllowed BrowserNetworkTimeQueriesEnabled WPADQuickCheckEnabled \
  ScrollToTextFragmentEnabled SignedHTTPExchangeEnabled
b true BlockThirdPartyCookies EncryptedClientHelloEnabled ReduceAcceptLanguageEnabled HttpsUpgradesEnabled SavingBrowserHistoryDisabled
i 1 SafeBrowsingProtectionLevel
s HttpsOnlyMode force_enabled
s WebRtcIPHandling default_public_interface_only
s DnsOverHttpsMode secure
s DnsOverHttpsTemplates "https://cloudflare-dns.com/dns-query"
ok "Privacy hardened"

i 2 DefaultNotificationsSetting DefaultGeolocationSetting DefaultSensorsSetting DefaultIdleDetectionSetting \
  DefaultLocalFontsSetting DefaultWindowManagementSetting DefaultWebBluetoothGuardSetting DefaultWebUsbGuardSetting \
  DefaultSerialGuardSetting DefaultWebHidGuardSetting DefaultDirectSocketsSetting DefaultDirectSocketsPrivateNetworkAccessSetting \
  DefaultPopupsSetting DefaultAutomaticDownloadsSetting DefaultClipboardSetting DefaultFileSystemReadGuardSetting \
  DefaultFileSystemWriteGuardSetting DefaultInsecureContentSetting DefaultControlledFrameSetting DefaultMediaStreamSetting
ok "Site permissions blocked"

quit_chrome
open_chrome "chrome://policy"
ok "Applied $(policy_keys | grep -c .) policies. Chrome restarted."
