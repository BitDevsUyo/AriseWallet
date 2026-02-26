import { StyleSheet } from 'react-native';
const styles = StyleSheet.create({

    container: {
        flex: 1,
        backgroundColor: '#0D0D0D',
        alignItems: 'center',
        justifyContent: 'center',
        paddingVertical: 40,
    },

    layout: {
        width: 337,
        height: 642,
        justifyContent: 'space-between',
        position: 'absolute',
        // top: 111,
        left: 19,
    },

    innerContainer: {
        width: 337,
        height: 471,
        paddingTop: 25,
        gap: 52,
    },

    heroImg: {
        width: 147,
        height: 211,
        opacity: 0.9,
        resizeMode: 'contain',
    },

    textContent: {
        width: 337,
        height: 75,
        gap: 8,
    },

    primaryText: {
        fontFamily: 'SF Pro Rounded',
        fontWeight: '500',
        fontStyle: 'normal',
        fontSize: 24,
        lineHeight: 24,
        letterSpacing: 0,
        color: '#fff',
    },

    secondaryText: {
        fontFamily: 'SF Pro Rounded',
        fontWeight: '400',
        fontStyle: 'normal',
        fontSize: 16,
        lineHeight: 24,
        letterSpacing: 0,
        color: '#666666',
    },

    biometrics: {
        width: 337,
        height: 56,
        flexDirection: 'row',
        justifyContent: 'space-between',
        opacity: 1,
        borderRadius: 16,
        padding: 16,
        backgroundColor: '#1C1C1C',
    },

    enable: {
        width: 145,
        height: 24,
        gap: 10,
        flexDirection: 'row',
    },

    scanImg: {
        width: 24,
        height: 24,
    },

    biometricText: {
        fontFamily: 'SF Pro Rounded',
        fontWeight: '600',
        fontSize: 16,
        lineHeight: 24,
        color: '#fff',

    },

    switch: {
        transform: [{ scaleX: 1.2 }, { scaleY: 1.2 }], // adjust size
    },

    primaryButton: {
        width: 337,
        height: 49,
        gap: 12,
        backgroundColor: '#FF6B00',
        borderRadius: 9999,
        opacity: 1,
        justifyContent: 'center',
        alignItems: 'center',
        paddingTop: 16,
        paddingBottom: 16,
    },

    primaryButtonText: {
        fontFamily: 'SF Pro Rounded',
        fontWeight: '600',
        fontSize: 14,
        lineHeight: 24,
        color: '#fff',
    },

});

export default styles;