import { StyleSheet } from 'react-native';
import {spacing, colors, radii} from '../../src/theme'
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
        paddingHorizontal: 12,
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

     modalOverlay: {
        flex: 1,
        backgroundColor: 'rgba(10, 10, 10, 0.95)',
        justifyContent: 'center',
        paddingHorizontal: spacing.xl,
      },
      modalContent: {
        alignItems: 'flex-start',
      },
      modalText: {
        color: colors.text.primary,
        fontSize: 26,
        fontWeight: '600',
        marginBottom: spacing.xs,
      },
      modalSubText: {
        color: colors.text.midgrey,
        fontSize: 16,
        lineHeight: 24,
      },
    
      spinnerContainer: {
        width: 64,
        height: 64,
        justifyContent: 'center',
        alignItems: 'center',
        marginBottom: spacing.xl,
      },
      iconCenter: {
        position: 'absolute',
        justifyContent: 'center',
        alignItems: 'center',
        zIndex: 1,
      },
      thinSpinner: {
        position: 'absolute',
        width: 64,
        height: 64,
        borderRadius: 32,
        borderWidth: 1,
        borderColor: 'rgba(255, 255, 255, 0.15)',
        borderTopColor: '#ffffff',
        zIndex: 2,
      },

});

export default styles;