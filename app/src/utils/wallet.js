import * as bip39 from 'bip39';
import * as bitcoin from 'bitcoinjs-lib';
import * as SecureStore from 'expo-secure-store';

export const createWallet = async () => {
  // Generate the users 12 word mnemonic
  // 128 bits entropy  12 words
  const mnemonic = bip39.generateMnemonic(128); 
  const seed = await bip39.mnemonicToSeed(mnemonic);

  // Create he users Bitcoin HD wallet
  const root = bitcoin.bip32.fromSeed(seed);
  const keyPair = root.derivePath("m/44'/0'/0'/0/0");
  const { address } = bitcoin.payments.p2pkh({ pubkey: keyPair.publicKey });

  // Store mnemonic securely
  await SecureStore.setItemAsync('mnemonic', mnemonic);

  return { mnemonic, address };
};

export const getStoredMnemonic = async () => {
  return await SecureStore.getItemAsync('mnemonic');
};
