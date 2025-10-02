import { StyleSheet, Text, View, ImageBackground, Image } from 'react-native'
import { Link } from 'expo-router'
import React from 'react'
import styles from './styles/aboutStyles'

const About = () => {
  return (
    <View style={styles.container}>
      <Text style={styles.title}> About page</Text>
      <Link href="/" style={styles.link}>Back Home</Link>
    </View>
  )
}

export default About

