import 'package:bdk_flutter/bdk_flutter.dart';
import 'package:bitdevs_project/dashboard/navcontoller_screen.dart';
import 'package:bitdevs_project/onboarding/statemanagement/wallet_controller.dart';
import 'package:bitdevs_project/onboarding/subscreens/introscreen.dart';
import 'package:bitdevs_project/theme/colors.dart';
import 'package:bitdevs_project/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    scaleAnimation = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
    );
    animationController.repeat(reverse: true);
    Future.delayed(const Duration(seconds: 1), _handleNavigation);
  }

  Future<void> _handleNavigation() async {
    if (!mounted) return;

    final walletProvider = context.read<WalletProvider>();
    await walletProvider.loadFromCache();

    if (!mounted) return;

    if (walletProvider.hasWallet) {
      await walletProvider.syncWallet(network: Network.testnet);
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => NavControllerScreen()),
        (route) => false,
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const Introscreen()),
        (route) => false,
      );
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: korangeColor,
      body: Center(
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppImages().introIcon),
              ),
            ),
          ),
        ),
      ),
    );
  }
}