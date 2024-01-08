import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ohotika/views/product.dart';
import 'package:provider/provider.dart';
import '../models/cart.dart';
import '../models/wishlist.dart';
import '../other/constant.dart';
import '../other/values_notifier.dart';
import '../services/database.dart';
import 'checkout.dart';
import 'header.dart';
import 'home.dart';
import 'navigations.dart';
import 'package:intl/intl.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  var carts = <Cart>[];
  var subTotal = 0.0;
  var total = 0.0;
  var shipping = 0.0;
  var wishlist = <Wishlist>[];
  var isLoading = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setData();
    });

    super.initState();
  }

  setData() async {
    wishlist = await DBProvider.db.getWishlists();
    await DBProvider.db.getCarts().then((value) {
      carts = value;

      subTotal = 0;

      for (var i in carts) {
        subTotal += (i.price ?? 0.0) * (i.quantity ?? 1);
      }

      if (subTotal >= 7000) {
        shipping = 0;
      } else {
        shipping = double.parse("$shippingTotal");
      }

      total = subTotal + shipping;
      isLoading = true;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width - 20;

    return Scaffold(
        backgroundColor: const Color(0xFFEBF3FB),
        appBar: const HeaderView(),
        body: SafeArea(
          child: Stack(
            children: [
              const Column(
                children: [
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      'корзина',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color(0xFF23262C),
                          fontSize: 14,
                          fontFamily: 'DaysSansBlack',
                          fontWeight: FontWeight.w400
                      ),
                    ),
                  ),
                  SizedBox(height: 25),
                ],
              ),
              if (isLoading) carts.isNotEmpty ? Column(
                children: [
                  const SizedBox(height: 54),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: SingleChildScrollView(
                        child: Wrap(spacing: 5, children: List<Widget>.generate(carts.length, (index) {
                          return cartItem(context, carts[index]);
                        })),
                      ),
                    ),
                  ),
                  Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(color: Color(0xFFEBF2FA)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Сумма',
                                style: TextStyle(
                                    color: Color(0xFF728A9D),
                                    fontSize: 12,
                                    fontFamily: 'DaysSansBlack',
                                    fontWeight: FontWeight.w400
                                ),
                              ),
                              Text(
                                '${NumberFormat.currency(locale: 'ru', symbol: '', decimalDigits: 0).format(subTotal)} руб.',
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                    color: Color(0xFF23262C),
                                    fontSize: 12,
                                    fontFamily: 'DaysSansBlack',
                                    fontWeight: FontWeight.w400
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Доставка',
                                style: TextStyle(
                                    color: Color(0xFF728A9D),
                                    fontSize: 12,
                                    fontFamily: 'DaysSansBlack',
                                    fontWeight: FontWeight.w400
                                ),
                              ),
                              Text(
                                '${NumberFormat.currency(locale: 'ru', symbol: '', decimalDigits: 0).format(shipping)} руб.',
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                    color: Color(0xFF23262C),
                                    fontSize: 12,
                                    fontFamily: 'DaysSansBlack',
                                    fontWeight: FontWeight.w400
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Итого',
                                style: TextStyle(
                                    color: Color(0xFF728A9D),
                                    fontSize: 12,
                                    fontFamily: 'DaysSansBlack',
                                    fontWeight: FontWeight.w400
                                ),
                              ),
                              Text(
                                '${NumberFormat.currency(locale: 'ru', symbol: '', decimalDigits: 0).format(total)} руб.',
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                    color: Color(0xFF23262C),
                                    fontSize: 12,
                                    fontFamily: 'DaysSansBlack',
                                    fontWeight: FontWeight.w400
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              AppMetrica.reportEvent('Переход в оформление заказа');
                              Navigator.push(
                                context,
                                CupertinoPageRoute(builder: (_) => const CheckoutView()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF12B438),
                              minimumSize: Size(width, 38),
                              elevation: 0,
                              alignment: Alignment.center,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  side: const BorderSide(width: 1, color: Color(0xFF12B438))
                              ),
                            ),
                            child: const Text(
                              'оформить заказ',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400
                              ),
                            ),
                          ),
                        ],
                      )
                  ),
                ],
              ) : Container(
                width: width,
                margin: const EdgeInsets.only(left: 10, top: 54),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 168,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                              width: 100,
                              height: 100,
                              padding: const EdgeInsets.only(
                                top: 11,
                                left: 5,
                                right: 5,
                                bottom: 11.93,
                              ),
                              clipBehavior: Clip.antiAlias,
                              decoration: const BoxDecoration(),
                              child: Center(
                                child: SvgPicture.asset("assets/cart_empty.svg", semanticsLabel: 'cart_empty', width: 100, height: 100),
                              )
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: width-20,
                            child: const Text(
                              'ваша корзина пуста',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color(0xFF23262C),
                                  fontSize: 12,
                                  fontFamily: 'DaysSansBlack',
                                  fontWeight: FontWeight.w400
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const SizedBox(
                            width: double.infinity,
                            child: Text(
                              'Наполните корзину приглянувшими товарами!',
                              style: TextStyle(
                                  color: Color(0xFF728A9D),
                                  fontSize: 14,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          CupertinoPageRoute(builder: (_) => const HomeView()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF12B438),
                        minimumSize: const Size(255, 38),
                        elevation: 0,
                        alignment: Alignment.center,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side: const BorderSide(width: 1, color: Color(0xFF12B438))
                        ),
                      ),
                      child: const Text(
                        'приступить к покупкам',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: const NavigationView(current: 2)
    );
  }

  updateCount(int count) {
    var x = "";

    if (count == 0) {
      x = "";
    } else {
      x = "$count";
    }

    Provider.of<ValuesNotifier>(context, listen: false).setCartCount(x);
  }

  Widget cartItem(BuildContext context, Cart item) {
    final double width = MediaQuery.of(context).size.width - 20;
    var quantity = item.quantity ?? 1;

    return Container(
      width: width,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (_) => ItemView(id: item.pid!, category: item.category!)),
              ).then((_) => setState(() {}));
            },
            child: CachedNetworkImage(
                width: 93,
                height: 93,
                imageUrl: item.imageUrl!,
                errorWidget: (context, url, error) => Image.asset("assets/no-image.png"),
                fit: BoxFit.contain
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: width-140,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (_) => ItemView(id: item.pid!, category: item.category!)),
                    ).then((_) => setState(() {}));
                  },
                  child: Text(
                      item.name!,
                      style: const TextStyle(
                        color: Color(0xFF23262C),
                        fontSize: 12,
                        fontFamily: 'DaysSansBlack',
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'код товара:',
                    style: TextStyle(
                        color: Color(0xFF728A9D),
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    item.article!,
                    style: const TextStyle(
                        color: Color(0xFF23262C),
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'размер:',
                    style: TextStyle(
                        color: Color(0xFF728A9D),
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    item.size!,
                    style: const TextStyle(
                        color: Color(0xFF23262C),
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () async {
                      quantity -= 1;

                      DBProvider.db.updateCart(item.cartId!, quantity).then((value) {
                        carts = value;
                        subTotal = 0;
                        var count = 0;

                        for (var i in carts) {
                          subTotal += (i.price ?? 0.0) * (i.quantity ?? 1);
                          count += (i.quantity ?? 1);
                        }

                        AppMetrica.reportEvent('Обновили количество товара ${item.name!} в корзине');

                        updateCount(count);

                        if (subTotal >= 7000) {
                          shipping = 0;
                        } else {
                          shipping = double.parse("$shippingTotal");
                        }

                        total = subTotal + shipping;
                        setState(() {});
                      });
                    },
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: ShapeDecoration(
                        color: const Color(0xFF12B438),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                      ),
                      alignment: Alignment.center,
                      child: Center(
                        child: SvgPicture.asset("assets/minus.svg", semanticsLabel: 'minus', width: 10, height: 10),
                      )
                    )
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "$quantity",
                    style: const TextStyle(
                        color: Color(0xFF23262C),
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400
                    ),
                  ),
                  const SizedBox(width: 10),
                  InkWell(
                    onTap: () async {
                      quantity += 1;

                      await DBProvider.db.updateCart(item.cartId!, quantity).then((value) {
                        carts = value;
                        subTotal = 0;
                        var count = 0;

                        for (var i in carts) {
                          subTotal += (i.price ?? 0.0) * (i.quantity ?? 1);
                          count += (i.quantity ?? 1);
                        }

                        updateCount(count);

                        if (subTotal >= 7000) {
                          shipping = 0;
                        } else {
                          shipping = double.parse("$shippingTotal");
                        }

                        total = subTotal + shipping;
                        setState(() {});
                      });
                    },
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: ShapeDecoration(
                        color: const Color(0xFF12B438),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                      ),
                      alignment: Alignment.center,
                      child: Center(
                        child: SvgPicture.asset("assets/plus.svg", semanticsLabel: 'plus', width: 10, height: 10),
                      )
                    )
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "${NumberFormat.currency(locale: 'ru', symbol: '', decimalDigits: 0).format(item.price)} руб.",
                    style: const TextStyle(
                        color: Color(0xFF23262C),
                        fontSize: 12,
                        fontFamily: 'DaysSansBlack',
                        fontWeight: FontWeight.w400
                    ),
                  ),
                  const SizedBox(width: 15),
                  InkWell(
                    onTap: () async {
                      if (wishlist.where((element) => element.pid == item.pid).isNotEmpty) {
                        AppMetrica.reportEvent('Удаление товара ${item.name!} из избранного в корзине');
                        DBProvider.db.deleteWishlist(item.pid!);
                      } else {
                        AppMetrica.reportEvent('Добавление товара ${item.name!} в избранное в корзине');
                        DBProvider.db.addWishlist(Wishlist(pid: item.pid!, imageUrl: item.imageUrl, name: item.name, price: item.price!, category: item.category));
                      }

                      DBProvider.db.getWishlists().then((value) {
                        setState(() {
                          wishlist = value;
                        });

                        var count = "";

                        if (value.isNotEmpty) {
                          count = "${value.length}";
                        }

                        Provider.of<ValuesNotifier>(context, listen: false).setWishlistCount(count);
                      });
                    },
                    child: Text(
                      wishlist.where((element) => element.pid == item.pid).isEmpty ? "в избранное" : "из избранного",
                      style: const TextStyle(
                          color: Color(0xFF12B438),
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400
                      ),
                    ),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}