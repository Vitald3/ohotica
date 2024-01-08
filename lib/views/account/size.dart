import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/adapters.dart';
import '../header.dart';
import '../navigations.dart';

class SizeView extends StatefulWidget {
  const SizeView({super.key});

  @override
  State<SizeView> createState() => _SizeViewState();
}

class _SizeViewState extends State<SizeView> {
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
                            "как выбрать размер",
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
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'верхняя одежда',
                          style: TextStyle(
                              color: Color(0xFF728A9D),
                              fontSize: 12,
                              fontFamily: 'DaysSansBlack',
                              fontWeight: FontWeight.w400
                          ),
                        ),
                        SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SizedBox(
                              width: 720,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(width: 1, color: Color(0xFF85A0AA)),
                                      ),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 120,
                                          height: 34,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                'международный\nразмер',
                                                style: TextStyle(
                                                  color: Color(0xFF23262C),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          height: 17,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                'S',
                                                style: TextStyle(
                                                  color: Color(0xFF23262C),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          height: 17,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                'M',
                                                style: TextStyle(
                                                  color: Color(0xFF23262C),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          height: 17,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                'L',
                                                style: TextStyle(
                                                  color: Color(0xFF23262C),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          height: 17,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                'XL',
                                                style: TextStyle(
                                                  color: Color(0xFF23262C),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          height: 17,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                'XXL',
                                                style: TextStyle(
                                                  color: Color(0xFF23262C),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          height: 17,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                'XXXL',
                                                style: TextStyle(
                                                  color: Color(0xFF23262C),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(width: 1, color: Color(0xFF85A0AA)),
                                      ),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 120,
                                          height: 34,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                'российский\nразмер',
                                                style: TextStyle(
                                                  color: Color(0xFF23262C),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          height: 17,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                '46',
                                                style: TextStyle(
                                                  color: Color(0xFF23262C),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          height: 17,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                '48',
                                                style: TextStyle(
                                                  color: Color(0xFF23262C),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          height: 17,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                '50',
                                                style: TextStyle(
                                                  color: Color(0xFF23262C),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          height: 17,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                '52',
                                                style: TextStyle(
                                                  color: Color(0xFF23262C),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          height: 17,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                '54',
                                                style: TextStyle(
                                                  color: Color(0xFF23262C),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          height: 17,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                '56',
                                                style: TextStyle(
                                                  color: Color(0xFF23262C),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          height: 17,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                '58',
                                                style: TextStyle(
                                                  color: Color(0xFF23262C),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          height: 17,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                '60',
                                                style: TextStyle(
                                                  color: Color(0xFF23262C),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          height: 17,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                '62',
                                                style: TextStyle(
                                                  color: Color(0xFF23262C),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          height: 17,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                '64',
                                                style: TextStyle(
                                                  color: Color(0xFF23262C),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(width: 1, color: Color(0xFF85A0AA)),
                                      ),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 120,
                                          height: 17,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                'рост, см',
                                                style: TextStyle(
                                                  color: Color(0xFF23262C),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          height: 39,
                                          child: Text(
                                            '170 182 176 188',
                                            maxLines: 2,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Color(0xFF23262C),
                                                fontSize: 14,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          height: 39,
                                          child: Text(
                                            '170 182 176',
                                            maxLines: 2,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Color(0xFF23262C),
                                                fontSize: 14,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          height: 39,
                                          child: Text(
                                            '170 182 176 188',
                                            maxLines: 2,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Color(0xFF23262C),
                                                fontSize: 14,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          height: 39,
                                          child: Text(
                                            '170 182 176 188',
                                            maxLines: 2,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Color(0xFF23262C),
                                                fontSize: 14,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          height: 39,
                                          child: Text(
                                            '170 182 176 188',
                                            maxLines: 2,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Color(0xFF23262C),
                                                fontSize: 14,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          height: 39,
                                          child: Text(
                                            '170 182 176 188',
                                            maxLines: 2,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Color(0xFF23262C),
                                                fontSize: 14,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          height: 39,
                                          child: Text(
                                            '176 188 182',
                                            maxLines: 2,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Color(0xFF23262C),
                                                fontSize: 14,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          height: 39,
                                          child: Text(
                                            '176 188 182',
                                            maxLines: 2,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Color(0xFF23262C),
                                                fontSize: 14,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          height: 39,
                                          child: Text(
                                            '182 188',
                                            maxLines: 2,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Color(0xFF23262C),
                                                fontSize: 14,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          height: 39,
                                          child: Text(
                                            '182 188',
                                            maxLines: 2,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Color(0xFF23262C),
                                                fontSize: 14,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(width: 1, color: Color(0xFF85A0AA)),
                                      ),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 17,
                                          width: 120,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                'обхват груди, см',
                                                style: TextStyle(
                                                  color: Color(0xFF23262C),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          child: Text(
                                            '92',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Color(0xFF23262C),
                                                fontSize: 14,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          child: Text(
                                            '96',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Color(0xFF23262C),
                                                fontSize: 14,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          child: Text(
                                            '100',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Color(0xFF23262C),
                                                fontSize: 14,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          child: Text(
                                            '104',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Color(0xFF23262C),
                                                fontSize: 14,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          child: Text(
                                            '108',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Color(0xFF23262C),
                                                fontSize: 14,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          child: Text(
                                            '112',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Color(0xFF23262C),
                                                fontSize: 14,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          child: Text(
                                            '116',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Color(0xFF23262C),
                                                fontSize: 14,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          child: Text(
                                            '120',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Color(0xFF23262C),
                                                fontSize: 14,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          child: Text(
                                            '124',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Color(0xFF23262C),
                                                fontSize: 14,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          child: Text(
                                            '128',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Color(0xFF23262C),
                                                fontSize: 14,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.only(top: 10),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 120,
                                          height: 17,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                'обхват талии, см',
                                                style: TextStyle(
                                                    color: Color(0xFF23262C),
                                                    fontSize: 14,
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.w600
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          child: Text(
                                            '80',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Color(0xFF23262C),
                                                fontSize: 14,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          child: Text(
                                            '84',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Color(0xFF23262C),
                                                fontSize: 14,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          child: Text(
                                            '88',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Color(0xFF23262C),
                                                fontSize: 14,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          child: Text(
                                            '92',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Color(0xFF23262C),
                                                fontSize: 14,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          child: Text(
                                            '96',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Color(0xFF23262C),
                                                fontSize: 14,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          child: Text(
                                            '100',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Color(0xFF23262C),
                                                fontSize: 14,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          child: Text(
                                            '104',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Color(0xFF23262C),
                                                fontSize: 14,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          child: Text(
                                            '108',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Color(0xFF23262C),
                                                fontSize: 14,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          child: Text(
                                            '112',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Color(0xFF23262C),
                                                fontSize: 14,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          child: Text(
                                            '116',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Color(0xFF23262C),
                                                fontSize: 14,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                        ),
                      ],
                    )
                ),
                const SizedBox(height: 10),
                Container(
                    padding: const EdgeInsets.all(10),
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'головные уборы',
                          style: TextStyle(
                              color: Color(0xFF728A9D),
                              fontSize: 12,
                              fontFamily: 'DaysSansBlack',
                              fontWeight: FontWeight.w400
                          ),
                        ),
                        SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SizedBox(
                              width: 480,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(width: 1, color: Color(0xFF85A0AA)),
                                      ),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 120,
                                          height: 34,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                'международный\nразмер',
                                                style: TextStyle(
                                                  color: Color(0xFF23262C),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          height: 17,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                'S',
                                                style: TextStyle(
                                                  color: Color(0xFF23262C),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          height: 17,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                'M',
                                                style: TextStyle(
                                                  color: Color(0xFF23262C),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          height: 17,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                'L',
                                                style: TextStyle(
                                                  color: Color(0xFF23262C),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          height: 17,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                'XL',
                                                style: TextStyle(
                                                  color: Color(0xFF23262C),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          height: 17,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                'XXL',
                                                style: TextStyle(
                                                  color: Color(0xFF23262C),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          height: 17,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                'XXXL',
                                                style: TextStyle(
                                                  color: Color(0xFF23262C),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.only(top: 10),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 120,
                                          height: 34,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                'российский\nразмер',
                                                style: TextStyle(
                                                  color: Color(0xFF23262C),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          height: 17,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                '57',
                                                style: TextStyle(
                                                  color: Color(0xFF23262C),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          height: 17,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                '58',
                                                style: TextStyle(
                                                  color: Color(0xFF23262C),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          height: 17,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                '59',
                                                style: TextStyle(
                                                  color: Color(0xFF23262C),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          height: 17,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                '60',
                                                style: TextStyle(
                                                  color: Color(0xFF23262C),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          height: 17,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                '61',
                                                style: TextStyle(
                                                  color: Color(0xFF23262C),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          height: 17,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                '62',
                                                style: TextStyle(
                                                  color: Color(0xFF23262C),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                        ),
                      ],
                    )
                ),
                const SizedBox(height: 10),
                Container(
                    padding: const EdgeInsets.all(10),
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'перчатки и рукавицы',
                          style: TextStyle(
                              color: Color(0xFF728A9D),
                              fontSize: 12,
                              fontFamily: 'DaysSansBlack',
                              fontWeight: FontWeight.w400
                          ),
                        ),
                        SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SizedBox(
                              width: 420,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(width: 1, color: Color(0xFF85A0AA)),
                                      ),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 120,
                                          height: 34,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                'международный\nразмер',
                                                style: TextStyle(
                                                  color: Color(0xFF23262C),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          height: 17,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                'S',
                                                style: TextStyle(
                                                  color: Color(0xFF23262C),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          height: 17,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                'M',
                                                style: TextStyle(
                                                  color: Color(0xFF23262C),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          height: 17,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                'L',
                                                style: TextStyle(
                                                  color: Color(0xFF23262C),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          height: 17,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                'XL',
                                                style: TextStyle(
                                                  color: Color(0xFF23262C),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          height: 17,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                'XXL',
                                                style: TextStyle(
                                                  color: Color(0xFF23262C),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.only(top: 10),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 120,
                                          height: 34,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                'российский\nразмер',
                                                style: TextStyle(
                                                  color: Color(0xFF23262C),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          height: 17,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                '20',
                                                style: TextStyle(
                                                  color: Color(0xFF23262C),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          height: 17,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                '22',
                                                style: TextStyle(
                                                  color: Color(0xFF23262C),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          height: 17,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                '24',
                                                style: TextStyle(
                                                  color: Color(0xFF23262C),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          height: 17,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                '26',
                                                style: TextStyle(
                                                  color: Color(0xFF23262C),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          height: 17,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                '28',
                                                style: TextStyle(
                                                  color: Color(0xFF23262C),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                        ),
                      ],
                    )
                ),
                const SizedBox(height: 10),
                Container(
                    padding: const EdgeInsets.all(10),
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'обувь',
                          style: TextStyle(
                              color: Color(0xFF728A9D),
                              fontSize: 12,
                              fontFamily: 'DaysSansBlack',
                              fontWeight: FontWeight.w400
                          ),
                        ),
                        SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SizedBox(
                              width: 720,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(width: 1, color: Color(0xFF85A0AA)),
                                      ),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 120,
                                          height: 34,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                'российский\nразмер',
                                                style: TextStyle(
                                                  color: Color(0xFF23262C),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          height: 17,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                '38',
                                                style: TextStyle(
                                                  color: Color(0xFF23262C),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          height: 17,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                '39',
                                                style: TextStyle(
                                                  color: Color(0xFF23262C),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          height: 17,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                '40',
                                                style: TextStyle(
                                                  color: Color(0xFF23262C),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          height: 17,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                '41',
                                                style: TextStyle(
                                                  color: Color(0xFF23262C),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          height: 17,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                '42',
                                                style: TextStyle(
                                                  color: Color(0xFF23262C),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          height: 17,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                '43',
                                                style: TextStyle(
                                                  color: Color(0xFF23262C),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          height: 17,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                '44',
                                                style: TextStyle(
                                                  color: Color(0xFF23262C),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          height: 17,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                '45',
                                                style: TextStyle(
                                                  color: Color(0xFF23262C),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          height: 17,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                '46',
                                                style: TextStyle(
                                                  color: Color(0xFF23262C),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          height: 17,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                '47',
                                                style: TextStyle(
                                                  color: Color(0xFF23262C),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.only(top: 10),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 120,
                                          height: 34,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                'длина стопы, см',
                                                style: TextStyle(
                                                  color: Color(0xFF23262C),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          height: 17,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                '24,5',
                                                style: TextStyle(
                                                  color: Color(0xFF23262C),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          height: 17,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                '25',
                                                style: TextStyle(
                                                  color: Color(0xFF23262C),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          height: 17,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                '25,5',
                                                style: TextStyle(
                                                  color: Color(0xFF23262C),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          height: 17,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                '26,5',
                                                style: TextStyle(
                                                  color: Color(0xFF23262C),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          height: 17,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                '27',
                                                style: TextStyle(
                                                  color: Color(0xFF23262C),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          height: 17,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                '27,5',
                                                style: TextStyle(
                                                  color: Color(0xFF23262C),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          height: 17,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                '28,5',
                                                style: TextStyle(
                                                  color: Color(0xFF23262C),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          height: 17,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                '29',
                                                style: TextStyle(
                                                  color: Color(0xFF23262C),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          height: 17,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                '29,5',
                                                style: TextStyle(
                                                  color: Color(0xFF23262C),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          height: 17,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                '30,5',
                                                style: TextStyle(
                                                  color: Color(0xFF23262C),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                        ),
                      ],
                    )
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const NavigationView()
    );
  }
}