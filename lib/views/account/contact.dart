import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ohotika/views/account/review.dart';
import 'package:url_launcher/url_launcher.dart';
import '../header.dart';
import '../navigations.dart';

class ContactView extends StatefulWidget {
  const ContactView({super.key});

  @override
  State<ContactView> createState() => _ContactViewState();
}

class _ContactViewState extends State<ContactView> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width - 20;

    return Scaffold(
        backgroundColor: const Color(0xFFEBF3FB),
        appBar: const HeaderView(),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                          child: const Text(
                            "контакты",
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
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xBF23262C),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'Охотика — фирменный интернет-магазин одежды и товаров для охотников, рыбаков, и любителей активного отдыха от известных производителей. Мы постоянно работаем над расширением ассортимента, улучшением логистики, оптимизацией цен. Только у нас вы найдете качественное обслуживание при низких ценах.',
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
                  width: width,
                  padding: const EdgeInsets.only(top: 10),
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
                            SvgPicture.asset("assets/icon1.svg", semanticsLabel: 'icon1', width: 24, height: 24),
                            const SizedBox(width: 15),
                            const Expanded(
                              child: SizedBox(
                                child: Text(
                                  'товар непосредственно от производителя',
                                  style: TextStyle(
                                      color: Color(0xFF23262C),
                                      fontSize: 14,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset("assets/icon2.svg", semanticsLabel: 'icon2', width: 24, height: 24),
                            const SizedBox(width: 15),
                            const Expanded(
                              child: SizedBox(
                                child: Text(
                                  'доставка по России и СНГ в короткие сроки',
                                  style: TextStyle(
                                      color: Color(0xFF23262C),
                                      fontSize: 14,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(width: 1, color: Color(0xFF85A0AA)),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset("assets/icon3.svg", semanticsLabel: 'icon3', width: 24, height: 24),
                            const SizedBox(width: 15),
                            const Expanded(
                              child: SizedBox(
                                child: Text(
                                  'оплату товара вы производите непосредственно при получении либо в приложении',
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
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (_) => const ReviewView()),
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
                    'оставить отзыв',
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
                  width: width,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'ООО «Риком»',
                        style: TextStyle(
                            color: Color(0xFF23262C),
                            fontSize: 12,
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
                          const Text(
                            '428003, г Чебоксары, ул К. Маркса, д. 47, помещ. 7, каб. 11',
                            style: TextStyle(
                              color: Color(0xFF23262C),
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                          const Text(
                            'Директор  Кабанов Игорь Валерьевич',
                            style: TextStyle(
                              color: Color(0xFF23262C),
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () async {
                                  Uri url = Uri(scheme: "tel", path: "+78001010375");

                                  if (await canLaunchUrl(url)) {
                                    await launchUrl(url);
                                  } else {
                                    throw 'Could not launch $url';
                                  }
                                },
                                child: const Text(
                                  '+7 (800) 101-03-75',
                                  style: TextStyle(
                                      color: Color(0xFF12B438),
                                      fontSize: 14,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  final Uri emailLaunchUri = Uri(
                                      scheme: 'mailto',
                                      path: "zakaz@ohotika.ru"
                                  );

                                  if (await canLaunchUrl(emailLaunchUri)) {
                                    await launchUrl(emailLaunchUri);
                                  } else {
                                    await Clipboard.setData(const ClipboardData(text: "zakaz@ohotika.ru"));

                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        content: Text("Email успешно скопирован"),
                                      ));
                                    }
                                  }
                                },
                                child: const Text(
                                  'hsnonline@ya.ru',
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
                          const SizedBox(height: 15),
                        ],
                      ),
                      const Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ИНН 2130009953',
                            style: TextStyle(
                              color: Color(0xFF728A9D),
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'КПП  213001001',
                            style: TextStyle(
                              color: Color(0xFF728A9D),
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'ОГРН  1062130014836',
                            style: TextStyle(
                              color: Color(0xFF728A9D),
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'ПАО "НБД-Банк", г.Нижний Новгород',
                            style: TextStyle(
                              color: Color(0xFF728A9D),
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Р/C  40702810211010031218',
                            style: TextStyle(
                              color: Color(0xFF728A9D),
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'К/C  30101810400000000705',
                            style: TextStyle(
                              color: Color(0xFF728A9D),
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'БИК  042202705',
                            style: TextStyle(
                              color: Color(0xFF728A9D),
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const NavigationView()
    );
  }
}