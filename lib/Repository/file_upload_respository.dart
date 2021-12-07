import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../api_link.dart';
import 'auth_respository.dart';
 import 'package:http_parser/http_parser.dart';



class FileUploadRespository extends GetxController{

final _userController=Get.find<AuthRepository>();
Future<String> uploadFile(String path)async{

var request=http.MultipartRequest("POST",Uri.parse(ApiLink.upload_file));
request.headers.addAll({
  "Authorization":"Bearer ${_userController.token}"
});

request.files.add(await http.MultipartFile.fromPath("file", path,contentType: new MediaType('image', 'jpeg')));
var streamResponse=await request.send(); 
String result = await streamResponse.stream.transform(Utf8Decoder()).single;
print("uploaded file output $result");

if(streamResponse.statusCode==200){

  // Get.snackbar("Success", "Profile Image Updated Successfully");
return result;
}else{
// Get.snackbar("Error", "Unable to Update Profile Image");
return "";
}





}

}