import { StyleSheet } from "react-native";

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
        height: 645,
        position: 'absolute',
        // top: 111,
        left: 19,
        gap: 83,
    },

    innerLayout: {
        width: 337,
        height: 513,
        gap: 44,
    },

    textContent: {
        width: 337,
        height: 75,
        gap: 8,
    },

    primaryText: {
        fontFamily: 'SF Pro Rounded',
        fontWeight: '500',
        fontSize: 24,
        lineHeight: 24,
        color: '#fff'
    },

    secondaryText: {
        fontFamily: 'SF Pro Rounded',
        fontWeight: '400',
        fontSize: 16,
        lineHeight: 24,
        color: '#666666'
    },

    innerText: {
        color: '#fff'
    },

    seedPhraseLayout: {
        width: 337,
        height: 394,
        gap: 28
    },

    seedPhrases: {
        flexDirection: 'row',
        flexWrap: 'wrap',
        width: 337,
        height: 335,
        gap: 19,
    },

    seedPhraseBox: {
        width: 159,
        height: 40,
        flexDirection: 'row',
        alignItems: 'center',
        borderRadius: 9999, // Full corner
        borderWidth: 1,
        borderColor: '#666666',
        opacity: 1,
        gap: 13,
        paddingHorizontal: 12,
        backgroundColor: 'transparent',
    },

    seedPhraseNumber: {
        width: 40,
        borderRightWidth: 1,
        gap: 10,
        paddingHorizontal: 12,
        paddingVertical: 12,
        color: '#666',
        borderColor: '#666666',
        fontWeight: '400',
    },

    seedPhraseText: {
        color: '#E0E0E0',
        fontWeight: '400',
    },

    copyButton: {
        flexDirection: 'row',
        width: 169,
        height: 31,
        borderRadius: 9999,
        paddingTop: 6,
        paddingBottom: 6,
        paddingRight: 12,
        paddingLeft: 12,
        gap: 10,
        backgroundColor: '#1C1C1C',
    },

    copyImg: {
        width: 19,
        height: 19,
    },

    copyText: {
        color: '#E0E0E0',
        fontSize: 16,
        fontWeight: '400',
        fontFamily: 'SF Pro Rounded',
        lineHeight: 24,
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