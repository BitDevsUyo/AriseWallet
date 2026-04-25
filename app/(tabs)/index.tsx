import { StyleSheet, Text, View, TouchableOpacity, Image, SafeAreaView, ScrollView, RefreshControl, Modal, ActivityIndicator } from 'react-native';
import { useWalletStore } from '../../src/store/walletStore';
import { getElectrumBlockchain } from '../../src/utils/bdk';
import { useRouter } from 'expo-router';
import { useState, useCallback, useEffect } from 'react';
import { Feather } from '@expo/vector-icons';
import Toast from 'react-native-toast-message';

import { colors, spacing, radii, layout } from '../../src/theme';

const SATS_PER_BTC = 100000000;

const Dashboard = () => {
  const router = useRouter();
  const activeWallet = useWalletStore((state) => state.activeWallet);
  const liveBtcPrice = useWalletStore((state) => state.liveBtcPrice);
  const fetchLivePrice = useWalletStore((state) => state.fetchLivePrice);
  const syncWallet = useWalletStore((state) => state.syncWallet);
  const loadTransactions = useWalletStore((state) => state.loadTransactions);

  const switchAndSyncVault = useWalletStore((state) => state.switchAndSyncVault);
  const isSyncing = useWalletStore((state) => state.isSyncing);

  const transactions = activeWallet?.transactions || [];

  const [refreshing, setRefreshing] = useState(false);

  const [showDropdown, setShowDropdown] = useState(false);

  useEffect(() => {
    loadTransactions();

    const performInitialSync = async () => {
      const syncSuccess = await syncWallet();
      if (!syncSuccess) {
        Toast.show({
          type: 'error',
          text1: 'Offline',
          text2: 'Please connect to the internet!!',
          position: 'top',
        });
      }
    };
    // fetchLivePrice();
    performInitialSync();
  }, []);


  const onRefresh = useCallback(async () => {
    setRefreshing(true);
    try {
      const [priceSuccess, syncSuccess] = await Promise.all([
        fetchLivePrice(),
        syncWallet()
      ]);

      if (!syncSuccess) {
        Toast.show({
          type: 'error',
          text1: 'Sync Failed',
          text2: 'No internet connection',
        });
      } else if (!priceSuccess) {
        Toast.show({
          type: 'info',
          text1: 'Wallet Synced',
          text2: 'Could not fetch latest USD price.',
        });
      }
      else {
        Toast.show({
          type: 'success',
          text1: 'Wallet Synced',
          text2: 'Wallet balance is up to date!',
        });
      }

    } catch (error) {
      console.error("Error during refresh:", error);
    } finally {
      setRefreshing(false);
    }
  }, [fetchLivePrice, syncWallet]);

  const rawBalanceSats = activeWallet?.balance || 0;
  const btcBalance = rawBalanceSats / SATS_PER_BTC;
  const usdBalance = btcBalance * liveBtcPrice;

  const getInitials = (name) => {
    if (!name) return "MW";
    const words = name.split(' ');
    return words.map(w => w[0]).join('').substring(0, 2).toUpperCase();
  };

  const formatTxDate = (confirmationTime) => {
    if (!confirmationTime) return "Pending...";
    const date = new Date(confirmationTime.timestamp * 1000);
    return date.toLocaleDateString('en-US', { month: 'short', day: 'numeric', hour: '2-digit', minute: '2-digit' });
  };

  const handleSwitchVault = async (vaultKey) => {
    setShowDropdown(false);
    const success = await switchAndSyncVault(vaultKey);

    if (success) {
      Toast.show({
        type: 'success',
        text1: 'Wallet Switched',
        text2: vaultKey === 'unified' ? 'Viewing all vaults' : `Viewing ${vaultKey} vault`,
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
          <Text style={styles.loadingText}>Syncing Wallet...</Text>
        </View>
      </Modal>

      <Modal visible={showDropdown} transparent={true} animationType="fade">
        <TouchableOpacity style={styles.dropdownOverlay} activeOpacity={1} onPress={() => setShowDropdown(false)}>
          <View style={styles.dropdownMenu}>
            {/* <Text style={styles.dropdownTitle}>Select Vault</Text> */}

            <TouchableOpacity style={styles.dropdownItem} onPress={() => handleSwitchVault('unified')}>
              <Text style={styles.dropdownItemText}>Unified (All Wallet)</Text>
            </TouchableOpacity>

            <TouchableOpacity style={styles.dropdownItem} onPress={() => handleSwitchVault('taproot')}>
              <Text style={styles.dropdownItemText}>Taproot </Text>
            </TouchableOpacity>

            <TouchableOpacity style={styles.dropdownItem} onPress={() => handleSwitchVault('native')}>
              <Text style={styles.dropdownItemText}>Native SegWit</Text>
            </TouchableOpacity>

            <TouchableOpacity style={styles.dropdownItem} onPress={() => handleSwitchVault('nested')}>
              <Text style={styles.dropdownItemText}>Nested(P2SH) SegWit</Text>
            </TouchableOpacity>

            <TouchableOpacity style={[styles.dropdownItem, { borderBottomWidth: 0 }]} onPress={() => handleSwitchVault('legacy')}>
              <Text style={styles.dropdownItemText}>Legacy</Text>
            </TouchableOpacity>
          </View>
        </TouchableOpacity>
      </Modal>

      <ScrollView
        contentContainerStyle={styles.container}
        showsVerticalScrollIndicator={false}
        refreshControl={
          <RefreshControl
            refreshing={refreshing}
            onRefresh={onRefresh}
            tintColor={colors.accent.primary}
            colors={[colors.accent.primary]}
          />
        }
      >

        <View style={styles.walletInfo}>
          <TouchableOpacity style={styles.activeProfile}>
            <Text style={styles.profileInitials}>{getInitials(activeWallet.name)}</Text>
          </TouchableOpacity>

          <TouchableOpacity style={styles.nameContainer} onPress={() => setShowDropdown(true)}>
            <Text style={styles.walletNameText}>{activeWallet.name || "Main Wallet"}</Text>
            <Feather name="chevron-down" size={20} color="#666666" />
          </TouchableOpacity>

          <TouchableOpacity>
            <Feather name="more-vertical" size={24} color="#FFFFFF" />
          </TouchableOpacity>
        </View>

        <View style={styles.walletBalance}>
          <Text style={styles.balancePrimary}>
            ${activeWallet.balance ? usdBalance.toFixed(2) : "0.00"}
          </Text>

          <Text style={styles.balanceSecond}>
            BTC:
            <Text style={styles.balanceSecondary}> ${btcBalance > 0 ? btcBalance.toFixed(8) : "0.00"}</Text>
          </Text>
        </View>

        <View style={styles.walletOperation}>

          <TouchableOpacity style={styles.actionItem}>
            <View style={styles.iconCircle}>
              <Image source={require('../assets/send.png')} style={styles.image} resizeMode="contain" />
            </View>
            <Text style={styles.actionText}>Send</Text>
          </TouchableOpacity>

          <TouchableOpacity style={styles.actionItem}
            onPress={() => router.push('receive')}
          >
            <View style={styles.iconCircle}>
              <Image source={require('../assets/recieve.png')} style={styles.image} resizeMode="contain" />
            </View>
            <Text style={styles.actionText}>Receive</Text>
          </TouchableOpacity>

          <TouchableOpacity style={styles.actionItem}>
            <View style={styles.iconCircle}>
              <Image source={require('../assets/buy.png')} style={styles.image} resizeMode="contain" />
            </View>
            <Text style={styles.actionText}>Buy</Text>
          </TouchableOpacity>

          <TouchableOpacity style={styles.actionItem}
            onPress={() => router.push('swap')}
          >
            <View style={styles.iconCircle}>
              <Image source={require('../assets/swap.png')} style={styles.image} resizeMode="contain" />
            </View>
            <Text style={styles.actionText}>Swap</Text>
          </TouchableOpacity>

        </View>

        <View style={styles.transactionsWrapper}>

          {transactions.length === 0 ? (
            <View style={styles.bottomContainer}>
              <View style={styles.innerContainer}>
                <Image
                  source={require('../assets/hero.png')}
                  style={styles.heroImage}
                  resizeMode="contain"
                />
                <Text style={styles.heroTitle}>Get Started with BTC</Text>
                <Text style={styles.heroSubtitle}>
                  Add BTC to your wallet to begin trading and staking.
                </Text>
              </View>

              <TouchableOpacity style={styles.primaryButton}>
                <Text style={styles.primaryButtonText}>Buy BTC</Text>
              </TouchableOpacity>
            </View>
          ) : (
            <>
              <Text style={styles.sectionTitle}>Transaction History</Text>

              {transactions.slice(0, 5).map((tx, index) => {
                const isReceive = tx.received > tx.sent;
                const netSats = Math.abs(tx.received - tx.sent);
                const txBtc = netSats / SATS_PER_BTC;
                const txUsd = txBtc * liveBtcPrice;
                const isConfirmed = !!tx.confirmationTime;

                return (
                  <View key={tx.txid || index} style={styles.txRow}>
                    <View style={styles.txIconContainer}>
                      <Feather
                        name={isReceive ? "arrow-down-left" : "arrow-up-right"}
                        size={20}
                        color={isReceive ? "#4CAF50" : colors.text.primary}
                      />
                    </View>

                    <View style={styles.txCenter}>
                      <Text style={styles.txTitle}>{isReceive ? "Received BTC" : "Sent BTC"}</Text>
                      <Text style={[styles.txStatus, { color: isConfirmed ? colors.text.midgrey : colors.accent.primary }]}>
                        {isConfirmed ? formatTxDate(tx.confirmationTime) : "Pending confirmation..."}
                      </Text>
                    </View>

                    <View style={styles.txRight}>
                      <Text style={styles.txAmountBtc}>
                        {isReceive ? "+" : "-"}{txBtc.toFixed(8)}
                      </Text>
                      <Text style={styles.txAmountUsd}>
                        ${txUsd.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}
                      </Text>
                    </View>
                  </View>
                );
              })}
            </>
          )}
        </View>

      </ScrollView>
    </SafeAreaView>
  );
}

export default Dashboard;

const styles = StyleSheet.create({
  safeArea: {
    flex: 1,
    backgroundColor: '#0D0D0D',
  },
  container: {
    flexGrow: 1,
    paddingHorizontal: 20,
    paddingVertical: 45,
    backgroundColor: colors.background.default,

  },

  walletInfo: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 40,
  },
  activeProfile: {
    width: 45,
    height: 45,
    borderRadius: 22,
    backgroundColor: colors.accent.primary,
    justifyContent: 'center',
    alignItems: 'center',
  },
  profileInitials: {
    color: '#FFFFFF',
    fontSize: 16,
    fontWeight: '600',
  },
  nameContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 2,
  },
  walletNameText: {
    color: '#FFFFFF',
    fontSize: 16,
    fontWeight: '500',
  },

  walletBalance: {
    alignItems: 'center',
    marginBottom: 40,
  },
  balancePrimary: {
    color: '#FFFFFF',
    fontSize: 40,
    fontWeight: 'bold',
    marginBottom: 4,
  },
  balanceSecond: {
    color: colors.text.primary,
    fontSize: 16,
  },
  balanceSecondary: {
    color: colors.text.midgrey,
    fontSize: 16,
  },

  walletOperation: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    paddingHorizontal: 10,
    // marginBottom: 60,
  },
  actionItem: {
    alignItems: 'center',
    gap: 10,
  },
  iconCircle: {
    width: 64,
    height: 64,
    borderRadius: radii.md * 3,
    backgroundColor: colors.background.darkgrey,
    justifyContent: 'center',
    alignItems: 'center',
  },
  image: {
    width: 28,
    height: 28,
    tintColor: '#FF6B00',
  },
  actionText: {
    color: '#FF6B00',
    fontSize: 13,
    fontWeight: '500',
  },

  bottomContainer: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  innerContainer: {
    alignItems: 'center',
    marginBottom: 30,
  },
  heroImage: {
    width: 240,
    height: 240,
    marginBottom: -60,
  },
  heroTitle: {
    color: colors.text.primary,
    fontSize: 20,
    fontWeight: '700',
    marginBottom: 8,
  },
  heroSubtitle: {
    color: colors.text.midgrey,
    fontSize: 16,
    fontWeight: 500,
    textAlign: 'center',
    lineHeight: 22,
    paddingHorizontal: 20,
  },

  // Primary Button
  primaryButton: {
    backgroundColor: colors.accent.primary,
    width: 135,
    maxWidth: 200,
    paddingVertical: 16,
    paddingHorizontal: 16,
    borderRadius: radii.md,
    alignItems: 'center',
  },
  primaryButtonText: {
    color: '#FFFFFF',
    fontSize: 16,
    fontWeight: '700',
  },

  transactionsWrapper: {
    flex: 1,
    paddingBottom: 40,
  },
  sectionTitle: {
    color: '#FFFFFF',
    fontSize: 18,
    fontWeight: '600',
    marginBottom: 20,
    marginTop: 60,
  },
  txRow: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: colors.background.darkgrey,
    padding: 16,
    borderRadius: 16,
    marginBottom: 12,
  },
  txIconContainer: {
    width: 40,
    height: 40,
    borderRadius: 20,
    backgroundColor: 'rgba(255, 255, 255, 0.05)',
    justifyContent: 'center',
    alignItems: 'center',
    marginRight: 12,
  },
  txCenter: {
    flex: 1,
  },
  txTitle: {
    color: '#FFFFFF',
    fontSize: 15,
    fontWeight: '600',
    marginBottom: 4,
  },
  txStatus: {
    fontSize: 13,
  },
  txRight: {
    alignItems: 'flex-end',
  },
  txAmountBtc: {
    color: '#FFFFFF',
    fontSize: 15,
    fontWeight: '700',
    marginBottom: 4,
  },
  txAmountUsd: {
    color: colors.text.midgrey,
    fontSize: 13,
  },

  // OVERLAY STYLES
  loadingOverlay: {
    flex: 1,
    backgroundColor: 'rgba(10, 10, 10, 0.8)',
    justifyContent: 'center',
    alignItems: 'center',
    zIndex: 1000,
  },
  loadingText: {
    color: '#FFFFFF',
    marginTop: 16,
    fontSize: 16,
    fontWeight: '600',
  },
  dropdownOverlay: {
    flex: 1,
    justifyContent: 'flex-start',
    alignItems: 'center',
    paddingTop: 120, 
  },
  dropdownMenu: {
    backgroundColor: colors.background.default, 
    width: 250,
    borderRadius: radii.xl,
    padding: spacing.xl,
  },
  dropdownTitle: {
    color: colors.text.midgrey,
    fontSize: 12,
    fontWeight: '600',
    marginBottom: 8,
    textTransform: 'uppercase',
    letterSpacing: 1,
  },
  dropdownItem: {
    paddingVertical: 12,
  },
  dropdownItemText: {
    color: '#FFFFFF',
    fontSize: 16,
    fontWeight: '500',
  },
});