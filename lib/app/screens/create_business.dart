import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huzz/Repository/business_respository.dart';
import 'package:huzz/app/screens/widget/custom_drop_field.dart';
import 'package:huzz/app/screens/widget/custom_form_field.dart';
import 'package:huzz/colors.dart';

class CreateBusiness extends StatelessWidget {
  final _businessController = Get.find<BusinessRespository>();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Obx(() {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: AppColor().backgroundColor,
            ),
            onPressed: () {
              Get.back();
            },
          ),
          title: Text(
            'Create Your Business',
            style: TextStyle(
              color: AppColor().backgroundColor,
              fontFamily: 'DMSans',
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: 100,
                  child: CustomTextField(
                      label: "Business Name",
                      validatorText: "Business name is required",
                      textEditingController: _businessController.businessName)),
              SizedBox(
                height: 5,
              ),
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: 100,
                  child: CustomTextField(
                    label: "Address (Optional)",
                    textEditingController:
                        _businessController.businessAddressController,
                  )),
              SizedBox(
                height: 5,
              ),
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: 100,
                  child: CustomTextField(
                    label: "Phone Number",
                    validatorText: "Phone Number is needed",
                    textEditingController:
                        _businessController.businessPhoneNumber,
                  )),
              SizedBox(
                height: 5,
              ),
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: 100,
                  child: CustomTextField(
                    label: "Email",
                    validatorText: "Email is required",
                    textEditingController: _businessController.businessEmail,
                  )),

              SizedBox(
                height: 5,
              ),
              SizedBox(
                height: 5,
              ),

              Container(
                  width: MediaQuery.of(context).size.width,
                  height: 104,
                  child: CustomDropDownField(
                    label: "Business Category",
                    validatorText: "Business Category is required",
                    hintText: "Select business category",
                    values: _businessController.businessCategory,
                    currentSelectedValue: _businessController.selectedCategory,
                  )),
              // Expanded(flex: 2, child: SizedBox()),
              SizedBox(
                height: 100,
              ),
              GestureDetector(
                onTap: () {
                  // Get.to(Signin());
                  if (_businessController.createBusinessStatus !=
                      CreateBusinessStatus.Loading)
                    _businessController.createBusiness();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  height: 50,
                  decoration: BoxDecoration(
                      color: AppColor().backgroundColor,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: (_businessController.createBusinessStatus ==
                          CreateBusinessStatus.Loading)
                      ? Container(
                          width: 30,
                          height: 30,
                          child: Center(
                              child: CircularProgressIndicator(
                                  color: Colors.white)),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50))),
                              child: Icon(
                                Icons.add,
                                color: AppColor().backgroundColor,
                                size: 16,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Continue',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ],
                        ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      );
    });
  }
}
// class CreateBusiness extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       body: Container(
//         width: MediaQuery.of(context).size.width,
//         height: MediaQuery.of(context).size.height,
//         child: Column(
//           children: [
//             SizedBox(
//               height: 100,
//             ),
//             Container(
//               child: Row(
//                 children: [
//                   SizedBox(
//                     width: 20,
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       Get.back();
//                     },
//                     child: Icon(
//                       Icons.arrow_back,
//                       color: AppColor().backgroundColor,
//                     ),
//                   ),
//                   SizedBox(
//                     width: 15,
//                   ),
//                   Text(
//                     "Create Your Business",
//                     style: TextStyle(
//                       fontSize: 18,
//                       color: AppColor().backgroundColor,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             CustomTextField(
//               label: "Business Name",
//               validatorText: "Business name is required",
//             ),
//             SizedBox(
//               height: 5,
//             ),
//             CustomTextField(
//               label: "Address (Optional)",
//             ),
//             SizedBox(
//               height: 5,
//             ),
//             CustomTextField(
//               label: "Phone Number",
//               validatorText: "Phone Number is needed",
//             ),
//             SizedBox(
//               height: 5,
//             ),
//             CustomTextField(
//               label: "Email",
//               validatorText: "Email is required",
//             ),
//             SizedBox(
//               height: 5,
//             ),
//             CustomTextField(
//               label: "Business Category",
//               validatorText: "Business Category is required",
//             ),
//             Expanded(child: SizedBox()),
//             InkWell(
//               onTap: () {
//                 Get.to(Signin());
//               },
//               child: Container(
//                 width: MediaQuery.of(context).size.width,
//                 margin: EdgeInsets.only(left: 50, right: 50),
//                 height: 50,
//                 decoration: BoxDecoration(
//                     color: AppColor().backgroundColor,
//                     borderRadius: BorderRadius.all(Radius.circular(10))),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Container(
//                       padding: EdgeInsets.all(3),
//                       decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.all(Radius.circular(50))),
//                       child: Icon(
//                         Icons.add,
//                         color: AppColor().backgroundColor,
//                         size: 16,
//                       ),
//                     ),
//                     SizedBox(
//                       width: 10,
//                     ),
//                     Text(
//                       'Continue',
//                       style: TextStyle(color: Colors.white, fontSize: 18),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: MediaQuery.of(context).size.height * 0.02,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
