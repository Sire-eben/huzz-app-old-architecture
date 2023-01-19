import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huzz/data/repository/product_repository.dart';
import 'package:huzz/ui/widget/custom_form_field.dart';
import 'package:huzz/data/model/product.dart';
import 'package:image_picker/image_picker.dart';
import 'package:huzz/core/constants/app_themes.dart';
import '../../../util/util.dart';

// ignore: must_be_immutable
class AddProduct extends StatefulWidget {
  Product? item;

  AddProduct({Key? key, this.item}) : super(key: key);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  int _counter = 0;

  @override
  void initState() {
    if (widget.item != null) {
      print("Product json is ${widget.item!.toJson()}");
    }
    super.initState();
  }

  void _incrementCounter() {
    if (_productController.productQuantityController.text.isEmpty)
      _productController.productQuantityController.text = "0";

    _counter = int.parse(_productController.productQuantityController.text);
    setState(() {
      _counter++;
    });
    _productController.productQuantityController.text = "$_counter";
  }

  void _decrementCounter() {
    if (_productController.productQuantityController.text.isEmpty)
      _productController.productQuantityController.text = "0";
    _counter = int.parse(_productController.productQuantityController.text);
    setState(() {
      if (_counter < 1) {
        setState(() {
          _counter = 0;
        });
      } else {
        _counter--;
      }
      _productController.productQuantityController.text = "$_counter";
    });
  }

  final TextEditingController textEditingController = TextEditingController();
  final _productController = Get.find<ProductRepository>();

