import { StyleSheet, Text, useColorScheme, View } from 'react-native'
import { Stack } from 'expo-router'
import React from 'react'
import { StatusBar } from 'expo-status-bar'
import { colors } from "../constants/colors"

const _layout = () => {
    const colorScheme = useColorScheme()
    const theme = colors[colorScheme] ?? colors.light

    return (
            <Stack screenOptions={{ headerStyle: { backgroundColor: '#0D0D0D' }, headerTintColor: '#666666' }}>

                <Stack.Screen name="index" options={{ headerShown: false, }} />
                <Stack.Screen name="secure" options={{ title: '' }} />
                <Stack.Screen name="recovery" options={{ title: '' }} />
                <Stack.Screen name="import" options={{ title: '' }} />

            </Stack>

    )
}

export default _layout

const styles = StyleSheet.create({

})