import { StyleSheet } from 'react-native';
const styles = StyleSheet.create({
    container: {
        backgroundColor: '#0D0D0D',
        flex: 1,
        alignItems: 'center',
        justifyContent: 'center',
        paddingVertical: 40,
    },

    layout: {
        width: 337,
        height: 652,
        justifyContent: 'space-between',
        position: 'absolute',
        // top: 111,
        left: 19,
    },

    textLayout: {
        width: 337,
        height: 222,
        gap: 44,
    },

    recoveryText: {
        width: 337,
        height: 75,
        gap: 8,
    },

    title: {
        color: '#fff',
        fontSize: 24,
        fontWeight: 500,
        fontFamily: "SF Pro Rounded",
    },

    subTitle: {
        color: '#666666',
        fontSize: 16,
        fontWeight: 400,
        fontFamily: "SF Pro Rounded",
    },

    input: {
        width: 337,
        height: 103,
        backgroundColor: '#1C1C1C',
        borderRadius: 16,
        padding: 12,
    },

    inputText: {
        color: '#fff',
        fontSize: 16,
        fontWeight: 400,
        fontFamily: "SF Pro Rounded",
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
        color: '#fff',
    },

});

export default styles;