import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'home.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}
class _SplashViewState extends State<SplashView> {
  var progress = 0.0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setData();
    });

    super.initState();
  }

  setData() {
    setState(() {
      progress = 0.0;
    });

    Timer.periodic(const Duration(milliseconds: 10), (timer) {
      setState(() {
        progress += 10;

        if (progress > 285) {
          progress = 285;
          timer.cancel();
        }
      });
    });

    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(builder: (_) => const HomeView()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.white,
                child: Center(
                  child: SvgPicture.asset("assets/splash.svg", semanticsLabel: 'splash', width: 285, height: 80),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'загрузка',
                      style: TextStyle(
                          color: Color(0xFF23262C),
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 285,
                      height: 4,
                      clipBehavior: Clip.antiAlias,
                      decoration: ShapeDecoration(
                        color: const Color(0xFFEBF2FA),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: progress,
                            height: 4,
                            decoration: ShapeDecoration(
                              color: const Color(0xFF12B438),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 135)
                  ],
                ),
              ),
            ]
        )
    );
  }
}