import 'package:flutter/material.dart';

class Customers extends StatefulWidget {
  const Customers({Key? key}) : super(key: key);

  @override
  _CustomersState createState() => _CustomersState();
}

class _CustomersState extends State<Customers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Center(
          child: Text('Customers'),
        ),
      ),
    );
  }
}
