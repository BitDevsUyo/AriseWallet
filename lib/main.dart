import 'package:bitdevs_project/core/cachemanager.dart';
import 'package:bitdevs_project/onboarding/statemanagement/wallet_controller.dart';
import 'package:bitdevs_project/onboarding/subscreens/splashscreen.dart';
import 'package:bitdevs_project/services/bdk_functions.dart';
import 'package:bitdevs_project/theme/colors.dart';
import 'package:bitdevs_project/theme/themecontroller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheManager().init();
  final themeProvider = ThemeProvider();
  await themeProvider.initTheme();
  final walletProvider = WalletProvider();
  await walletProvider.loadFromCache();
  WalletService.initBdk();
  /*if (kDebugMode) {
    const storage = FlutterSecureStorage();
    await storage.deleteAll();
    await CacheManager().clearAll();
    print('Debug mode: All data cleared!');
  }*/
  runApp(MyApp(themeProvider: themeProvider, walletProvider: walletProvider));
}

class MyApp extends StatelessWidget {
  final ThemeProvider themeProvider;
  final WalletProvider walletProvider;

  const MyApp({
    Key? key,
    required this.themeProvider,
    required this.walletProvider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: themeProvider),
        ChangeNotifierProvider.value(value: walletProvider),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, theme, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Bitcoin Wallet',
            themeMode: theme.themeMode,
            theme: AppThemes.lightTheme,
            darkTheme: AppThemes.darkTheme,
            home: Splashscreen(),
          );
        },
      ),
    );
  }
}
