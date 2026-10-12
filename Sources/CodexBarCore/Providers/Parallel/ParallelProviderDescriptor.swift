import Foundation

public enum ParallelProviderDescriptor {
    public static let descriptor: ProviderDescriptor = Self.spec.makeDescriptor()
    public static let spec = PluginProviderSpec(
        id: .parallel,
        displayName: "Parallel",
        sessionLabel: "Balance",
        weeklyLabel: "Balance",
        toggleTitle: "Show Parallel balance",
        balanceOnly: true,
        dashboardURL: "https://platform.parallel.ai",
        color: .init(hex: 0x1D1C1A),
        confetti: [0x1D1C1A, 0x8C8C8C],
        noDataMessage: "No cost history data.",
        webSource: .init(
            settingsSection: .init(ParallelProviderSettingsKey.self, cookieSettings: CookieProviderSettings.self),
            browserCookieOrder: BrowserCookieImportSupport.chromeOnly(
                reason: "Parallel imports only Chrome to avoid unrelated browser prompts."),
            browserSupportExemption: { _, _, settings in settings?.parallel?.cookieSource == .manual },
            resolveValues: { $0.settings?.parallel?.cookieSource == .off ? nil : .init() },
            field: .init(
                id: "parallel-cookie-header",
                title: "Cookie header",
                subtitle: "Paste the Cookie header from a signed-in platform.parallel.ai request.",
                placeholder: "Cookie: …",
                action: (
                    id: "parallel-open-platform",
                    title: "Open Parallel Platform",
                    url: "https://platform.parallel.ai")),
            picker: .init(
                id: "parallel-cookie-source",
                allowsOff: true,
                auto: .localized("Automatic imports Chrome cookies from platform.parallel.ai."),
                manual: .localized("Paste a Cookie header captured from %@.", argument: "platform.parallel.ai"),
                off: .localized("%@ cookies are disabled.", argument: "Parallel"),
                showsRefreshAction: true),
            detailLine: "Browser cookies",
            showsVersionInSettings: false,
            loginURL: "https://platform.parallel.ai/login"))
}

public enum ParallelProviderSettingsKey: ProviderSettingsSectionKey {
    public static let providerID = ProviderInstanceID.parallel
    public typealias Section = CookieProviderSettings
}

extension ProviderSettingsSnapshot {
    public var parallel: CookieProviderSettings? {
        self[ParallelProviderSettingsKey.self]
    }
}
