class Product {
  String? productId;
  String? businessId;
  String? productName;
  dynamic costPrice;
  dynamic sellingPrice;
  int? quantity;
  int? quantitySold;
  int? quantityLeft;
  DateTime? createdTime;
  DateTime? updatedTime;
  String? productType;
  DateTime? dateExpiration;
  String? productLogoFileStoreId;
  bool? deleted;
  bool? isAddingPending;
  bool? isUpdatingPending;

  Product(
      {this.productId,
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
      this.deleted,
      this.isAddingPending,
      this.isUpdatingPending});
  factory Product.fromJson(Map<String, dynamic> json) => Product(
      productId: json['id'],
      businessId: json['businessId'],
      costPrice: json['costPrice'],
      productName: json['name'],
      sellingPrice: json['sellingPrice'],
      quantity: json['quantity'],
      quantitySold: json['quantitySold'] ?? 0,
      quantityLeft: json['quantityLeft'] ?? 0,
      createdTime: DateTime.parse(json['createdDateTime']),
      updatedTime: json['updatedDateTime'] == null
          ? DateTime.parse(json['createdDateTime'])
          : DateTime.parse(json['updatedDateTime']),
      productType: json['productType'],
      dateExpiration: json['productExpiration'] == null
          ? null
          : DateTime.parse(json['productExpiration']),
      productLogoFileStoreId: json['productLogoFileStoreUrl'],
      deleted: json['deleted']??false,
      isAddingPending: json['isAddingPending'] ?? false,
      isUpdatingPending: json['isUpdatingPending'] ?? false);
  Map<String, dynamic> toJson() => {
        "id": productId,
        "businessId": businessId,
        "costPrice": costPrice,
        "name": productName,
        "sellingPrice": sellingPrice,
        "quantity": quantity,
        'quantitySold': quantitySold ?? 0,
        'quantityLeft': quantityLeft ?? 0,
        "createdDateTime": createdTime == null
            ? DateTime.now().toIso8601String()
            : createdTime!.toIso8601String(),
        "updatedDateTime": updatedTime == null
            ? DateTime.now().toIso8601String()
            : updatedTime!.toIso8601String(),
        "productType": productType,
        "productExpiration":
            dateExpiration == null ? null : dateExpiration!.toIso8601String(),
        "productLogoFileStoreUrl": productLogoFileStoreId,
        "deleted": deleted,
        "isAddingPending": isAddingPending ?? false,
        "isUpdatePendig": isUpdatingPending ?? false
      };
}
