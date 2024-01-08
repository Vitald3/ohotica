import 'dart:async';
import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:ohotika/models/categories.dart';
import 'package:ohotika/services/network/api.dart';
import 'package:ohotika/views/policy.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/api_response.dart';
import '../models/cart.dart';
import '../models/checkout.dart';
import '../models/product.dart';
import '../models/wishlist.dart';
import '../other/constant.dart';
import '../other/values_notifier.dart';
import '../services/database.dart';
import 'account/size.dart';
import 'header.dart';
import 'navigations.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'dart:io' show Platform;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:zoom_widget/zoom_widget.dart';
import 'package:intl/intl.dart';

class ItemView extends StatefulWidget {
  const ItemView({super.key, required this.id, required this.category});

  final String id;
  final Categories category;

  @override
  State<ItemView> createState() => _ItemViewState();
}

class _ItemViewState extends State<ItemView> {
  var wishlist = <Wishlist>[];
  var product = Product();
  TextEditingController controller = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  var maskFormatter = MaskedInputFormatter('+# (###) ###-##-##', allowedCharMatcher: RegExp(r'[0-9]'));
  var maskFormatter2 = MaskedInputFormatter('+# (###) ###-##-##', allowedCharMatcher: RegExp(r'[0-9]'));
  var submitButton = false;
  var size = "";
  var sizeName = "";
  var carts = <Cart>[];
  var focus = FocusNode();
  var focus2 = FocusNode();
  var countable = 1;
  var selectSize = 0;
  var contactBool = false;
  Cart? newCarts;
  var carouselController = CarouselController();

  String? get _errorText {
    if (controller.value.text != "" && !maskFormatter.isFilled) {
      return 'Номер телефона заполнен неккоректно';
    }

    return null;
  }

