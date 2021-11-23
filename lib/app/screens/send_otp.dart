import 'package:country_picker/country_picker.dart';
import 'package:flag/flag_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huzz/Repository/home_respository.dart';
import 'package:huzz/colors.dart';
class SendOtp extends StatefulWidget{
_SendOtpState createState()=>_SendOtpState();

}
class _SendOtpState extends State<SendOtp>{
final _homeController=Get.find<HomeRespository>();
String countryFlag="NG";
String countryCode="234";
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(

   body: Container(
width: MediaQuery.of(context).size.width,
height: MediaQuery.of(context).size.height,
child: Column(
  mainAxisAlignment: MainAxisAlignment.center,
  crossAxisAlignment: CrossAxisAlignment.start,
children:[

SizedBox(height: MediaQuery.of(context).size.height*0.1),
Container(

  margin: EdgeInsets.only(left: 20,),
child: Text("Phone Number",style: TextStyle(color: Colors.black,fontSize: 12,fontWeight: FontWeight.w400,),)

),
SizedBox(height: 10,),
Container(
  margin: EdgeInsets.only(left: 20,right: 20),
width: MediaQuery.of(context).size.width,
height: 50,
decoration: BoxDecoration(
color: Colors.white,
border: Border.all(color: AppColor().backgroundColor,width: 2.0),
borderRadius: BorderRadius.all(Radius.circular(10)),


),
child: Row(
mainAxisAlignment: MainAxisAlignment.start,
crossAxisAlignment: CrossAxisAlignment.start,
  children: [
GestureDetector(
  onTap: (){

    showCountryCode(context);
      },
  child:   Container(
    
    decoration: BoxDecoration(
      border: Border(right: BorderSide(color: AppColor().backgroundColor,width: 2)),
      // borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20))
  
    ),
  height: 50,
  width: 80,
  child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
  children: [
  SizedBox(width:10),
  Flag.fromString(countryFlag, height: 30, width:30),
  SizedBox(width: 5,),
  Icon(Icons.arrow_drop_down,size: 24,color: AppColor().backgroundColor.withOpacity(0.5),)
  
  
  ],
  
  ),
  
  
  ),
),
SizedBox(width: 10,),
Expanded(
  child:   TextFormField(

  decoration: InputDecoration(
    border: InputBorder.none,
    hintText: "9034678966",
    hintStyle: TextStyle(color: Colors.black.withOpacity(0.5),fontSize: 14,fontWeight: FontWeight.w500),
    prefixText: "+$countryCode ",
   
    prefixStyle: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Colors.black)
  ),
    
  ),
),
SizedBox(width: 10,),

  ],
),
),
Expanded(child: SizedBox()),
Container(
  margin: EdgeInsets.only(left: 50,right: 50),
  child: RichText(
    textAlign: TextAlign.center,
    text: TextSpan(
  text: "By clicking Continue, you agree to our ",
  style: TextStyle(fontSize: 12,color: Colors.black,letterSpacing: 2),
  children: [

    TextSpan(
text: "our Terms of use ",
style: TextStyle(fontSize: 12,color: AppColor().backgroundColor,letterSpacing: 2),
    ),
    TextSpan(

      text: "and ",
      style: TextStyle(fontSize: 12,color: Colors.black,letterSpacing: 2),
    ),
  TextSpan(
    text:"and Privacy policy",
    style: TextStyle(fontSize: 12,color: AppColor().backgroundColor,letterSpacing: 2)
  )
  ]

  ))
),
SizedBox(height: 20,),
GestureDetector(
  onTap: (){

    _homeController.selectOnboardSelectedNext();
  },
  child:   Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(left: 50,right: 50),
      height: 50,
      decoration: BoxDecoration(
         color: AppColor().backgroundColor,
         borderRadius: BorderRadius.all(Radius.circular(10))
  
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
           Text('Continue',style: TextStyle(color: Colors.white,fontSize: 18),),
           SizedBox(width: 10,),
           Container(padding: EdgeInsets.all(3),
             decoration:BoxDecoration(
               color: Colors.white,borderRadius: BorderRadius.all(Radius.circular(50))
  
             ),
             child: Icon(Icons.arrow_forward,color: AppColor().backgroundColor,size: 16,),
           )
  
  
        ],
      ),
    ),
),
  SizedBox(height: MediaQuery.of(context).size.height*0.1,)

]

),
   ),
    );
  }
  Future showCountryCode(BuildContext context)async{
    showCountryPicker(
  context: context,
  showPhoneCode: true, // optional. Shows phone code before the country name.
  onSelect: (Country country) {
    countryCode=country.toJson()['e164_cc'];
    countryFlag=country.toJson()['iso2_cc'];
    country.toJson();
    setState(() {
      
    });

    print('Select country: ${country.toJson()}');
  },
);

  }
}