import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huzz/core/constants/app_themes.dart';

class ContinueButton extends StatelessWidget {
<<<<<<< HEAD
=======
  final String label;
>>>>>>> 1d838468783131dda717d077445733e6aa6aba0b
  final VoidCallback action;

  const ContinueButton({
    super.key,
    required this.action,
<<<<<<< HEAD
=======
    required this.label,
>>>>>>> 1d838468783131dda717d077445733e6aa6aba0b
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.backgroundColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        onPressed: action,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
<<<<<<< HEAD
              'Continue',
=======
              label,
>>>>>>> 1d838468783131dda717d077445733e6aa6aba0b
              style: GoogleFonts.inter(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(
              width: 10,
            ),
            Container(
              padding: const EdgeInsets.all(3),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(50))),
              child: const Icon(
                Icons.arrow_forward,
                color: AppColors.backgroundColor,
                size: 16,
              ),
            )
          ],
        ),
      ),
    );
  }
}
