import { create } from 'zustand';
import * as SecureStore from 'expo-secure-store';
import { File, Directory, Paths } from "expo-file-system";
import { getElectrumBlockchain, buildAndSyncWallets } from '../utils/bdk';

export const useWalletStore = create((set, get) => ({

  activeWallet: {
    id: null,
    name: '',
    address: '',
    balance: 0,
    walletInstance: null, // The active BDK Rust object
    vaults: null,
    transactions: [],
    currentView: 'unified',
  },
  isAuthenticated: false,
  isSynced: false,
  isSyncing: false,

  liveBtcPrice: 0,

  onboarding: {
    mnemonic: '',
    name: '',
    passcode: '',
    biometricsEnabled: false,
  },

  fetchLivePrice: async () => {
    try {
      const response = await fetch('https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies=usd');
      const data = await response.json();

      if (data && data.bitcoin && data.bitcoin.usd) {
        set({ liveBtcPrice: data.bitcoin.usd });
        console.log("Global BTC Price Updated:", data.bitcoin.usd);
        return true;
      }
      return false;
    } catch (error) {
      console.error("Failed to fetch global BTC price", error);
      if (get().liveBtcPrice === 0) {
        set({ liveBtcPrice: 0 });
      }
      return false;
    }
  },

  // onboarding action

  updateOnboarding: (key, value) => set((state) => ({
    onboarding: { ...state.onboarding, [key]: value }
  })),

  finalizeAndSaveWallet: async () => {
    const { onboarding } = get();

    await SecureStore.setItemAsync('wallet_mnemonic', onboarding.mnemonic);
    await SecureStore.setItemAsync('wallet_passcode', onboarding.passcode);
    await SecureStore.setItemAsync('wallet_name', onboarding.name);

    set((state) => ({
      activeWallet: { ...state.activeWallet, name: onboarding.name },
      isAuthenticated: true,
      onboarding: { mnemonic: '', name: '', passcode: '', biometricsEnabled: false }
    }));
  },


  setWalletSession: (walletInstance, vaults, balance, addr) => set((state) => ({
    activeWallet: {
      ...state.activeWallet,
      walletInstance: walletInstance,
      vaults: vaults,
      balance: balance,
      address: addr,
    },
    isSynced: true
  })),

  updateBalance: (newBalance) => set((state) => ({
    activeWallet: { ...state.activeWallet, balance: newBalance }
  })),

  syncWallet: async () => {
    const { activeWallet, updateBalance, isSyncing } = get();

    if (!activeWallet || !activeWallet.walletInstance) return false;
    if (isSyncing) {
      console.log("Already syncing. Ignoring duplicate request.");
      return false;
    }

    try {
      set({ isSyncing: true });
      console.log("Starting pull-to-refresh sync...");

      const blockchain = await getElectrumBlockchain();
      const { legacy, nested, native, taproot } = activeWallet.vaults;

      // await Promise.all([
      //   legacy.sync(blockchain),
      //   nested.sync(blockchain),
      //   native.sync(blockchain),
      //   taproot.sync(blockchain)
      // ]);
      await legacy.sync(blockchain);
      await nested.sync(blockchain);
      await native.sync(blockchain);
      await taproot.sync(blockchain);

      const b44 = (await legacy.getBalance()).total;
      const b49 = (await nested.getBalance()).total;
      const b84 = (await native.getBalance()).total;
      const b86 = (await taproot.getBalance()).total;

      const newTotalBalance = b44 + b49 + b84 + b86;

      console.log(`Refresh complete! New total balance: ${newTotalBalance} sats`);
      updateBalance(newTotalBalance);
      get().loadTransactions();
      set({ isSyncing: false });

      return true;

    } catch (error) {
      console.error("Failed to sync wallet during refresh:", error);
      set({ isSyncing: false });
      return false;
    }
  },

  switchAndSyncVault: async (vaultKey) => {
    const { activeWallet,  syncWallet, loadTransactions } = get();
    if (!activeWallet || !activeWallet.vaults) return false;

    try {
      if (vaultKey === 'unified') {
        console.log("Zooming out to Unified view...");
        set((state) => ({
          activeWallet: {
            ...state.activeWallet,
            name: 'Main Wallet',
            currentView: 'unified',
            walletInstance: activeWallet.vaults.taproot, 
          }
        }));
        return await syncWallet(); 
      }

      set({ isSyncing: true });
      console.log(`Switching to ${vaultKey} vault...`);

      const selectedVault = activeWallet.vaults[vaultKey];
      const blockchain = await getElectrumBlockchain();

      await selectedVault.sync(blockchain);

      const vaultBalance = (await selectedVault.getBalance()).total;
      const addrInfo = await selectedVault.getAddress();
      const vaultAddress = await addrInfo.address.asString();

      set((state) => ({
        activeWallet: {
          ...state.activeWallet,
          name: vaultKey.charAt(0).toUpperCase() + vaultKey.slice(1) + ' Wallet',
          walletInstance: selectedVault,
          balance: vaultBalance,
          address: vaultAddress,
          currentView: vaultKey,
        },
      }));

      loadTransactions(); 
      set({ isSyncing: false });
      return true;

    } catch (error) {
      console.error(`Failed to switch to ${vaultKey}:`, error);
      set({ isSyncing: false });
      return false;
    }
  },

  loadTransactions: async () => {
    const { activeWallet } = get();
    if (!activeWallet || !activeWallet.vaults) return;

    try {
      const { legacy, nested, native, taproot } = activeWallet.vaults;

      let combinedHistory = [];

      if (activeWallet.currentView === 'unified') {
        const [tx44, tx49, tx84, tx86] = await Promise.all([
          legacy.listTransactions(true),
          nested.listTransactions(true),
          native.listTransactions(true),
          taproot.listTransactions(true)
        ]);

        combinedHistory = [...tx44, ...tx49, ...tx84, ...tx86];
      }else {
        const selectedVault = activeWallet.vaults[activeWallet.currentView];
        combinedHistory = await selectedVault.listTransactions(true);
      }

      const sortedTxs = combinedHistory.sort((a, b) => {
        const timeA = a.confirmationTime?.timestamp || Infinity;
        const timeB = b.confirmationTime?.timestamp || Infinity;
        return timeB - timeA;
      });

      set((state) => ({
        activeWallet: { ...state.activeWallet, transactions: sortedTxs }
      }));
    } catch (error) {
      console.error("Failed to load transactions", error);
    }
  },

  clearSession: async () => {
    try {
      await SecureStore.deleteItemAsync('wallet_mnemonic');
      await SecureStore.deleteItemAsync('wallet_passcode');
      await SecureStore.deleteItemAsync('wallet_name');

      if (Paths.document) {
        const contents = Paths.document.list();

        for (const item of contents) {
          if (item instanceof File && item.name.startsWith('bdk-') && item.name.endsWith('.sqlite')) {
            try {
              item.delete();
              console.log(`Deleted ghost database: ${item.name}`);
            } catch (deleteErr) {
              console.log(`Skipped ${item.name} (Likely already deleted or locked).`);
            }
          }
        }
      }

      set({
        activeWallet: { id: null, name: '', address: '', balance: 0, walletInstance: null, vaults: null, transactions: [], currentView: 'unified' },
        onboarding: { mnemonic: '', name: '', passcode: '', biometricsEnabled: false },
        isAuthenticated: false,
        isSynced: false,
        liveBtcPrice: 0,
      });
      console.log("Session and secure storage completely cleared.");
    } catch (error) {
      console.error("Failed to clear secure storage:", error);
    }
  },

  rehydrateWallet: async () => {
    if (get().activeWallet?.walletInstance) {
      return true;
    }
    try {
      console.log("Checking SecureStore for existing wallet...");

      const savedMnemonic = await SecureStore.getItemAsync('wallet_mnemonic');
      const savedName = await SecureStore.getItemAsync('wallet_name');

      if (savedMnemonic) {
        console.log("Wallet found! Rebuilding BDK instance...");

        const { activeWalletInstance, vaults, totalBalance, receiveAddress } = await buildAndSyncWallets(savedMnemonic, true);

        set((state) => ({
          activeWallet: {
            ...state.activeWallet,
            name: savedName || 'Main Wallet',
            walletInstance: activeWalletInstance,
            vaults: vaults,
            balance: totalBalance,
            address: receiveAddress,
          },
          isAuthenticated: false,
          isSynced: true
        }));

        console.log("Rehydration complete!");
        return true;
      }

      console.log("No saved wallet found.");
      return false;

    } catch (error) {
      console.error("Failed to rehydrate wallet:", error);
      return false;
    }
  },


}));