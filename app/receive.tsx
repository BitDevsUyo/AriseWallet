import { StyleSheet, Text, View, SafeAreaView, TouchableOpacity, Share, Image, TextInput, Modal, ActivityIndicator } from 'react-native';
import React from 'react';
import { useRouter } from 'expo-router';
import { Feather, Ionicons } from '@expo/vector-icons';
import QRCode from 'react-native-qrcode-svg';
import * as Clipboard from 'expo-clipboard';
import Toast from 'react-native-toast-message';

import { useWalletStore } from '../src/store/walletStore';
import { colors, radii, spacing } from '../src/theme';
import { useState } from 'react';

const Receive = () => {
  const router = useRouter();

  const address = useWalletStore((state) => state.activeWallet?.address) || "No address found";
  const walletName = useWalletStore((state) => state.activeWallet?.name) || "Main Wallet";
  const currentView = useWalletStore((state) => state.activeWallet?.currentView) || "unified";

  const switchAndSyncVault = useWalletStore((state) => state.switchAndSyncVault);
  const isSyncing = useWalletStore((state) => state.isSyncing);

  const [showDropdown, setShowDropdown] = useState(false);

  const getVaultDisplayName = (view) => {
    switch (view) {
      case 'native': return 'Native SegWit (P2WPKH)';
      case 'nested': return 'Nested SegWit (P2SH)';
      case 'legacy': return 'Legacy (P2PKH)';
      case 'taproot':
      case 'unified':
      default:
        return 'Taproot (P2TR)';
    }
  };

  const truncateAddress = (addr) => {
    if (!addr || addr.length < 15) return addr;
    return `${addr.slice(0, 8)}...${addr.slice(-6)}`;
  };

  const copyToClipboard = async () => {
    await Clipboard.setStringAsync(address);
    Toast.show({
      type: 'success',
      text1: 'Address Copied',
      text2: 'Ready to paste!',
      position: 'top'
    });
  };

  const shareAddress = async () => {
    try {
      await Share.share({
        message: address,
      });
    } catch (error) {
      console.error("Error sharing address:", error);
    }
  };

  const handleSwitchVault = async (vaultKey) => {
    setShowDropdown(false);
    const success = await switchAndSyncVault(vaultKey);
    
    if (success) {
      Toast.show({
        type: 'success',
        text1: 'Address Updated',
        text2: `Now receiving to ${getVaultDisplayName(vaultKey)}`,
      });
    } else {
      Toast.show({ type: 'error', text1: 'Sync Failed', text2: 'Check your connection.' });
    }
  };

  return (
    <SafeAreaView style={styles.safeArea}>

      <Modal visible={isSyncing} transparent={true} animationType="fade">
        <View style={styles.loadingOverlay}>
          <ActivityIndicator size="large" color={colors.accent.primary} />
          <Text style={styles.loadingText}>Generating Address...</Text>
        </View>
      </Modal>

      <Modal visible={showDropdown} transparent={true} animationType="slide">
        <TouchableOpacity style={styles.dropdownOverlay} activeOpacity={1} onPress={() => setShowDropdown(false)}>
          <View style={styles.dropdownMenu}>
            
            <TouchableOpacity style={styles.dropdownItem} onPress={() => handleSwitchVault('taproot')}>
              <Text style={styles.dropdownItemText}>Taproot (P2TR) (Default)</Text>
            </TouchableOpacity>

            <TouchableOpacity style={styles.dropdownItem} onPress={() => handleSwitchVault('native')}>
              <Text style={styles.dropdownItemText}>Segwit (P2WPKH)</Text>
            </TouchableOpacity>

            <TouchableOpacity style={styles.dropdownItem} onPress={() => handleSwitchVault('legacy')}>
              <Text style={styles.dropdownItemText}>Legacy (P2PKH)</Text>
            </TouchableOpacity>

            <TouchableOpacity style={[styles.dropdownItem, { borderBottomWidth: 0 }]} onPress={() => handleSwitchVault('nested')}>
              <Text style={styles.dropdownItemText}>Segwit-Compatible (P2SH)</Text>
            </TouchableOpacity>

          </View>
        </TouchableOpacity>
      </Modal>


      <View style={styles.header}>
        <TouchableOpacity onPress={() => router.back()} style={styles.iconButton}>
          <Feather name="chevron-left" size={24} color="#FFFFFF" />
        </TouchableOpacity>
        <Text style={styles.headerTitle}>Receive BTC</Text>
        <TouchableOpacity style={styles.iconButton}>
          <Feather name="file-text" size={20} color="#FFFFFF" />
        </TouchableOpacity>
      </View>

      <View style={styles.content}>

        <View style={styles.qrCard}>
          <TouchableOpacity style={styles.vaultSelector} onPress={() => setShowDropdown(true)}>
            <Text style={styles.vaultSelectorText}>{getVaultDisplayName(currentView)}</Text>
            <Feather name="chevron-down" size={16} color="#FFFFFF" />
          </TouchableOpacity>

          <View style={styles.qrWrapper}>
            <QRCode
              value={address}
              size={180}
              color="#000000"
              backgroundColor="#FFFFFF"
            />
          </View>

          <View style={styles.cardBottom}>
            <View>
              <Text style={styles.walletName}>{walletName}:</Text>
              <Text style={styles.truncatedAddress}>{truncateAddress(address)}</Text>
            </View>
            <View style={styles.btcIconWrapper}>
              <Image source={require('../assets//bitcoin.png')} style={styles.btcIconWrapperImage} />
            </View>
          </View>
        </View>

        <View style={styles.dividerContainer}>
            <TextInput 
              style={styles.setAmountText}
              placeholder='Set Amount'
              placeholderTextColor={colors.text.midgrey} 
              keyboardType="decimal-pad"
            />
        </View>

        <Text style={styles.warningText}>
          This address is for receiving BTC assets only
        </Text>

        <TouchableOpacity style={styles.actionRowButton}>
          <Text style={styles.actionRowText}>Change Address</Text>
          <Feather name="chevron-right" size={20} color={colors.text.midgrey} />
        </TouchableOpacity>

        <View style={styles.bottomButtonsRow}>
          <TouchableOpacity style={styles.halfButton} onPress={copyToClipboard}>
            <Feather name="copy" size={18} color="#FFFFFF" />
            <Text style={styles.halfButtonText}>Copy</Text>
          </TouchableOpacity>

          <TouchableOpacity style={styles.halfButton} onPress={shareAddress}>
            <Feather name="share" size={18} color="#FFFFFF" />
            <Text style={styles.halfButtonText}>Share</Text>
          </TouchableOpacity>
        </View>

      </View>
    </SafeAreaView>
  );
};

