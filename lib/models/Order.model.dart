class Order {
  final int id;
  final String totalPrice;
  final String status;
  final String location;
  final String createdAt;
  final Customer customer;
  final DeliveryMan deliveryMan;
  final List<OrderItem> orderItems;

  Order({
    required this.id,
    required this.totalPrice,
    required this.status,
    required this.location,
    required this.createdAt,
    required this.customer,
    required this.deliveryMan,
    required this.orderItems,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    var orderItemsJson = json['orderItems'] as List? ?? [];
    List<OrderItem> orderItemsList = orderItemsJson.map((item) => OrderItem.fromJson(item)).toList();

    return Order(
      id: json['id'],
      totalPrice: json['totalPrice'] ?? '0', // Handle string price
      status: json['status'] ?? 'Unknown',
      location: json['location'] ?? '',
      createdAt: json['createdAt'] ?? '',
      customer: Customer.fromJson(json['customer'] ?? {}), // Check for null
      deliveryMan: DeliveryMan.fromJson(json['deliveryMan'] ?? {}), // Check for null
      orderItems: orderItemsList,
    );
  }
}

class Customer {
  final String name;
  final String phone;

  Customer({
    required this.name,
    required this.phone,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      name: json['name'] ?? '', // Default empty string if null
      phone: json['phone'] ?? '', // Default empty string if null
    );
  }
}

class DeliveryMan {
  final String name;
  final String phone;

  DeliveryMan({
    required this.name,
    required this.phone,
  });

  factory DeliveryMan.fromJson(Map<String, dynamic> json) {
    return DeliveryMan(
      name: json['name'] ?? '', // Default empty string if null
      phone: json['phone'] ?? '', // Default empty string if null
    );
  }
}

class OrderItem {
  final int id;
  final Product product;
  final int quantity;

  OrderItem({
    required this.id,
    required this.product,
    required this.quantity,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      product: Product.fromJson(json['product'] ?? {}), // Check for null product
      quantity: json['quantity'] ?? 0, // Default quantity 0 if null
    );
  }
}

class Product {
  final int id;
  final String name;
  final String mainImage;
  final String price;
  final String description;
  final String preparationDuration;
  final String rating;
  final List<String> sizes;

  Product({
    required this.id,
    required this.name,
    required this.mainImage,
    required this.price,
    required this.description,
    required this.preparationDuration,
    required this.rating,
    required this.sizes,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    var sizesJson = json['sizes'] as List? ?? [];
    List<String> sizesList = List<String>.from(sizesJson);

    return Product(
      id: json['id'],
      name: json['name'] ?? '',
      mainImage: json['mainImage'] ?? '',
      price: json['price'] ?? '0', // Price as string
      description: json['description'] ?? '',
      preparationDuration: json['preparationDuration'] ?? '',
      rating: json['rating'] ?? '',
      sizes: sizesList,
    );
  }
}
