#if os(macOS)

import AppKit
import Combine
import NitroModules

class NativeMacOSPlatform: HybridNativePlatformSpec {
    var miniRuntime: UnistylesNativeMiniRuntime?
    var cancellables = Set<AnyCancellable>()

    var dependencyListeners: Array<CxxDependencyListener> = []
    var imeListeners: Array<CxxImeListener> = []

    override init() {
        super.init()

        self.miniRuntime = self.buildMiniRuntime()

        setupPlatformListeners()
    }

    deinit {
        removePlatformListeners()
    }

    func getMiniRuntime() -> UnistylesNativeMiniRuntime {
        return self.miniRuntime!
    }

    func buildMiniRuntime() -> UnistylesNativeMiniRuntime {
        let orientation = self.getOrientation()

        return UnistylesNativeMiniRuntime(
            colorScheme: self.getColorScheme(),
            screen: self.getScreenDimensions(),
            contentSizeCategory: self.getContentSizeCategory(),
            insets: self.getInsets(),
            pixelRatio: self.getPixelRatio(),
            fontScale: self.getFontScale(),
            rtl: self.getPrefersRtlDirection(),
            statusBar: self.getStatusBarDimensions(),
            navigationBar: self.getNavigationBarDimensions(),
            isPortrait: orientation == .portrait,
            isLandscape: orientation == .landscape
        )
    }

    func getMainWindow() -> NSWindow? {
        return NSApplication.shared.keyWindow
            ?? NSApplication.shared.mainWindow
            ?? NSApplication.shared.windows.first(where: { $0.contentView != nil })
    }

    func getColorScheme() -> ColorScheme {
        func getColorSchemeFn() -> ColorScheme {
            let appearance = getMainWindow()?.effectiveAppearance ?? NSApplication.shared.effectiveAppearance

            switch appearance.bestMatch(from: [.darkAqua, .aqua]) {
            case .darkAqua:
                return ColorScheme.dark
            case .aqua:
                return ColorScheme.light
            default:
                return ColorScheme.unspecified
            }
        }

        if Thread.isMainThread {
            return getColorSchemeFn()
        }

        return DispatchQueue.main.sync {
            return getColorSchemeFn()
        }
    }

    func getFontScale() -> Double {
        return 1
    }

    func getScreenDimensions() -> Dimensions {
        func getScreenDimensionsFn() -> Dimensions {
            guard let contentView = getMainWindow()?.contentView else {
                return self.miniRuntime?.screen ?? Dimensions(width: 0, height: 0)
            }

            let bounds = contentView.bounds

            return Dimensions(width: bounds.width, height: bounds.height)
        }

        if Thread.isMainThread {
            return getScreenDimensionsFn()
        }

        return DispatchQueue.main.sync {
            return getScreenDimensionsFn()
        }
    }

    func getOrientation() -> Orientation {
        let screenDimensions = getScreenDimensions()

        if (screenDimensions.width > screenDimensions.height) {
            return Orientation.landscape
        }

        return Orientation.portrait
    }

    func getContentSizeCategory() -> String {
        return "Medium"
    }

    func getInsets() -> Insets {
        func getInsetsFn() -> Insets {
            guard let contentView = getMainWindow()?.contentView else {
                return self.miniRuntime?.insets ?? Insets(top: 0, bottom: 0, left: 0, right: 0, ime: 0)
            }

            let safeArea = contentView.safeAreaInsets

            return Insets(
                top: safeArea.top,
                bottom: safeArea.bottom,
                left: safeArea.left,
                right: safeArea.right,
                ime: 0
            )
        }

        if Thread.isMainThread {
            return getInsetsFn()
        }

        return DispatchQueue.main.sync {
            return getInsetsFn()
        }
    }

    func getPrefersRtlDirection() -> Bool {
        func getPrefersRtlDirectionFn() -> Bool {
            let hasForcedRtl = UserDefaults.standard.bool(forKey: "RCTI18nUtil_forceRTL")
            let isRtl = NSApplication.shared.userInterfaceLayoutDirection == .rightToLeft

            return hasForcedRtl || isRtl
        }

        if Thread.isMainThread {
            return getPrefersRtlDirectionFn()
        }

        return DispatchQueue.main.sync {
            return getPrefersRtlDirectionFn()
        }
    }

    func getStatusBarDimensions() -> Dimensions {
        return Dimensions(width: 0, height: 0)
    }

    func getPixelRatio() -> Double {
        func getPixelRatioFn() -> Double {
            if let backingScaleFactor = getMainWindow()?.backingScaleFactor {
                return Double(backingScaleFactor)
            }

            return self.miniRuntime?.pixelRatio ?? 1
        }

        if Thread.isMainThread {
            return getPixelRatioFn()
        }

        return DispatchQueue.main.sync {
            return getPixelRatioFn()
        }
    }

    func setRootViewBackgroundColor(color: Double) throws {
        DispatchQueue.main.async {
            guard let contentView = self.getMainWindow()?.contentView else {
                print("🦄 Unistyles: Couldn't set rootView backgroundColor")

                return
            }

            contentView.wantsLayer = true
            contentView.layer?.backgroundColor = NSColor.fromInt(Int(color)).cgColor
        }
    }

    func getNavigationBarDimensions() -> Dimensions {
        return Dimensions(width: 0, height: 0)
    }

    func setStatusBarHidden(isHidden: Bool) throws {}

    func setNavigationBarHidden(isHidden: Bool) throws {}

    func setImmersiveMode(isEnabled: Bool) throws {}
}

#endif
