import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huzz/util/colors.dart';

class ExpandableWidget extends StatefulWidget {
  final String? name;
  final double? tL, tR, bL, bR;
  final bool? role;
  final Widget? manageChild, view, create, update, delete;
  ExpandableWidget({
    Key? key,
    this.name,
    this.tL,
    this.tR,
    this.bL,
    this.bR,
    this.role,
    this.manageChild,
    this.view,
    this.create,
    this.update,
    this.delete,
  }) : super(key: key);

  @override
  State<ExpandableWidget> createState() => _ExpandableWidgetState();
}

class _ExpandableWidgetState extends State<ExpandableWidget> {
  bool view = false, create = false, update = false, delete = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
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
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "View",
                      style: GoogleFonts.inter(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        
                      ),
                    ),
                    Container(child: widget.view)
                  ],
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Create",
                      style: GoogleFonts.inter(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        
                      ),
                    ),
                    Container(child: widget.create)
                  ],
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Update",
                      style: GoogleFonts.inter(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        
                      ),
                    ),
                    Container(child: widget.update)
                  ],
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Delete",
                      style: GoogleFonts.inter(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        
                      ),
                    ),
                    Container(child: widget.delete)
                  ],
                ),
              ),
              // SizedBox(
              //   height: 30,
              //   child: CheckboxListTile(
              //     contentPadding: EdgeInsets.zero,
              //     title: Text(
              //       "Create",
              //       style: GoogleFonts.inter(
              //         color: Colors.black,
              //         fontSize: 12,
              //         fontWeight: FontWeight.w400,
              //         
              //       ),
              //     ),
              //     value: create,
              //     onChanged: (newValue) {
              //       setState(() {
              //         create = newValue!;
              //       });
              //     },
              //   ),
              // ),
              // SizedBox(
              //   height: 30,
              //   child: CheckboxListTile(
              //     contentPadding: EdgeInsets.zero,
              //     title: Text(
              //       "Update",
              //       style: GoogleFonts.inter(
              //         color: Colors.black,
              //         fontSize: 12,
              //         fontWeight: FontWeight.w400,
              //         
              //       ),
              //     ),
              //     value: update,
              //     onChanged: (newValue) {
              //       setState(() {
              //         update = newValue!;
              //       });
              //     },
              //   ),
              // ),
              // CheckboxListTile(
              //   contentPadding: EdgeInsets.zero,
              //   title: Text(
              //     "Delete",
              //     style: GoogleFonts.inter(
              //       color: Colors.black,
              //       fontSize: 12,
              //       fontWeight: FontWeight.w400,
              //       
              //     ),
              //   ),
              //   value: delete,
              //   onChanged: (newValue) {
              //     setState(() {
              //       delete = newValue!;
              //     });
              //   },
              // )
            ],
          ),
          header: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 20, child: widget.manageChild),
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
      ),
    );
  }
}
