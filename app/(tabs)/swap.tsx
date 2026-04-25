import React, { useState, useRef, useEffect } from 'react';
import { StyleSheet, Text, View, TouchableOpacity, Animated, SafeAreaView, Image, TextInput } from 'react-native';
import { PrimaryButton } from '../../src/components/PrimaryButton';

import { Feather } from '@expo/vector-icons';
import { useRouter } from 'expo-router';

import { colors, spacing, radii, layout } from '../../src/theme';
import { useWalletStore } from '../../src/store/walletStore';

const SATS_PER_BTC = 100000000;
const CARD_HEIGHT = 115;
const CARD_GAP = 18;
const SWAP_DISTANCE = CARD_HEIGHT + CARD_GAP;


export default function SwapScreen() {
  const router = useRouter();

  const activeWallet = useWalletStore((state) => state.activeWallet);


  const rawBalanceSats = activeWallet?.balance || 0;
  const btcBalanceNum = rawBalanceSats / SATS_PER_BTC;

  const liveBtcPrice = useWalletStore((state) => state.liveBtcPrice);

  const [topAsset, setTopAsset] = useState({
    symbol: 'BTC',
    balanceDisplay: `${rawBalanceSats.toLocaleString()} sats`,
    balanceNum: btcBalanceNum,
    amount: ''
  });

  const [bottomAsset, setBottomAsset] = useState({
    symbol: 'USDC',
    balanceDisplay: '0.00',
    balanceNum: 0,
    amount: ''
  });
  const [isAnimating, setIsAnimating] = useState(false);


  const swapAnim = useRef(new Animated.Value(0)).current;



  const calculateConversion = (value: string, fromSymbol: string) => {
    const num = parseFloat(value);

    if (isNaN(num) || num === 0 || liveBtcPrice === 0) return '';

    if (fromSymbol === 'BTC') {
      // BTC to USDC (Live Math)
      return (num * liveBtcPrice).toFixed(2).toString();
    } else {
      // USDC to BTC (Live Math)
      return parseFloat((num / liveBtcPrice).toFixed(8)).toString();
    }
  };

  const handleTopInputChange = (value: string) => {
    setTopAsset({ ...topAsset, amount: value });
    setBottomAsset({ ...bottomAsset, amount: calculateConversion(value, topAsset.symbol) });
  };

  const handleBottomInputChange = (value: string) => {
    setBottomAsset({ ...bottomAsset, amount: value });
    setTopAsset({ ...topAsset, amount: calculateConversion(value, bottomAsset.symbol) });
  };

  const handleMaxPress = () => {
    const maxAmount = topAsset.balanceNum.toString();
    handleTopInputChange(maxAmount);
  };

  const handleSwap = () => {
    if (isAnimating) return;
    setIsAnimating(true);

    Animated.timing(swapAnim, {
      toValue: 1,
      duration: 1000,
      useNativeDriver: true,
    }).start(() => {
      const tempTop = topAsset;
      setTopAsset(bottomAsset);
      setBottomAsset(tempTop);

      setTimeout(() => {
        swapAnim.setValue(0);
        setIsAnimating(false);
      }, 50);
    });
  };

  const topCardTranslateY = swapAnim.interpolate({
    inputRange: [0, 1],
    outputRange: [0, SWAP_DISTANCE],
  });

  const bottomCardTranslateY = swapAnim.interpolate({
    inputRange: [0, 1],
    outputRange: [0, -SWAP_DISTANCE],
  });

  const iconRotation = swapAnim.interpolate({
    inputRange: [0, 1],
    outputRange: ['0deg', '-360deg'],
  });

  return (
    <SafeAreaView style={styles.container}>

      <View style={styles.header}>
        <TouchableOpacity onPress={() => router.back()} style={styles.backButton}>
          <Feather name="chevron-left" size={24} color="#FFFFFF" />
        </TouchableOpacity>
        <Text style={styles.headerTitle}>Swap</Text>
        <View style={{ width: 24 }} />
      </View>


      <View style={styles.swapContainer}>

        <Animated.View style={[styles.card, { transform: [{ translateY: topCardTranslateY }] }]}>
          <View style={styles.cardHeader}>
            <Text style={styles.cardLabel}>Sell</Text>

            <View style={styles.balanceContainer}>
              <TouchableOpacity onPress={handleMaxPress}>
                <Text style={[styles.cardLabel, styles.maxButton]}>Max</Text>
              </TouchableOpacity>
              <Text style={styles.cardLabel}> : <Text style={styles.cardBalance}>{topAsset.balanceDisplay}</Text></Text>
            </View>

          </View>
          <View style={styles.cardBody}>
            <TouchableOpacity style={styles.assetSelector}>
              <Text style={styles.assetText}>{topAsset.symbol}</Text>
              <Feather name="chevron-down" size={20} color="#FFFFFF" />
            </TouchableOpacity>

            <TextInput
              style={styles.amountInput}
              value={topAsset.amount}
              onChangeText={handleTopInputChange}
              keyboardType="decimal-pad"
              placeholder="0"
              placeholderTextColor={colors.text.midgrey}
            />
          </View>
        </Animated.View>

        <View style={styles.swapButtonWrapper}>
          <TouchableOpacity onPress={handleSwap} activeOpacity={0.8}>
            <Animated.View style={[styles.swapIconButton, { transform: [{ rotate: iconRotation }] }]}>
              <Image source={require('../assets/repeat.png')} style={styles.swapIconImage} />
            </Animated.View>
          </TouchableOpacity>
        </View>

        <Animated.View style={[styles.card, { transform: [{ translateY: bottomCardTranslateY }] }]}>
          <View style={styles.cardHeader}>
            <Text style={styles.cardLabel}>Buy</Text>

            <View style={styles.balanceContainer}>
              <Text style={styles.cardLabel}>Balance</Text>
              <Text style={styles.cardLabel}> : <Text style={styles.cardBalance}>{bottomAsset.balanceDisplay}</Text></Text>
            </View>

          </View>
          <View style={styles.cardBody}>
            <TouchableOpacity style={styles.assetSelector}>
              <Text style={styles.assetText}>{bottomAsset.symbol}</Text>
              <Feather name="chevron-down" size={20} color="#FFFFFF" />
            </TouchableOpacity>

            <TextInput
              style={styles.amountInput}
              value={bottomAsset.amount}
              onChangeText={handleBottomInputChange}
              keyboardType="decimal-pad"
              placeholder="0"
              placeholderTextColor={colors.text.midgrey}
            />
          </View>
        </Animated.View>

      </View>

      <View style={{ flex: 1 }} />

      <View style={styles.footer}>
        <TouchableOpacity style={styles.primaryButton}>
          <Text style={styles.primaryButtonText}>Swap</Text>
        </TouchableOpacity>
      </View>

    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  header: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingHorizontal: 20,
    paddingVertical: 45,
    marginBottom: 40,
  },
  backButton: {
    padding: 8,
    backgroundColor: colors.background.darkgrey,
    borderRadius: radii.xl,
  },
  headerTitle: {
    color: '#FFFFFF',
    fontSize: 18,
    fontWeight: '600',
  },
  swapContainer: {
    paddingHorizontal: 20,
    position: 'relative',
    height: 248,
    justifyContent: 'space-between',
  },
  card: {
    backgroundColor: colors.background.darkgrey,
    height: 115,
    borderRadius: 24,
    padding: 20,
    justifyContent: 'center',
  },
  cardHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginBottom: 12,
  },
  cardLabel: {
    color: colors.text.midgrey,
    fontSize: 13,
    fontWeight: '500',
  },
  balanceContainer: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  maxButton: {
    color: colors.text.midgrey,
    fontWeight: '700',
  },
  cardBalance: {
    color: colors.text.primary
  },
  cardBody: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  assetSelector: {
    paddingLeft: 18,
    flexDirection: 'row',
    alignItems: 'center',
    gap: 6,
  },
  assetText: {
    color: '#FFFFFF',
    fontSize: 20,
    fontWeight: 'bold',
  },
  amountInput: {
    color: '#FFFFFF',
    fontSize: 24,
    fontWeight: '500',
    minWidth: 100,
    textAlign: 'right', 
    padding: 0,
  },
  amountText: {
    color: colors.text.midgrey,
    fontSize: 24,
    fontWeight: '500',
  },
  swapButtonWrapper: {
    position: 'absolute',
    top: '50%',
    left: '50%',
    marginTop: -22,
    zIndex: 10,
  },
  swapIconButton: {
    width: 45,
    height: 45,
    backgroundColor: colors.accent.primary,
    borderRadius: 14,
    justifyContent: 'center',
    alignItems: 'center',
  },
  swapIconImage: {
    width: 24,
    height: 24,
  },
  footer: {
    paddingHorizontal: 20,
    paddingBottom: 40,
  },
  primaryButton: {
    backgroundColor: colors.accent.primary,
    width: '100%',
    height: 56,
    borderRadius: 28,
    justifyContent: 'center',
    alignItems: 'center',
  },
  primaryButtonText: {
    color: '#FFFFFF',
    fontSize: 16,
    fontWeight: '700',
  },
});