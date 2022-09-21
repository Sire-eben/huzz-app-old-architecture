import 'package:flutter/material.dart';
import 'package:huzz/util/colors.dart';

class MoreWidget extends StatelessWidget {
  final String? image, title, description;
  MoreWidget({Key? key, this.image, this.title, this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Color.fromARGB(31, 150, 150, 150),
      ),
      child: Row(
        children: [
          Container(
            height: 80,
            width: 100,
            padding: EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Image.asset(
              image!,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title!,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                  fontFamily: 'InterRegular',
                  fontSize: 16,
                ),
              ),
              Text(
                description!,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.normal,
                  fontFamily: 'InterRegular',
                  fontSize: 12,
                ),
              ),
            ],
          ),
          Spacer(),
          Row(
            children: [
              Icon(
                Icons.keyboard_arrow_right,
                color: AppColor().backgroundColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
