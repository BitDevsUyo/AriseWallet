import { Text, View, TouchableOpacity, ImageBackground, Alert, ActivityIndicator } from 'react-native'
import { Link, useRouter } from 'expo-router';
import { useFonts } from 'expo-font';
import styles from './styles/homeStyles';
import React, { useState } from 'react';
import { Descriptor, DescriptorSecretKey, Wallet, Mnemonic, Blockchain, DatabaseConfig } from "bdk-rn";
import { WordCount, Network, KeychainKind } from "bdk-rn/lib/lib/enums";
import { NativeModules } from "react-native";

const { BdkRnModule } = NativeModules;


const Home = () => {
    const router = useRouter();
    const [loading, setLoading] = useState(false);
    const [buttonText, setButtonText] = useState('Create new Wallet');
    const [mnemonic, setMnemonic] = useState('');

    const loadMnemonic = async () => {
        setLoading(true);
        setButtonText('Creating Wallet...');

        try {
            //Generate 12 word mnemonic
            const mnemonic = await new Mnemonic().create(WordCount.WORDS12);
            const mnemonicStr = mnemonic.asString();
            console.log("Mnemonic:", mnemonicStr);

            // Create descriptor secret key (xprv/tprv)
            const descriptorSecretKey = await new DescriptorSecretKey().create(
                Network.Testnet,
                mnemonic
            );
            const secretKeyString = await descriptorSecretKey.asString();
            console.log("Secret Key XPRV:", secretKeyString);

            //Create external and internal descriptor for BIP44
            const externalDescriptor = await new Descriptor().newBip44(
                descriptorSecretKey,
                KeychainKind.External,
                Network.Testnet,
                "p2pkh"
            );

            const internalDescriptor = await new Descriptor().newBip44(
                descriptorSecretKey,
                KeychainKind.Internal,
                Network.Testnet,
                "p2pkh"
            );
            console.log("External Descriptor:", await externalDescriptor.asString());
            console.log("Internal Descriptor:", await internalDescriptor.asString());


            //Connect to Electrum Blockchain
            const blockchainConfig = {
                url: "ssl://electrum.blockstream.info:60002",
                sock5: null,
                retry: 5,
                timeout: 5,
                stopGap: 500,
                validateDomain: false,
            };

            const blockchain = await new Blockchain().create(blockchainConfig);
            const height = await blockchain.getHeight();
            console.log("BlockChain Height:", height)
            console.log("Blockchain connected.");

            const dbConfig = await new DatabaseConfig().memory();

            // Create wallet
            const wallet = await new Wallet().create(
                externalDescriptor,
                internalDescriptor,
                Network.Testnet,
                dbConfig
            );
            console.log(" Wallet created successfully!");

            await wallet.sync(blockchain);
            console.log("Wallet synced.");

            // Log wallet balance
            const balance = await wallet.getBalance();
            console.log(" Wallet Balance:", balance);

            //  Log address
            const addrInfo = await wallet.getAddress();
            const receiveAddress = await addrInfo.address.asString();
            console.log("First Receive Address:", receiveAddress);


            router.push({
                pathname: "/secure",
                params: { mnemonic: mnemonic.asString() }
            });

        } catch (e) {
            console.log("Error generating mnemonic:", e);
        }
    };


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
                    onPress={loadMnemonic}
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
                    onPress={() => router.push("/import")}
                >
                    <Text style={styles.secondaryButtonText}>Import existing wallet</Text>
                </TouchableOpacity>
            </View>


        </View>
    )
}

export default Home


