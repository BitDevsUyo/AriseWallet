import { StyleSheet, Text, TextInput, TouchableOpacity, View, Modal, Animated, Easing } from 'react-native'
import { useRouter } from 'expo-router'
import { colors, spacing, radii } from '../../src/theme'
import React, { useEffect, useState, useRef } from 'react'
import styles from '../styles/importStyles'
import { FontAwesome5 } from '@expo/vector-icons';

import { buildAndSyncWallets } from '../../src/utils/bdk';
import { useWalletStore } from '../../src/store/walletStore';
import Toast from 'react-native-toast-message'



const Import = () => {
  const router = useRouter();

  const [phrase, setPhrase] = React.useState("");
  const [isProcessing, setIsProcessing] = useState(false);
  const [firstPin, setFirstPin] = useState('');
  const spinValue = useRef(new Animated.Value(0)).current;

  const {
    updateOnboarding,
    finalizeAndSaveWallet,
    setWalletSession
  } = useWalletStore((state) => state);

  useEffect(() => {
    if (isProcessing) {
      Animated.loop(
        Animated.timing(spinValue, {
          toValue: 1,
          duration: 1000,
          easing: Easing.linear,
          useNativeDriver: true,
        })
      ).start();
    } else {
      spinValue.setValue(0);
    }
  }, [isProcessing]);

  const spin = spinValue.interpolate({
    inputRange: [0, 1],
    outputRange: ['0deg', '360deg'],
  });


  const handleLoad = async () => {
    const cleanPhrase = phrase.trim();

    if (!cleanPhrase) {
      Toast.show({
        type: 'error',
        text1: 'Missing Phrase',
        text2: 'Please enter your recovery phrase to continue.',
      })
      return;
    }

    const wordCount = cleanPhrase.split(/\s+/).length;
    if (wordCount !== 12 && wordCount !== 24) {
      Toast.show({
        type: 'error',
        text1: 'Invalid Length',
        text2: `You entered ${wordCount} words. It must be 12 words.`,
      })
      return;
    }

    setIsProcessing(true);

    updateOnboarding('mnemonic', cleanPhrase);
    updateOnboarding('name', 'Imported Wallet'); 

    setTimeout(async () => {
      try {
        const { activeWalletInstance, vaults, totalBalance, receiveAddress } = await buildAndSyncWallets(cleanPhrase);

        await finalizeAndSaveWallet();
        setWalletSession(activeWalletInstance, vaults, totalBalance, receiveAddress);

        setIsProcessing(false);

        router.replace('/secure');

      } catch (error) {
        console.error("Wallet import failed:", error);
        setIsProcessing(false);

        const errString = String(error).toLowerCase();

        if (errString.includes('electrum') || errString.includes('network') || errString.includes('os error')) {
          Toast.show({
            type: 'error',
            text1: 'Network Error',
            text2: 'Could not import wallet. Check your Wi-Fi connection and try again.',
          });
        } else {
          Toast.show({
            type: 'error',
            text1: 'Invalid Recovery Phrase',
            text2: 'Check your spelling and word order, then try again.',
          });
        }
      }
    }, 150);
  }

  return (
    <View style={styles.container}>

      <View style={styles.layout}>

        <View style={styles.textLayout}>

          <View style={styles.recoveryText}>
            <Text style={styles.title}>Recovery Phrase</Text>
            <Text style={styles.subTitle}>Import your existing wallet with your 12 word recovery phrase</Text>
          </View>

          <View style={styles.input}>
            <TextInput style={styles.inputText} placeholder=" Recovery Phrase" placeholderTextColor="#666666" value={phrase} onChangeText={setPhrase} multiline />
          </View>

        </View>

        <TouchableOpacity
          style={styles.primaryButton}
          onPress={handleLoad}
        >
          <Text style={styles.primaryButtonText}>Import Recovery Phrase</Text>
        </TouchableOpacity>

      </View>

      <Modal visible={isProcessing} transparent={true} animationType="fade">
        <View style={styles.modalOverlay}>
          <View style={styles.modalContent}>

            <View style={styles.spinnerContainer}>
              <View style={styles.iconCenter}>
                <FontAwesome5 name="bitcoin" size={26} color="#ffffff" />
              </View>

              <Animated.View
                style={[
                  styles.thinSpinner,
                  { transform: [{ rotate: spin }] }
                ]}
              />
            </View>

            <Text style={styles.modalText}>Importing Wallet...</Text>
            <Text style={styles.modalSubText}>
              This may take a few seconds. Please don't{'\n'}close the app
            </Text>

          </View>
        </View>
      </Modal>

    </View>

  )
}

export default Import

