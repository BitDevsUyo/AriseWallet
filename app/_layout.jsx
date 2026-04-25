import { StyleSheet, Text, useColorScheme, View, TouchableOpacity } from 'react-native'
import { Stack,  } from 'expo-router'
import React, { useEffect, useState } from 'react'
import { StatusBar } from 'expo-status-bar'
import { colors } from "../constants/colors"
import Toast from 'react-native-toast-message';
import { useWalletStore } from '../src/store/walletStore';


const _layout = () => {
    const colorScheme = useColorScheme()
    const theme = colors[colorScheme] ?? colors.light

    const rehydrateWallet = useWalletStore((state) => state.rehydrateWallet);
    const [isAppReady, setIsAppReady] = useState(false);

    useEffect(() => {
        const initApp = async () => {
            await rehydrateWallet();
            setIsAppReady(true);
        };

        initApp();
    }, []);

    if (!isAppReady) {
        return <View style={{ flex: 1, backgroundColor: '#0D0D0D' }} />;
    }

    return (
        <>
            <Stack screenOptions={{ headerStyle: { backgroundColor: '#0D0D0D' }, headerTintColor: '#666666' }}>

                <Stack.Screen name="index" options={{ headerShown: false, }} />
                <Stack.Screen name="welcome" options={{ headerShown: false, }} />
                <Stack.Screen name="receive" options={{ headerShown: false }} />
                <Stack.Screen name="(create)" options={{ headerShown: false }} />
                <Stack.Screen name="(import)" options={{ headerShown: false }} />
                <Stack.Screen name="(tabs)" options={{ headerShown: false }} />

            </Stack>
            <Toast />
        </>

    )
}

export default _layout

const styles = StyleSheet.create({
    next: {
        backgroundColor: "#0D0D0D",
        paddingHorizontal: 9,
        paddingVertical: 4,
        borderRadius: 999,
    }

})