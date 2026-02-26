import { TouchableOpacity, Text, View, Image } from 'react-native'
import React from 'react'
import { Link } from 'expo-router'
import styles from './styles/recoveryStyles';
import { useState } from 'react'


const recovery = () => {
    return (
        <View style={styles.container}>

            <View style={styles.layout}>

                <View style={styles.innerLayout}>

                    <View style={styles.textContent}>
                        <Text style={styles.primaryText}>Recovery Phrase</Text>
                        <Text style={styles.secondaryText}>This is the only way you will be able to recover your account. Please store it somewhere <Text style={styles.innerText}>safe!</Text> </Text>

                    </View>

                    <View style={styles.seedPhraseLayout}>

                        <View style={styles.seedPhrases}>
                            <SeedPhrase number="1" phrase="" />
                            <SeedPhrase number="2" phrase="" />
                            <SeedPhrase number="3" phrase="" />
                            <SeedPhrase number="4" phrase="" />
                            <SeedPhrase number="5" phrase="" />
                            <SeedPhrase number="6" phrase="" />
                            <SeedPhrase number="7" phrase="" />
                            <SeedPhrase number="8" phrase="" />
                            <SeedPhrase number="9" phrase="" />
                            <SeedPhrase number="10" phrase="" />
                            <SeedPhrase number="11" phrase="" />
                            <SeedPhrase number="12" phrase="" />

                        </View>

                        <TouchableOpacity style={styles.copyButton}>
                            <Image source={require('./assets/copy.png')} style={styles.copyImg} />
                            <Link href="" style={styles.copyText}>Copy to clipboard</Link>
                        </TouchableOpacity>

                    </View>

                </View>

                <TouchableOpacity style={styles.primaryButton}>
                    <Link href="#" style={styles.primaryButtonText}>I’ve saved it somewhere</Link>
                </TouchableOpacity>

            </View>

        </View>
    )
}

const SeedPhrase = ({ number, phrase }) => (
    <View style={styles.seedPhraseBox}>
        <Text style={styles.seedPhraseNumber}>{number}</Text>
        <Text style={styles.seedPhraseText}>{phrase}</Text>
    </View>
);

export default recovery
