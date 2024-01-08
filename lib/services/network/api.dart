import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:async';
import 'dart:convert';
import '../../models/api_response.dart';
import '../../models/brends.dart';
import '../../models/categories.dart';
import '../../models/contact.dart';
import '../../models/product.dart';
import '../../models/products.dart';
import '../../models/search.dart';
import '../../other/constant.dart';

class Api {
  static Future<Categories> getCategory(String id) async {
    final response = await get(
        Uri.parse(categoriesUrl),
        headers: {
          'Content-Type': 'application/json',
        }
    ).catchError((error) {
      return error;
    });

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);

      if (json == null) {
        return Categories();
      }

      var data = Categories();

      for (var i in json) {
        final category = Categories.fromJson(i);

        if (category.id == id) {
          data = Categories.fromJson(i);
        }
      }

      return data;
    } else {
      return Categories();
    }
  }

  static Future<List<Categories>> getCategoriesByParentId(int parentId) async {
    final response = await get(
        Uri.parse("$categoriesUrl/$parentId/"),
        headers: {
          'Content-Type': 'application/json',
        }
    ).catchError((error) {
      return error;
    });

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);

      if (json == null) {
        return [];
      }

      var data = <Categories>[];

      for (var i in json) {
        data.add(Categories.fromJson(i));
      }

      return data;
    } else {
      return [];
    }
  }

  static Future<Products> getProducts(int id, int start, int limit, String sort, Map<String, List<String>> filters) async {
    var url = "$apiUrl$id/$start/$limit/goods";
    var urlData = <String>[];

    if (sort != "sort" && sort != "") {
      urlData.add("cena=$sort");
    }

    if (urlData.isNotEmpty) {
      url += "?${urlData.join("&")}";
    }

    if (filters.isNotEmpty) {
      url += urlData.isNotEmpty ? "&" : "?";
      var params = <String>[];

      filters.forEach((key, value) {
        params.add("$key|${value.join(",")}");
      });

      url += "filters[]=${params.join("&filters[]=")}";
    }

    final response = await get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        }
    ).catchError((error) {
      return error;
    });

    if (response.statusCode == 200) {
      return Products.fromJson(jsonDecode(response.body));
    } else {
      return Products();
    }
  }

  static Future<Product> getProduct(String id) async {
    final response = await get(
        Uri.parse("$apiUrl$id/good"),
        headers: {
          'Content-Type': 'application/json',
        }
    ).catchError((error) {
      return error;
    });

    if (response.statusCode == 200) {
      return Product.fromJson(jsonDecode(response.body));
    } else {
      return Product();
    }
  }

  static Future<List<SearchProducts>> search(String query) async {
    final response = await get(
        Uri.parse("$searchUrl$query"),
        headers: {
          'Content-Type': 'application/json',
        }
    ).catchError((error) {
      return error;
    });

    if (response.statusCode == 200) {
      final search = Search.fromJson(jsonDecode(response.body));

      var data = <SearchProducts>[];

      if (search.products != null && search.products!.isNotEmpty) {
        data = search.products ?? [];
      }

      return data;
    } else {
      return [];
    }
  }

  static Future<Brands> getBrands(String id) async {
    final response = await get(
        Uri.parse("$apiUrl$id/Brendy"),
        headers: {
          'Content-Type': 'application/json',
        }
    ).catchError((error) {
      return error;
    });

    if (response.statusCode == 200) {
      return Brands.fromJson(jsonDecode(response.body));
    } else {
      return Brands();
    }
  }

  static Future<ApiResponse> setCheckout(body) async {
    final response = await post(
        Uri.parse(setOrder),
        headers: {
          'Content-Type': 'application/json',
        },
        body: const JsonEncoder().convert(body)
    ).catchError((error) {
      return error;
    });

    if (response.statusCode == 200) {
      return ApiResponse.fromJson(jsonDecode(response.body));
    } else {
      return ApiResponse();
    }
  }

  static Future<ApiResponse> getCode(body) async {
    final response = await post(
        Uri.parse(getCodeLink),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body)
    ).catchError((error) {
      return error;
    });

    if (response.statusCode == 200) {
      return ApiResponse.fromJson(jsonDecode(response.body));
    } else {
      return ApiResponse();
    }
  }

  static Future<ApiResponse> checkCode(body) async {
    final response = await post(
        Uri.parse(checkCodeLink),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body)
    ).catchError((error) {
      return error;
    });

    if (response.statusCode == 200) {
      return ApiResponse.fromJson(jsonDecode(response.body));
    } else {
      return ApiResponse();
    }
  }

  static Future<ApiResponse> getOrders(int id) async {
    final response = await post(
        Uri.parse(getDeals),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"contactId": id})
    ).catchError((error) {
      return error;
    });

    if (response.statusCode == 200) {
      return ApiResponse.fromJson(jsonDecode(response.body));
    } else {
      return ApiResponse();
    }
  }

  static Future<ApiResponse> saveSetting(String path, Map<String, String> body) async{
    var request = http.MultipartRequest('POST', Uri.parse(setProfile));
    request.headers.addAll({'Content-Type': 'application/json'});

    if (path != "") {
      request.files.add(await http.MultipartFile.fromPath("file", path));
    }

    request.fields.addAll(body);
    var response = await request.send();
    var responseD = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      return ApiResponse.fromJson(json.decode(responseD.body));
    } else {
      return ApiResponse();
    }
  }

  static Future<ContactResponse> getContact(int id) async {
    final response = await get(
        Uri.parse("$getProfileLink?contactId=$id"),
        headers: {
          'Content-Type': 'application/json',
        }
    ).catchError((error) {
      return error;
    });

    if (response.statusCode == 200) {
      return ContactResponse.fromJson(jsonDecode(response.body));
    } else {
      return ContactResponse();
    }
  }

  static Future<ApiResponse> setReview(String path, Map<String, String> body) async{
    var request = http.MultipartRequest('POST', Uri.parse(setReviewLink));
    request.headers.addAll({'Content-Type': 'application/json'});

    if (path != "") {
      request.files.add(await http.MultipartFile.fromPath("file", path));
    }

    request.fields.addAll(body);

    var response = await request.send();
    var responseD = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      return ApiResponse.fromJson(json.decode(responseD.body));
    } else {
      return ApiResponse();
    }
  }

  static Future<ApiResponse> removeProfile(int id) async {
    final response = await post(
        Uri.parse(removeProfileLink),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"contactId": id})
    ).catchError((error) {
      return error;
    });

    if (response.statusCode == 200) {
      return ApiResponse.fromJson(jsonDecode(response.body));
    } else {
      return ApiResponse();
    }
  }

}