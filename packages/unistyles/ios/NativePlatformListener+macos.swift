#if os(macOS)

import AppKit
import Combine

extension NativeMacOSPlatform {
    func setupPlatformListeners() {
        let windowPublisher = NotificationCenter.default.publisher(for: NSNotification.Name("RCTWindowFrameDidChangeNotification"))
        let colorSchemePublisher = NotificationCenter.default.publisher(for: NSNotification.Name("RCTUserInterfaceStyleDidChangeNotification"))
        let resizePublisher = NotificationCenter.default.publisher(for: NSWindow.didResizeNotification)
        let keyWindowPublisher = NotificationCenter.default.publisher(for: NSWindow.didBecomeKeyNotification)
        let screenPublisher = NotificationCenter.default.publisher(for: NSWindow.didChangeScreenNotification)
        let backingPropertiesPublisher = NotificationCenter.default.publisher(for: NSWindow.didChangeBackingPropertiesNotification)
        let enterFullScreenPublisher = NotificationCenter.default.publisher(for: NSWindow.didEnterFullScreenNotification)
        let exitFullScreenPublisher = NotificationCenter.default.publisher(for: NSWindow.didExitFullScreenNotification)
        let screenParametersPublisher = NotificationCenter.default.publisher(for: NSApplication.didChangeScreenParametersNotification)

        Publishers
            .MergeMany([
                windowPublisher,
                colorSchemePublisher,
                resizePublisher,
                keyWindowPublisher,
                screenPublisher,
                backingPropertiesPublisher,
                enterFullScreenPublisher,
                exitFullScreenPublisher,
                screenParametersPublisher
            ])
            .throttle(for: .milliseconds(25), scheduler: RunLoop.main, latest: true)
            .sink { [weak self] _ in
                self?.onNativePlatformChange()
            }
            .store(in: &cancellables)
    }

    func removePlatformListeners() {
        self.unregisterPlatformListeners()
    }

    func registerPlatformListener(callback: @escaping (CxxDependencyListener)) throws {
        self.dependencyListeners.append(callback)
    }

    func registerImeListener(callback: @escaping ((UnistylesNativeMiniRuntime) -> Void)) throws {
        self.imeListeners.append(callback)
    }

    func emitCxxEvent(dependencies: Array<UnistyleDependency>, updatedMiniRuntime: UnistylesNativeMiniRuntime) {
        self.dependencyListeners.forEach { $0(dependencies, updatedMiniRuntime) }
    }

    func emitImeEvent(updatedMiniRuntime: UnistylesNativeMiniRuntime) {
        self.imeListeners.forEach { $0(updatedMiniRuntime) }
    }

    func unregisterPlatformListeners() {
        cancellables.removeAll()
        dependencyListeners.removeAll()
        imeListeners.removeAll()
    }

    @objc func onNativePlatformChange() {
        guard let currentMiniRuntime = self.miniRuntime else {
            return
        }

        let newMiniRuntime = self.buildMiniRuntime()
        let changedDependencies = UnistylesNativeMiniRuntime.diff(lhs: currentMiniRuntime, rhs: newMiniRuntime)

        if (changedDependencies.count > 0) {
            self.miniRuntime = newMiniRuntime
            self.emitCxxEvent(dependencies: changedDependencies, updatedMiniRuntime: newMiniRuntime)
        }
    }
}

#endif
