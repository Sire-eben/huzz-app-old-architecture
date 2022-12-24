import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:gap/gap.dart';
import 'package:huzz/core/constants/app_themes.dart';
import 'package:huzz/core/util/validators.dart';
import 'package:huzz/core/widgets/appbar.dart';
import 'package:huzz/core/widgets/button/button.dart';
import 'package:huzz/core/widgets/textfield/textfield.dart';

class RequestPaymentScreen extends StatefulWidget {
  const RequestPaymentScreen({super.key});

  @override
  State<RequestPaymentScreen> createState() => _RequestPaymentScreenState();
}

class _RequestPaymentScreenState extends State<RequestPaymentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(title: 'Request Payment'),
      body: SingleChildScrollView(
        reverse: true,
        child: Padding(
          padding: const EdgeInsets.all(Insets.lg),
          child: Column(children: [
            TextInputField(
              labelText: 'What is this payment for?',
              maxLines: 10,
              inputType: TextInputType.multiline,
              validator: Validators.validateString(),
            ),
            TextInputField(
              labelText: 'Amount',
              inputType: TextInputType.number,
              validator: Validators.validateAmount(),
            ),
            const Gap(Insets.xl * 2),
            Button(label: 'Send Request', action: () {})
          ]),
        ),
      ),
    );
  }
}
