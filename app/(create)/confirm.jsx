import { StyleSheet, Text, View, TouchableOpacity, } from 'react-native'
import { PrimaryButton } from '../../src/components/PrimaryButton'
import { colors, spacing, radii } from '../../src/theme'
import { Link, useRouter } from 'expo-router';
import React, { useState, useEffect } from 'react'

import { useWalletStore } from '../../src/store/walletStore';
import Toast from 'react-native-toast-message';

const confirm = () => {
  const router = useRouter();

  const mnemonic = useWalletStore((state) => state.onboarding.mnemonic);

  const [step, setStep] = useState(1);
  const [targetIndex, setTargetIndex] = useState(0);
  const [options, setOptions] = useState([]);
  const [selectedWord, setSelectedWord] = useState(null);

  const setupQuiz = (indexToAvoid = -1) => {
    if (!mnemonic) return;

    const wordsArray = mnemonic.split(' ');

    let randomTarget;
    do {
      randomTarget = Math.floor(Math.random() * wordsArray.length);
    } while (randomTarget === indexToAvoid);

    setTargetIndex(randomTarget);
    const correctWord = wordsArray[randomTarget];

    let uniqueDecoys = Array.from(new Set(wordsArray.filter(w => w !== correctWord)));

    uniqueDecoys = uniqueDecoys.sort(() => 0.5 - Math.random()).slice(0, 4);

    const allOptions = [correctWord, ...uniqueDecoys].sort(() => 0.5 - Math.random());
    setOptions(allOptions);
    setSelectedWord(null);
  };

  useEffect(() => {
   
    setupQuiz();
  }, [mnemonic]);

  const getOrdinal = (n) => {
    const s = ["th", "st", "nd", "rd"];
    const v = n % 100;
    return n + (s[(v - 20) % 10] || s[v] || s[0]);
  };

  const handleContinue = () => {
    const wordsArray = mnemonic.split(' ');
    const correctWord = wordsArray[targetIndex];

    if (selectedWord === correctWord) {
      if (step === 1) {
        setStep(2);
        setupQuiz(targetIndex);
      } else {
        router.push("/nameWallet");
      }
    } else {
      Toast.show({
        type: 'error',
        text1: 'Incorrect',
        text2: 'That is not the correct word. Please try again.',
      })
      setSelectedWord(null);
    }
  };

  return (
    <View style={styles.container}>

      <View style={styles.headerText}>
        <Text style={styles.mainText}>Confirm Recovery Phrase</Text>
        <Text style={styles.subText}>What was the <Text style={styles.subText}>{getOrdinal(targetIndex + 1)}</Text> word in your recovery phrase?</Text>
      </View>

      <View style={styles.confirmBox}>
        {options.map((word, index) => {
          const isSelected = selectedWord === word;
          return (
            <TouchableOpacity
              key={index}
              style={[
                styles.optionRow,
                isSelected && styles.optionRowSelected
              ]}
              onPress={() => setSelectedWord(word)}
              activeOpacity={0.7}
            >
              <Text style={styles.optionText}>{word}</Text>
              <View style={[
                styles.radioCircle,
                isSelected && styles.radioCircleSelected
              ]}>
                {isSelected && <View style={styles.radioDot} />}
              </View>
            </TouchableOpacity>
          )
        })}
      </View>

      <PrimaryButton
        title={"Continue"}
        disabled={!selectedWord}
        onPress={handleContinue}
      />

    </View>
  )
}

export default confirm

const styles = StyleSheet.create({
  container: {
    flex: 1,
    paddingHorizontal: spacing.lg,
    backgroundColor: colors.background.default,
    // justifyContent: 'center',
    // alignItems: 'center',
  },
  headerText: {
    paddingVertical: spacing.xl,
    marginBottom: spacing.xl * 2,
    gap: spacing.xs
  },
  mainText: {
    color: colors.text.primary,
    fontSize: 24,
    lineHeight: 24,
    fontWeight: "500"
  },
  subText: {
    color: colors.text.midgrey,
    fontSize: 16,
    lineHeight: 24,
  },
  confirmBox: {
    marginVertical: spacing.md,
    marginBottom: spacing.xl * 7,
    gap: spacing.sm
  },
  optionRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingVertical: spacing.md,
    paddingHorizontal: spacing.lg,
    borderRadius: radii.md || 12,
    backgroundColor: colors.background.surface,
  },
  optionRowSelected: {
    backgroundColor: colors.background.darkgrey,
  },
  optionText: {
    color: colors.text.primary,
    fontSize: 16,
    fontWeight: '500',
  },
  radioCircle: {
    height: 22,
    width: 22,
    borderRadius: 11,
    borderWidth: 1,
    borderColor: colors.border.default,
    alignItems: 'center',
    justifyContent: 'center',
  },
  radioCircleSelected: {
    borderColor: colors.accent.primary,
  },
  radioDot: {
    height: 10,
    width: 10,
    borderRadius: 5,
    backgroundColor: colors.accent.primary,
    justifyContent: 'center',
    alignItems: 'center'
  },
})