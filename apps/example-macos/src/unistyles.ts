import { StyleSheet } from 'react-native-unistyles'

const lightTheme = {
    colors: {
        background: '#f4f5f7',
        surface: '#ffffff',
        text: '#15171a',
        accent: '#6c5ce7'
    }
}

const darkTheme = {
    colors: {
        background: '#16181c',
        surface: '#24272d',
        text: '#f5f6f8',
        accent: '#a29bfe'
    }
}

const breakpoints = {
    compact: 0,
    regular: 640
}

type AppBreakpoints = typeof breakpoints
type AppThemes = {
    light: typeof lightTheme
    dark: typeof darkTheme
}

declare module 'react-native-unistyles' {
    export interface UnistylesThemes extends AppThemes {}
    export interface UnistylesBreakpoints extends AppBreakpoints {}
}

StyleSheet.configure({
    settings: {
        initialTheme: 'light'
    },
    breakpoints,
    themes: {
        light: lightTheme,
        dark: darkTheme
    }
})
