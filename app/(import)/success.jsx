import { StyleSheet, Text, View, Image, TouchableOpacity, Switch } from 'react-native';
import { spacing, colors, radii } from '../../src/theme';
import { useRouter } from 'expo-router';
import React, { useState, useEffect } from 'react';

import { useWalletStore } from '../../src/store/walletStore';

const success = () => {
    const router = useRouter();

    const activeWallet = useWalletStore((state) => state.activeWallet);
    useEffect(() => {
        console.log("WALLET RECOVERY SUCCESS");
        console.log("Wallet ID:   ", activeWallet.id);
        console.log("Wallet Name: ", activeWallet.name);
        console.log("BTC Address: ", activeWallet.address);
        console.log("Balance:     ", activeWallet.balance, "sats");
    }, []);

    const [isEnabled, setIsEnabled] = useState(false);

    return (
        <View style={styles.container}>

            <View style={styles.layout}>

                <View style={styles.innerContainer}>
                    <Image source={require('../assets/check.png')} style={styles.heroImg} />

                    <View style={styles.textContent}>
                        <Text style={styles.primaryText}>Wallet Imported Successfully</Text>
                        <Text style={styles.secondaryText}>Your wallet has been restored and is ready to{'\n'} use.</Text>
                    </View>

                </View>

                <TouchableOpacity
                    style={styles.primaryButton}
                    onPress={() => router.replace('(tabs)')}
                >
                    <Text style={styles.primaryButtonText}>Get Started</Text>
                </TouchableOpacity>

            </View>

        </View>
    )
}

export default success

const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: colors.background.default,
        justifyContent: 'center',
        alignItems: 'center',
        paddingVertical: spacing.xl,
        paddingHorizontal: spacing.xl,
    },

    layout: {
        paddingTop: 80,
        gap: 230,
    },

    innerContainer: {
  
    },

    heroImg: {
        width: 147,
        height: 211,
        opacity: 0.9,
        resizeMode: 'contain',
    },

    textContent: {
        gap: 8,
    },

    primaryText: {
        fontFamily: 'SF Pro Rounded',
        fontWeight: '500',
        fontSize: 25,
        lineHeight: 24,
        letterSpacing: 0,
        color: '#fff',
    },

    secondaryText: {
        fontFamily: 'SF Pro Rounded',
        fontWeight: '400',
        fontSize: 16,
        lineHeight: 24,
        color: colors.text.midgrey,
    },

    primaryButton: {
        width: 337,
        height: 49,
        gap: 12,
        backgroundColor: colors.accent.primary,
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

})