import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/cart.dart';
import '../models/wishlist.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "ohotika.db");

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute("CREATE TABLE Cart ("
              "cart_id INTEGER PRIMARY KEY,"
              "pid TEXT,"
              "name TEXT,"
              "image_url TEXT,"
              "quantity INTEGER,"
              "price DOUBLE,"
              "size TEXT,"
              "size_name TEXT,"
              "article TEXT,"
              "category TEXT"
              ")");

          await db.execute("CREATE TABLE Wishlist ("
              "id INTEGER PRIMARY KEY,"
              "pid TEXT,"
              "name TEXT,"
              "image_url TEXT,"
              "price DOUBLE,"
              "category TEXT"
              ")");
        });
  }

  getCart(int id) async {
    final db = await database;
    var res = await db.query("Cart", where: "pid = ?", whereArgs: [id]);
    var list = <Cart>[];

    if (res.isNotEmpty) {
      for (var i in res) {
        try {
          var cart = Cart.fromMap({
            "cart_id": i['cart_id'],
            "pid": i['pid'],
            "name": i['name'],
            "quantity": i['quantity'],
            "price": i['price'],
            "image_url": i['image_url'],
            "size": i['size'],
            "article": i['article']
          });

          list.add(cart);
        } catch (error) {
          //
        }
      }
    }

    return list;
  }

  Future<List<Cart>> getCarts() async {
    final db = await database;
    var res = await db.query("Cart", distinct: true, orderBy: 'cart_id');
    var list = <Cart>[];

    if (res.isNotEmpty) {
      try {
        for (var i in res) {
          var cart = Cart.fromMap({
            "cart_id": i['cart_id'],
            "pid": i['pid'],
            "name": i['name'],
            "quantity": i['quantity'],
            "price": i['price'],
            "image_url": i['image_url'],
            "size": i['size'],
            "size_name": i['size_name'],
            "article": i['article'],
            "category": i['category']
          });

          list.add(cart);
        }
      } catch (error) {
        //
      }
    }

    return list;
  }

  Future<void> clearCart() async {
    final Database db = await database;
    db.delete("Cart");
  }

  Future<List<Cart>> deleteCart(int id) async {
    final Database db = await database;
    db.delete("Cart", where: "cart_id = ?", whereArgs: [id]);
    return getCarts();
  }

  Future<int> addCart(Cart cart) async {
    var cartId = 0;

    if (cart.quantity! > 0) {
      final Database db = await database;

      cartId = await db.insert(
        'Cart',
        cart.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    return cartId;
  }

  Future<List<Cart>> updateCart(int id, int quantity) async {
    final Database db = await database;

    if (quantity <= 0) {
      db.delete("Cart", where: "cart_id = ?", whereArgs: [id]);
    } else {
      db.update("Cart", {"quantity": quantity}, where: 'cart_id = ?', whereArgs: [id]);
    }

    return getCarts();
  }

  addWishlist(Wishlist wishlist) async {
    final Database db = await database;
    await db.insert(
      'Wishlist',
      wishlist.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Cart>> deleteWishlist(String id) async {
    final Database db = await database;
    db.delete("Wishlist", where: "pid = ?", whereArgs: [id]);
    return getCarts();
  }

  Future<List<Wishlist>> getWishlists() async {
    final db = await database;
    var res = await db.query("Wishlist", distinct: true, orderBy: 'id');
    var list = <Wishlist>[];

    if (res.isNotEmpty) {
      try {
        for (var i in res) {
          var item = Wishlist.fromMap({
            "id": i['id'],
            "pid": i['pid'],
            "name": i['name'],
            "price": i['price'],
            "image_url": i['image_url'],
            "category": i['category']
          });

          list.add(item);
        }
      } catch (error) {
        //
      }
    }

    return list;
  }

  Future<void> clearWishlist() async {
    final Database db = await database;
    db.delete("Wishlist");
  }

}