import 'package:bitdevs_project/customutils/customitems.dart';
import 'package:bitdevs_project/theme/colors.dart';
import 'package:flutter/material.dart';

class Restorewalletscreen extends StatefulWidget {
  const Restorewalletscreen({super.key});

  @override
  State<Restorewalletscreen> createState() => _RestorewalletscreenState();
}

class _RestorewalletscreenState extends State<Restorewalletscreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kblackcolor,
      appBar: AppBar(
        backgroundColor: kblackcolor,
        iconTheme: IconThemeData(color: kwhitecolors),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: Text(
                      'Recovery Phrase',
                      style: TextStyle(color: kwhitecolors, fontSize: 24),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    'Import your existing wallet with your 12 word \nrecovery phrase',
                    style: TextStyle(color: kwhitecolors, fontSize: 16),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: TextFormField(
                style: TextStyle(color: korangeColor),
                maxLines: 3,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
            SizedBox(height: size.height * 0.5),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: customContainer(
                50,
                double.infinity,
                BoxDecoration(
                  color: korangeColor,
                  borderRadius: BorderRadius.circular(25),
                ),
                Center(child: Text("Import Recovery Phrase",style: TextStyle(color: kwhitecolors,fontSize: 15),)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
