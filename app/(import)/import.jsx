import { StyleSheet, Text, TextInput, TouchableOpacity, View, Modal, Animated, Easing } from 'react-native'
import { useRouter } from 'expo-router'
import { colors, spacing, radii } from '../../src/theme'
import React, { useEffect, useState, useRef } from 'react'
import styles from '../styles/importStyles'
import { FontAwesome5 } from '@expo/vector-icons';



const Import = () => {
  const router = useRouter();

  const [isProcessing, setIsProcessing] = useState(false);
  const [firstPin, setFirstPin] = useState('');
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

  const handleLoad = () => {

    setIsProcessing(true);

    setTimeout(() => {

      setIsProcessing(false);
      router.replace('/secure');
      
    }, 5000);
  }

  const [phrase, setPhrase] = React.useState("");
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
          // onPress={() => router.push("/secure")}
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

