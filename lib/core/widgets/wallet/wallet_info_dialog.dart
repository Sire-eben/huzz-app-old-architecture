import 'package:flutter/material.dart';

class WalletInfoDialog extends StatefulWidget {
  const WalletInfoDialog({super.key});

  @override
  State<WalletInfoDialog> createState() => _WalletInfoDialogState();
}

class _WalletInfoDialogState extends State<WalletInfoDialog> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(
          Icons.info_outline_rounded,
          size: 27,
        ),
        SizedBox(height: 7),
        Text(
          'This is where you can have access to your wallet.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
