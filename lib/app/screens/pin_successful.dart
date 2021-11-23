import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:huzz/app/screens/create_business.dart';
import 'package:huzz/colors.dart';

class PinSuccesful extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
body:Container(
width: MediaQuery.of(context).size.width,
height: MediaQuery.of(context).size.height,
child: Column(

  children: [

Container(
         height: 100,
         width: MediaQuery.of(context).size.width,
         child: Stack(
children: [

Positioned(
  top:20,
  child: SvgPicture.asset('assets/images/Vector.svg')),
  Positioned(
    top: 50,
    left:20,
    child: Icon(Icons.arrow_back,color: AppColor().backgroundColor,))

],


         ),
       ), 

       Container(
        width: MediaQuery.of(context).size.width*0.5,
         child: Text("PIN Created Successfully",textAlign: TextAlign.center,style: TextStyle(fontSize: 30,color: AppColor().backgroundColor),)),
       SizedBox(height: MediaQuery.of(context).size.height*0.2,),

       SvgPicture.asset("assets/images/Vector (2).svg"),
Expanded(child: SizedBox()),
       GestureDetector(
         onTap:(){
          Get.to(CreateBusiness());
         },

         child: Container(
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
           Text('Proceed',style: TextStyle(color: Colors.white,fontSize: 18),),
           SizedBox(width: 10,),
          //  Container(padding: EdgeInsets.all(3),
          //    decoration:BoxDecoration(
          //      color: Colors.white,borderRadius: BorderRadius.all(Radius.circular(50))
       
          //    ),
          //    child: Icon(Icons.arrow_forward,color: AppColor().backgroundColor,size: 16,),
          //  )
       
       
             ],
           ),
         ),
       ),
  SizedBox(height: MediaQuery.of(context).size.height*0.1,)




  ],
),

)

    );
  }
}