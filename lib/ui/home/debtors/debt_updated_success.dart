import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huzz/ui/app_scaffold.dart';
import 'package:huzz/core/constants/app_themes.dart';

class DebtUpdatedSuccess extends StatelessWidget {
  DebtUpdatedSuccess({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.backgroundColor,
          ),
          onPressed: () {
            Get.offAll(Dashboard());
          },
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Column(
                  children: [
                    Text(
                      'Transaction Updated Successfully',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        color: AppColors.backgroundColor,
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              SvgPicture.asset('assets/images/income_added.svg'),
              const Spacer(),
              Column(
                children: [
                  InkWell(
                    onTap: () async {
                      Get.offAll(() => Dashboard());
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(
                          horizontal:
                              MediaQuery.of(context).size.height * 0.03),
                      height: 50,
                      decoration: BoxDecoration(
                          color: AppColors.backgroundColor,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Center(
                        child: Text(
                          'Proceed',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 100)
            ],
          ),
        ),
      ),
    );
  }
}
