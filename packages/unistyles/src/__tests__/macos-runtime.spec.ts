const mockSetImmersiveModeNative = jest.fn()

const mockStatusBar = {
    setHiddenNative: jest.fn(),
}

const mockRuntime = {
    createHybridStatusBar: jest.fn(() => mockStatusBar),
    createHybridNavigationBar: jest.fn(() => ({})),
    nativeSetRootViewBackgroundColor: jest.fn(),
    setImmersiveModeNative: mockSetImmersiveModeNative,
}

jest.mock('react-native', () => ({
    Platform: { OS: 'macos' },
    StatusBar: {
        setBarStyle: jest.fn(),
        setHidden: jest.fn(),
    },
    processColor: jest.fn(() => 0),
}))

jest.mock('react-native-nitro-modules', () => ({
    NitroModules: {
        createHybridObject: jest.fn(() => mockRuntime),
    },
}))

describe('UnistylesRuntime on macOS', () => {
    it('routes immersive mode through the native macOS implementation', () => {
        const { Runtime } = require('../specs/UnistylesRuntime') as typeof import('../specs/UnistylesRuntime')

        Runtime.setImmersiveMode(true)

        expect(mockSetImmersiveModeNative).toHaveBeenCalledWith(true)
    })
})
