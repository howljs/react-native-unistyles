import React, { useEffect } from 'react'
import { Pressable, Text, View } from 'react-native'
import Animated, {
    useAnimatedStyle,
    useSharedValue,
    withRepeat,
    withTiming
} from 'react-native-reanimated'
import { StyleSheet, UnistylesRuntime, useUnistyles } from 'react-native-unistyles'

import './unistyles'

export const App = () => {
    const { rt } = useUnistyles()
    const progress = useSharedValue(0)

    styles.useVariants({
        size: 'large'
    })

    useEffect(() => {
        progress.value = withRepeat(withTiming(1, { duration: 800 }), -1, true)
    }, [progress])

    const animatedStyle = useAnimatedStyle(() => ({
        transform: [{ translateX: progress.value * 48 }]
    }))

    return (
        <View style={styles.screen}>
            <View testID="static-style" style={styles.card}>
                <Text style={styles.title}>Unistyles on macOS</Text>
                <Text testID="theme-value" style={styles.value}>
                    Theme: {rt.themeName ?? rt.colorScheme}
                </Text>
                <Text testID="breakpoint-value" style={styles.value}>
                    Breakpoint: {rt.breakpoint ?? 'compact'}
                </Text>
                <Text testID="screen-value" style={styles.value}>
                    Screen: {Math.round(rt.screen.width)} × {Math.round(rt.screen.height)}
                </Text>
                <Text testID="orientation-value" style={styles.value}>
                    Orientation: {rt.isLandscape ? 'landscape' : 'portrait'}
                </Text>
                <Text testID="pixel-ratio-value" style={styles.value}>
                    Pixel ratio: {rt.pixelRatio.toFixed(2)}
                </Text>
                <Text testID="font-scale-value" style={styles.value}>
                    Font scale: {rt.fontScale.toFixed(2)}
                </Text>
                <Text testID="insets-value" style={styles.value}>
                    Insets: {rt.insets.top.toFixed(0)}, {rt.insets.right.toFixed(0)}, {rt.insets.bottom.toFixed(0)},{' '}
                    {rt.insets.left.toFixed(0)}
                </Text>
                <View testID="variant-style" style={styles.variant}>
                    <Text style={styles.variantText}>Large variant</Text>
                </View>
                <Animated.View style={[styles.animated, animatedStyle]} />
                <View style={styles.actions}>
                    <Pressable style={styles.button} onPress={() => UnistylesRuntime.setTheme('light')}>
                        <Text style={styles.buttonText}>Light</Text>
                    </Pressable>
                    <Pressable style={styles.button} onPress={() => UnistylesRuntime.setTheme('dark')}>
                        <Text style={styles.buttonText}>Dark</Text>
                    </Pressable>
                </View>
            </View>
        </View>
    )
}

const styles = StyleSheet.create(theme => ({
    screen: {
        flex: 1,
        alignItems: 'center',
        justifyContent: 'center',
        padding: 32,
        backgroundColor: theme.colors.background
    },
    card: {
        width: {
            compact: '100%',
            regular: 560
        },
        gap: 16,
        padding: 24,
        borderRadius: 16,
        backgroundColor: theme.colors.surface
    },
    title: {
        color: theme.colors.text,
        fontSize: 24,
        fontWeight: '600'
    },
    value: {
        color: theme.colors.text,
        fontSize: 16
    },
    variant: {
        alignSelf: 'flex-start',
        borderRadius: 8,
        backgroundColor: theme.colors.accent,
        variants: {
            size: {
                large: {
                    paddingHorizontal: 20,
                    paddingVertical: 12
                }
            }
        }
    },
    variantText: {
        color: '#ffffff',
        fontWeight: '600'
    },
    animated: {
        width: 32,
        height: 8,
        borderRadius: 4,
        backgroundColor: theme.colors.accent
    },
    actions: {
        flexDirection: 'row',
        gap: 12
    },
    button: {
        paddingHorizontal: 16,
        paddingVertical: 10,
        borderRadius: 8,
        backgroundColor: theme.colors.accent
    },
    buttonText: {
        color: '#ffffff'
    }
}))
