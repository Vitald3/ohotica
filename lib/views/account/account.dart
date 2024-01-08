import 'dart:io';
import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:ohotika/views/account/review.dart';
import 'package:ohotika/views/account/reward.dart';
import 'package:ohotika/views/account/setting.dart';
import 'package:ohotika/views/account/size.dart';
import '../../models/api_response.dart';
import '../../other/extensions.dart';
import '../../services/network/api.dart';
import '../cart.dart';
import '../header.dart';
import '../navigations.dart';
import 'contact.dart';
import 'delivery.dart';
import 'order.dart';

class AccountView extends StatefulWidget {
  const AccountView({super.key, this.checkout});

  final bool? checkout;

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  late final Box setting;
  var contactId = 0;
  var name = "Гость";
  var reward = "";
  var avatar = "";
  var isLoading = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setData();
    });

    super.initState();
  }

  getContact() {
    avatar = setting.get("avatar") ?? "";

    Api.getContact(contactId).then((value) {
      if (value.contact != null) {
        name = value.contact!.name ?? "Гость";
        reward = getNoun(value.contact!.reward ?? 0, "балл", "балла", "баллов");
      }

      isLoading = true;

      setState(() {});
    });
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
      contactId = int.parse(contact.id!);

      if (contact.name != null) {
        name = contact.name!;
      }

      if (contact.reward != null) {
        reward = getNoun(contact.reward ?? 0, "балл", "балла", "баллов");
      } else {
        reward = "0 баллов";
      }

      getContact();
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width - 20;

    return WillPopScope(
      onWillPop: () async {
        if (widget.checkout ?? false) {
          Navigator.pushReplacement(
            context,
            CupertinoPageRoute(builder: (_) => const CartView()),
          );
        }

        return true;
      },
      child: Scaffold(
          backgroundColor: const Color(0xFFEBF3FB),
          appBar: const HeaderView(),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(10),
              child: Wrap(
                runSpacing: 5,
                children: [
                  Container(
                    width: width,
                    height: 98,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            AppMetrica.reportEvent('Пользователь $name перешел в настройки');
                            Navigator.push(
                              context,
                              CupertinoPageRoute(builder: (_) => const SettingView()),
                            ).then((_) => getContact());
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                avatar == "" ? SvgPicture.asset("assets/profile_empty.svg", semanticsLabel: 'profile_empty', width: 42, height: 42) : Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    CircleAvatar(
                                      radius: 21,
                                      backgroundColor: Colors.brown,
                                      backgroundImage: Image.file(
                                        File(avatar),
                                        errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                                          return const Center(child: Text('Тип изображения не поддерживается'));
                                        },
                                      ).image,
                                    ),
                                    Transform.translate(offset: const Offset(0, 0), child: SvgPicture.asset("assets/set.svg", semanticsLabel: 'back', width: 15, height: 15))
                                  ],
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: SizedBox(
                                    child: Text(
                                      'Добрый день, \n$name!',
                                      style: const TextStyle(
                                          color: Color(0xFF23262C),
                                          fontSize: 16,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w400
                                      ),
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
                  GestureDetector(
                    onTap: () {
                      AppMetrica.reportEvent('Пользователь $name перешел в заказы');
                      Navigator.push(
                        context,
                        CupertinoPageRoute(builder: (_) => const OrderView()),
                      );
                    },
                    child: Container(
                      width: width,
                      height: 69,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Expanded(
                            child: SizedBox(
                              child: Text(
                                'мои заказы',
                                style: TextStyle(
                                    color: Color(0xFF23262C),
                                    fontSize: 16,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400
                                ),
                              ),
                            ),
                          ),
                          SvgPicture.asset("assets/right.svg", semanticsLabel: 'right', width: 15, height: 15),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                      onTap: () {
                        AppMetrica.reportEvent('Пользователь $name перешел в бонусные баллы');
                        Navigator.push(
                          context,
                          CupertinoPageRoute(builder: (_) => const RewardView()),
                        );
                      },
                      child: Container(
                        width: width,
                        height: 69,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Expanded(
                              child: SizedBox(
                                child: Text(
                                  'бонусные баллы',
                                  style: TextStyle(
                                      color: Color(0xFF23262C),
                                      fontSize: 16,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400
                                  ),
                                ),
                              ),
                            ),
                            if (isLoading) Row(
                              children: [
                                Container(
                                  constraints: const BoxConstraints(maxWidth: 125),
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: ShapeDecoration(
                                    color: const Color(0xFF23262C),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                  ),
                                  child: Text(
                                    reward,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                SvgPicture.asset("assets/right.svg", semanticsLabel: 'right', width: 15, height: 15),
                              ],
                            ),
                          ],
                        ),
                      )
                  ),
                  GestureDetector(
                    onTap: () {
                      AppMetrica.reportEvent('Пользователь $name перешел в настройки профиля');
                      Navigator.push(
                        context,
                        CupertinoPageRoute(builder: (_) => const SettingView()),
                      ).then((_) => getContact());
                    },
                    child: Container(
                      width: width,
                      height: 69,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Expanded(
                            child: SizedBox(
                              child: Text(
                                'настройки',
                                style: TextStyle(
                                    color: Color(0xFF23262C),
                                    fontSize: 16,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400
                                ),
                              ),
                            ),
                          ),
                          SvgPicture.asset("assets/right.svg", semanticsLabel: 'right', width: 15, height: 15),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      AppMetrica.reportEvent('Пользователь $name перешел в отзывы');
                      Navigator.push(
                        context,
                        CupertinoPageRoute(builder: (_) => const ReviewView()),
                      );
                    },
                    child: Container(
                      width: width,
                      height: 69,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Expanded(
                            child: SizedBox(
                              child: Text(
                                'написать отзыв',
                                style: TextStyle(
                                    color: Color(0xFF23262C),
                                    fontSize: 16,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400
                                ),
                              ),
                            ),
                          ),
                          SvgPicture.asset("assets/right.svg", semanticsLabel: 'right', width: 15, height: 15),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      AppMetrica.reportEvent('Пользователь $name перешел в доставку');
                      Navigator.push(
                        context,
                        CupertinoPageRoute(builder: (_) => const DeliveryView()),
                      );
                    },
                    child: Container(
                      width: width,
                      height: 69,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Expanded(
                            child: SizedBox(
                              child: Text(
                                'оплата и доставка',
                                style: TextStyle(
                                    color: Color(0xFF23262C),
                                    fontSize: 16,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400
                                ),
                              ),
                            ),
                          ),
                          SvgPicture.asset("assets/right.svg", semanticsLabel: 'right', width: 15, height: 15),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      AppMetrica.reportEvent('Пользователь $name перешел в Как выбрать размеры');
                      Navigator.push(
                        context,
                        CupertinoPageRoute(builder: (_) => const SizeView()),
                      );
                    },
                    child: Container(
                      width: width,
                      height: 69,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Expanded(
                            child: SizedBox(
                              child: Text(
                                'как выбрать размер',
                                style: TextStyle(
                                    color: Color(0xFF23262C),
                                    fontSize: 16,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400
                                ),
                              ),
                            ),
                          ),
                          SvgPicture.asset("assets/right.svg", semanticsLabel: 'right', width: 15, height: 15),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      AppMetrica.reportEvent('Пользователь $name перешел в контакты');
                      Navigator.push(
                        context,
                        CupertinoPageRoute(builder: (_) => const ContactView()),
                      );
                    },
                    child: Container(
                      width: width,
                      height: 69,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Expanded(
                            child: SizedBox(
                              child: Text(
                                'контакты',
                                style: TextStyle(
                                    color: Color(0xFF23262C),
                                    fontSize: 16,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400
                                ),
                              ),
                            ),
                          ),
                          SvgPicture.asset("assets/right.svg", semanticsLabel: 'right', width: 15, height: 15),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: const NavigationView(current: 3)
      ),
    );
  }
}