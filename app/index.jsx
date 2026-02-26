import { Text, View, TouchableOpacity, ImageBackground, Alert } from 'react-native'
import { Link, useRouter } from 'expo-router';
import styles from './styles/homeStyles';
import React, { useState } from 'react';
import { createWallet } from './src/utils/wallet';
import 'react-native-get-random-values';



const Home = () => {

    return (
        <View style={styles.container}>

            <View style={styles.topContainer}>
                <ImageBackground
                    source={require('./assets/background.png')}
                    style={styles.background}
                    resizeMode="cover">
                    <View style={styles.overlay} />
                </ImageBackground>
            </View>
            <View style={styles.contentWrapper}>
                <Text style={styles.contentText}>
                    Secure. Simple. Bitcoin <Text style={styles.innerText}>made easy.</Text>
                </Text>
            </View>


            <View style={styles.bottomLayout}>
                <Text style={styles.bottomText}>
                    By tapping any button you agree and consent to our <Text style={styles.inner}>Terms of Services</Text> and <Text style={styles.inner}>Privacy Policy.</Text>
                </Text>

                <TouchableOpacity style={styles.primaryButton}>
                    <Link href="/secure" style={styles.primaryButtonText}>Create new wallet</Link>
                </TouchableOpacity>

                {/* <TouchableOpacity
                    style={styles.primaryButton}
                    onPress={handleCreateWallet}
                    disabled={isCreating}
                >
                    <Text style={styles.primaryButtonText}>
                        {isCreating ? 'Creating Wallet...' : 'Create new wallet'}
                    </Text>
                </TouchableOpacity> */}

                <TouchableOpacity style={styles.secondaryButton}>
                    <Link href="/import" style={styles.secondaryButtonText}>Import existing wallet</Link>
                </TouchableOpacity>
            </View>


        </View>
    )
}

export default Home


