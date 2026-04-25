import { TouchableOpacity, Text, View, Image } from 'react-native'
import React, { useEffect, useState } from 'react'
import { useRouter } from 'expo-router'
import styles from '../styles/recoveryStyles';
import * as Clipboard from 'expo-clipboard';

import {useWalletStore} from '../../src/store/walletStore'



const recovery = () => {
    const router = useRouter();
    const [copy, setCopied] = useState('Copy to clipboard');

    const mnemonic = useWalletStore((state)=> state.onboarding.mnemonic);
    const words = mnemonic ? mnemonic.split(" ") : [];
    console.log(mnemonic)


    const copyToClipboard = async () => {
        

        if (mnemonic) {
            await Clipboard.setStringAsync(mnemonic);

            setCopied('Copied to clipboard!');
            setTimeout( ()=>{
                setCopied('Copy to clipboard');
            }, 2000);
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
                            <Image source={require('../assets/copy.png')} style={styles.copyImg} />
                            <Text style={styles.copyText}>{copy}</Text>
                        </TouchableOpacity>

                    </View>

                </View>

                <TouchableOpacity
                    style={styles.primaryButton}
                    onPress={() => router.push("/confirm")}
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
