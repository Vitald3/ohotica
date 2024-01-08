import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/adapters.dart';
import '../../models/api_response.dart';
import '../../services/network/api.dart';
import '../header.dart';
import '../home.dart';
import '../navigations.dart';
import 'package:intl/intl.dart';

class OrderView extends StatefulWidget {
  const OrderView({super.key});

  @override
  State<OrderView> createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {
  late final Box setting;
  var tabActive = 1;
  var activeOrders = <Deals>[];
  var historyOrders = <Deals>[];
  var isLoading = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setData();
    });

    super.initState();
  }

  setData() async {
    await Hive.initFlutter();
    setting = await Hive.openBox('setting');
    final contactMap = setting.get("contact") ?? <String, dynamic>{};
    Map<String, dynamic> maps = {};

    contactMap.forEach((key, value){
      maps[key] = value;
    });

    final contact = Contact.fromJson(maps);

    if (contact.id != null) {
      Api.getOrders(int.parse(contact.id!)).then((value) {
        activeOrders = value.activeDeals!;
        historyOrders = value.historyDeals!;
        isLoading = true;
        setState(() {});
      });
    }
  }

  Color statusColor(String color) {
    var strColor = const Color(0xFF23262C);

    if (color.contains("ринят в работу") || color.contains("получен")) {
      strColor = const Color(0xFF23262C);
    } else if (color.contains("Возврат")) {
      strColor = const Color(0xFF9747FF);
    } else if (color.contains("отменен") || color.contains("отмена")) {
      strColor = const Color(0xFFD62D30);
    } else if (color.contains("оставлен") || color.contains("оставлено")) {
      strColor = const Color(0xFF2B5FE5);
    } else if (color.contains("в пути") || color.contains("В пути")) {
      strColor = const Color(0xFF12B438);
    } else if (color.contains("оформлен") || color.contains("формлено") || color.contains("овый заказ")) {
      strColor = const Color(0xFFF79E1B);
    }

    return strColor;
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width - 20;

    return Scaffold(
        backgroundColor: const Color(0xFFEBF3FB),
        appBar: const HeaderView(),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset("assets/left.svg", semanticsLabel: 'back', width: 15, height: 15),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: width - 25,
                        child: const Text(
                          "мои заказы",
                          style: TextStyle(
                            color: Color(0xFF23262C),
                            fontSize: 14,
                            fontFamily: 'DaysSansBlack',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          tabActive = 1;
                        });
                      },
                      child: Container(
                        width: (width/2)-10,
                        padding: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(width: 2, color: tabActive == 1 ? const Color(0xFF12B438) : Colors.transparent),
                          ),
                        ),
                        child: Text(
                          'активные заказы',
                          style: TextStyle(
                              color: tabActive == 1 ? const Color(0xFF23262C) : const Color(0xFF728A9D),
                              fontSize: 12,
                              fontFamily: 'DaysSansBlack',
                              fontWeight: FontWeight.w400
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          tabActive = 2;
                        });
                      },
                      child: Container(
                        width: (width/2)-10,
                        padding: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(width: 2, color: tabActive == 2 ? const Color(0xFF12B438) : Colors.transparent),
                          ),
                        ),
                        child: Text(
                          'история',
                          style: TextStyle(
                              color: tabActive == 2 ? const Color(0xFF23262C) : const Color(0xFF728A9D),
                              fontSize: 12,
                              fontFamily: 'DaysSansBlack',
                              fontWeight: FontWeight.w400
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              if (isLoading) Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Visibility(
                          visible: tabActive == 1,
                          child: activeOrders.isEmpty ? Container(
                            width: width,
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
                                        width: width,
                                        child: const Text(
                                          'нет активных заказов',
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
                          ) : Wrap(runSpacing: 5, children: List.generate(activeOrders.length, (index) {
                            final item = activeOrders[index];
                            final scrollController = ScrollController();
                            var total = double.parse("${item.opportunity}");

                            return Container(
                              width: width,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(width: 1, color: Color(0xFF85A0AA)),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: SizedBox(
                                            child: Text(
                                              '№ ${item.id}',
                                              style: const TextStyle(
                                                  color: Color(0xFF728A9D),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w400
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Container(
                                            padding: const EdgeInsets.only(top: 2, left: 10, right: 10, bottom: 5),
                                            decoration: ShapeDecoration(
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(width: 1, color: statusColor(item.status!)),
                                                borderRadius: BorderRadius.circular(100),
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                item.status!,
                                                style: TextStyle(
                                                    color: statusColor(item.status!),
                                                    fontSize: 14,
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.w400
                                                ),
                                              ),
                                            )
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (item.items != null) const SizedBox(height: 10),
                                  if (item.items != null) Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    child: SizedBox(
                                      width: width,
                                      height: item.items!.length < 3 ? item.items!.length * 112 : 315,
                                      child: ListView(
                                          controller: scrollController,
                                          children: List<Widget>.generate(item.items!.length, (index) {
                                            final product = item.items![index];

                                            return Row(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                CachedNetworkImage(
                                                    width: 93,
                                                    height: 93,
                                                    imageUrl: product.image!,
                                                    errorWidget: (context, url, error) => Image.asset("assets/no-image.png"),
                                                    fit: BoxFit.contain
                                                ),
                                                const SizedBox(width: 10),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width: width-140,
                                                      child: Text(
                                                          product.name!,
                                                          style: const TextStyle(
                                                            color: Color(0xFF23262C),
                                                            fontSize: 12,
                                                            fontFamily: 'DaysSansBlack',
                                                            fontWeight: FontWeight.w400,
                                                          ),
                                                          maxLines: 3,
                                                          overflow: TextOverflow.ellipsis
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
                                                          product.sku!,
                                                          style: const TextStyle(
                                                              color: Color(0xFF23262C),
                                                              fontSize: 14,
                                                              fontFamily: 'Inter',
                                                              fontWeight: FontWeight.w400
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    if (product.size != null) Row(
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
                                                          product.size!,
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
                                                    Text(
                                                      '${product.quantity} х ${NumberFormat.currency(locale: 'ru', symbol: '', decimalDigits: 0).format(product.price)} руб.',
                                                      style: const TextStyle(
                                                          color: Color(0xFF23262C),
                                                          fontSize: 12,
                                                          fontFamily: 'DaysSansBlack',
                                                          fontWeight: FontWeight.w400
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ],
                                            );
                                          })
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        top: BorderSide(color: item.items != null ? const Color(0xFF85A0AA) : Colors.transparent),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 136,
                                          height: 17,
                                          child: Text(
                                            '${NumberFormat.currency(locale: 'ru', symbol: '', decimalDigits: 0).format(total)} руб.',
                                            style: const TextStyle(
                                                color: Color(0xFF23262C),
                                                fontSize: 12,
                                                fontFamily: 'DaysSansBlack',
                                                fontWeight: FontWeight.w400
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          item.date!,
                                          style: const TextStyle(
                                              color: Color(0xFF728A9D),
                                              fontSize: 14,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w400
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }))
                      ),
                      Visibility(
                          visible: tabActive == 2,
                          child: historyOrders.isEmpty ? Container(
                            width: width,
                            margin: const EdgeInsets.only(right: 10),
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
                                      const SizedBox(
                                        child: Text(
                                          'нет активных заказов',
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
                          ) : Wrap(runSpacing: 5, children: List.generate(historyOrders.length, (index) {
                            final item = historyOrders[index];
                            final scrollController = ScrollController();
                            var total = double.parse("${item.opportunity}");

                            return Container(
                              width: width,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(width: 1, color: Color(0xFF85A0AA)),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: SizedBox(
                                            child: Text(
                                              '№ ${item.id}',
                                              style: const TextStyle(
                                                  color: Color(0xFF728A9D),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w400
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Container(
                                            padding: const EdgeInsets.only(top: 2, left: 10, right: 10, bottom: 5),
                                            decoration: ShapeDecoration(
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(width: 1, color: statusColor(item.status!)),
                                                borderRadius: BorderRadius.circular(100),
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                item.status!,
                                                style: TextStyle(
                                                    color: statusColor(item.status!),
                                                    fontSize: 14,
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.w400
                                                ),
                                              ),
                                            )
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    child: SizedBox(
                                      width: width,
                                      height: item.items!.length < 3 ? item.items!.length * 112 : 315,
                                      child: ListView(
                                          controller: scrollController,
                                          children: List<Widget>.generate(item.items!.length, (index) {
                                            final product = item.items![index];

                                            return Row(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                CachedNetworkImage(
                                                    width: 93,
                                                    height: 93,
                                                    imageUrl: product.image!,
                                                    errorWidget: (context, url, error) => Image.asset("assets/no-image.png"),
                                                    fit: BoxFit.contain
                                                ),
                                                const SizedBox(width: 10),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width: width-140,
                                                      child: Text(
                                                          product.name!,
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
                                                          product.sku!,
                                                          style: const TextStyle(
                                                              color: Color(0xFF23262C),
                                                              fontSize: 14,
                                                              fontFamily: 'Inter',
                                                              fontWeight: FontWeight.w400
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    if (product.size != null) Row(
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
                                                          product.size!,
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
                                                    Text(
                                                      '${product.quantity} х ${NumberFormat.currency(locale: 'ru', symbol: '', decimalDigits: 0).format(product.price)} руб.',
                                                      style: const TextStyle(
                                                          color: Color(0xFF23262C),
                                                          fontSize: 12,
                                                          fontFamily: 'DaysSansBlack',
                                                          fontWeight: FontWeight.w400
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ],
                                            );
                                          })
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        top: BorderSide(color: Color(0xFF85A0AA)),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 136,
                                          height: 17,
                                          child: Text(
                                            '${NumberFormat.currency(locale: 'ru', symbol: '', decimalDigits: 0).format(total)} руб.',
                                            style: const TextStyle(
                                                color: Color(0xFF23262C),
                                                fontSize: 12,
                                                fontFamily: 'DaysSansBlack',
                                                fontWeight: FontWeight.w400
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          item.date!,
                                          style: const TextStyle(
                                              color: Color(0xFF728A9D),
                                              fontSize: 14,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w400
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }))
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: const NavigationView()
    );
  }
}