import { StyleSheet, Text, TextInput, TouchableOpacity, View,} from 'react-native'
import { Link } from 'expo-router'
import React from 'react'
import styles from './styles/importStyles'

const Import = () => {

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

        <TouchableOpacity style={styles.primaryButton}>
          <Link href="#" style={styles.primaryButtonText}>Import Recovery Phrase</Link>
        </TouchableOpacity>

      </View>

    </View>
  )
}

export default Import

