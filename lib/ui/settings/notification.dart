import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:huzz/data/repository/auth_respository.dart';
import 'package:huzz/util/colors.dart';
import 'package:huzz/data/model/notification_model.dart';
import 'package:random_color/random_color.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  RandomColor _randomColor = RandomColor();
  final controller = Get.find<AuthRepository>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: AppColor().backgroundColor,
            ),
            onPressed: () {
              Get.back();
            },
          ),
          title: Text(
            'Notifications',
            style: TextStyle(
              color: AppColor().backgroundColor,
              fontFamily: 'InterRegular',
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: notificationList.length > 0
            ? Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "assets/images/notification_bell.svg",
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Messages',
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.black,
                          fontFamily: 'InterRegular',
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Your notifications will appear here',
                      style: TextStyle(
                          fontSize: 10,
                          color: Colors.black,
                          fontFamily: 'InterRegular'),
                    ),
                  ],
                ),
              )
            : Padding(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
                child: ListView.separated(
                    shrinkWrap: true,
                    separatorBuilder: (context, index) => Divider(),
                    itemCount: notificationList.length,
                    itemBuilder: (BuildContext context, int index) {
                      var item = notificationList[index];
                      return GestureDetector(
                        onTap: () {},
                        child: Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).size.width * 0.02),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _randomColor.randomColor()),
                                  child: SvgPicture.asset(item.image!)),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  item.message!,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'InterRegular',
                                      fontSize: 10),
                                ),
                              ),
                              Column(
                                children: [
                                  Text(
                                    item.time!,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'InterRegular',
                                        color: AppColor()
                                            .blackColor
                                            .withOpacity(0.5),
                                        fontSize: 8),
                                  ),
                                  Text(
                                    item.time!,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'InterRegular',
                                        color: AppColor()
                                            .blackColor
                                            .withOpacity(0.5),
                                        fontSize: 8),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              ));
  }
}
