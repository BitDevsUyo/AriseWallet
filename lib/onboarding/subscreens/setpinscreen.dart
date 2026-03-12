import 'package:bdk_flutter/bdk_flutter.dart';
import 'package:bitdevs_project/customutils/customitems.dart';
import 'package:bitdevs_project/onboarding/statemanagement/wallet_controller.dart';
import 'package:bitdevs_project/onboarding/subscreens/syncwallet.dart';
import 'package:bitdevs_project/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class SetPinScreen extends StatefulWidget {
  final String walletName;
  const SetPinScreen({super.key, required this.walletName});

  @override
  State<SetPinScreen> createState() => _SetPinScreenState();
}

class _SetPinScreenState extends State<SetPinScreen> {
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _confirmPinController = TextEditingController();
  bool _confirmPasscode = false;
  String _firstPin = "";
  String _currentPin = "";
  @override
  void dispose() {
    //_pinController.dispose();
    // _confirmPinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final walletProvider = Provider.of<WalletProvider>(context);

    return Scaffold(
      backgroundColor: kblackcolor,
      appBar: AppBar(
        backgroundColor: kblackcolor,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Center(
            child: Text(
              _confirmPasscode ? 'Confirm your Passcode' : 'Create Passcode',
              style: theme.textTheme.titleLarge?.copyWith(
                fontSize: 26,
                color: kwhitecolors,
                fontWeight: FontWeight.w700,
                fontFamily: "Aeonik",
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 8, top: 5),
              child: Text(
                textAlign: TextAlign.center,
                'This passcode helps prevent unauthorized access and confirms your transactions',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontSize: 15,

                  color: kbuttonGraycolor,
                  fontWeight: FontWeight.normal,
                  fontFamily: "Aeonik",
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: SizedBox(
                width: 240,
                child: PinCodeTextField(
                  controller: _confirmPasscode
                      ? _confirmPinController
                      : _pinController,
                  appContext: context,
                  length: 4,
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  animationType: AnimationType.fade,
                  backgroundColor: Colors.transparent,
                  enableActiveFill: true,
                  cursorColor: Colors.white,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(10),
                    fieldHeight: 60,
                    fieldWidth: 50,
                    borderWidth: 1,
                    inactiveColor: kgraycolor,
                    selectedColor: kgraycolor,
                    activeColor: kgraycolor,
                    inactiveFillColor: kgraycolor,
                    selectedFillColor: kgraycolor,
                    activeFillColor: kgraycolor,
                  ),
                  textStyle: theme.textTheme.titleLarge?.copyWith(
                    fontSize: 18,
                    color: korangeColor,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Aeonik",
                  ),
                  onChanged: (value) {
                    setState(() {
                      _currentPin = value;
                    });
                  },
                ),
              ),
            ),
          ),
          SizedBox(height: 380),
          InkWell(
            onTap: () async {
              if (!_confirmPasscode) {
                if (_currentPin.length == 4) {
                  setState(() {
                    _firstPin = _currentPin;
                    _currentPin = "";
                    _confirmPasscode = true;
                    _pinController.clear();
                  });
                } else {
                  showCustomSnackBar(
                    context,
                    "Please enter a 4-digit passcode",
                  );
                }
              } else {
                if (_currentPin.length < 4) {
                  showCustomSnackBar(context, "Please complete your passcode");
                  return;
                }
                if (_currentPin != _firstPin) {
                  showCustomSnackBar(context, "Passcode does not match");
                  setState(() {
                    _firstPin = "";
                    _currentPin = "";
                    _confirmPasscode = false;
                    _pinController.clear();
                    _confirmPinController.clear();
                  });
                  return;
                }
                await walletProvider.saveWalletNameAndPasscode(
                  walletName: widget.walletName,
                  passcode: _currentPin,
                );

                if (!mounted) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SyncingScreen()),
                );

                walletProvider.syncWallet(network: Network.testnet);
                if (walletProvider.error != null) {
                  showCustomSnackBar(context, walletProvider.error!);
                  return;
                }
                debugPrint(
                  "Saved! Name: ${widget.walletName}, Pin: $_currentPin",
                );
                if (!mounted) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SyncingScreen()),
                );
              }
            },
            child: customContainer(
              50,
              size.width * 0.9,
              BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: korangeColor,
              ),
              Center(
                child: Text(
                  'Proceed',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontSize: 15,
                    color: kwhitecolors,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Aeonik",
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
