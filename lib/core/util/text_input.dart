import 'package:huzz/generated/assets.gen.dart';

class PhoneNumber {
  final String number;
  final String dialCode;

  const PhoneNumber({required this.number, required this.dialCode});
}

class PhoneNumberCountry {
  final String name;
  final String shortName;
  final String countryCode;
  final String flag;
  final int maxLength;

  const PhoneNumberCountry({
    required this.name,
    required this.shortName,
    required this.countryCode,
    required this.flag,
    required this.maxLength,
  });
}

final ngn = PhoneNumberCountry(
  name: "Nigeria",
  shortName: "NG",
  countryCode: "234",
  flag: Assets.images.nigeria.path,
  maxLength: 11,
);

List<PhoneNumberCountry> phoneNumberCountryList() => [ngn];
