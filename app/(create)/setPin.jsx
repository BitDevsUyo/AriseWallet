import React, { useState, useRef, useEffect } from 'react';
import { View, Text, StyleSheet, SafeAreaView, Alert, Modal, Animated, Easing } from 'react-native';
import { useRouter } from 'expo-router';
import OTPTextView from 'react-native-otp-textinput';

import { colors, spacing, radii } from '../../src/theme';
import { useWalletStore } from '../../src/store/walletStore';
import { FontAwesome5 } from '@expo/vector-icons';
import { PrimaryButton } from '../../src/components/PrimaryButton';
import { buildAndSyncWallets } from '../../src/utils/bdk';

export default function Passcode() {
  const router = useRouter();

  const {
    updateOnboarding,
    finalizeAndSaveWallet,
    setWalletSession,
    onboarding
  } = useWalletStore((state) => state);

  const otpInput = useRef(null); 
  const [pin, setPin] = useState('');
  const [isConfirming, setIsConfirming] = useState(false);
  const [isProcessing, setIsProcessing] = useState(false);
  const [firstPin, setFirstPin] = useState('');

  // Spinner Animation Setup 
  const spinValue = useRef(new Animated.Value(0)).current;

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

  const handleSubmit = () => {
    if (pin.length !== 4) return;

    if (!isConfirming) {
      setFirstPin(pin);
      setIsConfirming(true);
      setPin('');
      otpInput.current.clear();
    } else {
      if (pin === firstPin) {
        updateOnboarding('passcode', pin);

        setIsProcessing(true);

        // Timeout to let UI render before BDK blocks the thread
        setTimeout(async () => {
          try {
            const mnemonicToUse = onboarding.mnemonic;
            const { activeWalletInstance, totalBalance, receiveAddress } = await buildAndSyncWallets(mnemonicToUse);

            await finalizeAndSaveWallet();
            setWalletSession(activeWalletInstance, totalBalance, receiveAddress);

            setIsProcessing(false);
            router.push('/protectWallet'); 

          } catch (error) {
            console.error("Wallet creation failed:", error);
            Alert.alert('Error', 'Failed to build wallet. Please try again.');
            setIsProcessing(false);
          }
        }, 150);

      } else {
        Alert.alert('Error', 'Passcodes do not match. Please try again.');
        setIsConfirming(false);
        setFirstPin('');
        setPin('');
        otpInput.current.clear();
      }
    }
  };

  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.title}>
          {isConfirming ? 'Confirm Passcode' : 'Create Passcode'}
        </Text>
        <Text style={styles.subtitle}>
          {isConfirming
            ? 'Confirm the passcode you just created.'
            : 'This passcode helps prevent unauthorized access and confirms your transactions.'}
        </Text>
      </View>

      <View style={styles.inputContainer}>
        <OTPTextView
          ref={otpInput}
          handleTextChange={(text) => setPin(text)}
          inputCount={4}
          keyboardType="numeric"
          secureTextEntry={true}
          tintColor={colors.accent.primary}
          textInputStyle={styles.otpInput}
          containerStyle={styles.otpContainer}
          autoFocus={true}
        />
      </View>

      <View style={{ flex: 1 }} />

      <PrimaryButton
        title={isConfirming ? 'Confirm' : 'Create'}
        onPress={handleSubmit}
        disabled={pin.length !== 4}
        style={{ marginBottom: spacing.xl }}
      />

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

            <Text style={styles.modalText}>Creating Wallet...</Text>
            <Text style={styles.modalSubText}>
              This may take a few seconds. Please don't{'\n'}close the app
            </Text>
            
          </View>
        </View>
      </Modal>

    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: colors.background.default,
    alignItems: 'center',
    paddingVertical: spacing.xl,
    paddingTop: spacing.xl * 2,
  },
  header: {
    alignItems: 'center',
    marginTop: spacing.xl * 2
  },
  title: {
    color: colors.text.primary,
    textAlign: 'center',
    fontSize: 24,
    fontWeight: '500',
    marginBottom: spacing.sm
  },
  subtitle: {
    color: colors.text.midgrey,
    fontSize: 16,
    fontWeight: '400',
    textAlign: 'center',
    paddingHorizontal: spacing.lg
  },
  inputContainer: {
    marginTop: spacing.xl * 2,
    alignItems: 'center',
  },
  otpContainer: {
    width: '80%',
    justifyContent: 'space-between',
  },
  otpInput: {
    backgroundColor: colors.background.darkgrey,
    color: colors.accent.primary,
    borderRadius: radii.md,
    borderBottomWidth: 0,
    width: 50,
    height: 50,
  },

  modalOverlay: {
    flex: 1,
    backgroundColor: 'rgba(10, 10, 10, 0.95)',
    justifyContent: 'center',
    paddingHorizontal: spacing.xl,
  },
  modalContent: {
    alignItems: 'flex-start',
  },
  modalText: {
    color: colors.text.primary,
    fontSize: 26,
    fontWeight: '600',
    marginBottom: spacing.xs,
  },
  modalSubText: {
    color: colors.text.midgrey,
    fontSize: 16,
    lineHeight: 24,
  },

  spinnerContainer: {
    width: 64,
    height: 64,
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: spacing.xl,
  },
  iconCenter: {
    position: 'absolute',
    justifyContent: 'center',
    alignItems: 'center',
    zIndex: 1,
  },
  thinSpinner: {
    position: 'absolute',
    width: 64,
    height: 64,
    borderRadius: 32,
    borderWidth: 1,
    borderColor: 'rgba(255, 255, 255, 0.15)',
    borderTopColor: '#ffffff',
    zIndex: 2,
  },
});