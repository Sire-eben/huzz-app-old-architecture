class CustomerM {
  String? name, acctNo, bankName;

  CustomerM({this.bankName, this.name, this.acctNo});
}

List<CustomerM> customerMList = [
  CustomerM(
      name: 'Akinlose Damilare', acctNo: '09038726495', bankName: 'First Bank'),
  CustomerM(name: 'Olaitan Adetayo', acctNo: '09038726495', bankName: 'GTB'),
  CustomerM(name: 'Olatunde Joshua', acctNo: '09038726495', bankName: 'Wema'),
  CustomerM(
      name: 'Akinlose Joshua', acctNo: '09038726495', bankName: 'Kuda Bank'),
  CustomerM(
      name: 'Olatunde Damilare',
      acctNo: '09038726495',
      bankName: 'Access Bank'),
];
