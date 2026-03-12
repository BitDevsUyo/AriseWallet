import 'package:bitdevs_project/customutils/customitems.dart';
import 'package:bitdevs_project/dashboard/dashboardscreen.dart';
import 'package:bitdevs_project/theme/colors.dart';
import 'package:bitdevs_project/utils/constants.dart';
import 'package:flutter/material.dart';

class WalletReadyScreen extends StatefulWidget {
  const WalletReadyScreen({super.key});

  @override
  State<WalletReadyScreen> createState() => _WalletReadyScreenState();
}

class _WalletReadyScreenState extends State<WalletReadyScreen> {
 @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kblackcolor,
      appBar: AppBar(backgroundColor: ktransparentcolor),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 60),
            customContainer(
              230,
              220,
              BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(AppImages().readyImage),
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
                    'Your Wallet Is Ready!',
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
                  'You’ve successfully created a new wallet.Ready to enjoy secure, easy transactions?. ',
                  style: TextStyle(color: Colors.grey[500], fontSize: 15),
                ),
              ),
            ),
        
            SizedBox(height: 200),
            Center(
              child: InkWell(
                onTap: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) =>DashboardScreen()),
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
                    child: Text('Get Started', style: TextStyle(color: kwhitecolors,fontWeight: FontWeight.w700)),
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