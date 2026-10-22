# Policy reference

Every policy that [`scripts/apply.sh`](../scripts/apply.sh) sets, what it does and the value it uses. Each one was checked against `chrome://policy` on Chrome 155.

Value meanings: `2` on a `Default…Setting` means **block**. Gemini-style `…Settings` use `1` = off, and the older GenAI-style `…Settings` use `2` = off.

## AI

| Policy | Value | Effect |
|---|---|---|
| `GeminiSettings` | 1 | Gemini in Chrome off |
| `GeminiActOnWebSettings` | 1 | Gemini can't act on web pages |
| `GeminiSparkSettings` | 1 | Gemini Spark off |
| `GeminiChromeFileUploadSettings` | 1 | No file uploads to Gemini *(unreleased in 155)* |
| `FindAndFillWithGeminiSettings` | 1 | Gemini find-and-fill off *(unreleased in 155)* |
| `AIModeSettings` | 1 | AI Mode in the address bar off |
| `ThirdPartyAiChatSettings` | 1 | Third-party AI chat side panel off |
| `ChromeSuggestionsSettings` | 1 | AI suggestions off |
| `SearchContentSharingSettings` | 1 | Lens and page sharing with Google off |
| `GenAILocalFoundationalModelSettings` | 1 | On-device AI model isn't downloaded |
| `HelpMeWriteSettings` | 2 | Help me write off |
| `HistorySearchSettings` | 2 | AI history search off |
| `TabCompareSettings` | 2 | Tab compare off |
| `CreateThemesSettings` | 2 | AI themes off |
| `DevToolsGenAiSettings` | 2 | AI in DevTools off |
| `AutofillPredictionSettings` | 2 | AI autofill predictions off |
| `BuiltInAIAPIsEnabled` | false | AI APIs for websites off |
| `TranslatorAPIAllowed` | false | Translator API for websites off |
| `BrowserLabsEnabled` | false | Chrome Labs experiments off |

## Bloat

| Policy | Value | Effect |
|---|---|---|
| `PromotionsEnabled` | false | No promo content |
| `ShoppingListEnabled` | false | No price tracking or shopping list |
| `FeedbackSurveysEnabled`, `SafeBrowsingSurveysEnabled` | false | No surveys |
| `UserFeedbackAllowed` | false | No feedback prompts |
| `MediaRecommendationsEnabled` | false | No media recommendations |
| `NTPCardsVisible`, `NTPOutlookCardVisible`, `NTPSharepointCardVisible` | false | No New Tab cards |
| `NTPCustomBackgroundEnabled` | false | No custom New Tab backgrounds |
| `NTPFooterExtensionAttributionEnabled` | false | No extension credit in the New Tab footer |
| `SideSearchEnabled`, `GoogleSearchSidePanelEnabled` | false | No search side panels |
| `HistoryClustersVisible` | false | No history "journeys" |
| `AccessibilityImageLabelsEnabled` | false | No image descriptions sent to Google |
| `DesktopSharingHubEnabled` | false | No share hub |
| `EnableMediaRouter`, `AccessCodeCastEnabled` | false | Cast off |
| `ShowCastIconInToolbar`, `ShowCastSessionsStartedByOtherDevices` | false | No Cast UI |
| `LiveCaptionEnabled`, `LiveTranslateEnabled` | false | No live captions or translation |
| `TranslateEnabled` | false | No translate prompts |
| `SpellcheckEnabled`, `SpellCheckServiceEnabled` | false | No spell check |
| `SearchSuggestEnabled` | false | No suggestions while typing |
| `AutofillAddressEnabled`, `AutofillCreditCardEnabled` | false | No address or card autofill |
| `PaymentMethodQueryEnabled` | false | Sites can't check saved cards |
| `ShowHomeButton` | false | No Home button |
| `QRCodeGeneratorEnabled` | false | No QR codes |
| `AllowDinosaurEasterEgg` | false | No dinosaur game |
| `ExtensionReviewPromptsEnabled` | false | No extension review prompts |
| `SigninInterceptionEnabled` | false | No "sign in to Chrome?" pop-up |
| `PromptForDownloadLocation` | false | Downloads save without asking |
| `AutoplayAllowed` | false | No video autoplay |
| `SafeBrowsingDeepScanningEnabled` | false | No deep scans of downloads |
| `BrowserAddPersonEnabled` | false | Can't add new profiles |
| `BrowserGuestModeEnabled` | false | No Guest mode |
| `HideWebStoreIcon` | true | No Web Store icon |
| `SuppressUnsupportedOSWarning` | true | No old-macOS warning |
| `AdsSettingForIntrusiveAdsSites` | 2 | Chrome's ad filter blocks ads on abusive sites |
| `ComponentUpdatesEnabled` | false | No background component downloads (security components still update) |
| `ChromeVariations` | 1 | Only critical-fix experiments |

## Speed and memory

