import 'dart:convert';

import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:ohotika/models/wishlist.dart';
import 'package:ohotika/views/products.dart';
import 'package:provider/provider.dart';
import '../models/categories.dart';
import '../models/products.dart';
import '../other/values_notifier.dart';
import '../services/database.dart';
import 'header.dart';
import 'home.dart';
import 'navigations.dart';
import 'package:intl/intl.dart';

class WishlistView extends StatefulWidget {
  const WishlistView({super.key});

  @override
  State<WishlistView> createState() => _WishlistViewState();
}

class _WishlistViewState extends State<WishlistView> {
  late final Box setting;
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
    await DBProvider.db.getWishlists().then((value) {
      wishlist = value;
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
              Column(
                children: [
                  const SizedBox(height: 20),
                  const Center(
                    child: Text(
                      'избранное',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color(0xFF23262C),
                          fontSize: 14,
                          fontFamily: 'DaysSansBlack',
                          fontWeight: FontWeight.w400
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (wishlist.isNotEmpty) Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                          onTap: () async {
                            await DBProvider.db.clearWishlist();

                            if (context.mounted) {
                              Provider.of<ValuesNotifier>(context, listen: false).setWishlistCount("");
                            }

                            AppMetrica.reportEvent('Удаление всех товаров в избранном');

                            setState(() {
                              wishlist = [];
                            });
                          },
                          child: const Text(
                            'удалить все',
                            style: TextStyle(
                                color: Color(0xFF12B438),
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400
                            ),
                          )
                      ),
                      const SizedBox(width: 10)
                    ],
                  )
                ],
              ),
              if (isLoading) wishlist.isNotEmpty ? Column(
                children: [
                  const SizedBox(height: 90),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                      child: Wrap(spacing: 5, runSpacing: 5, children: List<Widget>.generate(wishlist.length, (index) {
                        final item = wishlist[index];

                        return ProductView(category: item.category!, product: Items(id: item.pid!, name: item.name, price: NumberFormat.currency(locale: 'ru', symbol: '', decimalDigits: 0).format(item.price), imageUrl: item.imageUrl), wishlistType: () async {
                          await DBProvider.db.getWishlists().then((value) {
                            wishlist = value;
                            setState(() {});
                          });
                        });
                      })),
                    ),
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
                              'нет товаров в избранном',
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
                              'Наполните избранное приглянувшими товарами!',
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
        bottomNavigationBar: const NavigationView(current: 1)
    );
  }
}