  String? get _errorText2 {
    if (controller2.value.text != "" && !maskFormatter2.isFilled) {
      return 'Номер телефона заполнен неккоректно';
    }

    return null;
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setData();
    });

    super.initState();
  }

  setData() async {
    await Hive.initFlutter();
    final setting = await Hive.openBox('setting');
    wishlist = await DBProvider.db.getWishlists();
    await Api.getProduct(widget.id).then((value) {
      product = value;
      isLoading = true;
    });
    final contactMap = setting.get("contact") ?? <String, dynamic>{};
    Map<String, dynamic> maps = {};

    contactMap.forEach((key, value){
      maps[key] = value;
    });

    final contact = Contact.fromJson(maps);

    if (contact.id != null) {
      Api.getContact(int.parse(contact.id!)).then((value) {
        if (value.contact != null && value.contact!.phone != null && (value.contact!.phone ?? "") != "") {
          setState(() {
            controller.text = maskFormatter.applyMask("+${value.contact!.phone}").text;
            controller2.text = maskFormatter2.applyMask("+${value.contact!.phone}").text;
            maskFormatter.formatEditUpdate(const TextEditingValue(text: ""), TextEditingValue(text: maskFormatter.applyMask("+${value.contact!.phone}").text));
            maskFormatter2.formatEditUpdate(const TextEditingValue(text: ""), TextEditingValue(text: maskFormatter2.applyMask("+${value.contact!.phone}").text));
          });
        }
      });
    }

    setState(() {});
  }

  addCart(int quantity, BuildContext context) async {
    AppMetrica.reportEvent('Добавили в корзину товар ${product.name}');
    await DBProvider.db.addCart(Cart(pid: widget.id, imageUrl: product.imageUrl, name: product.name, quantity: quantity, price: double.parse(product.price!.replaceAll(" ", "")), size: size, sizeName: sizeName, article: product.article, category: widget.category));

    await DBProvider.db.getCarts().then((value) {
      carts = value;
      var count = 0;

      for (var i in carts) {
        count += (i.quantity ?? 1);
      }

      Provider.of<ValuesNotifier>(context, listen: false).setCartCount("$count");
      setState(() {});
    });
  }

  salePopup(BuildContext context, double width) {
    AppMetrica.reportEvent('Открыт попап в рассрочку в товаре ${product.name}');
    showModalBottomSheet(
        context: context,
        useSafeArea: true,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15)),
        ),
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (BuildContext context, StateSetter state) {
            var total = 0.0;

            for (var i in carts) {
              total += (i.price ?? 0.0) * (i.quantity ?? 1);
            }

            final scrollController = ScrollController();

            return Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 58),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: SizedBox(
                              width: width,
                              height: carts.length > 1 ? 146 : 115,
                              child: RawScrollbar(
                                controller: scrollController,
                                thumbVisibility: true,
                                trackVisibility: true,
                                thickness: 3,
                                thumbColor: const Color(0xFF12B438),
                                trackColor: const Color(0xFFEBF2FA),
                                trackBorderColor: Colors.transparent,
                                child: ListView(
                                    controller: scrollController,
                                    children: List<Widget>.generate(carts.length, (index) {
                                      final item = carts[index];

                                      return Row(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          CachedNetworkImage(
                                              width: 93,
                                              height: 93,
                                              imageUrl: item.imageUrl!,
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
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    '${item.quantity} х ${NumberFormat.currency(locale: 'ru', symbol: '', decimalDigits: 0).format(item.price)} руб.',
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
                                                      await DBProvider.db.deleteCart(item.cartId!).then((value) {
                                                        carts = value;
                                                        var count = "${carts.length}";

                                                        if (count == "0") {
                                                          count = "";
                                                        }

                                                        Provider.of<ValuesNotifier>(context, listen: false).setCartCount(count);

                                                        if (carts.isEmpty) {
                                                          Navigator.of(context).pop();
                                                        } else {
                                                          state(() {});
                                                        }
                                                      });
                                                    },
                                                    child: const Text(
                                                      'удалить',
                                                      style: TextStyle(
                                                          color: Color(0xFF12B438),
                                                          fontSize: 14,
                                                          fontFamily: 'Inter',
                                                          fontWeight: FontWeight.w400
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              const SizedBox(height: 10),
                                            ],
                                          )
                                        ],
                                      );
                                    })
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Container(
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(color: Color(0xFFEBF2FA)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (total < 7000) Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: width/2,
                                        child: const Text(
                                          'ДОСТАВКА',
                                          style: TextStyle(
                                              color: Color(0xFF728A9D),
                                              fontSize: 12,
                                              fontFamily: 'DaysSansBlack',
                                              fontWeight: FontWeight.w400
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: width/2,
                                        child: Text(
                                          '${NumberFormat.currency(locale: 'ru', symbol: '', decimalDigits: 0).format(shippingTotal)} руб.',
                                          textAlign: TextAlign.right,
                                          style: const TextStyle(
                                              color: Color(0xFF23262C),
                                              fontSize: 12,
                                              fontFamily: 'DaysSansBlack',
                                              fontWeight: FontWeight.w400
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (total < 7000) const SizedBox(height: 5),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: width/2,
                                        child: const Text(
                                          'ИТОГО',
                                          style: TextStyle(
                                              color: Color(0xFF728A9D),
                                              fontSize: 12,
                                              fontFamily: 'DaysSansBlack',
                                              fontWeight: FontWeight.w400
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: width/2,
                                        child: Text(
                                          '${NumberFormat.currency(locale: 'ru', symbol: '', decimalDigits: 0).format(total + (total < 7000 ? shippingTotal : 0))} руб.',
                                          textAlign: TextAlign.right,
                                          style: const TextStyle(
                                              color: Color(0xFF23262C),
                                              fontSize: 12,
                                              fontFamily: 'DaysSansBlack',
                                              fontWeight: FontWeight.w400
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  SizedBox(
                                    width: width,
                                    child: const Text(
                                      'Укажите номер телефона для перехода на страницу оформления заявки на рассрочку',
                                      style: TextStyle(
                                          color: Color(0xFF23262C),
                                          fontSize: 14,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w600
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  SizedBox(
                                    width: width,
                                    child: TextField(
                                        controller: controller2,
                                        focusNode: focus2,
                                        inputFormatters: [maskFormatter2],
                                        decoration: InputDecoration(
                                          hintText: "+7 (000) 000-00-00",
                                          errorText: _errorText2,
                                          hintStyle: const TextStyle(
                                            color: Color(0xFF728A9D),
                                            fontSize: 14,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400,
                                          ),
                                          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                width: 1,
                                                color: Color(0xFF85A0AA),
                                              ),
                                              borderRadius: BorderRadius.circular(10)
                                          ),
                                          focusedErrorBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                width: 1,
                                                color: Colors.red,
                                              ),
                                              borderRadius: BorderRadius.circular(10)
                                          ),
                                          errorBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                width: 1,
                                                color: Colors.red,
                                              ),
                                              borderRadius: BorderRadius.circular(10)
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                width: 1,
                                                color: Color(0xFF85A0AA),
                                              ),
                                              borderRadius: BorderRadius.circular(10)
                                          ),
                                        ),
                                        onChanged: (val) {
                                          if (controller2.text.isEmpty || controller2.text == "+7") {
                                            controller2.text = "+7 (9";
                                          }

                                          if (maskFormatter2.isFilled) {
                                            state(() {});
                                          }
                                        },
                                        onTap: () {
                                          if (controller2.text.isEmpty || controller2.text == "+7") {
                                            controller2.text = "+7 (9";
                                          }
                                        },
                                        keyboardType: TextInputType.number
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  ElevatedButton(
                                    onPressed: () async {
                                      if (controller2.text.isEmpty || controller2.text == "+7") {
                                        controller2.text = "+7 (9";
                                      }

                                      if (!maskFormatter.isFilled) {
                                        focus2.requestFocus();
                                      } else {
                                        FocusScope.of(context).unfocus();
                                      }

                                      if (maskFormatter2.isFilled) {
                                        AppMetrica.reportEvent('Нажали продолжить попап в рассрочку в товаре ${product.name}');

                                        if (!submitButton) {
                                          state(() {
                                            submitButton = true;
                                          });

                                          var products = <CheckoutProducts>[];
                                          var subTotal = 0.0;

                                          for (var i in carts) {
                                            subTotal += (i.price ?? 0.0) * (i.quantity ?? 1);

                                            products.add(CheckoutProducts(
                                                id: "${i.pid}",
                                                name: "${i.name}",
                                                quantity: i.quantity,
                                                size: Sizes(
                                                    name: sizeName,
                                                    value: size
                                                )
                                            ));
                                          }

                                          final checkout = Checkout(
                                              name: "",
                                              phone: "+${maskFormatter2.unmaskedValue}",
                                              platform: Platform.isAndroid ? 1 : 0,
                                              paymentMethod: 3,
                                              shippingTotal: subTotal < 7000 ? shippingTotal : 0,
                                              productTotal: subTotal.toInt(),
                                              total: subTotal.toInt(),
                                              rewardTotal: 0,
                                              products: products
                                          );

                                          await Api.setCheckout(checkout).then((response) async {
                                            if ((response.success ?? false) && response.url != "") {
                                              Uri url = Uri.parse(response.url!);

                                              if (await canLaunchUrl(url)) {
                                                if (context.mounted) {
                                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                    behavior: SnackBarBehavior.floating,
                                                    content: Text("Сейчас вы будете перенаправлены в сбербанк для оплаты товара"),
                                                  ));
                                                }

                                                await launchUrl(url);

                                                Timer(const Duration(seconds: 3), () {
                                                  state(() {
                                                    submitButton = false;
                                                  });

                                                  Navigator.of(context).pop();
                                                });
                                              } else {
                                                state(() {
                                                  submitButton = false;
                                                });

                                                if (context.mounted) {
                                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                    behavior: SnackBarBehavior.floating,
                                                    content: Text("Ошибка создания платежа"),
                                                  ));
                                                }
                                              }
                                            } else {
                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                behavior: SnackBarBehavior.floating,
                                                content: Text(response.error ?? "Произошла ошибка"),
                                              ));
                                            }
                                          });
                                        }
                                      } else {
                                        focus2.requestFocus();
                                      }
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
                                    child: submitButton ? const CupertinoActivityIndicator(color: Colors.white, radius: 10) : const Text(
                                      'продолжить',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w400
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    constraints: BoxConstraints(minHeight: 45, minWidth: width),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: double.infinity,
                                          child: Text.rich(
                                            TextSpan(
                                              children: [
                                                const TextSpan(
                                                  text: 'нажимая на кнопку «',
                                                  style: TextStyle(
                                                      color: Color(0xFF23262C),
                                                      fontSize: 12,
                                                      fontFamily: 'Inter',
                                                      fontWeight: FontWeight.w400
                                                  ),
                                                ),
                                                const TextSpan(
                                                  text: 'продолжить',
                                                  style: TextStyle(
                                                      color: Color(0xFF23262C),
                                                      fontSize: 12,
                                                      fontFamily: 'Inter',
                                                      fontWeight: FontWeight.w400
                                                  ),
                                                ),
                                                const TextSpan(
                                                  text: '», вы соглашаетесь с',
                                                  style: TextStyle(
                                                      color: Color(0xFF23262C),
                                                      fontSize: 12,
                                                      fontFamily: 'Inter',
                                                      fontWeight: FontWeight.w400
                                                  ),
                                                ),
                                                const TextSpan(
                                                  text: ' ',
                                                  style: TextStyle(
                                                      color: Color(0xFF23262C),
                                                      fontSize: 12,
                                                      fontFamily: 'Inter',
                                                      fontWeight: FontWeight.w400
                                                  ),
                                                ),
                                                TextSpan(
                                                  recognizer: TapGestureRecognizer()..onTap = () {
                                                    Navigator.push(
                                                      context,
                                                      CupertinoPageRoute(builder: (_) => const PolicyView()),
                                                    );
                                                  },
                                                  text: 'политикой конфиденциальности ',
                                                  style: const TextStyle(
                                                      color: Color(0xFF12B438),
                                                      fontSize: 12,
                                                      fontFamily: 'Inter',
                                                      fontWeight: FontWeight.w400
                                                  ),
                                                ),
                                                const TextSpan(
                                                  text: 'и даете согласие на обработку персональных данных',
                                                  style: TextStyle(
                                                      color: Color(0xFF23262C),
                                                      fontSize: 12,
                                                      fontFamily: 'Inter',
                                                      fontWeight: FontWeight.w400
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )
                          ),
                        ],
                      )
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset("assets/sber.svg", semanticsLabel: 'close', width: 100, height: 20),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: SvgPicture.asset("assets/close.svg", semanticsLabel: 'close', width: 20, height: 20),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                  ],
                ),
              ],
            );
          });
        }
    );
  }

  consultationPopup(BuildContext context, double width) {
    AppMetrica.reportEvent('Открыт попап получение консультации в товаре ${product.name}');
    showModalBottomSheet(
        context: context,
        useSafeArea: true,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15)),
        ),
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (BuildContext context, StateSetter state) {
            return Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                      padding: EdgeInsets.only(left: 10, right: 10, bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 58),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CachedNetworkImage(
                                  width: 93,
                                  height: 93,
                                  imageUrl: newCarts!.imageUrl!,
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
                                        newCarts!.name!,
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
                                        newCarts!.article!,
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
                                        size,
                                        style: const TextStyle(
                                            color: Color(0xFF23262C),
                                            fontSize: 14,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "${NumberFormat.currency(locale: 'ru', symbol: '', decimalDigits: 0).format(newCarts!.price)} руб.",
                                    style: const TextStyle(
                                        color: Color(0xFF23262C),
                                        fontSize: 12,
                                        fontFamily: 'DaysSansBlack',
                                        fontWeight: FontWeight.w400
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: width,
                            child: TextField(
                                controller: controller,
                                focusNode: focus,
                                inputFormatters: [maskFormatter],
                                decoration: InputDecoration(
                                  hintText: "+7 (000) 000-00-00",
                                  errorText: _errorText,
                                  hintStyle: const TextStyle(
                                    color: Color(0xFF728A9D),
                                    fontSize: 14,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        width: 1,
                                        color: Color(0xFF85A0AA),
                                      ),
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        width: 1,
                                        color: Colors.red,
                                      ),
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  errorBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        width: 1,
                                        color: Colors.red,
                                      ),
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        width: 1,
                                        color: Color(0xFF85A0AA),
                                      ),
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                ),
                                onChanged: (val) {
                                  if (controller.text.isEmpty || controller.text == "+7") {
                                    controller.text = "+7 (9";
                                  }

                                  if (maskFormatter.isFilled) {
                                    state(() {});
                                  }
                                },
                                onTap: () {
                                  if (controller.text.isEmpty || controller.text == "+7") {
                                    controller.text = "+7 (9";
                                  }
                                },
                                keyboardType: TextInputType.number
                            ),
                          ),
                          const SizedBox(height: 80),
                          ElevatedButton(
                            onPressed: () {
                              if (submitButton) {
                                return;
                              }

                              AppMetrica.reportEvent('Нажали применить в получении консультации в товаре ${product.name}');

                              if (controller.text.isEmpty || controller.text == "+7") {
                                controller.text = "+7 (9";
                              }

                              if (!maskFormatter.isFilled) {
                                focus.requestFocus();
                              }

                              if (maskFormatter.isFilled && !submitButton) {
                                state(() {
                                  submitButton = true;
                                });

                                var subTotal = 0.0;
                                var products = <CheckoutProducts>[];

                                subTotal += (newCarts!.price ?? 0.0) * (newCarts!.quantity ?? 1);

                                final checkoutProduct = CheckoutProducts(
                                    id: "${newCarts!.pid}",
                                    name: "${newCarts!.name}",
                                    quantity: newCarts!.quantity
                                );

                                if (newCarts!.sizeName != "" && newCarts!.size != "") {
                                  checkoutProduct.size = Sizes(
                                      name: newCarts!.sizeName,
                                      value: newCarts!.size
                                  );
                                }

                                products.add(checkoutProduct);

                                final checkout = Checkout(
                                    name: "",
                                    phone: "+${maskFormatter.unmaskedValue}",
                                    platform: Platform.isAndroid ? 1 : 0,
                                    paymentMethod: 4,
                                    shippingTotal: 0,
                                    productTotal: subTotal.toInt(),
                                    total: subTotal.toInt(),
                                    rewardTotal: 0,
                                    products: products
                                );

                                Api.setCheckout(checkout).then((response) async {
                                  state(() {
                                    submitButton = false;
                                  });

                                  if (response.success ?? false) {
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                      behavior: SnackBarBehavior.floating,
                                      content: Text("Ваша заявка принята"),
                                    ));

                                    Navigator.of(context).pop();
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      behavior: SnackBarBehavior.floating,
                                      content: Text(response.error ?? "Произошла ошибка"),
                                    ));
                                  }
                                });
                              }
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
                            child: submitButton ? const CupertinoActivityIndicator(color: Colors.white, radius: 10) : const Text(
                              'заказать консультацию',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            constraints: BoxConstraints(minHeight: 45, minWidth: width),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: Text.rich(
                                    TextSpan(
                                      children: [
                                        const TextSpan(
                                          text: 'нажимая на кнопку «',
                                          style: TextStyle(
                                              color: Color(0xFF23262C),
                                              fontSize: 12,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w400
                                          ),
                                        ),
                                        const TextSpan(
                                          text: 'заказать консультацию',
                                          style: TextStyle(
                                              color: Color(0xFF23262C),
                                              fontSize: 12,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w400
                                          ),
                                        ),
                                        const TextSpan(
                                          text: '», вы соглашаетесь с',
                                          style: TextStyle(
                                              color: Color(0xFF23262C),
                                              fontSize: 12,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w400
                                          ),
                                        ),
                                        const TextSpan(
                                          text: ' ',
                                          style: TextStyle(
                                              color: Color(0xFF23262C),
                                              fontSize: 12,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w400
                                          ),
                                        ),
                                        TextSpan(
                                          recognizer: TapGestureRecognizer()..onTap = () {
                                            Navigator.push(
                                              context,
                                              CupertinoPageRoute(builder: (_) => const PolicyView()),
                                            );
                                          },
                                          text: 'политикой конфиденциальности ',
                                          style: const TextStyle(
                                              color: Color(0xFF12B438),
                                              fontSize: 12,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w400
                                          ),
                                        ),
                                        const TextSpan(
                                          text: 'и даете согласие на обработку персональных данных',
                                          style: TextStyle(
                                              color: Color(0xFF23262C),
                                              fontSize: 12,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w400
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30)
                        ],
                      )
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'получить консультацию',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color(0xFF728A9D),
                                fontSize: 12,
                                fontFamily: 'DaysSansBlack',
                                fontWeight: FontWeight.w400
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: SvgPicture.asset("assets/close.svg", semanticsLabel: 'close', width: 20, height: 20),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                  ],
                ),
              ],
            );
          });
        }
    );
  }

  openSizesPopup(BuildContext context) {
    AppMetrica.reportEvent('Открыт попап выбора размера в товаре ${product.name}');
    final double width = MediaQuery.of(context).size.width - 20;

    showModalBottomSheet(
        context: context,
        useSafeArea: true,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15)),
        ),
        builder: (BuildContext context) {
          var sizeItem = size;

          return StatefulBuilder(builder: (BuildContext context, StateSetter state) {
            return SafeArea(
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(height: 52),
                          Wrap(children: List<Widget>.generate(product.sizes!.length, (index) {
                            final item = product.sizes![index];

                            return GestureDetector(
                                onTap: () {
                                  sizeItem = item.value!;
                                  sizeName = item.name!;

                                  state(() {});
                                },
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 5),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(child: Text(item.value!)),
                                          Container(
                                            width: 20,
                                            height: 20,
                                            decoration: ShapeDecoration(
                                                shape: RoundedRectangleBorder(
                                                  side: const BorderSide(width: 1, color: Color(0xFF23262C)),
                                                  borderRadius: BorderRadius.circular(2),
                                                ),
                                                image: sizeItem == item.value ? const DecorationImage(
                                                  image: AssetImage("assets/checkbox.jpg"),
                                                  fit: BoxFit.fill,
                                                ) : null
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (product.sizes!.length-1 > index) const Divider()
                                  ],
                                )
                            );
                          })),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () async {
                              var selectSize2 = selectSize;

                              setState(() {
                                size = sizeItem;
                                selectSize = 0;
                              });

                              if (selectSize2 > 0) {
                                if (selectSize2 == 2) {
                                  if (carts.where((element) => element.pid == widget.id).isEmpty) {
                                    await addCart(1, context);
                                  }
                                } else if (selectSize2 == 3) {
                                  await addCart(1, context);
                                } else {
                                  newCarts = Cart(pid: widget.id, imageUrl: product.imageUrl, name: product.name, quantity: 1, price: double.parse(product.price!.replaceAll(" ", "")), size: size, sizeName: sizeName, article: product.article, category: widget.category);
                                }

                                if (context.mounted) {
                                  Navigator.of(context).pop();

                                  if (selectSize2 == 1) {
                                    consultationPopup(context, width);
                                  } else if (selectSize2 == 2) {
                                    salePopup(context, width);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                      content: Text("Товар добавлен в корзину"),
                                    ));
                                  }
                                }
                              } else {
                                Navigator.of(context).pop();
                              }
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
                              'применить',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                'размер',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color(0xFF728A9D),
                                    fontSize: 12,
                                    fontFamily: 'DaysSansBlack',
                                    fontWeight: FontWeight.w400
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: SvgPicture.asset("assets/close.svg", semanticsLabel: 'close', width: 20, height: 20),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                      ],
                    )
                  ],
                )
            );
          });
        }
    );
  }

  @override
  void dispose() {
    controller.dispose();
    controller2.dispose();
    scroll.dispose();
    nestedScroll.dispose();
    super.dispose();
  }

  bool isHeightCalculated = false;
  final ScrollController scroll = ScrollController();
  final ScrollController nestedScroll = ScrollController();
  var scrollHeader = false;
  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width - 20;
    final double height = MediaQuery.of(context).size.height;
    final double imageWidth = (width > 375 ? 375 : width) + 60;

    return Scaffold(
        backgroundColor: const Color(0xFFEBF3FB),
        appBar: const HeaderView(),
        body: SafeArea(
          child: Stack(
            children: [
              if (isLoading) Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      width: width,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset("assets/left.svg", semanticsLabel: 'back', width: 15, height: 15),
                          SizedBox(
                            width: width - 25,
                            child: Text(
                              product.name!,
                              style: const TextStyle(
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
                  product.shopStatus != null ? Expanded(
                    child: NotificationListener<ScrollNotification>(
                        onNotification: (scrollNotification) {
                          final x = nestedScroll.position.pixels + 60;

                          if (scrollNotification.metrics.pixels > 170 && !scrollHeader && x > 0 && nestedScroll.position.userScrollDirection == ScrollDirection.reverse) {
                            setState(() {
                              scrollHeader = true;
                            });
                          } else if (scrollNotification.metrics.pixels < 250 && scrollHeader && x > 0 && x < 250 && nestedScroll.position.userScrollDirection == ScrollDirection.forward) {
                            setState(() {
                              scrollHeader = false;
                            });
                          }

                          return true;
                        },
                        child: NestedScrollView(
                            controller: nestedScroll,
                            floatHeaderSlivers: true,
                            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                              return [
                                const SliverAppBar(
                                  collapsedHeight: 0,
                                  toolbarHeight: 0,
                                  backgroundColor: Colors.transparent,
                                  expandedHeight: 1,
                                  titleSpacing: 0,
                                  elevation: 0,
                                  pinned: true,
                                  floating: true,
                                  clipBehavior: Clip.none,
                                  automaticallyImplyLeading: false,
                                ),
                                SliverAppBar(
                                  flexibleSpace: FlexibleSpaceBar(
                                      background: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.only(bottom: product.images != null && product.images!.isNotEmpty ? 8 : 0),
                                              child: Stack(
                                                alignment: Alignment.topRight,
                                                clipBehavior: Clip.none,
                                                children: [
                                                  Container(
                                                    color: const Color(0xFFEBF3FB),
                                                    alignment: Alignment.bottomCenter,
                                                    height: 300,
                                                  ),
                                                  Container(
                                                    alignment: Alignment.bottomCenter,
                                                    color: Colors.white,
                                                    padding: const EdgeInsets.only(bottom: 10),
                                                    height: 280,
                                                    child: Text(
                                                      product.images != null && product.images!.length > 1 ? "$countable/${product.images!.length}" : "",
                                                      style: const TextStyle(
                                                          color: Color(0xFF23262C),
                                                          fontSize: 12,
                                                          fontFamily: 'Inter',
                                                          fontWeight: FontWeight.w400
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 230,
                                                    width: width,
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        const SizedBox(height: 15),
                                                        Expanded(
                                                          child: product.images != null && product.images!.isNotEmpty ? CarouselSlider(
                                                            carouselController: carouselController,
                                                            options: CarouselOptions(
                                                                onPageChanged: (index, option) {
                                                                  setState(() {
                                                                    countable = index + 1;
                                                                  });
                                                                }
                                                            ),
                                                            items: List.generate(product.images!.length, (index) {
                                                              return GestureDetector(
                                                                onTap: () {
                                                                  AppMetrica.reportEvent('Просмотр картинок в полном массштабе в товаре ${product.name}');
                                                                  Navigator.of(context).push(
                                                                      PageRouteBuilder(
                                                                          opaque: false,
                                                                          pageBuilder: (BuildContext context, _, __) {
                                                                            var countImages = index + 1;
                                                                            final PageController controller = PageController(initialPage: countImages - 1);

                                                                            return StatefulBuilder(builder: (BuildContext context, StateSetter state) {
                                                                              return Scaffold(
                                                                                  backgroundColor: const Color(0xFF23262C).withOpacity(0.85),
                                                                                  body: SafeArea(
                                                                                      top: true,
                                                                                      child: GestureDetector(
                                                                                        onTap: () {
                                                                                          Navigator.of(context).pop();
                                                                                        },
                                                                                        child: Stack(
                                                                                          alignment: Alignment.topRight,
                                                                                          children: [
                                                                                            Center(
                                                                                              child: SizedBox(
                                                                                                height: height-200,
                                                                                                child: Column(
                                                                                                  children: [
                                                                                                    Expanded(
                                                                                                      child: PageView(
                                                                                                        controller: controller,
                                                                                                        onPageChanged: (val) {
                                                                                                          var count = val + 1;
                                                                                                          countImages = count;
                                                                                                          state(() {});
                                                                                                          carouselController.animateToPage(count-1);
                                                                                                          setState(() {
                                                                                                            countable = count;
                                                                                                          });
                                                                                                        },
                                                                                                        padEnds: false,
                                                                                                        children: List<Widget>.generate(product.images!.length, (index) {
                                                                                                          return Zoom(
                                                                                                              backgroundColor: Colors.transparent,
                                                                                                              initTotalZoomOut: true,
                                                                                                              maxScale: 4,
                                                                                                              child: Container(
                                                                                                                width: width > 375 ? 375 : width,
                                                                                                                height: imageWidth,
                                                                                                                decoration: ShapeDecoration(
                                                                                                                  image: DecorationImage(
                                                                                                                    image: CachedNetworkImageProvider(product.images![index].original ?? ""),
                                                                                                                    fit: BoxFit.contain,
                                                                                                                  ),
                                                                                                                  shape: RoundedRectangleBorder(
                                                                                                                    borderRadius: BorderRadius.circular(10),
                                                                                                                  ),
                                                                                                                ),
                                                                                                              )
                                                                                                          );
                                                                                                        }),
                                                                                                      ),
                                                                                                    ),
                                                                                                    const SizedBox(height: 20),
                                                                                                    Text(
                                                                                                      "$countImages/${product.images!.length}",
                                                                                                      style: const TextStyle(
                                                                                                          color: Colors.white,
                                                                                                          fontSize: 16,
                                                                                                          fontFamily: 'Inter',
                                                                                                          fontWeight: FontWeight.w400
                                                                                                      ),
                                                                                                    )
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                            InkWell(
                                                                                                onTap: () {
                                                                                                  Navigator.of(context).pop();
                                                                                                },
                                                                                                child: SizedBox(
                                                                                                    width: 34,
                                                                                                    height: 34,
                                                                                                    child: Center(
                                                                                                      child: SvgPicture.asset("assets/close2.svg", semanticsLabel: 'close', width: 17, height: 17),
                                                                                                    )
                                                                                                )
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      )
                                                                                  )
                                                                              );
                                                                            });
                                                                          }
                                                                      )
                                                                  );
                                                                },
                                                                child: Container(
                                                                  color: Colors.white,
                                                                  width: double.infinity,
                                                                  height: 230,
                                                                  child: CachedNetworkImage(
                                                                      imageUrl: product.images![index].thumb ?? "",
                                                                      errorWidget: (context, url, error) => Image.asset("assets/no-image.png"),
                                                                      fit: BoxFit.contain
                                                                  ),
                                                                ),
                                                              );
                                                            }),
                                                          ) : GestureDetector(
                                                            onTap: () {
                                                              Navigator.of(context).push(
                                                                  PageRouteBuilder(
                                                                      opaque: false,
                                                                      pageBuilder: (BuildContext context, _, __) {
                                                                        return StatefulBuilder(builder: (BuildContext context, StateSetter state) {
                                                                          return Scaffold(
                                                                              backgroundColor: const Color(0xFF23262C).withOpacity(0.85),
                                                                              body: SafeArea(
                                                                                  top: true,
                                                                                  child: GestureDetector(
                                                                                    onTap: () {
                                                                                      Navigator.of(context).pop();
                                                                                    },
                                                                                    child: Stack(
                                                                                      alignment: Alignment.topRight,
                                                                                      children: [
                                                                                        Center(
                                                                                          child: SizedBox(
                                                                                            height: height-200,
                                                                                            child: Column(
                                                                                              children: [
                                                                                                Expanded(
                                                                                                    child: Zoom(
                                                                                                        backgroundColor: Colors.transparent,
                                                                                                        initTotalZoomOut: true,
                                                                                                        maxScale: 4,
                                                                                                        child: Container(
                                                                                                          width: width > 375 ? 375 : width,
                                                                                                          height: imageWidth,
                                                                                                          decoration: ShapeDecoration(
                                                                                                            image: DecorationImage(
                                                                                                              image: CachedNetworkImageProvider(product.imageUrlOriginal!),
                                                                                                              fit: BoxFit.contain,
                                                                                                            ),
                                                                                                            shape: RoundedRectangleBorder(
                                                                                                              borderRadius: BorderRadius.circular(10),
                                                                                                            ),
                                                                                                          ),
                                                                                                        )
                                                                                                    )
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        InkWell(
                                                                                            onTap: () {
                                                                                              Navigator.of(context).pop();
                                                                                            },
                                                                                            child: SizedBox(
                                                                                                width: 34,
                                                                                                height: 34,
                                                                                                child: Center(
                                                                                                  child: SvgPicture.asset("assets/close2.svg", semanticsLabel: 'close', width: 17, height: 17),
                                                                                                )
                                                                                            )
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  )
                                                                              )
                                                                          );
                                                                        });
                                                                      }
                                                                  )
                                                              );
                                                            },
                                                            child: Container(
                                                              color: Colors.red,
                                                              width: double.infinity,
                                                              height: 230,
                                                              child: CachedNetworkImage(
                                                                  imageUrl: product.imageUrl!,
                                                                  errorWidget: (context, url, error) => Image.asset("assets/no-image.png"),
                                                                  fit: BoxFit.contain
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        if (wishlist.where((element) => element.pid == widget.id).isNotEmpty) {
                                                          AppMetrica.reportEvent('Удалили товар ${product.name} из избранного');
                                                          DBProvider.db.deleteWishlist(widget.id);
                                                        } else {
                                                          AppMetrica.reportEvent('Добавили товар ${product.name} в избранное');
                                                          DBProvider.db.addWishlist(Wishlist(pid: widget.id, imageUrl: product.imageUrl, name: product.name, price: double.parse(product.price!.replaceAll(" ", "")), category: widget.category));
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
                                                      });
                                                    },
                                                    child: SizedBox(
                                                        width: 42,
                                                        height: 42,
                                                        child: Center(
                                                          child: SvgPicture.asset("assets/${wishlist.where((element) => element.pid == widget.id).isNotEmpty ? "heart" : "wishlist"}.svg", semanticsLabel: 'wishlist', width: 14, height: 13),
                                                        )
                                                    ),
                                                  ),
                                                  Positioned(
                                                      right: 17,
                                                      height: 40,
                                                      width: 40,
                                                      bottom: product.images != null && product.images!.isNotEmpty ? 2 : -18,
                                                      child: GestureDetector(
                                                        onTap: () async {
                                                          var nameShare = product.name!;
                                                          AppMetrica.reportEvent('Поделились товаром ${product.name}');
                                                          var urlShare = product.url ?? "";

                                                          final box = context.findRenderObject() as RenderBox?;

                                                          if (urlShare.isNotEmpty) {
                                                            await Share.shareUri(Uri.parse(urlShare));
                                                          } else {
                                                            await Share.share(
                                                                nameShare,
                                                                subject: "Поделиться товаром",
                                                                sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
                                                          }
                                                        },
                                                        child: Align(
                                                            alignment: Alignment.bottomRight,
                                                            child: Container(
                                                                width: 40,
                                                                height: 40,
                                                                decoration: ShapeDecoration(
                                                                  color: Colors.white,
                                                                  shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(100),
                                                                  ),
                                                                  shadows: const [
                                                                    BoxShadow(
                                                                      color: Color(0x59728A9D),
                                                                      blurRadius: 20,
                                                                      offset: Offset(0, 6),
                                                                      spreadRadius: 0,
                                                                    )
                                                                  ],
                                                                ),
                                                                child: Center(
                                                                  child: SvgPicture.asset("assets/share.svg", semanticsLabel: 'share', width: 25, height: 25),
                                                                )
                                                            )
                                                        ),
                                                      )
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ]
                                      )
                                  ),
                                  collapsedHeight: 0,
                                  toolbarHeight: 0,
                                  bottom: PreferredSize(
                                      preferredSize: const Size.fromHeight(170),
                                      child: Visibility(
                                          visible: scrollHeader,
                                          child: Container(
                                              color: const Color(0xFFEBF3FB),
                                              height: 170,
                                              child: Stack(
                                                alignment: Alignment.topCenter,
                                                clipBehavior: Clip.none,
                                                children: [
                                                  Container(
                                                    width: width + 20,
                                                    height: 150,
                                                    clipBehavior: Clip.none,
                                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                                                    decoration: const ShapeDecoration(
                                                      color: Colors.white,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.only(
                                                          bottomLeft: Radius.circular(10),
                                                          bottomRight: Radius.circular(10),
                                                        ),
                                                      ),
                                                    ),
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                          width: 130,
                                                          height: 130,
                                                          decoration: ShapeDecoration(
                                                            image: DecorationImage(
                                                              image: CachedNetworkImageProvider(product.imageUrl!),
                                                              fit: BoxFit.contain,
                                                            ),
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(10),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: width - 166,
                                                          height: 150,
                                                          child: Column(
                                                            mainAxisSize: MainAxisSize.min,
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                "${product.price} руб.",
                                                                style: const TextStyle(
                                                                    color: Color(0xFF23262C),
                                                                    fontSize: 14,
                                                                    fontFamily: 'DaysSansBlack',
                                                                    fontWeight: FontWeight.w400
                                                                ),
                                                              ),
                                                              const SizedBox(height: 15),
                                                              Column(
                                                                mainAxisSize: MainAxisSize.min,
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Visibility(
                                                                    visible: (product.vendor ?? "") != "",
                                                                    child: Text(
                                                                      'производитель: ${product.vendor}',
                                                                      style: const TextStyle(
                                                                          color: Color(0xFF728A9D),
                                                                          fontSize: 14,
                                                                          fontFamily: 'Inter',
                                                                          fontWeight: FontWeight.w400
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Visibility(
                                                                    visible: (product.vendor ?? "") != "",
                                                                    child: Text(
                                                                      'код товара: ${product.article}',
                                                                      style: const TextStyle(
                                                                          color: Color(0xFF728A9D),
                                                                          fontSize: 14,
                                                                          fontFamily: 'Inter',
                                                                          fontWeight: FontWeight.w400
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  const Text(
                                                                    'доставка: по всей России',
                                                                    style: TextStyle(
                                                                        color: Color(0xFF728A9D),
                                                                        fontSize: 14,
                                                                        fontFamily: 'Inter',
                                                                        fontWeight: FontWeight.w400
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Positioned(
                                                      right: 17,
                                                      bottom: 0,
                                                      width: 40,
                                                      height: 40,
                                                      child: Align(
                                                        alignment: Alignment.bottomRight,
                                                        child: GestureDetector(
                                                            onTap: () async {
                                                              var nameShare = product.name!;
                                                              AppMetrica.reportEvent('Поделились товаром ${product.name}');
                                                              var urlShare = product.url ?? "";

                                                              final box = context.findRenderObject() as RenderBox?;

                                                              if (urlShare.isNotEmpty) {
                                                                await Share.shareUri(Uri.parse(urlShare));
                                                              } else {
                                                                await Share.share(
                                                                    nameShare,
                                                                    subject: "Поделиться товаром",
                                                                    sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
                                                              }
                                                            },
                                                            child: Container(
                                                                width: 40,
                                                                height: 40,
                                                                decoration: ShapeDecoration(
                                                                  color: Colors.white,
                                                                  shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(100),
                                                                  ),
                                                                  shadows: const [
                                                                    BoxShadow(
                                                                      color: Color(0x59728A9D),
                                                                      blurRadius: 20,
                                                                      offset: Offset(0, 6),
                                                                      spreadRadius: 0,
                                                                    )
                                                                  ],
                                                                ),
                                                                child: Center(
                                                                  child: SvgPicture.asset("assets/share.svg", semanticsLabel: 'share', width: 25, height: 25),
                                                                )
                                                            )
                                                        ),
                                                      )
                                                  ),
                                                ],
                                              )
                                          )
                                      )
                                  ),
                                  backgroundColor: Colors.transparent,
                                  expandedHeight: 330,
                                  titleSpacing: 0,
                                  elevation: 0,
                                  pinned: true,
                                  floating: true,
                                  clipBehavior: Clip.none,
                                  automaticallyImplyLeading: false,
                                )
                              ];
                            },
                            body: Transform.translate(
                              offset: const Offset(0, -40),
                              child: SingleChildScrollView(
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: width,
                                          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${product.price} руб.",
                                                style: const TextStyle(
                                                    color: Color(0xFF23262C),
                                                    fontSize: 14,
                                                    fontFamily: 'DaysSansBlack',
                                                    fontWeight: FontWeight.w400
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Visibility(
                                                visible: (product.vendor ?? "") != "",
                                                child: Text(
                                                  'производитель: ${product.vendor}',
                                                  style: const TextStyle(
                                                      color: Color(0xFF728A9D),
                                                      fontSize: 14,
                                                      fontFamily: 'Inter',
                                                      fontWeight: FontWeight.w400
                                                  ),
                                                ),
                                              ),
                                              Visibility(
                                                visible: (product.vendor ?? "") != "",
                                                child: Text(
                                                  'код товара: ${product.article}',
                                                  style: const TextStyle(
                                                      color: Color(0xFF728A9D),
                                                      fontSize: 14,
                                                      fontFamily: 'Inter',
                                                      fontWeight: FontWeight.w400
                                                  ),
                                                ),
                                              ),
                                              const Text(
                                                'доставка: по всей России',
                                                style: TextStyle(
                                                    color: Color(0xFF728A9D),
                                                    fontSize: 14,
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.w400
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        if (product.sizes != null && product.sizes!.isNotEmpty) Container(
                                          width: double.infinity,
                                          height: 47,
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                                          decoration: const BoxDecoration(color: Colors.white),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  openSizesPopup(context);
                                                },
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      size != "" ? 'размер: $size' : 'выберите размер',
                                                      style: const TextStyle(
                                                          color: Color(0xFF23262C),
                                                          fontSize: 14,
                                                          fontFamily: 'Inter',
                                                          fontWeight: FontWeight.w400
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    SvgPicture.asset("assets/down.svg", semanticsLabel: 'down', width: 15, height: 15),
                                                  ],
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  AppMetrica.reportEvent('Перешли в подобрать размер из товара ${product.name}');
                                                  Navigator.push(
                                                    context,
                                                    CupertinoPageRoute(builder: (_) => const SizeView()),
                                                  );
                                                },
                                                child: const Text(
                                                  'подобрать размер',
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                      color: Color(0xFF12B438),
                                                      fontSize: 14,
                                                      fontFamily: 'Inter',
                                                      fontWeight: FontWeight.w400
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                            visible: (product.description ?? "") != "",
                                            child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    const SizedBox(height: 15),
                                                    const Text(
                                                      'описание',
                                                      style: TextStyle(
                                                          color: Color(0xFF23262C),
                                                          fontSize: 12,
                                                          fontFamily: 'DaysSansBlack',
                                                          fontWeight: FontWeight.w400
                                                      ),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    SizedBox(
                                                      width: width-20,
                                                      child: Html(
                                                        data: product.description!,
                                                        style: {
                                                          "body": Style(margin: Margins.zero, padding: HtmlPaddings.zero),
                                                          "p": Style(
                                                              color: const Color(0xFF23262C),
                                                              fontSize: FontSize(14),
                                                              fontFamily: 'Inter',
                                                              fontWeight: FontWeight.w400
                                                          ),
                                                        },
                                                      ),
                                                    ),
                                                    const SizedBox(height: 15)
                                                  ],
                                                )
                                            )
                                        ),
                                        const SizedBox(height: 58),
                                      ]
                                  )
                              ),
                            )
                        )
                    ),
                  ) : const Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Данный товар не доступен',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400
                      ),
                    ),
                  ),
                ],
              ),
              if (isLoading && product.shopStatus != null) Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    height: 58,
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(color: Colors.white),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              if (product.sizes != null && product.sizes!.isNotEmpty && size == "") {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                  content: Text("Выберите размер!"),
                                ));

                                setState(() {
                                  selectSize = 1;
                                });

                                Timer(const Duration(milliseconds: 650), () {
                                  openSizesPopup(context);
                                });
                              } else {
                                newCarts = Cart(pid: widget.id, imageUrl: product.imageUrl, name: product.name, quantity: 1, price: double.parse(product.price!.replaceAll(" ", "")), size: size, sizeName: sizeName, article: product.article, category: widget.category);

                                if (context.mounted) {
                                  consultationPopup(context, width);
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              elevation: 0,
                              alignment: Alignment.center,
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  side: const BorderSide(width: 1, color: Color(0xFF12B438))
                              ),
                            ),
                            child: const Text(
                              'получить консультацию',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color(0xFF12B438),
                                  fontSize: 13.5,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  height: 0.8
                              ),
                            ),
                          ),
                        ),
                        if (double.parse(product.price!.replaceAll(" ", "")) > 10000) const SizedBox(width: 2),
                        if (double.parse(product.price!.replaceAll(" ", "")) > 10000) Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              if (product.sizes != null && product.sizes!.isNotEmpty && size == "") {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                  content: Text("Выберите размер!"),
                                ));

                                setState(() {
                                  selectSize = 2;
                                });

                                Timer(const Duration(milliseconds: 650), () {
                                  openSizesPopup(context);
                                });

                                return;
                              } else {
                                if (carts.where((element) => element.pid == widget.id).isEmpty) {
                                  await addCart(1, context);
                                }
                              }

                              if (context.mounted) {
                                salePopup(context, width);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              elevation: 0,
                              padding: EdgeInsets.zero,
                              alignment: Alignment.center,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  side: const BorderSide(width: 1, color: Color(0xFF12B438))
                              ),
                            ),
                            child: const Text(
                              'в рассрочку',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color(0xFF12B438),
                                  fontSize: 13.5,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  height: 0.8
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: double.parse(product.price!.replaceAll(" ", "")) < 10000 ? 6 : 2),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              if (product.sizes != null && product.sizes!.isNotEmpty && size == "") {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                  content: Text("Выберите размер!"),
                                ));

                                setState(() {
                                  selectSize = 3;
                                });

                                Timer(const Duration(milliseconds: 650), () {
                                  openSizesPopup(context);
                                });

                                return;
                              } else {
                                await addCart(1, context);
                              }

                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                  content: Text("Товар добавлен в корзину"),
                                ));
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF12B438),
                              elevation: 0,
                              padding: EdgeInsets.zero,
                              alignment: Alignment.center,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  side: const BorderSide(width: 1, color: Color(0xFF12B438))
                              ),
                            ),
                            child: const Text(
                              'добавить в корзину',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13.5,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  height: 0.8
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
              )
            ],
          ),
        ),
        bottomNavigationBar: const NavigationView()
    );
  }
}