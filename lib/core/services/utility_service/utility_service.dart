import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class UtilityService {
  bool dateIsPast(DateTime date) {
    var now = DateTime.now();
    return DateTime(date.year, date.month, date.day)
            .difference(DateTime(now.year, now.month, now.day))
            .inDays <
        0;
  }

  bool isNumeric(String value) {
    if (value.isEmpty) return false;
    return double.tryParse(value) != null ? true : false;
  }

  String toTitleCase(String text) {
    return '${text[0].toUpperCase()}${text.substring(1)}';
  }

  void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }

  String formatDate(DateTime date) {
    final formatter = DateFormat('MMMM dd, yyyy');
    return formatter.format(date);
  }

  SvgPicture svgPicture(String fileName, {BoxFit fit = BoxFit.contain}) {
    return SvgPicture.asset(
      'lib/assets/svgs/$fileName.svg',
      fit: fit,
    );
  }

  double deviceSizer(BuildContext context, bool isWidth, {double value}) {
    if (isWidth) {
      return MediaQuery.of(context).size.width * (value / 411);
    } else {
      return MediaQuery.of(context).size.height * (value / 823);
    }
  }

  String buildPhoneNumber(
      {@required String phoneCode, @required String phoneNumber}) {
    if (phoneNumber.split('')[0] == '0') {
      var formattedPhoneNumber = phoneNumber.split('')[0] == '0'
          ? phoneNumber.substring(1)
          : phoneNumber;
      return '$phoneCode$formattedPhoneNumber';
    }
    return phoneCode + phoneNumber;
  }

  String phoneNumberStripZero({@required String phoneNumber}) {
    if (phoneNumber.split('')[0] == '0') {
      var number = phoneNumber.split('')[0] == '0'
          ? phoneNumber.substring(1)
          : phoneNumber;
      return number;
    }
    return phoneNumber;
  }

  String convertAmount({@required int amount, bool isInverse = false}) {
    if (isInverse) {
      return (amount * 100).toStringAsFixed(2).toString();
    } else {
      return (amount / 100).toStringAsFixed(2).toString();
    }
  }
}
