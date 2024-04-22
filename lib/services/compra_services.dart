import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:tecnoshopping/models/cliente_model.dart';
import 'dart:convert';

import 'package:tecnoshopping/models/products_model.dart';
import 'package:tecnoshopping/providers/providers.dart';

Future<String> realizarCompra(Map<String, dynamic> data) async {
  final url = Uri.parse('http://3.134.107.41/api/purchase');
  final headers = {'Content-Type': 'application/json'};
  final body = json.encode(data);

  final response = await http.post(url, headers: headers, body: body);

  if (response.statusCode == 200) {
    // La solicitud fue exitosa
    return json.decode(response.body)['success'];
  } else {
    // Ocurrió un error
    throw Exception('Error al realizar la compra');
  }
}

Future<Map<String, dynamic>> obtenerDatosCompra(BuildContext context) async {
  final clienteProvider = Provider.of<ClienteProvider>(context, listen: false);
  final totalProvider = Provider.of<TotalPurchasedProvider>(context, listen: false);
  final productsProvider = Provider.of<ProductsProvider>(context, listen: false);

  // Obtener los datos del cliente
  final Cliente? cliente = clienteProvider.cliente;
  if (cliente == null) {
    throw Exception('No se ha establecido un cliente');
  }

  // Obtener el total de la compra
  final double total = totalProvider.purchasedTotal;

  // Obtener los productos comprados
  final Products? products = productsProvider.products;
  if (products == null) {
    throw Exception('No se han seleccionado productos');
  }

  final List<Map<String, dynamic>> productosCompra = products.products.map((product) {
    return {
      'id': product.id,
      'quantity': product.purchased,
      'unit_price': product.price,
      'subtotal': product.buy,
    };
  }).toList();

  // Construir el mapa datosCompra
  final Map<String, dynamic> datosCompra = {
    'products': productosCompra,
    'total': total,
    'cliente': {
      'ci': cliente.ci,
      'name': cliente.name,
      'last_name': cliente.last_name,
      'number_phone': cliente.phone,
    },
  };

  return datosCompra;
}
