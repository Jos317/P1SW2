import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tecnoshopping/models/products_model.dart';

class ProductsProvider extends ChangeNotifier {
  Products? _products;

  Products? get products => _products;

  Future<void> inicializarDatos() async {
    await obtenerDatos();
  }

  Future<void> obtenerDatos() async {
    final response = await http
        .get(Uri.parse('http://3.134.107.41/api/products'));

    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);
      _products = Products.fromJson(decodedData);
      notifyListeners();
    } else {
      throw Exception('Error al obtener datos');
    }
  }

  // Future<void> obtenerDatos() async {
  //   final Products prueba = Products(
  //     products: [
  //       Product(
  //         id: 1, 
  //         code: "A1", 
  //         name: "Mouse Gamer Inalambrico", 
  //         url: "", 
  //         brand: "2.4 Ghz",
  //         description: "Small format at 60%. HyperX mechanical switches. Double Layer PBT Keycaps (Black). Customizable with HyperX", 
  //         quantity: 10, 
  //         price: 10.2, 
  //         category: Category(
  //           id: 1, 
  //           name: "Mouse"
  //         )),
  //       Product(
  //         id: 2,
  //         code: "A2",
  //         name: "Trust Gxt 107 Izza Negro",
  //         url: "https://radioshackbo.com/wp-content/uploads/2019/10/DEADBOLT-Gaming-Mouse-8D-Inalambrico-de-2-4GHz-2606002-01.jpg",
  //         brand: "GXT 107 IZZA",
  //         description: "Small format at 60%. HyperX mechanical switches. Double Layer PBT Keycaps (Black). Customizable with HyperX",
  //         quantity: 15,
  //         price: 15.50,
  //         category: Category(
  //           id: 1,
  //           name: "Mouse",
  //         ),
  //       ),
  //       Product(
  //         id: 3,
  //         code: "A3",
  //         name: "hyperx alloy origins 70",
  //         url: "https://www.venex.com.ar/products_images/1625603479_hx-product-keyboard-alloy-origins-core-us-2-zm-lg.jpg",
  //         brand: "hyperx alloy",
  //         description: "Small format at 60%. HyperX mechanical switches. Double Layer PBT Keycaps (Black). Customizable with HyperX",
  //         quantity: 5,
  //         price: 50,
  //         category: Category(
  //           id: 2,
  //           name: "Teclado",
  //         ),
  //       ),
  //       Product(
  //         id: 4,
  //         code: "A4-002",
  //         name: "60 preview hyperx alloy origins",
  //         url: "https://www.pcgamesn.com/wp-content/sites/pcgamesn/2021/05/hyper-x-alloy-origins-60-gaming-keyboard-review-550x309.jpg",
  //         brand: "hyperx alloy",
  //         description: "Small format at 60%. HyperX mechanical switches. Double Layer PBT Keycaps (Black). Customizable with HyperX",
  //         quantity: 10,
  //         price: 40.5,
  //         category: Category(
  //           id: 2,
  //           name: "Teclado",
  //         ),
  //       ),
  //       Product(
  //         id: 5,
  //         code: "A4421",
  //         name: "Mouse Gamer Inalambrico",
  //         url: "https://radioshackbo.com/wp-content/uploads/2019/10/DEADBOLT-Gaming-Mouse-8D-Inalambrico-de-2-4GHz-2606002-01.jpg",
  //         brand: "2.4 Ghz",
  //         description: "Small format at 60%. HyperX mechanical switches. Double Layer PBT Keycaps (Black). Customizable with HyperX",
  //         quantity: 5,
  //         price: 7500,
  //         category: Category(
  //           id: 3,
  //           name: "Laptop",
  //         ),
  //       ),
  //       Product(
  //         id: 6,
  //         code: "A2112",
  //         name: "Mouse Gamer Inalambrico Trust Gxt 107 Izza Negro",
  //         url: "https://radioshackbo.com/wp-content/uploads/2019/10/DEADBOLT-Gaming-Mouse-8D-Inalambrico-de-2-4GHz-2606002-01.jpg",
  //         brand: "GXT 107 IZZA",
  //         description: "Small format at 60%. HyperX mechanical switches. Double Layer PBT Keycaps (Black). Customizable with HyperX",
  //         quantity: 15,
  //         price: 20050.50,
  //         category: Category(
  //           id: 4,
  //           name: "MacBook",
  //         ),
  //       ),
  //       Product(
  //         id: 7,
  //         code: "BF13",
  //         name: "hyperx alloy origins 70",
  //         url: "https://www.venex.com.ar/products_images/1625603479_hx-product-keyboard-alloy-origins-core-us-2-zm-lg.jpg",
  //         brand: "hyperx alloy",
  //         description: "Small format at 60%. HyperX mechanical switches. Double Layer PBT Keycaps (Black). Customizable with HyperX",
  //         quantity: 5,
  //         price: 155.50,
  //         category: Category(
  //           id: 5,
  //           name: "Monitor",
  //         ),
  //       ),
  //       Product(
  //         id: 8,
  //         code: "A4-1102",
  //         name: "hyperx alloy origins 60 preview",
  //         url: "https://www.pcgamesn.com/wp-content/sites/pcgamesn/2021/05/hyper-x-alloy-origins-60-gaming-keyboard-review-550x309.jpg",
  //         brand: "hyperx alloy",
  //         description: "Small format at 60%. HyperX mechanical switches. Double Layer PBT Keycaps (Black). Customizable with HyperX",
  //         quantity: 10,
  //         price: 200.50,
  //         category: Category(
  //           id: 6,
  //           name: "Impresora",
  //         ),
  //       ),
  //   ]);
  //   _products = prueba;
  // }

  List<String> getAllCategories() {
    final Set<String> categories = {}; // Conjunto para almacenar categorías únicas
    final Products allProducts = _products!;
    // Iteramos sobre la lista de productos
    for (var product in allProducts.products) {
      // Agregamos el nombre de la categoría al conjunto
      categories.add(product.category.name);
    }

    return categories.toList(); // Convertimos el conjunto en una lista
  }

  void productsNull() {
    _products = null;
  }
}
