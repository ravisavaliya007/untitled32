

import 'dart:io';

class Customer {
  String custId;
  String custName;
  String custContact;
  List<Product> custCart = [];

  Customer(this.custId, this.custName, this.custContact);
}

class Product {
  String proId;
  String proName;
  int proQty;
  double proPrice;

  Product(this.proId, this.proName, this.proQty, this.proPrice);
}

void main() {
  List<Customer> customers = [];
  List<Product> products = [
    Product("P1", "Product 1", 10, 100),
    Product("P2", "Product 2", 5, 200),
    Product("P3", "Product 3", 3, 300),
    // Add more products as needed
  ];

  while (true) {
    print("\nMenu:");
    print("1. Add Customer");
    print("2. Shop");
    print("3. Search Customer by ID");
    print("4. Exit");
    print("Enter your choice: ");

    int choice = int.parse(stdin.readLineSync()!);

    switch (choice) {
      case 1:
        createCustomer(customers);
        break;
      case 2:
        shop(customers, products);
        break;
      case 3:
        searchCustomer(customers);
        break;
      case 4:
        print("Exiting program...");
        return;
      default:
        print("Invalid choice. Please try again.");
    }
  }
}

void createCustomer(List<Customer> customers) {
  print("\nEnter Customer Details:");
  print("Customer ID: ");
  String custId = stdin.readLineSync()!;
  print("Customer Name: ");
  String custName = stdin.readLineSync()!;
  print("Customer Contact: ");
  String custContact = stdin.readLineSync()!;

  customers.add(Customer(custId, custName, custContact));
  print("Customer added successfully!");
}

void shop(List<Customer> customers, List<Product> products) {
  if (customers.isEmpty) {
    print("No customers available. Please add a customer first.");
    return;
  }

  print("\nSelect a Customer:");
  for (int i = 0; i < customers.length; i++) {
    print("${i + 1}. ${customers[i].custName}");
  }

  int customerChoice = int.parse(stdin.readLineSync()!) - 1;
  Customer selectedCustomer = customers[customerChoice];

  while (true) {
    print("\nCategories:");
    print("1. Food");
    print("2. Electronics");
    print("3. Clothing");
    print("4. Exit");
    print("Enter your choice: ");

    int categoryChoice = int.parse(stdin.readLineSync()!);

    if (categoryChoice == 4) {
      break;
    }

    print("\nProducts:");
    for (int i = 0; i < products.length; i++) {
      print("${i + 1}. ${products[i].proName} - ${products[i].proPrice} INR");
    }

    print("Enter the product number: ");
    int productChoice = int.parse(stdin.readLineSync()!) - 1;

    if (productChoice < 0 || productChoice >= products.length) {
      print("Invalid product choice. Please try again.");
      continue;
    }

    Product selectedProduct = products[productChoice];

    print("Enter quantity: ");
    int quantity = int.parse(stdin.readLineSync()!);

    if (selectedProduct.proQty >= quantity) {
      selectedProduct.proQty -= quantity;
      selectedCustomer.custCart.add(Product(
          selectedProduct.proId,
          selectedProduct.proName,
          quantity,
          selectedProduct.proPrice * quantity));
      print("Product added to cart successfully!");
    } else {
      print("Insufficient stock.");
    }
  }

  double totalAmount = 0;
  selectedCustomer.custCart.forEach((product) {
    totalAmount += product.proPrice;
  });

  double discount = 0;
  if (totalAmount >= 500 && totalAmount < 1500) {
    discount = 0.10;
  } else if (totalAmount >= 1500 && totalAmount < 3500) {
    discount = 0.20;
  } else if (totalAmount >= 3500 && totalAmount < 6500) {
    discount = 0.25;
  } else if (totalAmount >= 6500) {
    discount = 0.30;
  }

  double discountedAmount = totalAmount * (1 - discount);

  print("\nBilling Summary:");
  print("Customer ID: ${selectedCustomer.custId}");
  print("Customer Name: ${selectedCustomer.custName}");
  print("Cart:");
  selectedCustomer.custCart.forEach((product) {
    print("${product.proQty} ${product.proName} - ${product.proPrice} INR");
  });
  print("Total Amount: ${totalAmount.toStringAsFixed(2)} INR");
  print("Discount: ${(discount * 100).toStringAsFixed(2)}%");
  print("Discounted Amount: ${discountedAmount.toStringAsFixed(2)} INR");
}

void searchCustomer(List<Customer> customers) {
  print("Enter Customer ID to search: ");
  String searchId = stdin.readLineSync()!;

  Customer? foundCustomer;
  for (Customer customer in customers) {
    if (customer.custId == searchId) {
      foundCustomer = customer;
      break;
    }
  }

  if (foundCustomer != null) {
    print("\nSearch Result:");
    print("Customer ID: ${foundCustomer.custId}");
    print("Customer Name: ${foundCustomer.custName}");
    print("Customer Contact: ${foundCustomer.custContact}");
    print("Cart:");
    double totalAmount = 0;
    foundCustomer.custCart.forEach((product) {
      print("${product.proQty} ${product.proName} - ${product.proPrice} INR");
      totalAmount += product.proPrice;
    });
    double discount = calculateDiscount(totalAmount);
    double discountedAmount = totalAmount * (1 - discount);
    print("Total Amount: ${totalAmount.toStringAsFixed(2)} INR");
    print("Discount: ${(discount * 100).toStringAsFixed(2)}%");
    print("Discounted Amount: ${discountedAmount.toStringAsFixed(2)} INR");
  } else {
    print("Customer not found.");
  }
}

double calculateDiscount(double totalAmount) {
  if (totalAmount >= 500 && totalAmount < 1500) {
    return 0.10;
  } else if (totalAmount >= 1500 && totalAmount < 3500) {
    return 0.20;
  } else if (totalAmount >= 3500 && totalAmount < 6500) {
    return 0.25;
  } else if (totalAmount >= 6500) {
    return 0.30;
  } else {
    return 0.0;
  }
}
