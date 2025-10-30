// ignore_for_file: sort_child_properties_last, use_build_context_synchronously

import 'package:bitdevs_project/customutils/customitems.dart';
import 'package:bitdevs_project/onboarding/statemanagement/walletprovider.dart';
import 'package:flutter/material.dart';
import 'package:bitdevs_project/theme/colors.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Proceedscreen extends StatefulWidget {
  const Proceedscreen({super.key});

  @override
  State<Proceedscreen> createState() => _ProceedscreenState();
}

class _ProceedscreenState extends State<Proceedscreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _goToNextPage() {
    if (_currentPage < 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 5),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kblackcolor,
      appBar: AppBar(
        backgroundColor: kblackcolor,
        iconTheme: IconThemeData(color: kwhitecolors),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 90),
                child: SmoothPageIndicator(
                  controller: _pageController,
                  
                  count: 2,
                  effect: ExpandingDotsEffect(
                    
                    activeDotColor: kwhitecolors,
                    dotColor: Colors.grey.shade700,
                    dotHeight: 10,
                    dotWidth: 10,
                    expansionFactor: 3,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 90),
              child: InkWell(
                
                onTap: () => _goToNextPage(),
                child: Text("Next", style: TextStyle(color: kwhitecolors))),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: _pageController,
              onPageChanged: (index) => setState(() => _currentPage = index),
              children: [ _buildNextStepPage(),_buildFingerprintPage(),],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFingerprintPage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              customContainer(
                250,
                300,
                BoxDecoration(
                  color: kblackcolor,
                  image: const DecorationImage(
                    image: AssetImage('assets/padlock.png'),
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: const Text(
                  'Protect your wallet',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),

          const SizedBox(height: 3),

          Text(
            'Adding biometric security to your wallet will ensure that your wallet is accessible by you.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 17,
              height: 1,
              wordSpacing: 1,
            ),
          ),

          const SizedBox(height: 40),
          customContainer(
            60,
            double.infinity,
            BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: kdarkgraycolor,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset('assets/biometrics.png'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Switch(
                    value: true,
                    onChanged: (value) {
                      setState(() {});
                    },
                    activeColor: kwhitecolors,
                    inactiveThumbColor: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 120),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: ()=>_goToNextPage(),
              child: customContainer(
                50,
                double.infinity,
                BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: korangeColor,
                ),
                Center(
                  child: Text(
                    'Proceed',
                    style: TextStyle(
                      color: kwhitecolors,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextStepPage() {
    final walletProvider = Provider.of<Walletprovider>(context);
    final mnemonic = walletProvider.usersWalletData?.mnemonic ?? "";
    final mnemonicswords = mnemonic.split(" ");

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 10),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Recovery Phrase',
                  style: TextStyle(color: kwhitecolors, fontSize: 24),
                ),
              ),
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: 410,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    'This is the only way you will be able to recover your account.\nPlease store it somewhere Safe!',
                    style: TextStyle(color: kwhitecolors, fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.all(8.5),
            child: Container(
              
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              height: 400,
              width: double.infinity,
              child: GridView.builder(
                itemCount: 12,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 2,
                  childAspectRatio: 3,
                  mainAxisSpacing: 0.5,
                  crossAxisCount: 2,
                ),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Container(
                        
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10.5),
                                child: Text(
                                  "${index + 1}",
                                  style: TextStyle(
                                    color: kwhitecolors,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                          
                            ],
                          ),
                          height: 60,
                          width: 35,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                blurStyle: BlurStyle.solid,
                                color: kwhitecolors,
                                blurRadius: 0.5,
                                spreadRadius: 1,
                              ),
                            ],
                            color: kblackcolor,
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30,),topLeft: Radius.circular(30)),
                          ),
                        ),
                        Container(
                        
                          child: Row(
                            children: [
                             
                             Padding(
                                padding: const EdgeInsets.only(bottom: 2,left: 20),
                                child: Text(
                                  overflow: TextOverflow.ellipsis,
                                  mnemonicswords[index],
                                  style: TextStyle(
                                    color: kwhitecolors,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          height: 60,
                          width: 130,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                blurStyle: BlurStyle.solid,
                                color: kwhitecolors,
                                blurRadius: 0.5,
                                spreadRadius: 1,
                              ),
                            ],
                            color: kblackcolor,
                            borderRadius: BorderRadius.only(bottomRight: Radius.circular(30,),topRight: Radius.circular(30)),
                          ),
                        ),
                        

                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 2),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () async {
                    final WalletData = await Provider.of<Walletprovider>(
                      listen: false,
                      context,
                    );
                    final mnemonic = WalletData.usersWalletData?.mnemonic ?? "";
                    print(mnemonic);
                    if (mnemonic.isNotEmpty) {
                      Clipboard.setData(ClipboardData(text: mnemonic));
                    showCustomSnackBar(context, "Copied to clipboard!");

                    }else{
                     showCustomSnackBar(context, "No mnemonics found");

                    }

                    
                  },
                  child: customContainer(
                    50,
                    200,
                    BoxDecoration(
                      color: kdarkgraycolor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.copy, color: kwhitecolors),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Copy to clipboard',
                            style: TextStyle(color: kwhitecolors),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: InkWell(
             onTap: () => _goToNextPage(),
              child: customContainer(
                50,
                double.infinity,
                BoxDecoration(
                  color: korangeColor,
                  borderRadius: BorderRadius.circular(25),
                ),
                Center(
                  child: Text(
                    "I've save it somewhere",
                    style: TextStyle(
                      color: kwhitecolors,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
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
