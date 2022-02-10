class ServiceModel {
  String? name, amount, description, image;
  ServiceModel({
    this.amount,
    this.name,
    this.image,
    this.description,
  });
}

List<ServiceModel> serviceList = [
  ServiceModel(
    amount: 'N20,000',
    name: 'Labour',
    image: 'assets/images/productImage.png',
    description:
        'Helped moving some certain loads from one place to the other Helped moving some certain loads from one place to the other Helped moving some certain loads from one place to ',
  ),
  ServiceModel(
    amount: 'N4,456',
    name: 'Labour',
    image: 'assets/images/productImage.png',
    description:
        'Helped moving some certain loads from one place to the other Helped moving some certain loads from one place to the other Helped moving some certain loads from one place to ',
  ),
  ServiceModel(
    amount: 'N5980',
    name: 'Labour',
    image: 'assets/images/productImage.png',
    description:
        'Helped moving some certain loads from one place to the other Helped moving some certain loads from one place to the other Helped moving some certain loads from one place to ',
  ),
  ServiceModel(
    amount: 'N3,000',
    name: 'Labour',
    image: 'assets/images/productImage.png',
    description:
        'Helped moving some certain loads from one place to the other Helped moving some certain loads from one place to the other Helped moving some certain loads from one place to ',
  ),
  ServiceModel(
    amount: 'N3,000',
    name: 'Labour',
    image: 'assets/images/productImage.png',
    description:
        'Helped moving some certain loads from one place to the other Helped moving some certain loads from one place to the other Helped moving some certain loads from one place to ',
  ),
  ServiceModel(
    amount: 'N3,000',
    name: 'Labour',
    image: 'assets/images/productImage.png',
    description:
        'Helped moving some certain loads from one place to the other Helped moving some certain loads from one place to the other Helped moving some certain loads from one place to ',
  ),
  ServiceModel(
    amount: 'N3,000',
    name: 'Labour',
    image: 'assets/images/productImage.png',
    description:
        'Helped moving some certain loads from one place to the other Helped moving some certain loads from one place to the other Helped moving some certain loads from one place to ',
  ),
  ServiceModel(
    amount: 'N3,000',
    name: 'Labour',
    description:
        'Helped moving some certain loads from one place to the other Helped moving some certain loads from one place to the other Helped moving some certain loads from one place to ',
  ),
];

class Service {
  String? name;
  Service({this.name});
}

List<Service> serviceListz = [
  Service(name: 'Shoe'),
  Service(name: 'Bag'),
  Service(name: 'Television'),
];