| Policy | Value | Effect |
|---|---|---|
| `HighEfficiencyModeEnabled` | true | Memory Saver on |
| `MemorySaverModeSavings` | 2 | Memory Saver on aggressive |
| `BackgroundTabFreezingEnabled` | true | Background tabs freeze |
| `IntensiveWakeUpThrottlingEnabled` | true | Background timers throttled |
| `BatterySaverModeAvailability` | 1 | Energy Saver turns on when the battery is low |
| `TotalMemoryLimitMb` | RAM ÷ 8 | Tabs are discarded above this limit |
| `DiskCacheSize` | 52428800 | Cache capped at 50 MB |
| `NetworkPredictionOptions` | 2 | No preloading, which saves memory, disk and network |
| `HardwareAccelerationModeEnabled` | true | GPU acceleration on |
| `BuiltInDnsClientEnabled` | true | Chrome's own DNS client |
| `QuicAllowed` | true | QUIC protocol on |
| `TLS13EarlyDataEnabled` | true | Faster reconnects |
| `HappyEyeballsV3Enabled` | true | Faster choice between IPv4 and IPv6 |
| `CompressionDictionaryTransportEnabled` | true | Smaller downloads |
| `PrefetchWithServiceWorkerEnabled`, `ServiceWorkerAutoPreloadEnabled` | false | No background prefetching through service workers |
| `AdditionalDnsQueryTypesEnabled` | true | HTTPS DNS records |
| `AbusiveExperienceInterventionEnforce` | true | Blocks abusive page behaviour |

## Privacy and telemetry

| Policy | Value | Effect |
|---|---|---|
| `BlockThirdPartyCookies` | true | No cross-site cookies |
| `SavingBrowserHistoryDisabled` | true | History isn't saved |
| `HttpsOnlyMode` | force_enabled | HTTPS forced |
| `HttpsUpgradesEnabled` | true | HTTP links upgraded to HTTPS |
| `DnsOverHttpsMode` | secure | Encrypted DNS only |
| `DnsOverHttpsTemplates` | Cloudflare | DNS resolver |
| `EncryptedClientHelloEnabled` | true | Hides which site you connect to |
| `ReduceAcceptLanguageEnabled` | true | Less language information sent |
| `WebRtcIPHandling` | default_public_interface_only | No local IP leaks |
| `SafeBrowsingProtectionLevel` | 1 | Standard Safe Browsing |
| `SafeBrowsingProxiedRealTimeChecksAllowed` | false | No live URL checks |
| `SafeBrowsingExtendedReportingEnabled` | false | No extended reports |
| `UrlKeyedAnonymizedDataCollectionEnabled` | false | Visited URLs not sent |
| `UrlKeyedMetricsAllowed` | false | URL metrics off *(unreleased in 155)* |
| `DomainReliabilityAllowed` | false | No reliability reports |
| `AlternateErrorPagesEnabled` | false | No suggestion lookups on error pages |
| `WebRtcEventLogCollectionAllowed`, `WebRtcTextLogCollectionAllowed` | false | No WebRTC log uploads |
| `BrowserNetworkTimeQueriesEnabled` | false | No time checks with Google |
| `WPADQuickCheckEnabled` | false | No proxy auto-detection |
| `ScrollToTextFragmentEnabled` | false | No text-fragment links |
| `SignedHTTPExchangeEnabled` | false | No signed exchanges |

## Site permissions (all blocked by default, value `2`)

`DefaultNotificationsSetting`, `DefaultGeolocationSetting`, `DefaultMediaStreamSetting` (camera and mic), `DefaultClipboardSetting`, `DefaultFileSystemReadGuardSetting`, `DefaultFileSystemWriteGuardSetting`, `DefaultPopupsSetting`, `DefaultAutomaticDownloadsSetting`, `DefaultInsecureContentSetting`, `DefaultSensorsSetting`, `DefaultIdleDetectionSetting`, `DefaultLocalFontsSetting`, `DefaultWindowManagementSetting`, `DefaultWebBluetoothGuardSetting`, `DefaultWebUsbGuardSetting`, `DefaultSerialGuardSetting`, `DefaultWebHidGuardSetting`, `DefaultDirectSocketsSetting`\*, `DefaultDirectSocketsPrivateNetworkAccessSetting`\*, `DefaultControlledFrameSetting`\*

\* Unreleased in Chrome 155. They take effect once Google releases those features.

## Policies left out on purpose

| Policy | Why |
|---|---|
| `MetricsReportingEnabled`, `NTPFooterManagementNoticeEnabled` | Chrome only accepts them as Mandatory policies (needs a profile and shows the banner) |
| `GenAiDefaultSettings` | Only works from cloud management |
| `ProfilePickerOnStartupAvailability`, `NTPShortcuts` | Not supported at this level |
| `PrivacySandbox*`, `Lens*`, `PromotionalTabsEnabled`, `InsecureFormsWarningsEnabled`, `DefaultWindowPlacementSetting` | Deprecated or overridden |
| `BackgroundModeEnabled`, `ClickToCallEnabled`, `SharedClipboardEnabled`, `HelpMeReadSettings` and others | Not available on macOS |
| `ClearBrowsingDataOnExitList`, `BrowsingDataLifetime` | Need sync turned off |
