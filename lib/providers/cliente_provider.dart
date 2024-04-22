import 'package:flutter/material.dart';
import 'package:tecnoshopping/models/cliente_model.dart';

class ClienteProvider extends ChangeNotifier {
  Cliente? _cliente;

  Cliente? get cliente => _cliente;

  void ponerCliente(Cliente cliente) {
    _cliente = cliente;
  }

  void clienteNull() {
    _cliente = null;
  }
}
