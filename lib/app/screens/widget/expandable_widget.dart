import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:huzz/colors.dart';

class ExpandableWidget extends StatefulWidget {
  final String? name;
  final double? tL, tR, bL, bR;
  ExpandableWidget({Key? key, this.name, this.tL, this.tR, this.bL, this.bR})
      : super(key: key);

  @override
  State<ExpandableWidget> createState() => _ExpandableWidgetState();
}

class _ExpandableWidgetState extends State<ExpandableWidget> {
  bool manageCustomer = false;
  bool view = false, create = false, update = false, delete = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(widget.tL!),
              topRight: Radius.circular(widget.tR!),
              bottomLeft: Radius.circular(widget.bL!),
              bottomRight: Radius.circular(widget.bR!)),
          color: AppColor().backgroundColor.withOpacity(0.1)),
      child: ExpandablePanel(
        theme: ExpandableThemeData(
          headerAlignment: ExpandablePanelHeaderAlignment.center,
          tapBodyToCollapse: true,
          hasIcon: true,
          iconColor: AppColor().backgroundColor,
        ),
        collapsed: Container(),
        expanded: Column(
          children: [
            SizedBox(
              height: 30,
              child: CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  "View",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'InterRegular',
                  ),
                ),
                value: view,
                onChanged: (newValue) {
                  setState(() {
                    view = newValue!;
                  });
                },
              ),
            ),
            SizedBox(
              height: 30,
              child: CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  "Create",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'InterRegular',
                  ),
                ),
                value: create,
                onChanged: (newValue) {
                  setState(() {
                    create = newValue!;
                  });
                },
              ),
            ),
            SizedBox(
              height: 30,
              child: CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  "Update",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'InterRegular',
                  ),
                ),
                value: update,
                onChanged: (newValue) {
                  setState(() {
                    update = newValue!;
                  });
                },
              ),
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                "Delete",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'InterRegular',
                ),
              ),
              value: delete,
              onChanged: (newValue) {
                setState(() {
                  delete = newValue!;
                });
              },
            )
          ],
        ),
        header: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 20,
              child: Checkbox(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                activeColor: AppColor().backgroundColor,
                value: manageCustomer,
                onChanged: (value) {
                  setState(() {
                    manageCustomer = value!;
                  });
                },
              ),
            ),
            SizedBox(width: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  widget.name!,
                  style: Theme.of(context).textTheme.headline4!.copyWith(
                        color: AppColor().backgroundColor,
                        fontFamily: "InterRegular",
                        fontStyle: FontStyle.normal,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                SizedBox(width: 5),
                SvgPicture.asset(
                  "assets/images/info.svg",
                  height: 15,
                  width: 15,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
