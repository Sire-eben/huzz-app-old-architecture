import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzz/core/constants/app_themes.dart';
import 'package:huzz/core/mixins/form_mixin.dart';
import 'package:huzz/core/util/extension.dart';
import 'package:huzz/core/util/validators.dart';
import 'package:huzz/core/widgets/app_bar.dart';
import 'package:huzz/core/widgets/button/button.dart';
import 'package:huzz/core/widgets/textfield/textfield.dart';

class RequestPaymentScreen extends StatefulWidget {
  const RequestPaymentScreen({super.key});

  @override
  State<RequestPaymentScreen> createState() => _RequestPaymentScreenState();
}

class _RequestPaymentScreenState extends State<RequestPaymentScreen>
    with FormMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(title: 'Request Payment'),
      body: SingleChildScrollView(
        reverse: true,
        child: Padding(
          padding: const EdgeInsets.all(Insets.lg),
          child: Form(
            key: formKey,
            child: Column(children: [
              TextInputField(
                labelText: 'What is this payment for?',
                maxLines: 5,
                inputType: TextInputType.multiline,
                validator: Validators.validateString(),
              ),
              TextInputField(
                labelText: 'Amount',
                inputType: TextInputType.number,
                validator: Validators.validateAmount(),
              ),
              const Gap(Insets.xl),
              Button(
                  label: 'Send Request',
                  action: () {
                    if (formKey.currentState!.validate()) {
                      sendRequestSheet(context);
                    }
                  }),
              const Gap(Insets.xl * 2),
            ]),
          ),
        ),
      ),
    );
  }

  sendRequestSheet(BuildContext context) {
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(22),
            topRight: Radius.circular(22),
          ),
        ),
        constraints: const BoxConstraints(maxHeight: 700),
        backgroundColor: Colors.white,
        context: context,
        builder: (context) {
          return Container(
            height: 500,
            width: context.width,
            padding: const EdgeInsets.all(Insets.lg),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 4,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade500,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  const Gap(Insets.md),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Preview',
                        style: TextStyles.t1.copyWith(),
                      ),
                      InkWell(
                        onTap: () => context.pop(),
                        child: Container(
                          padding: const EdgeInsets.all(Insets.sm),
                          decoration: const BoxDecoration(
                            color: AppColors.lightBackgroundColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(Insets.lg),
                  Container(
                    padding: const EdgeInsets.all(Insets.md),
                    height: 230,
                    width: context.width,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2,
                        color: AppColors.primaryColor,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Dear Tunde, pleas kindly help me with #50,000, i want to pay my rent with it. I promise to pay back as soon as possible. Thanks',
                          style: TextStyles.b2.copyWith(
                            color: Colors.black,
                            fontSize: 13,
                          ),
                        ),
                        const Spacer(),
                        const AccountDetailsWidget(
                          title: 'Account Name:',
                          subtitle: 'Tunmise Hassan',
                        ),
                        const AccountDetailsWidget(
                          title: 'Account Number:',
                          subtitle: '30110028312',
                        ),
                        const AccountDetailsWidget(
                          title: 'Amount:',
                          subtitle: '#50,000',
                        ),
                      ],
                    ),
                  ),
                  const Gap(Insets.lg),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Send Options'),
                      IconButton(
                        icon: const Icon(Icons.share),
                        onPressed: () {},
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}

class AccountDetailsWidget extends StatelessWidget {
  final String title, subtitle;
  const AccountDetailsWidget({
    Key? key,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyles.b2.copyWith(color: AppColors.primaryColor),
        ),
        Text(subtitle),
      ],
    );
  }
}
