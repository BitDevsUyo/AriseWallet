import { StyleSheet, Text, View, Image, TouchableOpacity, Switch, Modal } from 'react-native';
import * as LocalAuthentication from 'expo-local-authentication';
import * as SecureStore from 'expo-secure-store';
import { useRouter } from 'expo-router';
import React, { useState } from 'react';
import styles from '../styles/secureStyles';

const protectWallet = () => {
    const router = useRouter();
    const [isEnabled, setIsEnabled] = useState(false);
    const [isPassCode, setIsPassCode] = useState(false);

    const [isOpen, setIsOpen] = useState(false);
    const [isFinger, setIsFinger] = useState(false);
    const [isFace, setIsFace] = useState(false);

    const toggleSwitch = () => {
        setIsEnabled(previousState => {
            const newState = !previousState;
            if (newState) {
                setIsOpen(true);
            }
            return newState;
        });
    }


    const togglePassCode = () => setIsPassCode(previousState => !previousState);
    const toggleFaceId = () => setIsFace(previousState => !previousState);
    const toggleFingerPrint = () => setIsFinger(previousState => !previousState);

    return (
        <View style={styles.container}>

            <View style={styles.layout}>

                <View style={styles.innerContainer}>
                    <Image source={require('../assets/lock.png')} style={styles.heroImg} />

                    <View style={styles.textContent}>
                        <Text style={styles.primaryText}>Protect your wallet</Text>
                        <Text style={styles.secondaryText}>Choose an authentication method for wallet security and easy log in </Text>
                    </View>


                    <View style={styles.choiceBox}>
                        <View style={styles.biometrics}>
                            <View style={styles.enable}>
                                <Image source={require('../assets/scan-face.png')} style={styles.scanImg} />
                                <Text style={styles.biometricText}>Enable biometrics</Text>
                                {/* {isEnabled ? "On" : "Off"} */}
                            </View>

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
                            </View>

                            <Switch
                                trackColor={{ false: "#767577", true: "#4cd964" }}
                                thumbColor={isPassCode ? "#fff" : "#f4f3f4"}
                                ios_backgroundColor="#3e3e3e"
                                onValueChange={togglePassCode}
                                value={isPassCode}
                                style={styles.switch}
                            />

                        </View>
                    </View>

                </View>

                <TouchableOpacity
                    style={styles.primaryButton}
                    onPress={() => router.push('/success')}
                >
                    <Text style={styles.primaryButtonText}>Proceed</Text>
                </TouchableOpacity>

            </View>

            <Modal
                animationType="slide"
                transparent={true}
                visible={isOpen}
                onRequestClose={() => {
                    setIsOpen(false);
                    if (!isFace && !isFinger) setIsEnabled(false);
                }}
            >
                <View style={styles.modalOverlay}>
                    <View style={styles.modalContent}>

                        <TouchableOpacity
                            style={styles.closeButton}
                            onPress={() => {
                                setIsOpen(false);
                                if (!isFace && !isFinger) setIsEnabled(false);
                            }}
                        >
                            <Text style={styles.closeButtonText}>✕</Text>
                        </TouchableOpacity>

                        <View style={styles.modalChoiceBox}>
                            <View style={styles.modalBiometricsRow}>
                                <View style={styles.enable}>
                                    <Image source={require('../assets/scan-face.png')} style={styles.scanImg} />
                                    <Text style={styles.biometricText}>Face ID</Text>
                                </View>
                                <Switch
                                    trackColor={{ false: "#767577", true: "#4cd964" }}
                                    thumbColor={isFace ? "#fff" : "#f4f3f4"}
                                    ios_backgroundColor="#3e3e3e"
                                    onValueChange={toggleFaceId}
                                    value={isFace}
                                    style={styles.switch}
                                />
                            </View>

                            <View style={styles.modalBiometricsRow}>
                                <View style={styles.enable}>
                                    <Image source={require('../assets/finger-scan.png')} style={styles.scanImg} />
                                    <Text style={styles.biometricText}>Finger Print</Text>
                                </View>
                                <Switch
                                    trackColor={{ false: "#767577", true: "#4cd964" }}
                                    thumbColor={isFinger ? "#fff" : "#f4f3f4"}
                                    ios_backgroundColor="#3e3e3e"
                                    onValueChange={toggleFingerPrint}
                                    value={isFinger}
                                    style={styles.switch}
                                />
                            </View>
                        </View>

                    </View>
                </View>
            </Modal>

        </View>
    )
}

export default protectWallet