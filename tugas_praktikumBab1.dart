import 'dart:async';

class User {
  String name;
  int age;
  late Set<Product> products;
  Role? role;

  User({required this.name, required this.age, this.role});

  void viewProducts() {
    if (products.isEmpty) {
      print("$name tidak memiliki produk.");
    } else {
      print("Produk yang dimiliki $name:");
      for (var product in products) {
        print(
            "${product.productName}, Harga: \$${product.price}, Stok: ${product.inStock ? "Tersedia" : "Habis"}");
      }
    }
  }

  void addProduct(Product product) {
    print("Fungsi addProduct() harus diimplementasikan pada subclass.");
  }
}

class Product {
  String productName;
  double price;
  bool inStock;

  Product({
    required this.productName,
    required this.price,
    required this.inStock,
  });
}

enum Role { Admin, Customer }

class AdminUser extends User {
  AdminUser({required String name, required int age})
      : super(name: name, age: age, role: Role.Admin);

  @override
  void addProduct(Product product) {
    try {
      if (!product.inStock) {
        throw Exception(
            "Produk ${product.productName} tidak tersedia di stok.");
      }
      if (products.add(product)) {
        print("Produk ${product.productName} berhasil ditambahkan.");
      } else {
        print("Produk ${product.productName} sudah ada di daftar.");
      }
    } catch (e) {
      print("Kesalahan: ${e.toString()}");
    }
  }

  void removeProduct(Product product) {
    if (products.remove(product)) {
      print("Produk ${product.productName} berhasil dihapus.");
    } else {
      print("Produk ${product.productName} tidak ditemukan.");
    }
  }
}

class CustomerUser extends User {
  CustomerUser({required String name, required int age})
      : super(name: name, age: age, role: Role.Customer);

  @override
  void addProduct(Product product) {
    print("Anda tidak memiliki izin untuk menambahkan produk.");
  }
}

Future<Product> fetchProductDetails(String productName) async {
  print("Mengambil detail produk $productName dari server...");
  await Future.delayed(Duration(seconds: 2));
  return Product(productName: productName, price: 100.0, inStock: true);
}

class UserWithMap extends User {
  late Map<String, Product> productMap;

  UserWithMap({required String name, required int age})
      : super(name: name, age: age) {
    productMap = {};
  }

  @override
  void addProduct(Product product) {
    if (product.inStock) {
      productMap[product.productName] = product;
      print("Produk ${product.productName} berhasil ditambahkan.");
    } else {
      print("Produk ${product.productName} stok habis.");
    }
  }

  @override
  void viewProducts() {
    print("Daftar Produk untuk $name:");
    if (productMap.isEmpty) {
      print("Tidak ada produk yang ditambahkan.");
    } else {
      productMap.forEach((key, value) {
        print(
            "$key - Harga: \$${value.price}, Stok: ${value.inStock ? 'Tersedia' : 'Habis'}");
      });
    }
  }
}

void main() async {
  AdminUser admin = AdminUser(name: "Admin User", age: 30);
  admin.products = Set<Product>();

  CustomerUser customer = CustomerUser(name: "Customer User", age: 25);
  customer.products = Set<Product>();

  Product laptop = Product(productName: "Laptop", price: 1500.0, inStock: true);
  Product phone = Product(productName: "Phone", price: 800.0, inStock: false);
  Product tablet = Product(productName: "Tablet", price: 600.0, inStock: true);

  admin.addProduct(laptop);
  admin.addProduct(phone);
  admin.addProduct(tablet);

  admin.viewProducts();

  customer.addProduct(laptop);

  admin.removeProduct(phone);

  admin.viewProducts();

  Product newProduct = await fetchProductDetails("Smartwatch");
  print(
      "Produk yang diambil dari server: ${newProduct.productName}, Harga: \$${newProduct.price}");

  UserWithMap userMap = UserWithMap(name: "User  dengan Map", age: 28);
  userMap.addProduct(laptop);
  userMap.addProduct(tablet);
  userMap.viewProducts();
}
