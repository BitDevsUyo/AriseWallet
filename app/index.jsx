import { StyleSheet, Text, View, TouchableOpacity, ImageBackground, Image } from 'react-native'
import { Link } from 'expo-router'
import styles from './styles/homeStyles';
import React from 'react'


const Home = () => {
    return (
        <View style={styles.container}>

            <View style={styles.topContainer}>
                <ImageBackground
                    source={require('./assets/background.png')} // your image path
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
                    <Link href="" style={styles.primaryButtonText}>Create new wallet</Link>
                </TouchableOpacity>

                <TouchableOpacity style={styles.secondaryButton}>
                    <Link href="/about" style={styles.secondaryButtonText}>Import existing wallet</Link>
                </TouchableOpacity>
            </View>


        </View>
    )
}

export default Home

// {/* <Text style={styles.primaryButtonText}>Create new wallet</Text> */}
// {/* <Text style={styles.secondaryButtonText}>Import existing wallet</Text> */}


