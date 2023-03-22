import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huzz/core/constants/app_themes.dart';

class InvoiceNotAuthorized extends StatefulWidget {
  const InvoiceNotAuthorized({super.key});

  @override
  State<InvoiceNotAuthorized> createState() => _InvoiceNotAuthorizedState();
}

class _InvoiceNotAuthorizedState extends State<InvoiceNotAuthorized> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
            Text(
              "Manage Invoices",
              style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: AppColors.backgroundColor),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.height * 0.02,
                    right: MediaQuery.of(context).size.height * 0.02,
                    bottom: MediaQuery.of(context).size.height * 0.02),
                decoration: BoxDecoration(
                    color: Color(0xffF5F5F5),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        width: 2, color: Colors.grey.withOpacity(0.2))),
                child: Container(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.height * 0.02,
                      right: MediaQuery.of(context).size.height * 0.02,
                      bottom: MediaQuery.of(context).size.height * 0.02),
                  decoration: BoxDecoration(
                    color: Color(0xffF5F5F5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/images/invoice.svg'),
                        Text(
                          'Invoice',
                          style: GoogleFonts.inter(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Your invoices will show here.',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'You need to be authorized\nto view this module',
                          style: GoogleFonts.inter(
                              fontSize: 14,
                              color: AppColors.orangeBorderColor,
                              fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
