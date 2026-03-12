import 'dart:developer' as dev;

import 'package:bdk_flutter/bdk_flutter.dart';
import 'package:bitdevs_project/customutils/customitems.dart';
import 'package:bitdevs_project/onboarding/statemanagement/wallet_controller.dart';
import 'package:bitdevs_project/onboarding/subscreens/enablebioscreen.dart';
import 'package:bitdevs_project/theme/colors.dart';
import 'package:bitdevs_project/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SyncingScreen extends StatefulWidget {
  const SyncingScreen({super.key});

  @override
  State<SyncingScreen> createState() => _SyncingScreenState();
}

class _SyncingScreenState extends State<SyncingScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  bool _syncDone = false;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _progressController = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 0.85).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeOut),
    );
    _progressController.forward();
    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed && _syncDone) {
        _completeAndNavigate();
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _sync();
    });
  }

  Future<void> _sync() async {
    final walletProvider = Provider.of<WalletProvider>(context, listen: false);
    await walletProvider.syncWallet(network: Network.testnet);
    if (!mounted) return;

    if (walletProvider.error != null) {
      showCustomSnackBar(context, walletProvider.error!);
      return;
    }
    _syncDone = true;
    if (_progressController.isCompleted) {
      _completeAndNavigate();
    }
  }

  Future<void> _completeAndNavigate() async {
    if (!mounted) return;
    await _progressController.animateTo(
      1.0,
      duration: const Duration(milliseconds: 400),
    );

    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => Enablebioscreen()),
      (route) => false,
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kblackcolor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  AnimatedBuilder(
                    animation: Listenable.merge([
                      _pulseAnimation,
                      _progressAnimation,
                    ]),
                    builder: (context, child) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          Transform.scale(
                            scale: _pulseAnimation.value,
                            child: Container(
                              width: 160,
                              height: 160,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: kgraycolor.withOpacity(0.08),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 110,
                            height: 110,
                            child: CircularProgressIndicator(
                              value: _progressAnimation.value,
                              strokeWidth: 3.5,
                              backgroundColor: kgraycolor.withOpacity(0.2),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                kwhitecolors,
                              ),
                              strokeCap: StrokeCap.round,
                            ),
                          ),
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(AppImages().introIcon),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  Text(
                    'Importing Wallet....',
                    style: TextStyle(
                      color: kwhitecolors,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  Text(
                    'This may take a few seconds. Please don\'t\nclose the app',
                    style: TextStyle(color: Colors.grey[500], fontSize: 15),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
