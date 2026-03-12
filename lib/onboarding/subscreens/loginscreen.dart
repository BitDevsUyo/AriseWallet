import 'package:bitdevs_project/customutils/customitems.dart';
import 'package:bitdevs_project/dashboard/dashboardscreen.dart';
import 'package:bitdevs_project/onboarding/statemanagement/wallet_controller.dart';
import 'package:bitdevs_project/theme/colors.dart';
import 'package:bdk_flutter/bdk_flutter.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _pinController = TextEditingController();
  final LocalAuthentication _localAuth = LocalAuthentication();
  String _currentPin = "";
  bool _isLoading = false;
  bool _biometricAvailable = false;

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
    WidgetsBinding.instance.addPostFrameCallback((_) => _tryBiometric());
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

Future<void> _checkBiometrics() async {
  try {
    final canCheck = await _localAuth.canCheckBiometrics;
    final isSupported = await _localAuth.isDeviceSupported();
    final enrolled = await _localAuth.getAvailableBiometrics(); 

    if (mounted) {
      setState(() =>
        _biometricAvailable = canCheck && isSupported && enrolled.isNotEmpty,
      );
    }
  } catch (_) {
    if (mounted) setState(() => _biometricAvailable = false);
  }
}
  Future<void> _tryBiometric() async {
    if (!_biometricAvailable) return;
    try {
      final authenticated = await _localAuth.authenticate(
        localizedReason: 'Authenticate to access your wallet',
        options: const AuthenticationOptions(
          biometricOnly: false,
          stickyAuth: true,
        ),
      );
      if (authenticated && mounted) {
        await _syncAndNavigate();
      }
    } catch (_) {}
  }

  Future<void> _verifyPin() async {
    if (_currentPin.length < 4) {
      if (mounted) showCustomSnackBar(context, "Please enter your 4-digit passcode");
      return;
    }

    final walletProvider = context.read<WalletProvider>();

    if (!mounted) return;

    /*if (!isValid) {
      showCustomSnackBar(context, "Incorrect passcode. Try again.");
      setState(() {
        _currentPin = "";
        _pinController.clear();
      });
      return;
    }*/

    await _syncAndNavigate();
  }

  Future<void> _syncAndNavigate() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    final walletProvider = context.read<WalletProvider>();
    await walletProvider.syncWallet(network: Network.testnet);

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (walletProvider.error != null) {
      if (mounted) showCustomSnackBar(context, walletProvider.error!);
      return;
    }

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => DashboardScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: kblackcolor,
      appBar: AppBar(
        backgroundColor: kblackcolor,
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              Container(
                height: 72,
                width: 72,
                decoration: BoxDecoration(
                  color: kgraycolor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.lock_outline_rounded,
                  color: korangeColor,
                  size: 36,
                ),
              ),

              const SizedBox(height: 20),

              Text(
                'Welcome Back',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontSize: 26,
                  color: kwhitecolors,
                  fontWeight: FontWeight.w700,
                  fontFamily: "Aeonik",
                ),
              ),

              const SizedBox(height: 6),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  textAlign: TextAlign.center,
                  'Enter your passcode to unlock your wallet',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 15,
                    color: kbuttonGraycolor,
                    fontWeight: FontWeight.normal,
                    fontFamily: "Aeonik",
                  ),
                ),
              ),

              const SizedBox(height: 32),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: SizedBox(
                    width: 240,
                    child: PinCodeTextField(
                      controller: _pinController,
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
                        selectedColor: korangeColor,
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
                        setState(() => _currentPin = value);
                      },
                      onCompleted: (_) => _verifyPin(),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              InkWell(
                onTap: _isLoading ? null : _verifyPin,
                child: customContainer(
                  50,
                  size.width * 0.9,
                  BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: korangeColor,
                  ),
                  Center(
                    child: _isLoading
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : Text(
                            'Unlock Wallet',
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

              const SizedBox(height: 24),

              if (_biometricAvailable)
                GestureDetector(
                  onTap: _tryBiometric,
                  child: Column(
                    children: [
                      Container(
                        height: 56,
                        width: 56,
                        decoration: BoxDecoration(
                          color: kgraycolor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.fingerprint_rounded,
                          color: korangeColor,
                          size: 30,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Use Biometrics',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: kbuttonGraycolor,
                          fontFamily: "Aeonik",
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(color: korangeColor),
              ),
            ),
        ],
      ),
    );
  }
}