class Product{
String? productId;
String? businessId;
String? productName;
int? costPrice;
int? sellingPrice;
int? quantity;
int? quantitySold;
int? quantityLeft;
DateTime? createdTime;
DateTime? updatedTime;
String? productType;
DateTime? dateExpiration;
String? productLogoFileStoreId;
bool? deleted;


Product({
this.productId,
this.businessId,
this.productName,
this.costPrice,
this.sellingPrice,
this.quantity,
this.quantitySold,
this.quantityLeft,
this.createdTime,
this.updatedTime,
this.productType,
this.dateExpiration,
this.productLogoFileStoreId,
this.deleted

});
factory Product.fromJson(Map<String,dynamic> json)=>Product(
productId: json['id'],
businessId: json['businessId'],
costPrice: json['costPrice'],
productName: json['name'],
sellingPrice: json['sellingPrice'],
quantity: json['quantity'],
quantitySold: json['quantitySold']??0,
quantityLeft: json['quantityLeft']??0,
createdTime: DateTime.parse(json['createdDateTime']),
updatedTime: json['updatedDateTime']==null?DateTime.parse(json['createdDateTime']):DateTime.parse(json['updatedDateTime']),
productType:json['productType'],
dateExpiration: json['productExpiration']==null?null:DateTime.parse(json['productExpiration']),
productLogoFileStoreId: json['productLogoFileStoreId'],
deleted: json['delete']



);
Map<String,dynamic> toJson()=>{
"id":productId,
"businessId":businessId,
"costPrice":costPrice,
"name":productName,
"sellingPrice":sellingPrice,
"quantity":quantity,
'quantitySold':quantitySold,
'quantityLeft':quantityLeft,
"createdDateTime":createdTime!.toIso8601String(),
"updatedDateTime":updatedTime!.toIso8601String(),
"productType":productType,
"productExpiration":dateExpiration==null?null:dateExpiration!.toIso8601String(),
"productLogoFileStoreId":productLogoFileStoreId,
"deleted":deleted


};
}