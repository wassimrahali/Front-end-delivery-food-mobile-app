class ApiConstants {
  static const String baseUrl = 'https://foodie-back.up.railway.app/api';

  // Auth Endpoints
  static const String registerCustomer = '$baseUrl/auth/register';
  static const String registerDeliveryMan = '$baseUrl/auth/registerDeliveryMan';
  static const String loginCustomer = '$baseUrl/auth/login';
  static const String loginAdmin = '$baseUrl/auth/loginAdmin';
  static const String loginDeliveryMan = '$baseUrl/auth/loginDileveryMan';
  static const String sendEmail = '$baseUrl/auth/sendVerificationCode';
  static const String resetPassword = '$baseUrl/auth/resetPassword';
  static const String updatePasswordByEmail = '$baseUrl/auth/updatePasswordByEmail';

  // Customer Endpoints
  static const String getAllCustomers = '$baseUrl/auth/customers';
  static const String getCustomerById = '$baseUrl/auth/customer/'; // Append {id} dynamically
  static const String updateCustomer = '$baseUrl/auth/customer/'; // Append {id} dynamically
  static const String deleteCustomer = '$baseUrl/auth/customer/'; // Append {id} dynamically
  static const String LogoutCustomer = '$baseUrl/auth/signout';


  // DeliveryMan Endpoints
  static const String getAllDeliveryMen = '$baseUrl/auth/DeliveryMan';
  static const String getDeliveryManById = '$baseUrl/auth/DeliveryMan/'; // Append {id} dynamically
  static const String updateDeliveryMan = '$baseUrl/auth/DeliveryMan/'; // Append {id} dynamically
  static const String deleteDeliveryMan = '$baseUrl/auth/DeliveryMan/'; // Append {id} dynamically

  // Product Endpoints
  static const String getAllProducts = '$baseUrl/products';
  static const String createProduct = '$baseUrl/products';
  static const String getProductById = '$baseUrl/products/'; // Append {id} dynamically
  static const String updateProduct = '$baseUrl/products/'; // Append {id} dynamically
  static const String deleteProduct = '$baseUrl/products/'; // Append {id} dynamically

  // Category Endpoints
  static const String getAllCategories = '$baseUrl/categories';
  static const String createCategory = '$baseUrl/categories';
  static const String getCategoryById = '$baseUrl/categories/'; // Append {id} dynamically
  static const String updateCategory = '$baseUrl/categories/'; // Append {id} dynamically
  static const String deleteCategory = '$baseUrl/categories/'; // Append {id} dynamically
//Order Endpoints
  static const String createOrder = '$baseUrl/orders';
  static const String getALLOrders = '$baseUrl/orders';
  static const String getAOrdersByStatus= '$baseUrl/orders/status/';
  static const String getOrderById = '$baseUrl/orders/customer/';
  static const String UpdateOrderStatusById = '$baseUrl/orders/update-status/';
  static const String UpdateOrderDataById = '$baseUrl/orders/';


}
