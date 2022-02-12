import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:huzz/Repository/product_repository.dart';
import 'package:huzz/app/screens/widget/custom_form_field.dart';
import 'package:huzz/colors.dart';
import 'package:huzz/model/product.dart';
import 'package:image_picker/image_picker.dart';

// ignore: must_be_immutable
class AddService extends StatefulWidget {
  Product? item;
  AddService({Key? key, this.item}) : super(key: key);

  @override
  _AddServiceState createState() => _AddServiceState();
}

class _AddServiceState extends State<AddService> {
  final _productController = Get.find<ProductRepository>();
  final TextEditingController textEditingController = TextEditingController();

  String? value;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColor().whiteColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColor().whiteColor,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back,
            color: AppColor().backgroundColor,
          ),
        ),
        title: Text(
          (widget.item == null) ? "Add Service" : "Update Service",
          style: TextStyle(
            color: AppColor().backgroundColor,
            fontSize: 18,
          ),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => showModalBottomSheet(
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20))),
                  context: context,
                  builder: (context) => buildAddImage()),
              child: Center(
                child: (_productController.productImage != null)
                    ? Image.file(
                        _productController.productImage!,
                        height: 150,
                        width: 150,
                      )
                    : Image.asset(
                        'assets/images/Group 3647.png',
                        height: 50,
                        color: AppColor().backgroundColor,
                      ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Center(
              child: Text(
                'Service Image',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'DMSans',
                  fontSize: 12,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            CustomTextField(
              label: "Service name",
              validatorText: "Service name is needed",
              hint: 'E.g Manicure',
              textEditingController: _productController.productNameController,
            ),
            CustomTextField(
              label: "Service Amount",
              validatorText: "Service amount is needed",
              hint: '₦0.00',
              textEditingController:
                  _productController.productCostPriceController,
            ),
            CustomTextField(
              label: "Service Description",
              validatorText: "",
              hint: 'Add a brief service description',
              textEditingController: _productController.serviceDescription,
            ),
            Spacer(),
            InkWell(
              onTap: () {
                // Get.to(ServiceListing());

                if (_productController.addingProductStatus !=
                    AddingProductStatus.Loading) {
                  if (widget.item == null)
                    _productController.addBudinessProduct(
                        "SERVICES", 'Service');
                  else
                    _productController.UpdateBusinessProduct(
                        widget.item!, 'Service');
                }
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                decoration: BoxDecoration(
                    color: AppColor().backgroundColor,
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
                          style: TextStyle(
                            color: AppColor().whiteColor,
                            fontSize: 18,
                            fontFamily: 'DMSans',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAddImage() => Obx(() {
        return Container(
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
                        color: AppColor().backgroundColor,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 5),
              Text(
                'Upload Image',
                style: TextStyle(
                  color: AppColor().blackColor,
                  fontFamily: 'DMSans',
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(height: 100),
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
                    (_productController.productImage != null)
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
                  style: TextStyle(
                    color: AppColor().blackColor,
                    fontFamily: 'DMSans',
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
                      color: AppColor().backgroundColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Text(
                      'Continue',
                      style: TextStyle(
                        color: AppColor().whiteColor,
                        fontFamily: 'DMSans',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      });
}
