import { StyleSheet, Text, View, TouchableOpacity, Alert } from 'react-native'
import React from 'react'
import { useRouter } from 'expo-router';
import { useWalletStore } from '../../src/store/walletStore';

const settings = () => {
  const router = useRouter();
  const clearSession = useWalletStore((state) => state.clearSession);

  const handleLogout = () => {
    Alert.alert(
      "Remove Wallet",
      "Are you sure you want to log out? This will remove your wallet from this device. Make sure you have your 12-word recovery phrase written down, or you will lose access to your funds!",
      [
        { 
          text: "Cancel", 
          style: "cancel" 
        },
        {
          text: "Yes, Log Out",
          style: "destructive", 
          onPress: async () => {
            await clearSession();
            router.push('/welcome');  
          }
        }
      ]
    );
  };

  return (
    <View style={styles.container}>
      <TouchableOpacity 
        style={styles.logout}
        onPress={handleLogout}
      >
        <Text style={styles.logoutText}>Log Out</Text>
      </TouchableOpacity>
    </View>
  )
}

export default settings

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#0D0D0D' 
  },
  logout: {
    backgroundColor: '#FF3B30', 
    paddingVertical: 16,
    paddingHorizontal: 32,
    borderRadius: 12,
  },
  logoutText: {
    color: '#ffffff',
    fontSize: 18,
    fontWeight: '600'
  },
})