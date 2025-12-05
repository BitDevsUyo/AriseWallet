import { TouchableOpacity, Text, View, Image } from 'react-native'
import React from 'react'
import { useRouter, useLocalSearchParams } from 'expo-router'
import styles from './styles/recoveryStyles';
import * as Clipboard from 'expo-clipboard';
import { NativeModules } from "react-native";
const { BdkRnModule } = NativeModules;


const recovery = () => {
    const router = useRouter();
    const { mnemonic } = useLocalSearchParams();
    const words = mnemonic ? mnemonic.split(" ") : [];

    const copyToClipboard = async () => {
        if (mnemonic) {
            await Clipboard.setStringAsync(mnemonic);
            alert("Recovery phrase copied!");
        }
    };

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
                            {words.map((word, index) => (
                                <SeedPhrase
                                    key={index}
                                    number={index + 1}
                                    phrase={word}
                                />
                            ))}
                        </View>

                        <TouchableOpacity style={styles.copyButton} onPress={copyToClipboard}>
                            <Image source={require('./assets/copy.png')} style={styles.copyImg} />
                            <Text style={styles.copyText}>Copy to clipboard</Text>
                        </TouchableOpacity>

                    </View>

                </View>

                <TouchableOpacity
                    style={styles.primaryButton}
                    onPress={() => router.push("/#")}
                >
                    <Text style={styles.primaryButtonText}>I’ve saved it somewhere</Text>
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
