import { StyleSheet, Text, View, Image, TouchableOpacity, Switch } from 'react-native';
import * as LocalAuthentication from 'expo-local-authentication';
import * as SecureStore from 'expo-secure-store';
import { useRouter } from 'expo-router';
import React, { useState } from 'react';

const success = () => {
    const router = useRouter();
    const [isEnabled, setIsEnabled] = useState(false);

    return (
        <View style={styles.container}>

            <View style={styles.layout}>

                <View style={styles.innerContainer}>
                    <Image source={require('../assets/check.png')} style={styles.heroImg} />

                    <View style={styles.textContent}>
                        <Text style={styles.primaryText}>Your Wallet Is Ready!</Text>
                        <Text style={styles.secondaryText}>You’ve successfully created a new wallet.
                            Ready to enjoy secure, easy transactions?.</Text>
                    </View>


                    {/* <View style={styles.choiceBox}>
                        <View style={styles.biometrics}>
                            <View style={styles.enable}>
                                <Image source={require('../assets/scan-face.png')} style={styles.scanImg} />
                                <Text style={styles.biometricText}>Enable biometrics</Text>
                                {/* {isEnabled ? "On" : "Off"} */}
                            {/* </View>

                            <Switch
                                trackColor={{ false: "#767577", true: "#4cd964" }}
                                thumbColor={isEnabled ? "#fff" : "#f4f3f4"}
                                ios_backgroundColor="#3e3e3e"
                                onValueChange={toggleSwitch}
                                value={isEnabled}
                                style={styles.switch}
                            />

                        </View>

                        <View style={styles.biometrics}>
                            <View style={styles.enable}>
                                <Image source={require('../assets/password.png')} style={styles.scanImg} />
                                <Text style={styles.biometricText}>Continue with passcode</Text>
                                {/* {isEnabled ? "On" : "Off"} */}
                            {/* </View>

                            <Switch
                                trackColor={{ false: "#767577", true: "#4cd964" }}
                                thumbColor={isEnabled ? "#fff" : "#f4f3f4"}
                                ios_backgroundColor="#3e3e3e"
                                onValueChange={toggleSwitch}
                                value={isEnabled}
                                style={styles.switch}
                            />

                        </View>
                    </View>  */}

                </View>

                <TouchableOpacity
                    style={styles.primaryButton}
                    onPress={() => router.push('/#')}
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
        backgroundColor: '#0D0D0D',
        alignItems: 'center',
        justifyContent: 'center',
    },

    layout: {
        width: 337,
        height: 642,
        justifyContent: 'space-between',
        position: 'absolute',
        left: 19,
    },

    innerContainer: {
        width: 337,
        height: 471,
        paddingTop: 25,
    },

    heroImg: {
        width: 147,
        height: 211,
        opacity: 0.9,
        resizeMode: 'contain',
    },

    textContent: {
        width: 337,
        height: 75,
        gap: 8,
    },

    primaryText: {
        fontFamily: 'SF Pro Rounded',
        fontWeight: '500',
        fontStyle: 'normal',
        fontSize: 24,
        lineHeight: 24,
        letterSpacing: 0,
        color: '#fff',
    },

    secondaryText: {
        fontFamily: 'SF Pro Rounded',
        fontWeight: '400',
        fontStyle: 'normal',
        fontSize: 16,
        lineHeight: 24,
        letterSpacing: 0,
        color: '#666666',
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

})