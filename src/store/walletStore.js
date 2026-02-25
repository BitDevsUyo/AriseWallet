import { create } from 'zustand';
import * as SecureStore from 'expo-secure-store';

export const useWalletStore = create((set, get) => ({

  // activate app state (The unlocked wallet)
  activeWallet: {
    id: null,
    name: '',
    address: '',
    balance: 0,
    walletInstance: null, // The active BDK Rust object
  },
  isAuthenticated: false, // True when user enters correct passcode/FaceID
  isSynced: false,

  // temp onboarding state
  onboarding: {
    mnemonic: '',
    name: '',
    passcode: '',
    biometricsEnabled: false,
  },

  // onboarding action
  
  updateOnboarding: (key, value) => set((state) => ({
    onboarding: { ...state.onboarding, [key]: value }
  })),

  finalizeAndSaveWallet: async () => {
    const { onboarding } = get();
    
    // Save to device's secure vault
    await SecureStore.setItemAsync('wallet_mnemonic', onboarding.mnemonic);
    await SecureStore.setItemAsync('wallet_passcode', onboarding.passcode);
    await SecureStore.setItemAsync('wallet_name', onboarding.name);

    // Move to active state & wipe onboarding memory
    set((state) => ({
      activeWallet: { ...state.activeWallet, name: onboarding.name },
      isAuthenticated: true,
      onboarding: { mnemonic: '', name: '', passcode: '', biometricsEnabled: false } 
    }));
  },

  // activate wallet

  setWalletSession: (walletInstance, balance, addr) => set((state) => ({
    activeWallet: {
      ...state.activeWallet,
      walletInstance: walletInstance,
      balance: balance,
      address: addr,
    },
    isSynced: true
  })),

  updateBalance: (newBalance) => set((state) => ({
    activeWallet: { ...state.activeWallet, balance: newBalance }
  })),

  clearSession: () => set({
    activeWallet: { id: null, name: '', address: '', balance: 0, walletInstance: null },
    isAuthenticated: false,
    isSynced: false,
  }),

  // We will build this out later when we make the "Login" screen
  loadWalletFromStorage: async () => {
    const savedName = await SecureStore.getItemAsync('wallet_name');
    if (savedName) {
      set((state) => ({ activeWallet: { ...state.activeWallet, name: savedName } }));
    }
  }
}));