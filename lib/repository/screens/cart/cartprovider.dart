import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String name;
  final String image;
  final double price;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    this.quantity = 1,
  });
}

class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  int get itemCount => _items.values.fold(0, (sum, item) => sum + item.quantity);

  double get totalAmount {
    return _items.values.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  void addItem(String id, String name, String image, double price) {
    if (_items.containsKey(id)) {
      _items.update(
        id,
            (existingItem) => CartItem(
          id: existingItem.id,
          name: existingItem.name,
          image: existingItem.image,
          price: existingItem.price,
          quantity: existingItem.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        id,
            () => CartItem(
          id: id,
          name: name,
          image: image,
          price: price,
        ),
      );
    }
    notifyListeners();
  }

  void incrementQuantity(String id) {
    if (_items.containsKey(id)) {
      _items.update(
        id,
            (existingItem) => CartItem(
          id: existingItem.id,
          name: existingItem.name,
          image: existingItem.image,
          price: existingItem.price,
          quantity: existingItem.quantity + 1,
        ),
      );
      notifyListeners();
    }
  }

  void decrementQuantity(String id) {
    if (!_items.containsKey(id)) return;

    if (_items[id]!.quantity > 1) {
      _items.update(
        id,
            (existingItem) => CartItem(
          id: existingItem.id,
          name: existingItem.name,
          image: existingItem.image,
          price: existingItem.price,
          quantity: existingItem.quantity - 1,
        ),
      );
    } else {
      _items.remove(id);
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}