  String? value;
  int qty = 1;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.whiteColor,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back,
            color: AppColors.backgroundColor,
          ),
        ),
        title: Text(
          (widget.item == null) ? "Add Product" : "Edit Product",
          style: GoogleFonts.inter(
            color: AppColors.backgroundColor,
            fontSize: 18,
          ),
        ),
        elevation: 0,
      ),
      body: Obx(() {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () => showModalBottomSheet(
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20))),
                  context: context,
                  builder: (context) => buildAddImage()),
              child: Center(
                child: (_productController.productImage != null &&
                        _productController.productImage != Null)
                    ? Image.file(
                        _productController.productImage!,
                        height: 150,
                        width: 150,
                      )
                    : (widget.item != null &&
                            widget.item!.productLogoFileStoreId != null &&
                            widget.item!.productLogoFileStoreId!.isNotEmpty)
                        ? Image.network(
                            widget.item!.productLogoFileStoreId!,
                            height: 50,
                          )
                        : Image.asset(
                            'assets/images/Group 3647.png',
                            height: 50,
                            color: AppColors.backgroundColor,
                          ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Center(
              child: Text(
                'Product Image',
                style: GoogleFonts.inter(
                  color: Colors.black,
                  fontSize: 12,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: CustomTextField(
                label: "Product name",
                validatorText: "Product name is needed",
                hint: 'E.g Television',
                textEditingController: _productController.productNameController,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 175,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          margin: EdgeInsets.only(left: 20, right: 20, top: 9),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Cost price',
                                style: GoogleFonts.inter(
                                    color: Colors.black, fontSize: 12),
                              ),
                              SizedBox(
                                width: 1,
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 5),
                                child: Text(
                                  "*",
                                  style: GoogleFonts.inter(
                                      color: Colors.red, fontSize: 12),
                                ),
                              ),
                            ],
                          )),
                      Container(
                        margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                        child: TextFormField(
                          controller:
                              _productController.productCostPriceController,
                          keyboardType: Platform.isIOS
                              ? TextInputType.numberWithOptions(
                                  signed: true, decimal: true)
                              : TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            isDense: true,
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.backgroundColor, width: 2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.backgroundColor, width: 2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.backgroundColor, width: 2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            hintText: '${Utils.getCurrency()} 0.00',
                            hintStyle:
                                Theme.of(context).textTheme.headline4!.copyWith(
                                      color: Colors.black26,
                                      fontSize: 14,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.normal,
                                    ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  width: 175,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          margin: EdgeInsets.only(left: 20, right: 20, top: 9),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Selling price',
                                style: GoogleFonts.inter(
                                    color: Colors.black, fontSize: 12),
                              ),
                              SizedBox(
                                width: 1,
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 5),
                                child: Text(
                                  "*",
                                  style: GoogleFonts.inter(
                                      color: Colors.red, fontSize: 12),
                                ),
                              ),
                            ],
                          )),
                      Container(
                        margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                        child: TextFormField(
                          controller:
                              _productController.productSellingPriceController,
                          keyboardType: Platform.isIOS
                              ? TextInputType.numberWithOptions(
                                  signed: true, decimal: true)
                              : TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            isDense: true,
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.backgroundColor, width: 2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.backgroundColor, width: 2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.backgroundColor, width: 2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            hintText: '${Utils.getCurrency()} 0.00',
                            hintStyle:
                                Theme.of(context).textTheme.headline4!.copyWith(
                                      fontSize: 14,
                                      color: Colors.black26,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.normal,
                                    ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 50,
                    margin: EdgeInsets.only(
                      left: 20,
                      right: 20,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Quantity',
                          style: GoogleFonts.inter(
                              color: Colors.black, fontSize: 12),
                        ),
                        SizedBox(
                          width: 1,
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          child: Text(
                            "*",
                            style: GoogleFonts.inter(
                                color: Colors.red, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: _decrementCounter,
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.backgroundColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.remove,
                        size: 18,
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: 120,
                    child: TextFormField(
                      controller: _productController.productQuantityController,
                      keyboardType: Platform.isIOS
                          ? TextInputType.numberWithOptions(
                              signed: true, decimal: true)
                          : TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        isDense: true,
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColors.backgroundColor, width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColors.backgroundColor, width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColors.backgroundColor, width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        hintText: _productController
                                .productQuantityController.text.isEmpty
                            ? "0"
                            : _productController.productQuantityController.text,
                        hintStyle:
                            Theme.of(context).textTheme.headline4!.copyWith(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.normal,
                                ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: _incrementCounter,
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.backgroundColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.add,
                        size: 18,
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Select Unit',
                style: GoogleFonts.inter(color: Colors.black, fontSize: 12),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 1,
              padding: EdgeInsets.symmetric(
                horizontal: 10,
              ),
              margin: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 2, color: AppColors.backgroundColor),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _productController.selectedUnit.value,
                  focusColor: AppColors.whiteColor,
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.backgroundColor,
                  ),
                  iconSize: 30,
                  hint: Text(
                    'Select product unit',
                    style: GoogleFonts.inter(
                      color: Colors.black26,
                    ),
                  ),
                  items: _productController.units.map(buildMenuItem).toList(),
                  onChanged: (value) =>
                      setState(() => _productController.selectedUnit(value)),
                ),
              ),
            ),
            Spacer(),
            InkWell(
              onTap: () {
                if (_productController.addingProductStatus !=
                    AddingProductStatus.Loading) {
                  if (widget.item == null)
                    _productController.addBudinessProduct("GOODS", 'Product');
                  else
                    _productController.UpdateBusinessProduct(
                        widget.item!, 'Product');
                }
              },
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                decoration: BoxDecoration(
                    color: AppColors.backgroundColor,
                    borderRadius: BorderRadius.circular(10)),
                child: (_productController.addingProductStatus ==
                        AddingProductStatus.Loading)
                    ? Container(
                        width: 30,
                        height: 30,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
                      )
                    : Center(
                        child: Text(
                          (widget.item == null) ? 'Save' : "Update",
                          style: GoogleFonts.inter(
                            color: AppColors.whiteColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        );
      }),
    );
  }

  Widget buildAddImage() => Obx(() {
        return Container(
          height: 300,
          padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.04,
              right: MediaQuery.of(context).size.width * 0.04,
              bottom: MediaQuery.of(context).size.width * 0.04,
              top: MediaQuery.of(context).size.width * 0.02),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  height: 3,
                  width: 70,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color: Color(0xffE6F4F2),
                      shape: BoxShape.circle,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(
                        Icons.close,
                        color: AppColors.backgroundColor,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 5),
              Text(
                'Upload Image',
                style: GoogleFonts.inter(
                  color: AppColors.blackColor,
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(height: 30),
              GestureDetector(
                onTap: () async {
                  final ImagePicker _picker = ImagePicker();
                  // Pick an image
                  final XFile? image =
                      await _picker.pickImage(source: ImageSource.gallery);
                  _productController.MproductImage(File(image!.path));
                  print("image path ${image.path}");
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    (_productController.productImage != null &&
                            _productController.productImage != Null)
                        ? Image.file(
                            _productController.productImage!,
                            height: 150,
                            width: 150,
                          )
                        : SvgPicture.asset(
                            'assets/images/camera.svg',
                          ),
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Center(
                child: Text(
                  'Select from Device',
                  style: GoogleFonts.inter(
                    color: AppColors.blackColor,
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  height: 55,
                  margin: EdgeInsets.symmetric(
                    horizontal: 15,
                  ),
                  decoration: BoxDecoration(
                      color: AppColors.backgroundColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Text(
                      'Done',
                      style: GoogleFonts.inter(
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      });

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Color(0xffCFD1D2),
            ),
            borderRadius: BorderRadius.circular(10),
            color: Color(0xffDCF2EF),
          ),
          child: Center(
            child: Text(
              item,
              style: GoogleFonts.inter(fontSize: 14),
            ),
          ),
        ),
      );
}
