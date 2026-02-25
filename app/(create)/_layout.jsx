import { StyleSheet, Text, useColorScheme, View, TouchableOpacity } from 'react-native'
import { Stack, useRouter } from 'expo-router'
import React from 'react'
import { StatusBar } from 'expo-status-bar'
import { colors } from "../../constants/colors"


const _layout = () => {
    const colorScheme = useColorScheme()
    const theme = colors[colorScheme] ?? colors.light
    const router = useRouter();

    return (
        <Stack screenOptions={{ headerStyle: { backgroundColor: '#0D0D0D' }, headerTintColor: '#666666', headerShadowVisible: false, headerBackTitleVisible: false, }}>

            <Stack.Screen name="recovery" 
            options={{ 
                title: '', 
            }} />

            <Stack.Screen name="confirm" 
            options={{ 
                title: '', 
            }} 
            />
            <Stack.Screen name="nameWallet" options={{ title: '', }} />
            <Stack.Screen name="protectWallet" options={{ title: '', }} />
            <Stack.Screen name="success" options={{ title: '', }} />
            <Stack.Screen name="setPin" options={{ headerShown: false, }} />
            

        </Stack>

    )
}

export default _layout

const styles = StyleSheet.create({
    next: {
        backgroundColor: "#1C1C1C",
        paddingHorizontal: 9,
        paddingVertical: 4,
        borderRadius: 999,
    }

})