export default Receive;

const styles = StyleSheet.create({
  safeArea: {
    flex: 1,
    backgroundColor: '#0D0D0D', 
  },
  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingHorizontal: 20,
    paddingVertical: 45,
  },
  iconButton: {
    width: 40,
    height: 40,
    justifyContent: 'center',
    alignItems: 'center',
  },
  headerTitle: {
    color: '#FFFFFF',
    fontSize: 16,
    fontWeight: '600',
  },
  content: {
    flex: 1,
    paddingHorizontal: 20,
    alignItems: 'center',
    paddingTop: 20,
  },

  // QR CARD STYLES
  qrCard: {
    backgroundColor: '#1A1A1A', 
    width: 250,
    borderRadius: 24,
    padding: 24,
    alignItems: 'center',
    marginBottom: 40,
  },
  vaultSelector: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 8,
    marginBottom: 14,
  },
  vaultSelectorText: {
    color: '#FFFFFF',
    fontSize: 14,
    fontWeight: '500',
  },
  qrWrapper: {
    backgroundColor: '#FFFFFF',
    padding: 16,
    borderRadius: radii.md,
    marginBottom: 14,
  },
  cardBottom: {
    width: '100%',
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  walletName: {
    color: '#FFFFFF',
    fontSize: 14,
    fontWeight: '600',
    marginBottom: 4,
  },
  truncatedAddress: {
    color: colors.text.midgrey,
    fontSize: 13,
  },
  btcIconWrapper: {
    backgroundColor: colors.accent.primary, 
    width: 40,
    height: 40,
    borderRadius: 10,
    justifyContent: 'center',
    alignItems: 'center',
  },
  btcIconWrapperImage: {
    width: 54,
    height: 54,
    // padding: 0,
  },

  // SET AMOUNT STYLES
  dividerContainer: {
    flexDirection: 'column',
    justifyContent: 'center',
    alignItems: 'center',
    width: '100%',
    marginBottom: 40,
    borderBottomWidth: 1,
    borderBottomColor: colors.background.darkgrey,
  },
  setAmountText: {
    color: colors.text.midgrey,
    fontSize: 12,
    marginHorizontal: 15,
  },

  // BOTTOM CONTROLS
  warningText: {
    color: colors.text.midgrey,
    fontSize: 12,
    marginBottom: 16,
  },
  actionRowButton: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    backgroundColor: '#1A1A1A',
    width: '100%',
    padding: 18,
    borderRadius: 16,
    marginBottom: 16,
  },
  actionRowText: {
    color: '#FFFFFF',
    fontSize: 15,
    fontWeight: '500',
  },
  bottomButtonsRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    width: '100%',
    gap: 16,
  },
  halfButton: {
    flex: 1,
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#1A1A1A',
    paddingVertical: 18,
    borderRadius: 16,
    gap: 8,
  },
  halfButtonText: {
    color: '#FFFFFF',
    fontSize: 15,
    fontWeight: '500',
  },

  loadingOverlay: { flex: 1, backgroundColor: 'rgba(10, 10, 10, 0.8)', justifyContent: 'center', alignItems: 'center', zIndex: 1000 },
  loadingText: { color: '#FFFFFF', marginTop: 16, fontSize: 16, fontWeight: '600' },
  
  dropdownOverlay: {
    flex: 1,
    backgroundColor: 'rgba(0, 0, 0, 0.6)', 
    justifyContent: 'flex-end', 
  },
  dropdownMenu: {
    backgroundColor: colors.background.default, 
    width: '100%',
    borderTopLeftRadius: 30,
    borderTopRightRadius: 30,
    paddingVertical: 30,
    paddingHorizontal: 20,
    borderTopWidth: 1,
    borderTopColor: '#2A2A2A',
  },
  dropdownItem: {
    paddingVertical: 25,
  },
  dropdownItemText: {
    color: '#FFFFFF',
    fontSize: 18, 
    fontWeight: '400',
  },
});