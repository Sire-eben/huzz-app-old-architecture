import 'package:flutter/material.dart';
import 'package:huzz/util/colors.dart';
import 'package:random_color/random_color.dart';

class TeamsWidget extends StatelessWidget {
  final String? name, position;
  final Widget? deleteAction;
  final Widget? editAction;
  final Widget? status;
  TeamsWidget({
    Key? key,
    this.name,
    this.position,
    this.deleteAction,
    this.status,
    this.editAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RandomColor _randomColor = RandomColor();
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.02,
          horizontal: MediaQuery.of(context).size.height * 0.018),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.withOpacity(0.1),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: _randomColor.randomColor()),
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
            flex: 7,
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
          Expanded(flex: 1, child: editAction!),
          Expanded(flex: 1, child: deleteAction!),
        ],
      ),
    );
  }
}

class NoTeamsWidget extends StatelessWidget {
  final String? fName, lName, position;

  NoTeamsWidget({
    Key? key,
    this.fName,
    this.lName,
    this.position,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.02,
          horizontal: MediaQuery.of(context).size.height * 0.018),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.withOpacity(0.1),
      ),
      child: Row(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: AppColor().backgroundColor),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Center(
                  child: Text(
                    fName!.substring(0, 1).toUpperCase() +
                        lName!.substring(0, 1).toUpperCase(),
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
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    fName!,
                    style: TextStyle(
                        fontSize: 14,
                        color: AppColor().blackColor,
                        fontFamily: 'InterRegular',
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 2),
                  Text(
                    lName!,
                    style: TextStyle(
                        fontSize: 14,
                        color: AppColor().blackColor,
                        fontFamily: 'InterRegular',
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Text(
                position!,
                style: TextStyle(
                    fontSize: 10,
                    color: AppColor().blackColor,
                    fontFamily: 'InterRegular',
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
