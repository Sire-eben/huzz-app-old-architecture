import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:huzz/colors.dart';

class TeamsWidget extends StatelessWidget {
  final String? name, position;
  final Widget? status;
  TeamsWidget({Key? key, this.name, this.position, this.status})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.withOpacity(0.1),
      ),
      child: Row(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: AppColor().backgroundColor),
                child: Center(
                  child: Text(
                    name!.substring(0, 2).toUpperCase(),
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontFamily: 'InterRegular',
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name!,
                  style: TextStyle(
                      fontSize: 14,
                      color: AppColor().blackColor,
                      fontFamily: 'InterRegular',
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      position!,
                      style: TextStyle(
                          fontSize: 10,
                          color: AppColor().blackColor,
                          fontFamily: 'InterRegular',
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(width: 40),
                    status!
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
              onTap: () {
                // _customerController
                //     .setItem(item);
                // Get.to(AddCustomer(
                //   item: item,
                // ));
              },
              child: SvgPicture.asset('assets/images/edit.svg')),
          SizedBox(
            width: 10,
          ),
          GestureDetector(
              onTap: () {
                // _displayDialog(
                //     context, item);
              },
              child: SvgPicture.asset('assets/images/delete.svg')),
        ],
      ),
    );
  }
}
