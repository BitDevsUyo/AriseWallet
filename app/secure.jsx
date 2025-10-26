import { StyleSheet, Text, View, Image, TouchableOpacity, Switch } from 'react-native'
import { Link } from 'expo-router'
import React, { useState } from 'react'
import styles from './styles/secureStyles'

const secure = () => {

    const [isEnabled, setIsEnabled] = useState(false);

    // Function to toggle the switch
    const toggleSwitch = () => setIsEnabled(previousState => !previousState);

    return (
        <View style={styles.container}>

            <View style={styles.layout}>

                <View style={styles.innerContainer}>
                    <Image source={require('./assets/lock.png')} style={styles.heroImg} />

                    <View style={styles.textContent}>
                        <Text style={styles.primaryText}>Protect your wallet</Text>
                        <Text style={styles.secondaryText}>Adding biometric security to your  will ensure that your wallet is accessible by only you.</Text>
                    </View>

                    <View style={styles.biometrics}>
                        <View style={styles.enable}>
                            <Image source={require('./assets/scan-face.png')} style={styles.scanImg} />
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

                </View>

                <TouchableOpacity style={styles.primaryButton}>
                    <Link href="/recovery" style={styles.primaryButtonText}>Proceed</Link>
                </TouchableOpacity>

            </View>

        </View>
    )
}

export default secure