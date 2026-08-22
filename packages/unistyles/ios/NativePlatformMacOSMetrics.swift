#if os(macOS)

import Foundation

enum MacOSRuntimeMetrics {
    static func fontScale(systemFontSize: CGFloat, defaultFontSize: CGFloat) -> Double {
        guard systemFontSize > 0, defaultFontSize > 0 else {
            return 1
        }

        return Double(systemFontSize / defaultFontSize)
    }
}

#endif
