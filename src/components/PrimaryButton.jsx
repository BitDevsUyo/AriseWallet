import { StyleSheet, TouchableOpacity, Text, View } from 'react-native'
import { colors, spacing, radii, layout } from '../theme'
import React from 'react'

const variantStyles = {
    primary: { backgroundColor: colors.accent.primary },
    grey: { backgroundColor: colors.background.darkgrey }
}

export function PrimaryButton({
    title,
    onPress,
    variant = 'primary',
    style,
    disabled
}) {

    const backgroundStyle = variantStyles[variant] || variantStyles.primary;

    return (
        <TouchableOpacity
            activeOpacity={1}
            onPress={onPress}
            disabled={disabled}
            style={[
                styles.button,
                backgroundStyle,
                disabled && styles.disabled,
                style, //External styling
            ]}>
            <Text style={styles.label}>{title}</Text>
        </TouchableOpacity>
    );
}


const styles = StyleSheet.create({

    button: {
        height: layout.buttonHeight,
        width: layout.buttonWidth,
        borderRadius: radii.buttonRadii,
        justifyContent: "center",
        alignItems: "center",
        paddingHorizontal: spacing.md,
    },
    label: {
        color: colors.text.primary,
        fontFamily: 'SF Pro Rounded',
        fontSize: 14,
        lineHeight: 24,
        fontWeight: '600',
    },
    disabled: {
        opacity: 1,
    },
});
