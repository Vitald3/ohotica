import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/adapters.dart';
import '../header.dart';
import '../navigations.dart';

class RewardView extends StatefulWidget {
  const RewardView({super.key});

  @override
  State<RewardView> createState() => _RewardViewState();
}

class _RewardViewState extends State<RewardView> {
  late final Box setting;

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
                            "бонусные баллы",
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
                  width: width,
                  height: 34,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xBF23262C),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          '1 балл = 1 рубль',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontFamily: 'DaysSansBlack',
                              fontWeight: FontWeight.w400
                          ),
                        ),
                      ),
                    ],
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
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'как это работает',
                          style: TextStyle(
                              color: Color(0xFF728A9D),
                              fontSize: 12,
                              fontFamily: 'DaysSansBlack',
                              fontWeight: FontWeight.w400
                          ),
                        ),
                      ),
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
                            SvgPicture.asset("assets/r1.svg", semanticsLabel: 'close', width: 24, height: 24),
                            const SizedBox(width: 15),
                            const Expanded(
                              child: SizedBox(
                                child: Text(
                                  'делайте заказы',
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
                            bottom: BorderSide(width: 1, color: Color(0xFF85A0AA)),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset("assets/r2.svg", semanticsLabel: 'close', width: 24, height: 24),
                            const SizedBox(width: 15),
                            const Expanded(
                              child: SizedBox(
                                child: Text(
                                  'накапливайте баллы',
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
                        padding: const EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset("assets/r3.svg", semanticsLabel: 'close', width: 24, height: 24),
                            const SizedBox(width: 15),
                            const Expanded(
                              child: SizedBox(
                                child: Text(
                                  'оплачивайте баллами',
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
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  width: width,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xBF23262C),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          'как получить баллы',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontFamily: 'DaysSansBlack',
                              fontWeight: FontWeight.w400
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        width: 314,
                        child: Text(
                          '3% от суммы каждой покупки начисляются баллами на ваш бонусный счёт',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        ),
                      ),
                    ],
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
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'как потратить баллы',
                          style: TextStyle(
                              color: Color(0xFF728A9D),
                              fontSize: 12,
                              fontFamily: 'DaysSansBlack',
                              fontWeight: FontWeight.w400
                          ),
                        ),
                      ),
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
                            SvgPicture.asset("assets/r4.svg", semanticsLabel: 'close', width: 24, height: 24),
                            const SizedBox(width: 15),
                            const Expanded(
                              child: SizedBox(
                                child: Text(
                                  'при заказе через сайт',
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
                        padding: const EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset("assets/r5.svg", semanticsLabel: 'close', width: 24, height: 24),
                            const SizedBox(width: 15),
                            const Expanded(
                              child: SizedBox(
                                child: Text(
                                  'при заказе через приложение',
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
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const NavigationView()
    );
  }
}