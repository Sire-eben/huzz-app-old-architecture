import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huzz/colors.dart';

class CustomDropDownField extends StatelessWidget{
Rx<String> currentSelectedValue;
TextStyle? labelTextStyle;
String? hintText;
List<String> values;
String? label;
String? validatorText;
  CustomDropDownField({
 required this.currentSelectedValue,
 this.labelTextStyle=const TextStyle(color:Colors.grey),
 required this.hintText,
 required this.values,
 this.label,
 this.validatorText

  });

 String _currentSelectedValue="";
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var _currencies = [];
  
print("value ${ currentSelectedValue.value.isEmpty}");
return  Container(
     width: MediaQuery.of(context).size.width,
   height: 104,
   
  child:   Column(
    children: [
Container(
  margin: EdgeInsets.only(left: 20,right: 20,top: 9),
  child: 
Row(
  crossAxisAlignment: CrossAxisAlignment.center,
  children: [
        Text(label!,style: TextStyle(color:Colors.black,fontSize: 12),),
        SizedBox(width: 5,),
       (validatorText!=null &&validatorText!.isNotEmpty)? Container(
         margin: EdgeInsets.only(top: 5),
         child: Text("*",style: TextStyle(color: Colors.red,fontSize: 12),)):Container()
  ],
)),

      Container(
        margin: EdgeInsets.only(left: 20,right: 20,top: 10),
        child: FormField<String>(
                  builder: (FormFieldState<String> state) {
                    return InputDecorator(
                      decoration: InputDecoration(
                          labelStyle:labelTextStyle,
                          errorStyle: TextStyle(color: Colors.redAccent, fontSize: 16.0),
                          hintText: hintText,
                          enabledBorder:OutlineInputBorder(
                            borderSide: BorderSide(color: AppColor().backgroundColor),
                            borderRadius: BorderRadius.circular(10.0)) ,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColor().backgroundColor),
                            borderRadius: BorderRadius.circular(10.0))),
                      isEmpty: currentSelectedValue.value.isEmpty,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: currentSelectedValue.value.isEmpty?null:currentSelectedValue.value,
                          isDense: true,
                          onChanged: (String? newValue) {
                            
                              currentSelectedValue(newValue!);
                              state.didChange(newValue);
                          
                          },
                          items: values.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  },
                ),
      ),
    ],
  ),
);
  }
}