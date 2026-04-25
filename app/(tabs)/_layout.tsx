import { View, Image } from 'react-native'
import { Tabs } from "expo-router";
import { useEffect } from 'react';
import { colors } from "../../src/theme";
import { useWalletStore } from '../../src/store/walletStore';



export default function TabLayout() {
  const fetchLivePrice = useWalletStore((state) => state.fetchLivePrice);
  useEffect(() => {
    fetchLivePrice(); 
    const priceInterval = setInterval(fetchLivePrice, 60000); 

    return () => clearInterval(priceInterval); 
  }, []);

  return (
    <View style={{ flex: 1, backgroundColor: '#0D0D0D' }}>
      <Tabs

        screenOptions={{
          headerShown: false,
          sceneStyle: { backgroundColor: '#0D0D0D' },
          tabBarStyle: {
            backgroundColor: colors.background.default,
            borderTopWidth: 1,
            borderLeftWidth: 1,
            borderRightWidth: 1,
            borderBottomWidth: 0,
            borderColor: colors.background.darkgrey,
            height: 71,
            paddingTop: 10,
            paddingBottom: 12,
            marginHorizontal: -1,
            borderRadius: 15,
          },
          tabBarActiveTintColor: colors.accent.primary,
          tabBarInactiveTintColor: colors.text.secondary,
          tabBarLabelStyle: {
            fontFamily: "Raleway-SemiBold",
            fontSize: 12,
          },
        }}

      >
        <Tabs.Screen
          name="index"
          options={{
            title: "Home",
            tabBarIcon: ({ color, focused }) => (
              <Image
                source={require("../assets/home.png")}
                style={{
                  width: focused ? 28 : 22,
                  height: focused ? 28 : 22,
                  tintColor: focused ? colors.accent.primary : colors.background.darkgrey,
                }}
              />
            )
          }}
        />
        <Tabs.Screen
          name="swap"
          options={{
            title: "Swap",
            tabBarIcon: ({ color, focused }) => (
              <Image
                source={require("../assets/swap.png")}
                style={{
                  width: focused ? 28 : 22,
                  height: focused ? 28 : 22,
                  tintColor: focused ? colors.accent.primary : colors.text.secondary,
                }}
              />
            )

          }}
        />
        <Tabs.Screen
          name="explore"
          options={{
            title: "Explore",
            tabBarIcon: ({ color, focused }) => (
              <Image
                source={require("../assets/explore.png")}
                style={{
                  width: focused ? 28 : 22,
                  height: focused ? 28 : 22,
                  tintColor: focused ? colors.accent.primary : colors.text.secondary,
                }}
              />
            )
          }}
        />
        <Tabs.Screen
          name="settings"
          options={{
            title: "Settings",
            tabBarIcon: ({ color, focused }) => (
              <Image
                source={require("../assets/settings.png")}
                style={{
                  width: focused ? 28 : 22,
                  height: focused ? 28 : 22,
                  tintColor: focused ? colors.accent.primary : colors.text.secondary,
                }}
              />
            )
          }}
        />
      </Tabs>
    </View>

  );
}
