import 'package:bitdevs_project/customutils/customitems.dart';
import 'package:bitdevs_project/onboarding/statemanagement/wallet_controller.dart';
import 'package:bitdevs_project/onboarding/subscreens/wallet_readyscreen.dart';
import 'package:bitdevs_project/services/biometrics.dart';
import 'package:bitdevs_project/theme/colors.dart';
import 'package:bitdevs_project/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Enablebioscreen extends StatefulWidget {
  const Enablebioscreen({super.key});

  @override
  State<Enablebioscreen> createState() => _EnablebioscreenState();
}

class _EnablebioscreenState extends State<Enablebioscreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final walletProvider = Provider.of<WalletProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: kblackcolor,
      appBar: AppBar(backgroundColor: ktransparentcolor),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40),
            customContainer(
              250,
              220,
              BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(AppImages().padlockImage),
                  fit: BoxFit.fitHeight,
                ),
              ),
              Center(),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  Text(
                    'Protect your wallet',
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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  'Choose an authentication method for wallet security and easy log in ',
                  style: TextStyle(color: Colors.grey[500], fontSize: 15),
                ),
              ),
            ),
            SizedBox(height: 40),
            Center(
              child: customContainer(
                60,
                size.width * 0.9,
                BoxDecoration(
                  color: kgraycolor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(AppImages().bioImages),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 13),
                          child: Text(
                            'Enable biometrics',
                            style: TextStyle(
                              color: kwhitecolors,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Switch(
                        value: false,
                        onChanged: (val) async {
                          if (appBiometrics.canAuthenticate) {
                            await walletProvider.updateBiometrics(val);
                            showCustomSnackBar(context, "Biometrics Enabled");
                          } else {
                            showCustomSnackBar(
                              context,
                              "Biometrics not available on this device",
                            );
                          }
                        },
                        activeColor: kwhitecolors,
                        activeTrackColor: kblackcolor,
                        inactiveThumbColor: kgraycolor,
                        inactiveTrackColor: kwhitecolors,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            /*SizedBox(height:10,),
            Center(
              child: customContainer(
                60,
                size.width * 0.9,
                BoxDecoration(
                  color: kgraycolor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(AppImages().passwordCodeImage),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 13),
                          child: Text(
                            'Continue with passcode',
                            style: TextStyle(color: kwhitecolors),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Switch(
                        value: true,
                        onChanged: (val) {},
                        activeColor: kwhitecolors,
                        activeTrackColor: kblackcolor,
                        inactiveThumbColor: kgraycolor,
                        inactiveTrackColor: kwhitecolors,
                      ),
                    ),
                  ],
                ),
              ),
            ),*/
            SizedBox(height: 90),
            Center(
              child: InkWell(
                onTap: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => WalletReadyScreen()),
                  (route) => false, 
                ),

                child: customContainer(
                  55,
                  size.width * 0.9,
                  BoxDecoration(
                    color: korangeColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  Center(
                    child: Text(
                      'Proceed',
                      style: TextStyle(color: kwhitecolors),
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
}
