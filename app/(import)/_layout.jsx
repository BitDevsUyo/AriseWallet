import { StyleSheet, Text, useColorScheme, View, TouchableOpacity } from 'react-native'
import { Stack, useRouter } from 'expo-router'
import React from 'react'
import { StatusBar } from 'expo-status-bar'
import { colors } from "../../constants/colors"
import HeaderIndicator from "../../components/headerIndicator";


const _layout = () => {
    const colorScheme = useColorScheme()
    const theme = colors[colorScheme] ?? colors.light
    const router = useRouter();

    return (
        <Stack screenOptions={{ headerStyle: { backgroundColor: '#0D0D0D' }, headerTintColor: '#666666', headerShadowVisible: false, headerBackTitleVisible: false, }}>

            <Stack.Screen name="import" 
            options={{ 
                title: '', 
            }} />
            <Stack.Screen name="secure" 
            options={{
                title: '', 
                headerTitle: () =>  <View style={{ flex: 1, alignItems: "center", justifyContent: 'center' }}><HeaderIndicator active={1}/></View>, 
                headerRight: () => (
                    <TouchableOpacity style={styles.next} onPress={() => router.push("/recovery")} >
                        <Text style={{ color: "#fff", fontSize: 16 }}>Next</Text>
                    </TouchableOpacity>)
            }} />

            <Stack.Screen name='success' options={{title: '', }} />

            <Stack.Screen name="recovery" 
            options={{
                title: '', 
                headerTitle: () => <View style={{ flex: 1, alignItems: "center", justifyContent: 'center' }}><HeaderIndicator active={2}/></View>, 
                headerRight: () => (
                    <TouchableOpacity style={styles.next} onPress={() => router.push("/import")} >
                        <Text style={{ color: "#fff", fontSize: 16, alignItems: 'center' }}>Next</Text>
                    </TouchableOpacity>)
            }} />


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