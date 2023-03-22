import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huzz/core/widgets/state/loading.dart';
import 'package:huzz/data/repository/product_repository.dart';
import 'package:huzz/ui/widget/custom_form_field.dart';
import 'package:huzz/core/constants/app_themes.dart';
import 'package:huzz/data/model/product.dart';
import 'package:image_picker/image_picker.dart';
import 'package:huzz/core/util/util.dart';

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
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.whiteColor,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(
            Icons.arrow_back,
            color: AppColors.backgroundColor,
          ),
        ),
        title: Text(
          (widget.item == null) ? "Add Service" : "Update Service",
          style: GoogleFonts.inter(
            color: AppColors.backgroundColor,
            fontSize: 18,
          ),
        ),
        elevation: 0,
      ),
      body: Obx(() {
        return Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => showModalBottomSheet(
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20))),
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
                                  widget
                                      .item!.productLogoFileStoreId!.isNotEmpty)
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
                  const SizedBox(
                    height: 5,
                  ),
                  Center(
                    child: Text(
                      'Service Image',
                      style: GoogleFonts.inter(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextField(
                    label: "Service name",
                    validatorText: "Service name is needed",
                    hint: 'E.g Hair Cut',
                    textEditingController:
                        _productController.productNameController,
                  ),
                  CustomTextField(
                    label: "Service Amount",
                    validatorText: "Service amount is needed",
                    hint: '${Utils.getCurrency()}0.00',
                    inputformater: [FilteringTextInputFormatter.digitsOnly],
                    keyType: Platform.isIOS
                        ? const TextInputType.numberWithOptions(
                            signed: true, decimal: true)
                        : TextInputType.number,
                    textEditingController:
                        _productController.productCostPriceController,
                  ),
                  CustomTextField(
                    label: "Service Description",
                    validatorText: "",
                    hint: 'Add a brief service description',
                    textEditingController:
                        _productController.serviceDescription,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  InkWell(
                    onTap: () {
                      // Get.to(ServiceListing());

                      if (_productController.addingProductStatus !=
                          AddingProductStatus.Loading) {
                        _productController.productSellingPriceController.text =
                            "0";
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
                          color: AppColors.backgroundColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: (_productController.addingProductStatus ==
                              AddingProductStatus.Loading)
                          ? Container(
                              width: 30,
                              height: 30,
                              child: const Center(
                                  child: LoadingWidget()),
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
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        );
      }),
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
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 30,
                    width: 30,
                    decoration: const BoxDecoration(
                      color: Color(0xffE6F4F2),
                      shape: BoxShape.circle,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: const Icon(
                        Icons.close,
                        color: AppColors.backgroundColor,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 5),
              Text(
                'Upload Image',
                style: GoogleFonts.inter(
                  color: AppColors.blackColor,
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(height: 100),
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
              const SizedBox(
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
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  height: 55,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 15,
                  ),
                  decoration: BoxDecoration(
                      color: AppColors.backgroundColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Text(
                      'Continue',
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
}
