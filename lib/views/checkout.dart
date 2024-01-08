import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:ohotika/views/policy.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/api_response.dart';
import '../models/cart.dart';
import '../models/checkout.dart';
import '../models/product.dart';
import '../other/constant.dart';
import '../other/extensions.dart';
import '../other/values_notifier.dart';
import '../services/database.dart';
import '../services/network/api.dart';
import 'account/account.dart';
import 'header.dart';
import 'navigations.dart';
import 'dart:io' show Platform;
import 'package:intl/intl.dart';

class CheckoutView extends StatefulWidget {
  const CheckoutView({super.key});

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  var carts = <Cart>[];
  late final Box setting;
  var subTotal = 0.0;
  var total = 0.0;
  var shipping = 0.0;
  var rewardTotal = 0.0;
  var wishlist = [];
  var isLoading = false;
  var contactId = "";
  final _formKey = GlobalKey<FormState>();
  TextEditingController controller = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  TextEditingController controller4 = TextEditingController();
  FocusNode focus = FocusNode();
  FocusNode focus2 = FocusNode();
  FocusNode focus3 = FocusNode();
  var maskFormatter = MaskedInputFormatter('+# (###) ###-##-##', allowedCharMatcher: RegExp(r'[0-9]'));
  var maskFormatter2 = MaskedInputFormatter('####', allowedCharMatcher: RegExp(r'[0-9]'));
  var codeSubmit = false;
  var phoneSubmit = false;
  var checkoutSubmit = false;
  var payment = 1;
  var reward = 10;
  var rewardToggle = false;
  var phone = "";
  var percent = 0;
  var code = "";
  var codeFix = false;
  String? get _errorText {
    if (controller4.value.text != "" && !maskFormatter.isFilled) {
      return 'Номер телефона заполнен неккоректно';
    }

    return null;
  }

