import 'package:bitdevs_project/customutils/customitems.dart';
import 'package:bitdevs_project/onboarding/subscreens/setpinscreen.dart';
import 'package:bitdevs_project/theme/colors.dart';
import 'package:flutter/material.dart';

class Namewalletscreen extends StatefulWidget {
  const Namewalletscreen({super.key});
  @override
  State<Namewalletscreen> createState() => _NamewalletscreenState();
}

class _NamewalletscreenState extends State<Namewalletscreen> {
  final TextEditingController _nameWalletController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: kblackcolor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kblackcolor,
        centerTitle: false,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 20),
            child: Row(
              children: [
                Text(
                  'Name your Wallet',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontSize: 29,
                    color: kwhitecolors,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Aeonik",
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              children: [
                Text(
                  'This helps you manage multiple wallets easily.',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontSize: 15,
                    color: kbuttonGraycolor,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Aeonik",
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 40),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: TextFormField(
              style: theme.textTheme.titleLarge?.copyWith(
                  fontSize: 15,
                  color: kwhitecolors,
                  fontWeight: FontWeight.normal,
                  fontFamily: "Aeonik",
                ),
              controller: _nameWalletController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {},
              decoration: InputDecoration(
                hintText: "Enter your wallet name",
                hintStyle: theme.textTheme.titleLarge?.copyWith(
                  fontSize: 15,
                  color: kwhitecolors,
                  fontWeight: FontWeight.normal,
                  fontFamily: "Aeonik",
                ),
                
                filled: true,
                fillColor: kgraycolor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 18,
                ),

                errorMaxLines: 2,
              ),
            ),
          ),
          SizedBox(height: 400),
          InkWell(
            onTap: () {
              if (_nameWalletController.text.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SetPinScreen(
                        walletName: _nameWalletController.text.trim(),
                      );
                    },
                  ),
                );
              } else {
                showCustomSnackBar(context, "Please input your wallet Name");
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
