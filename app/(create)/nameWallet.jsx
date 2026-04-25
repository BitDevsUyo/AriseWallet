import { StyleSheet, Text, View, TextInput } from 'react-native'
import { colors, spacing, layout, radii } from '../../src/theme'
import { PrimaryButton } from '../../src/components/PrimaryButton'
import { Link, useRouter } from 'expo-router';
import React, { useState } from 'react'

import { useWalletStore } from '../../src/store/walletStore';

const nameWallet = () => {
    const router = useRouter();
    const [walletName, setWalletName] = useState('');
    const updateOnboarding = useWalletStore((state) => state.updateOnboarding);

    const handleProceed = () => {
        if (walletName.trim() === '') return;
        
        updateOnboarding('name', walletName.trim());
        
        router.push("/setPin");
    };

    return (
        <View style={styles.container}>

            <View style={styles.nameContainer}>
                <View style={styles.nameText}>
                    <Text style={styles.headText}>Name Your Wallet</Text>
                    <Text style={styles.subText}>This helps you manage multiple wallets easily.</Text>
                </View>

                <View style={styles.input}>
                    <TextInput 
                        style={styles.inputText} 
                        placeholder="Enter Wallet Name" 
                        placeholderTextColor="#666666" 
                        value={walletName} 
                        onChangeText={setWalletName} 
                        autoFocus={true} 
                    />
                </View>
            </View>

            <PrimaryButton
                title={"Proceed"}
                onPress={handleProceed}
                disabled={walletName.trim() === ''}
            />

        </View>
    )
}

export default nameWallet

const styles = StyleSheet.create({
    container: {
        flex: 1,
        paddingHorizontal: spacing.lg,
        paddingVertical: spacing.xl,
        backgroundColor: colors.background.default,
        justifyContent: 'space-between',
        alignItems: 'center',
        // gap: spacing.xl
    },
    nameContainer: {
        gap: spacing.xl,
        paddingBottom: layout.topNavHeight  * 3.5
    },
    nameText: {
        gap: spacing.xs
    },
    headText: {
        color: colors.text.primary,
        fontSize: 24,
        fontWeight: '500',
        lineHeight: 24,
    },
    subText: {
        fontSize: 16,
        fontWeight: '400',
        lineHeight: 24,
        color: colors.text.midgrey,
    },
    input: {
        width: layout.buttonWidth,
        height: layout.buttonHeight,
        backgroundColor: colors.background.darkgrey,
        borderRadius: radii.buttonRadii,
        paddingHorizontal: 12,
        justifyContent: 'center'
    },
    inputText: {
        color: '#fff',
        fontSize: 16,
        fontWeight: 400,
        fontFamily: "SF Pro Rounded",
    },
})