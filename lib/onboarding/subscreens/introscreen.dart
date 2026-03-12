import 'dart:async';
import 'dart:ui';
import 'package:bdk_flutter/bdk_flutter.dart';
import 'package:bitdevs_project/customutils/customitems.dart';
import 'package:bitdevs_project/onboarding/subscreens/proceedscreen.dart';
import 'package:bitdevs_project/onboarding/subscreens/restorewalletscreen.dart';
import 'package:bitdevs_project/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../statemanagement/wallet_controller.dart';


class Introscreen extends StatefulWidget {
  const Introscreen({super.key});

  @override
  State<Introscreen> createState() => _IntroscreenState();
}

class _IntroscreenState extends State<Introscreen> {
  final String fullText = "Secure.Simple.\nBitcoin made easy.";
  int visibleChars = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTyping();
  }

  void _startTyping() {
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (visibleChars < fullText.length) {
        setState(() {
          visibleChars++;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    String currentText = fullText.substring(0, visibleChars);
    return Scaffold(
      backgroundColor: kblackcolor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 90),
            Stack(
              children: [
                ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: customContainer(
                    size.height / 1.5,
                    size.width,
                    BoxDecoration(
                      color: kblackcolor,
                      image: const DecorationImage(
                        image: AssetImage('assets/bitcoinicon.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(),
                  ),
                ),
                Container(
                  height: size.height / 1.5,
                  width: size.width,
                  color: kblackcolor.withOpacity(0.4),
                ),
                SizedBox(
                  height: size.height / 1.6,
                  width: size.width,
                  child: Column(
                    children: [
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 0,
                          right: 16,
                        ),
                        child: RichText(
                          textAlign: TextAlign.start,
                          maxLines: 2,
                          text: TextSpan(
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 34,
                              height: 1.2,
                              letterSpacing: 0.0,
                            ),
                            children: [
                              TextSpan(
                                text: _getWhitePart(currentText),
                                style: TextStyle(
                                  color: kwhitecolors,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              TextSpan(
                                text: _getGrayPart(currentText),
                                style: const TextStyle(
                                  color: Colors.grey,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                          bottom: 20,
                          right: 16,
                          top: 8,
                        ),
                        child: RichText(
                          textAlign: TextAlign.start,
                          text: TextSpan(
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                            children: [
                              TextSpan(
                                text:
                                    "By tapping any button you agree and consent to our ",
                                style: TextStyle(color: Colors.grey),
                              ),
                              TextSpan(
                                text: "Terms of Services ",
                                style: TextStyle(color: Colors.white),
                              ),
                              TextSpan(
                                text: "and ",
                                style: TextStyle(color: Colors.grey),
                              ),
                              TextSpan(
                                text: "Privacy Policy",
                                style: TextStyle(color: kwhitecolors),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Consumer<WalletProvider>(
              builder: (context, walletProvider, child) {
                return GestureDetector(
                  onTap: walletProvider.isLoading
                      ? null
                      : () async {
                          final mnemonic = await walletProvider.createWallet(
                            network: Network.testnet,
                          );
                          if (mnemonic.isNotEmpty) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => Proceedscreen(),
                                ),
                              );
                            });
                          }
                        },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                    child: customContainer(
                      size.height / 16,
                      size.width * 0.9,
                      BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: korangeColor,
                      ),
                      Center(
                        child: walletProvider.isLoading
                            ? CircularProgressIndicator(color: kblackcolor)
                            : Text(
                                'Create a wallet',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  height: 1.2,
                                  letterSpacing: 0.0,
                                  color: kwhitecolors,
                                ),
                              ),
                      ),
                    ),
                  ),
                );
              },
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return Restorewalletscreen();
                    },
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: customContainer(
                  size.height / 20,
                  size.width * 0.9,
                  BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: kdarkgraycolor,
                  ),
                  Center(
                    child: Text(
                      'Import existing wallet',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        height: 1.2,
                        letterSpacing: 0.0,
                        color: kwhitecolors,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getWhitePart(String text) {
    const whiteText = "Secure.Simple.\nBitcoin";
    if (text.length <= whiteText.length) {
      return text;
    }
    return whiteText;
  }

  String _getGrayPart(String text) {
    const whiteText = "Secure.Simple.\nBitcoin";
    if (text.length > whiteText.length) {
      return text.substring(whiteText.length);
    }
    return "";
  }
}