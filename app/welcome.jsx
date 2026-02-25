import React, { useState } from 'react';
import { Text, View, TouchableOpacity, ImageBackground, Alert, ActivityIndicator } from 'react-native'
import { Link, useRouter } from 'expo-router';
import styles from './styles/homeStyles';

import {useWalletStore} from '../src/store/walletStore';
import { generateNewMnemonics } from '../src/utils/bdk';


const Home = () => {
    const router = useRouter();
    const [loading, setLoading] = useState(false);
    const [buttonText, setButtonText] = useState('Create new Wallet');

    const updateOnboarding = useWalletStore((state) => state.updateOnboarding);

    const handleCreateWallet = async () => {
        try{
            setLoading(true);
            setButtonText('Creating Wallet...');

            const phrase = await generateNewMnemonics();
            updateOnboarding('mnemonic', phrase);

            setLoading(false)
            setButtonText('Create new Wallet')
            router.push('/recovery')
        }catch (error){
            console.error("Failed to generate mnemonic:", error);
            Alert.alert("Error", "Could not generate recovery phrase.");
            setLoading(false);
        }
    }


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
                    By tapping any button you agree and consent to our <Link href="" style={styles.inner}>Terms of Services</Link> and <Link href="" style={styles.inner}>Privacy Policy.</Link>
                </Text>

                <TouchableOpacity
                    style={styles.primaryButton}
                    // onPress={() => router.push("/recovery")}
                    onPress={handleCreateWallet}
                    disabled={loading}
                >
                    {loading ? (
                        <ActivityIndicator size='small' color='#fff' />
                    ) : (
                        <Text style={styles.primaryButtonText}>
                            {/* Create new Wallet */}
                            {buttonText}
                        </Text>
                    )}

                </TouchableOpacity>

                <TouchableOpacity
                    style={styles.secondaryButton}
                    // onPress={syncWallet}
                    onPress={() => router.push("/import")}
                >
                    <Text style={styles.secondaryButtonText}>
                        Import existing wallet
                    </Text>
                </TouchableOpacity>
            </View>


        </View >
    )
}

export default Home


