import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/adapters.dart';
import '../services/database.dart';

class ValuesNotifier extends ChangeNotifier {
  ValuesNotifier() {
    setBox();
    getCarts();
    getCountWishlist();
  }

  Box? setting;
  var cartCount = "";
  var wishlistCount = "";
  var timeCount = "5:00";

  setBox() async {
    await Hive.initFlutter();
    setting = await Hive.openBox('setting');
  }

  getCarts() async {
    await DBProvider.db.getCarts().then((value) {
      cartCount = "${value.length}";
      cartCount = cartCount == "0" ? "" : cartCount;
      notifyListeners();
    });
  }

  getCountWishlist() async {
    await DBProvider.db.getWishlists().then((value) {
      wishlistCount = "${value.length}";
      wishlistCount = wishlistCount == "0" ? "" : wishlistCount;
      notifyListeners();
    });
  }

  setCartCount(String val) {
    cartCount = val;
    notifyListeners();
  }

  setTimeCount(String val) {
    timeCount = val;
    notifyListeners();
  }

  setWishlistCount(String val) {
    wishlistCount = val;
    notifyListeners();
  }
}