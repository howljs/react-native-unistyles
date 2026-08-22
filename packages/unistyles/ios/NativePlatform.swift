import Foundation

typealias CxxDependencyListener = (Array<UnistyleDependency>, UnistylesNativeMiniRuntime) -> Void
typealias CxxImeListener = (UnistylesNativeMiniRuntime) -> Void

public class NativePlatform {
    public static func create() -> HybridNativePlatformSpec_cxx {
        #if os(iOS)
        let nativePlatform = NativeIOSPlatform()
        #elseif os(macOS)
        let nativePlatform = NativeMacOSPlatform()
        #else
        fatalError("Unistyles does not support this Apple platform")
        #endif

        return HybridNativePlatformSpec_cxx(nativePlatform);
    }
}
