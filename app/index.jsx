import { StyleSheet,  View, Image, } from 'react-native'
import React from 'react'
import { useEffect } from 'react'
import { useRouter } from 'expo-router'

const index = () => {
  const router = useRouter();

  useEffect(()=> {
    const redirect = setTimeout(()=> {
      router.replace('/welcome');
    }, 2500);

    return () => clearTimeout(redirect);
  }, [router]);

  return (
    <View style={styles.container}>
      <Image source={require('./assets/bitcoin.png')} style={styles.welcomeImage}/>
    </View>
  )
}

export default index

const styles = StyleSheet.create({
    container: {
        flex: 1,
        padding: 20,
        backgroundColor: '#FF6B00',
        justifyContent: 'center',
        alignItems: 'center',
    },
    welcomeImage: {
        width: 75.5,
        height: 100,
    }
})

