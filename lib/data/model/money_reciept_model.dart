class Customer {
  final String name;
  final String phone;

  const Customer({
    required this.name,
    required this.phone,
  });
}

class Supplier {
  final String name;
  final String mail;
  final String phone;

  const Supplier({
    required this.name,
    required this.mail,
    required this.phone,
  });
}

class MoneyInOutInvoice {
  final InvoiceInfo info;
  final Supplier supplier;
  final Customer customer;
  final List<InvoiceItem> items;

  const MoneyInOutInvoice({
    required this.info,
    required this.supplier,
    required this.customer,
    required this.items,
  });
}

class InvoiceInfo {
  final String description;
  final String number;
  final DateTime date;
  final DateTime dueDate;

  const InvoiceInfo({
    required this.description,
    required this.number,
    required this.date,
    required this.dueDate,
  });
}

class InvoiceItem {
  final String item;
  final int quantity;
  final double amount;

  const InvoiceItem({
    required this.item,
    required this.quantity,
    required this.amount,
  });
}
