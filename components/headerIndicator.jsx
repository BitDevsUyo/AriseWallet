import { View, StyleSheet, Animated } from "react-native";
import React, { useEffect, useRef } from "react";

export default function HeaderIndicator({ active = 1 }) {
  const translateX = useRef(new Animated.Value(0)).current;

  useEffect(() => {
    Animated.spring(translateX, {
      toValue: active === 1 ? 0 : 22, 
      useNativeDriver: true,
      bounciness: 6,
    }).start();
  }, [active]);

  return (
    <View style={styles.container}>

      <View style={styles.bar} />
      <View style={styles.bar} />

      <Animated.View
        style={[
          styles.thumb,
          { transform: [{ translateX }] }
        ]}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    width: 40,
    height: 6,
    position: "relative",
    flexDirection: "row",
    justifyContent: "space-between",
    alignItems: "center",
  },
  bar: {
    width: 16,
    height: 3,
    borderRadius: 2,
    backgroundColor: '#1C1C1C',
  },
  thumb: {
    position: "absolute",
    width: 16,
    height: 3,
    borderRadius: 2,
    backgroundColor: "#ffffff",
  },
});
