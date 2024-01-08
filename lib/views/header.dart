import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

class HeaderView extends StatelessWidget implements PreferredSizeWidget {
  const HeaderView({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(32);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: const Color(0xFF12B438),
        automaticallyImplyLeading: false,
        toolbarHeight: 32,
        titleSpacing: 0,
        elevation: 0,
        title: GestureDetector(
          onTap: () async {
            AppMetrica.reportEvent('Набор номера из шапки');
            Uri url = Uri(scheme: "tel", path: "88001010375");

            if (await canLaunchUrl(url)) {
              await launchUrl(url);
            } else {
              throw 'Could not launch $url';
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset("assets/phone.svg", semanticsLabel: 'phone', width: 15, height: 15),
              const SizedBox(width: 10),
              const Text(
                '8 800 101 03 75',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400
                ),
              )
            ],
          ),
        )
    );
  }
}