  String? get _errorText2 {
    if (controller2.value.text != "" && !maskFormatter2.isFilled) {
      return 'Код должен состоять из 4 цифр';
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
    setting = await Hive.openBox('setting');
    wishlist = setting.get("wishlist") ?? [];
    final contactMap = setting.get("contact") ?? <String, dynamic>{};
    Map<String, dynamic> maps = {};

    contactMap.forEach((key, value){
      maps[key] = value;
    });

    final contact = Contact.fromJson(maps);

    if (contact.id != null) {
      contactId = contact.id!;
      reward = contact.reward ?? 0;
      phone = "+${contact.phone!}".trim();
      controller4.text = maskFormatter.applyMask(phone).text.trim();

      await Api.getContact(int.parse(contactId)).then((value) {
        if (value.contact != null) {
          controller.text = value.contact!.name!;

          reward = value.contact!.reward ?? 0;
          phone = "+${value.contact!.phone!}".trim();
          controller4.text = maskFormatter.applyMask("+${value.contact!.phone}").text.trim();
          maskFormatter.formatEditUpdate(const TextEditingValue(text: ""), TextEditingValue(text: maskFormatter.applyMask("+${value.contact!.phone}").text));
        }

        setState(() {});
      });
    }

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

  getCode(BuildContext context) {
    if (code != "") {
      openCode(context);
    } else {
      Api.getCode(Checkout(phone: "+${maskFormatter.unmaskedValue}")).then((response) {
        if ((response.success ?? false) && response.code != "") {
          setState(() {
            code = response.code!;
          });

          openCode(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text(response.error ?? "Произошла ошибка"),
          ));
        }
      });
    }
  }

  openCode(BuildContext context) {
    final double width = MediaQuery.of(context).size.width - 20;

    showCupertinoModalPopup(context: context, builder: (BuildContext context) {
      return StatefulBuilder(builder: (BuildContext context, StateSetter state) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
              top: true,
              child: Center(
                  child: Container(
                    width: width-20,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: double.infinity,
                          child: Text(
                            'Введите код подтверждения, последние 4 цифры входящего звонка',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color(0xFF728A9D),
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400
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
                                hintText: "0000",
                                fillColor: Colors.white,
                                filled: true,
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
                                if (maskFormatter2.isFilled) {
                                  state(() {});
                                }
                              },
                              keyboardType: TextInputType.number
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () async {
                            focus3.unfocus();

                            if (controller2.value.text != "") {
                              if (code == controller2.value.text) {
                                state(() {
                                  codeSubmit = true;
                                });

                                Api.checkCode(Checkout(phone: "+${maskFormatter.unmaskedValue}", code: controller2.value.text, platform: Platform.isAndroid ? 1 : 0)).then((response) async {
                                  state(() {
                                    codeSubmit = false;
                                  });

                                  if ((response.success ?? false) && response.contact != null) {
                                    setting.put("contact", response.contact?.toJson());
                                    final contactMap = response.contact?.toJson() ?? <String, dynamic>{};
                                    Map<String, dynamic> maps = {};

                                    contactMap.forEach((key, value){
                                      maps[key] = value;
                                    });

                                    final contact = Contact.fromJson(maps);

                                    if (contact.id != null) {
                                      setState(() {
                                        contactId = contact.id!;
                                        reward = contact.reward ?? 0;
                                        phone = "+${contact.phone!}";
                                        codeFix = true;
                                      });

                                      await Api.getContact(int.parse(contact.id!)).then((value) {
                                        if (value.contact != null) {
                                          controller.text = value.contact!.name!;

                                          if ((value.contact!.reward ?? 0) > 0) {
                                            reward = value.contact!.reward!;
                                          }

                                          setState(() {});
                                        }
                                      });

                                      if (context.mounted) {
                                        Navigator.of(context).pop();
                                      }
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        content: Text("Пользователь не найден"),
                                      ));

                                      Navigator.of(context).pop();
                                    }
                                  } else {
                                    var error = response.error ?? "Произошла ошибка";

                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      behavior: SnackBarBehavior.floating,
                                      content: Text(error == "" ? "Произошла ошибка" : error),
                                    ));

                                    Navigator.of(context).pop();
                                  }
                                });
                              } else {
                                focus2.requestFocus();

                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  content: Text("Код введен неверно"),
                                ));
                              }
                            } else {
                              focus2.requestFocus();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            minimumSize: Size(width, 38),
                            elevation: 0,
                            alignment: Alignment.center,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(width: 1, color: Color(0xFF12B438)),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          child: codeSubmit ? const CupertinoActivityIndicator(color: Color(0xFF12B438), radius: 10) : const Text(
                            'продолжить',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color(0xFF12B438),
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
              )
          ),
        );
      });
    });
  }

  openSuccessPopup(BuildContext context, int orderId) {
    final double width = MediaQuery.of(context).size.width - 20;

    showCupertinoModalPopup(context: context, builder: (BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
            top: true,
            child: Center(
                child: Container(
                  width: width-20,
                  padding: const EdgeInsets.all(25),
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset("assets/success.svg", semanticsLabel: 'close', width: 48, height: 48),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: width-40,
                        child: Text(
                          'ваш заказ $orderId принят',
                          style: const TextStyle(
                            color: Color(0xFF23262C),
                            fontSize: 14,
                            fontFamily: 'DaysSansBlack',
                            fontWeight: FontWeight.w400
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: width-40,
                        child: const Text(
                          'Менеджер свяжется с вами в ближайшее время с 8:00 до 19:00 по московскому времени для уточнения деталей заказа.',
                          style: TextStyle(
                            color: Color(0xFF728A9D),
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: width-40,
                        child: const Text(
                          'Спасибо за заказ',
                          style: TextStyle(
                            color: Color(0xFF23262C),
                            fontSize: 14,
                            fontFamily: 'DaysSansBlack',
                            fontWeight: FontWeight.w400
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: () async {
                          DBProvider.db.clearCart();
                          Provider.of<ValuesNotifier>(context, listen: false).setCartCount("");

                          setState(() {
                            carts = [];
                            subTotal = 0.0;
                            total = 0.0;
                            shipping = 0.0;
                            percent = 0;
                            code = "";
                            rewardTotal = 0.0;
                          });

                          Navigator.of(context).pop();

                          Navigator.pushReplacement(
                            context,
                            CupertinoPageRoute(builder: (_) => const AccountView(checkout: true)),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          minimumSize: Size(width-20, 34),
                          elevation: 0,
                          alignment: Alignment.center,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(width: 1, color: Color(0xFF12B438)),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: const Text(
                          'понятно',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color(0xFF12B438),
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400
                          ),
                        ),
                      ),
                    ],
                  ),
                )
            )
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width - 20;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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
                        'оформление',
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
                Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                          children: [
                            const SizedBox(height: 54),
                            Container(
                                width: width,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: width-20,
                                      child: TextFormField(
                                          textInputAction: TextInputAction.next,
                                          controller: controller,
                                          focusNode: focus,
                                          decoration: InputDecoration(
                                            hintText: "Имя",
                                            hintStyle: const TextStyle(
                                              color: Color(0xFF85A0AA),
                                              fontSize: 14,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w400,
                                            ),
                                            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                width: 1,
                                                strokeAlign: BorderSide.strokeAlignOutside,
                                                color: Color(0xFF85A0AA),
                                              ),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            focusedErrorBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                width: 1,
                                                strokeAlign: BorderSide.strokeAlignOutside,
                                                color: Colors.red,
                                              ),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                width: 1,
                                                strokeAlign: BorderSide.strokeAlignOutside,
                                                color: Colors.red,
                                              ),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                width: 1,
                                                strokeAlign: BorderSide.strokeAlignOutside,
                                                color: Color(0xFF85A0AA),
                                              ),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                          keyboardType: TextInputType.text
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    SizedBox(
                                      width: width-20,
                                      child: TextFormField(
                                          controller: controller4,
                                          focusNode: focus3,
                                          inputFormatters: [maskFormatter],
                                          readOnly: contactId != "",
                                          decoration: InputDecoration(
                                            hintText: "+7 (000) 000-00-00",
                                            fillColor: Colors.white,
                                            errorText: _errorText,
                                            filled: true,
                                            hintStyle: const TextStyle(
                                              color: Color(0xFF85A0AA),
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
                                            if (controller4.text.isEmpty || controller4.text == "+7") {
                                              controller4.text = "+7 (9";
                                            }

                                            if (maskFormatter.isFilled) {
                                              setState(() {});
                                            }
                                          },
                                          onEditingComplete: () {
                                            if (contactId == "" && maskFormatter.isFilled && !codeFix && !phoneSubmit) {
                                              setState(() {
                                                phoneSubmit = true;
                                              });

                                              getCode(context);
                                            }
                                          },
                                          onSaved: (val) {
                                            if (contactId == "" && maskFormatter.isFilled && !codeFix && !phoneSubmit) {
                                              setState(() {
                                                phoneSubmit = true;
                                              });

                                              getCode(context);
                                            }
                                          },
                                          onTap: () {
                                            if (controller4.value.text.isEmpty || controller4.text == "+7") {
                                              controller4.text = "+7 (9";
                                            }

                                            if (contactId == "" && maskFormatter.isFilled && !codeFix && !phoneSubmit) {
                                              setState(() {
                                                phoneSubmit = true;
                                              });

                                              getCode(context);
                                            }
                                          },
                                          onFieldSubmitted: (val) {
                                            if (contactId == "" && maskFormatter.isFilled && !codeSubmit && !codeFix && !phoneSubmit) {
                                              setState(() {
                                                phoneSubmit = true;
                                              });

                                              getCode(context);
                                            }
                                          },
                                          keyboardType: TextInputType.number
                                      ),
                                    ),
                                    if (contactId == "" && code != "" && !codeFix && !phoneSubmit) const SizedBox(height: 10),
                                    if (contactId == "" && code != "" && !codeFix && !phoneSubmit) InkWell(
                                      onTap: () {
                                        openCode(context);
                                      },
                                      child: const Text(
                                        'Ввести код',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Color(0xFF12B438),
                                            fontSize: 14,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400
                                        ),
                                      ),
                                    )
                                  ],
                                )
                            ),
                            const SizedBox(height: 10),
                            Container(
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
                                  const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    child: Text(
                                      'способ оплаты',
                                      style: TextStyle(
                                          color: Color(0xFF728A9D),
                                          fontSize: 12,
                                          fontFamily: 'DaysSansBlack',
                                          fontWeight: FontWeight.w400
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      AppMetrica.reportEvent('Переключение метода доставки на Оплата при получении');

                                      setState(() {
                                        payment = 1;
                                      });
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
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
                                          const Expanded(
                                            child: SizedBox(
                                              child: Text(
                                                'оплата при получении',
                                                style: TextStyle(
                                                  color: Color(0xFF23262C),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w400,
                                                  height: 0,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: Stack(
                                              children: [
                                                Positioned(
                                                  left: 0,
                                                  top: 0,
                                                  child: Container(
                                                    width: 20,
                                                    height: 20,
                                                    decoration: const ShapeDecoration(
                                                      shape: OvalBorder(
                                                        side: BorderSide(width: 1, color: Color(0xFF12B438)),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                if (payment == 1) Positioned(
                                                  left: 5,
                                                  top: 5,
                                                  child: SizedBox(
                                                    width: 10,
                                                    height: 10,
                                                    child: Stack(
                                                      children: [
                                                        Positioned(
                                                          left: 0,
                                                          top: 0,
                                                          child: Container(
                                                            width: 10,
                                                            height: 10,
                                                            decoration: const ShapeDecoration(
                                                              color: Color(0xFF12B438),
                                                              shape: OvalBorder(),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      AppMetrica.reportEvent('Переключение метода доставки на Оплата онлайн');

                                      setState(() {
                                        payment = 2;
                                      });
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: reward > 0 && contactId != "" ? 15 : 5),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(width: 1, color: reward > 0 && contactId != "" ? const Color(0xFF85A0AA) : Colors.transparent),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          const Expanded(
                                            child: SizedBox(
                                              child: Text(
                                                'оплата онлайн',
                                                style: TextStyle(
                                                  color: Color(0xFF23262C),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w400,
                                                  height: 0,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Image.asset("assets/pays.png", width: 106, height: 15),
                                          const SizedBox(width: 10),
                                          SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: Stack(
                                              children: [
                                                Positioned(
                                                  left: 0,
                                                  top: 0,
                                                  child: Container(
                                                    width: 20,
                                                    height: 20,
                                                    decoration: const ShapeDecoration(
                                                      shape: OvalBorder(
                                                        side: BorderSide(width: 1, color: Color(0xFF12B438)),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                if (payment == 2) Positioned(
                                                  left: 5,
                                                  top: 5,
                                                  child: SizedBox(
                                                    width: 10,
                                                    height: 10,
                                                    child: Stack(
                                                      children: [
                                                        Positioned(
                                                          left: 0,
                                                          top: 0,
                                                          child: Container(
                                                            width: 10,
                                                            height: 10,
                                                            decoration: const ShapeDecoration(
                                                              color: Color(0xFF12B438),
                                                              shape: OvalBorder(),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (reward > 0 && contactId != "") GestureDetector(
                                      onTap: () {
                                        if (rewardToggle) {
                                          total += rewardTotal;
                                          rewardTotal = 0.0;
                                          rewardToggle = false;
                                          percent = 0;
                                          setState(() {});
                                          return;
                                        }

                                        showCupertinoModalPopup(context: context, builder: (BuildContext context) {
                                          percent = (subTotal * 0.1).ceil();

                                          if (reward < percent) {
                                            percent = reward;
                                          }

                                          return Scaffold(
                                            backgroundColor: Colors.transparent,
                                            body: SafeArea(
                                                top: true,
                                                child: Center(
                                                    child: Container(
                                                      width: width-20,
                                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                                                      decoration: ShapeDecoration(
                                                        color: Colors.white,
                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                      ),
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          SizedBox(
                                                            width: double.infinity,
                                                            child: Text(
                                                              'на вашем счете ${getNoun(reward, "балл", "балла", "баллов")}',
                                                              textAlign: TextAlign.center,
                                                              style: const TextStyle(
                                                                  color: Color(0xFF23262C),
                                                                  fontSize: 14,
                                                                  fontFamily: 'DaysSansBlack',
                                                                  fontWeight: FontWeight.w400
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(height: 15),
                                                          const SizedBox(
                                                            width: 290,
                                                            child: Text(
                                                              'Для списания доступно 10% от суммы заказа.',
                                                              style: TextStyle(
                                                                color: Color(0xFF728A9D),
                                                                fontSize: 14,
                                                                fontFamily: 'Inter',
                                                                fontWeight: FontWeight.w400,
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(height: 15),
                                                          SizedBox(
                                                            width: double.infinity,
                                                            child: Text(
                                                              'списать ${getNoun(percent, "балл", "балла", "баллов")}?',
                                                              textAlign: TextAlign.center,
                                                              style: const TextStyle(
                                                                  color: Color(0xFF23262C),
                                                                  fontSize: 14,
                                                                  fontFamily: 'DaysSansBlack',
                                                                  fontWeight: FontWeight.w400
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(height: 15),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              ElevatedButton(
                                                                onPressed: () async {
                                                                  Navigator.of(context).pop();
                                                                },
                                                                style: ElevatedButton.styleFrom(
                                                                  backgroundColor: Colors.white,
                                                                  minimumSize: Size((width/2)-40, 34),
                                                                  elevation: 0,
                                                                  alignment: Alignment.center,
                                                                  shape: RoundedRectangleBorder(
                                                                    side: const BorderSide(width: 1, color: Colors.white),
                                                                    borderRadius: BorderRadius.circular(5),
                                                                  ),
                                                                ),
                                                                child: const Text(
                                                                  'нет, спасибо',
                                                                  textAlign: TextAlign.center,
                                                                  style: TextStyle(
                                                                      color: Color(0xFF12B438),
                                                                      fontSize: 14,
                                                                      fontFamily: 'Inter',
                                                                      fontWeight: FontWeight.w400
                                                                  ),
                                                                ),
                                                              ),
                                                              ElevatedButton(
                                                                onPressed: () async {
                                                                  setState(() {
                                                                    if (!rewardToggle) {
                                                                      rewardToggle = true;
                                                                      rewardTotal = double.parse("$percent");
                                                                      total -= rewardTotal;
                                                                    }
                                                                  });

                                                                  AppMetrica.reportEvent('Списание бонусных баллов клиентом ${maskFormatter.applyMask("+${controller4.text}").text.trim()}');

                                                                  Navigator.of(context).pop();
                                                                },
                                                                style: ElevatedButton.styleFrom(
                                                                  backgroundColor: const Color(0xFF12B438),
                                                                  minimumSize: Size((width/2)-40, 34),
                                                                  elevation: 0,
                                                                  alignment: Alignment.center,
                                                                  shape: RoundedRectangleBorder(
                                                                    side: const BorderSide(width: 1, color: Color(0xFF12B438)),
                                                                    borderRadius: BorderRadius.circular(5),
                                                                  ),
                                                                ),
                                                                child: const Text(
                                                                  'списать',
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
                                                        ],
                                                      ),
                                                    )
                                                )
                                            ),
                                          );
                                        });
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 5),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            const Expanded(
                                              child: SizedBox(
                                                child: Text(
                                                  'списать баллы',
                                                  style: TextStyle(
                                                    color: Color(0xFF23262C),
                                                    fontSize: 14,
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.w400,
                                                    height: 0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 35,
                                              height: 20,
                                              decoration: ShapeDecoration(
                                                color: Color(!rewardToggle ? 0xFF85A0AA : 0xFF12B438),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(32),
                                                ),
                                              ),
                                              child: Stack(
                                                children: [
                                                  Positioned(
                                                    left: !rewardToggle ? 2 : 17,
                                                    top: 2,
                                                    child: Container(
                                                      width: 16,
                                                      height: 16,
                                                      decoration: ShapeDecoration(
                                                        color: Colors.white,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(50),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            ColoredBox(
                                color: const Color(0xFFEBF2FA),
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
                                    if (rewardTotal > 0) const SizedBox(height: 5),
                                    if (rewardTotal > 0) Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Списано бонусов',
                                          style: TextStyle(
                                              color: Color(0xFF728A9D),
                                              fontSize: 12,
                                              fontFamily: 'DaysSansBlack',
                                              fontWeight: FontWeight.w400
                                          ),
                                        ),
                                        Text(
                                          '${NumberFormat.currency(locale: 'ru', symbol: '', decimalDigits: 0).format(rewardTotal)} руб.',
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
                                        if (contactId == "") {
                                          if (maskFormatter.isFilled && !codeFix) {
                                            getCode(context);
                                          } else {
                                            focus3.requestFocus();

                                            if (controller4.text.isEmpty || controller4.text == "+7") {
                                              controller4.text = "+7 (9";
                                            }

                                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                              content: Text("Заполните номер телефона"),
                                            ));
                                          }

                                          return;
                                        }

                                        if (checkoutSubmit) {
                                          return;
                                        }

                                        setState(() {
                                          checkoutSubmit = true;
                                        });

                                        subTotal = 0.0;
                                        var products = <CheckoutProducts>[];

                                        for (var i in carts) {
                                          subTotal += (i.price ?? 0.0) * (i.quantity ?? 1);

                                          final checkoutProduct = CheckoutProducts(
                                              id: "${i.pid}",
                                              name: "${i.name}",
                                              quantity: i.quantity
                                          );

                                          if (i.sizeName != "" && i.size != "") {
                                            checkoutProduct.size = Sizes(
                                                name: i.sizeName,
                                                value: i.size
                                            );
                                          }

                                          products.add(checkoutProduct);
                                        }

                                        final checkout = Checkout(
                                            name: controller.value.text,
                                            phone: phone,
                                            platform: Platform.isAndroid ? 1 : 0,
                                            paymentMethod: payment,
                                            shippingTotal: subTotal < 7000 ? shipping.toInt() : 0,
                                            productTotal: subTotal.toInt(),
                                            total: (subTotal.toInt() + (subTotal < 7000 ? shipping.toInt() : 0)) - percent,
                                            rewardTotal: percent,
                                            products: products
                                        );

                                        Api.setCheckout(checkout).then((response) async {
                                          setState(() {
                                            checkoutSubmit = false;
                                          });

                                          if (response.success ?? false) {
                                            AppMetrica.reportEvent('Клиент ${maskFormatter.applyMask("+${controller4.text}").text.trim()} оформил заказ');

                                            if (payment == 2) {
                                              var text = "";

                                              if (response.url != null && response.url != "") {
                                                Uri url = Uri.parse(response.url!);

                                                if (await canLaunchUrl(url)) {
                                                  await launchUrl(url);
                                                  await DBProvider.db.clearCart();

                                                  if (context.mounted) {
                                                    Provider.of<ValuesNotifier>(context, listen: false).setCartCount("");
                                                  }

                                                  setState(() {
                                                    carts = [];
                                                    subTotal = 0.0;
                                                    total = 0.0;
                                                    shipping = 0.0;
                                                    percent = 0;
                                                    code = "";
                                                    rewardTotal = 0.0;
                                                  });
                                                } else {
                                                  text = "Ссылка для оплаты скопированна в буфер обмена";
                                                  await Clipboard.setData(ClipboardData(text: response.url!));
                                                }
                                              } else {
                                                text = "Произошла ошибка создания ссылки на оплату";
                                              }

                                              if (context.mounted) {
                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                  behavior: SnackBarBehavior.floating,
                                                  content: Text(text),
                                                ));
                                              }
                                            } else if (payment == 1) {
                                              openSuccessPopup(context, response.orderId ?? 0);
                                            }
                                          } else {
                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                              behavior: SnackBarBehavior.floating,
                                              content: Text(response.error ?? "Произошла ошибка"),
                                            ));
                                          }
                                        });
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
                                      child: checkoutSubmit ? const CupertinoActivityIndicator(color: Colors.white, radius: 10) : const Text(
                                        'заказать',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Container(
                                      constraints: BoxConstraints(minHeight: 30, minWidth: width),
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
                                                    text: 'нажимая на кнопку «оформить заказ», вы соглашаетесь с',
                                                    style: TextStyle(
                                                      color: Color(0xFF23262C),
                                                      fontSize: 12,
                                                      fontFamily: 'Inter',
                                                      fontWeight: FontWeight.w400,
                                                      height: 0,
                                                    ),
                                                  ),
                                                  const TextSpan(
                                                    text: ' ',
                                                    style: TextStyle(
                                                      color: Color(0xFF23262C),
                                                      fontSize: 12,
                                                      fontFamily: 'Inter',
                                                      fontWeight: FontWeight.w400,
                                                      height: 0,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    recognizer: TapGestureRecognizer()..onTap = () {
                                                      AppMetrica.reportEvent('Клиент ${maskFormatter.applyMask("+${controller4.text}").text.trim()} открыл политику конфиденциальности');

                                                      Navigator.push(
                                                        context,
                                                        CupertinoPageRoute(builder: (_) => const PolicyView()),
                                                      );
                                                    },
                                                    text: 'политикой конфиденциальности',
                                                    style: const TextStyle(
                                                      color: Color(0xFF12B438),
                                                      fontSize: 12,
                                                      fontFamily: 'Inter',
                                                      fontWeight: FontWeight.w400,
                                                      height: 0,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                )
                            ),
                          ]
                      ),
                    )
                ),
              ],
            ),
          ),
          bottomNavigationBar: const NavigationView()
      ),
    );
  }
}