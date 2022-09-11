import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:huzz/ui/create_business.dart';
import 'package:huzz/util/colors.dart';

class PinSuccesful extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          Container(
            height: 100,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                Positioned(
                  top: 20,
                  child: SvgPicture.asset('assets/images/Vector.svg'),
                ),
                Positioned(
                  top: 50,
                  left: 20,
                  child: GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: AppColor().backgroundColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
              width: MediaQuery.of(context).size.width * 0.5,
              child: Text(
                "Account Created Successfully",
                textAlign: TextAlign.center,
                style:
                    TextStyle(fontSize: 30, color: AppColor().backgroundColor),
              )),
          Spacer(),
          Center(
            child: Image.asset(
              'assets/images/checker.png',
            ),
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              Get.to(CreateBusiness());
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(left: 50, right: 50),
              height: 50,
              decoration: BoxDecoration(
                  color: AppColor().backgroundColor,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Proceed',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          )
        ],
      ),
    ));
  }
}
