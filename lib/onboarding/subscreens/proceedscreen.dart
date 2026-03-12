// ignore_for_file: sort_child_properties_last
import 'package:bitdevs_project/customutils/customitems.dart';
import 'package:bitdevs_project/onboarding/statemanagement/wallet_controller.dart';
import 'package:bitdevs_project/onboarding/subscreens/namewalletscreen.dart';
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
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: kblackcolor,
      appBar: AppBar(
        backgroundColor: kblackcolor,
        iconTheme: IconThemeData(color: theme.colorScheme.surfaceBright),
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
                child: Text(
                  "Next",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontSize: 18,
                    color: kwhitecolors,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Aeonik",
                  ),
                ),
              ),
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
              children: [_buildNextStepPage(), _buildConfirmPage()],
            ),
          ),
        ],
      ),
    );
  }

  int _confirmStep = 0;
  int? _selectedOption;
  late List<int> _questionPositions;
  bool _confirmInitialized = false;

  void _initConfirm(List<String> words) {
    if (_confirmInitialized) return;
    final positions = List.generate(12, (i) => i)..shuffle();
    _questionPositions = positions.take(5).toList();
    _confirmInitialized = true;
  }

  void _resetConfirm() {
    setState(() {
      _confirmStep = 0;
      _selectedOption = null;
      _confirmInitialized = false;
    });
  }

  List<String> _buildOptions(List<String> words, int correctIndex) {
    final correct = words[correctIndex];
    final others = List<String>.from(words)
      ..remove(correct)
      ..shuffle();
    final fakes = others.take(4).toList();
    final options = [correct, ...fakes]..shuffle();
    return options;
  }

  Widget _buildConfirmPage() {
    final walletProvider = Provider.of<WalletProvider>(context);
    final mnemonic = walletProvider.pendingMnemonic ??
        walletProvider.walletData?.mnemonic ??
        "";
    final words = mnemonic.split(" ");
    final theme = Theme.of(context);

    if (words.length < 12) {
      return Center(
        child: Text("No mnemonic found", style: TextStyle(color: Colors.grey)),
      );
    }
    _initConfirm(words);
    final wordIndex = _questionPositions[_confirmStep];
    final wordNumber = wordIndex + 1;
    final options = _buildOptions(words, wordIndex);
    final correctWord = words[wordIndex];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(
            'Confirm Recovery Phrase',
            style: theme.textTheme.titleLarge?.copyWith(
              fontSize: 25,
              color: kwhitecolors,
              fontWeight: FontWeight.w700,
              fontFamily: "Aeonik",
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'What was the word ',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontSize: 14,
                  color: kbuttonGraycolor,
                  fontWeight: FontWeight.w700,
                  fontFamily: "Aeonik",
                ),
              ),
              Text(
                '${_ordinal(wordNumber)} ',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontSize: 14,
                  color: korangeColor,
                  fontWeight: FontWeight.w700,
                  fontFamily: "Aeonik",
                ),
              ),
              Text(
                'In your recovery phrase?',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontSize: 14,
                  color: kbuttonGraycolor,
                  fontWeight: FontWeight.w700,
                  fontFamily: "Aeonik",
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: List.generate(5, (i) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.only(right: 6),
                height: 6,
                width: i == _confirmStep ? 24 : 8,
                decoration: BoxDecoration(
                  color: i < _confirmStep
                      ? korangeColor
                      : i == _confirmStep
                          ? kwhitecolors
                          : kbuttonGraycolor,
                  borderRadius: BorderRadius.circular(10),
                ),
              );
            }),
          ),
          const SizedBox(height: 30),
          ...List.generate(options.length, (i) {
            final isSelected = _selectedOption == i;
            return GestureDetector(
              onTap: _selectedOption != null
                  ? null
                  : () async {
                      setState(() => _selectedOption = i);
                      final picked = options[i];
                      await Future.delayed(const Duration(milliseconds: 350));
                      if (picked == correctWord) {
                        if (_confirmStep < 4) {
                          setState(() {
                            _confirmStep++;
                            _selectedOption = null;
                          });
                        } else {
                          setState(() {});
                        }
                      } else {
                        showCustomSnackBar(
                          context,
                          "Wrong word! Please start over.",
                        );
                        await Future.delayed(const Duration(milliseconds: 500));
                        _resetConfirm();
                      }
                    },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 25,
                ),
                decoration: BoxDecoration(
                  color: kdarkgraycolor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(width: 1.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      options[i],
                      style: TextStyle(
                        color: isSelected ? korangeColor : kwhitecolors,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Aeonik",
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 20,
                      width: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? korangeColor : kgraycolor,
                          width: 2,
                        ),
                        color: isSelected ? korangeColor : ktransparentcolor,
                      ),
                      child: isSelected
                          ? Icon(Icons.check, size: 14, color: kwhitecolors)
                          : null,
                    ),
                  ],
                ),
              ),
            );
          }),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: GestureDetector(
              onTap: _confirmStep == 4 && _selectedOption != null
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => Namewalletscreen()),
                      );
                    }
                  : null,
              child: customContainer(
                55,
                double.infinity,
                BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: _confirmStep == 4 && _selectedOption != null
                      ? korangeColor
                      : kbuttonGraycolor,
                ),
                Center(
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      color: kwhitecolors,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      fontFamily: "Aeonik",
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

  String _ordinal(int n) {
    if (n >= 11 && n <= 13) return "${n}th";
    switch (n % 10) {
      case 1:
        return "${n}st";
      case 2:
        return "${n}nd";
      case 3:
        return "${n}rd";
      default:
        return "${n}th";
    }
  }


  Widget _buildNextStepPage() {
    final walletProvider = Provider.of<WalletProvider>(context);
    final mnemonic = walletProvider.pendingMnemonic ??
        walletProvider.walletData?.mnemonic ??
        "";
    final mnemonicswords = mnemonic.split(" ");
    final theme = Theme.of(context);

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
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontSize: 24,
                    color: kwhitecolors,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Aeonik",
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: 380,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    'This is the only way you will be able to recover your account. Please store it somewhere Safe!',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontSize: 15,
                      color: kwhitecolors,
                      fontWeight: FontWeight.normal,
                      fontFamily: "Aeonik",
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(8.5),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              height: 390,
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
                          height: 60,
                          width: 35,
                          decoration: BoxDecoration(
                            color: kblackcolor,
                            boxShadow: [
                              BoxShadow(
                                color: theme.colorScheme.tertiary,
                                blurRadius: 0.5,
                                spreadRadius: 1,
                              ),
                            ],
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(30),
                              topLeft: Radius.circular(30),
                            ),
                          ),
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
                        ),
                        Container(
                          height: 60,
                          width: 130,
                          decoration: BoxDecoration(
                            color: kblackcolor,
                            boxShadow: [
                              BoxShadow(
                                color: kwhitecolors,
                                blurRadius: 0.5,
                                spreadRadius: 1,
                              ),
                            ],
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 2,
                                  left: 20,
                                ),
                                child: Text(
                                  overflow: TextOverflow.ellipsis,
                                  mnemonicswords.length > index
                                      ? mnemonicswords[index]
                                      : '',
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontSize: 15,
                                    color: kwhitecolors,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: "Aeonik",
                                  ),
                                ),
                              ),
                            ],
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
                  onTap: () {
                    final walletProvider = Provider.of<WalletProvider>(
                      context,
                      listen: false,
                    );
                    // ← fixed: pendingMnemonic first
                    final mnemonic = walletProvider.pendingMnemonic ??
                        walletProvider.walletData?.mnemonic ??
                        "";
                    if (mnemonic.isNotEmpty) {
                      Clipboard.setData(ClipboardData(text: mnemonic));
                      showCustomSnackBar(context, "Copied to clipboard!");
                    } else {
                      showCustomSnackBar(context, "No mnemonics found");
                    }
                  },
                  child: customContainer(
                    50,
                    200,
                    BoxDecoration(
                      color: kblackcolor.withOpacity(0.9),
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
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: InkWell(
              onTap: () => _goToNextPage(),
              child: customContainer(
                45,
                300,
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