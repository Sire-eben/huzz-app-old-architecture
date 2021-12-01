import 'package:flutter/material.dart';

class Merchants extends StatefulWidget {
  const Merchants({Key? key}) : super(key: key);

  @override
  _MerchantsState createState() => _MerchantsState();
}

class _MerchantsState extends State<Merchants> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Center(
          child: Text('Merchants'),
        ),
      ),
    );
  }
}
