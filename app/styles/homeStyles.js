import { StyleSheet } from 'react-native';

const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: '#0D0D0D',
        alignItems: 'center',
        justifyContent: 'space-between',
        paddingHorizontal: 20,
        paddingVertical: 40,
    },

    background: {
        flex: 1,
        width: 484,
        height: 484,
        opacity: 0.4,
        justifyContent: 'center',
        alignItems: 'center',
    },

    // overlay: {
    //     ...StyleSheet.absoluteFillObject,
    //     backgroundColor: 'rgba(0,0,0,0.4)',
    // },

    contentWrapper: {
        position: 'absolute', 
        justifyContent: 'center',
        alignItems: 'center',
        width: '90%',
    },


    contentText: {
        width: 336,
        height: 96,
        top: 424,
        opacity: 1,

        fontStyle: 'SF Pro Rounded',
        fontWeight: '600',
        fontSize: 40,
        lineHeight: 40,
        letterSpacing: 0,
        color: '#fff',
        textAlign: 'left',
    },

    bottomLayout: {
        width: 336,
        height: 171,
        position: 'absolute',
        top: 584,
        left: 20,
        opacity: 1,
        flexDirection: 'column',
        justifyContent: 'space-between',
        gap: 27,
    },

    bottomText: {
        width: 300,
        height: 34,
        fontStyle: 'SF Pro Rounded',
        fontWeight: '400',
        fontSize: 14,
        // lineHeight: 14,
        letterSpacing: 0,
        textAlign: 'left',
        color: '#666666',
    },

    primaryButton: {
        width: 336,
        height: 49,
        backgroundColor: '#FF6B00',
        borderRadius: 9999,
        opacity: 1,
        justifyContent: 'center',
        alignItems: 'center',
        paddingTop: 16,
        paddingRight: 71,
        paddingBottom: 16,
        paddingLeft: 71,
    },
    primaryButtonText: {
        fontFamily: 'SF Pro Rounded',
        fontWeight: '600',
        fontSize: 16,
        color: '#fff',
    },

    secondaryButton: {
        width: 336,
        height: 49,
        backgroundColor: '#1C1C1C',
        borderRadius: 9999,
        opacity: 1,
        alignItems: 'center',
        paddingTop: 16,
        paddingRight: 71,
        paddingBottom: 16,
        paddingLeft: 71,
    },
    secondaryButtonText: {
        fontFamily: 'SF Pro Rounded',
        fontWeight: '600',
        fontSize: 16,
        color: '#fff',
    },

    innerText: {
        color: '#666',
    },

    inner: {
        color: '#fff',
    }

})

export default styles;
