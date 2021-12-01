import 'package:flutter/material.dart';
import 'package:huzz/colors.dart';

class Customers extends StatefulWidget {
  const Customers({Key? key}) : super(key: key);

  @override
  _CustomersState createState() => _CustomersState();
}

class _CustomersState extends State<Customers> {
  final _searchcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            TextField(
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: AppColor().backgroundColor,
                  fontFamily: 'DMSans'),
              controller: _searchcontroller,
              cursorColor: Colors.white,
              autofocus: false,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                  color: AppColor().backgroundColor,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0),
                  borderSide: BorderSide(color: Colors.black12),
                ),
                fillColor: Colors.white,
                filled: true,
                hintText: 'Search Customers',
                hintStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                    fontFamily: 'DMSans'),
                contentPadding:
                    EdgeInsets.only(left: 16, right: 8, top: 8, bottom: 8),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    width: 2,
                    color: AppColor().backgroundColor,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    width: 2,
                    color: AppColor().backgroundColor,
                  ),
                ),
              ),
            ),
            Text('Customers'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: Icon(Icons.add),
        backgroundColor: AppColor().backgroundColor,
        label: Text(
          'Add Customer',
          style: TextStyle(
              fontFamily: 'DMSans',
              fontSize: 10,
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
