import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:ohotika/other/values_notifier.dart';
import 'package:ohotika/views/wishlist.dart';
import 'package:provider/provider.dart';
import '../models/api_response.dart';
import 'account/account.dart';
import 'cart.dart';
import 'home.dart';
import 'account/login.dart';

class NavigationView extends StatelessWidget {
  const NavigationView({super.key, this.current});

  final int? current;
  
  @override
  Widget build(BuildContext context) {
    final String cartCount = Provider.of<ValuesNotifier>(context, listen: true).cartCount;
    var wishlistCount = Provider.of<ValuesNotifier>(context, listen: false).wishlistCount;
    Box? setting;
    
    return SizedBox(
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          iconSize: 20,
          selectedFontSize: 0,
          type: BottomNavigationBarType.fixed,
          currentIndex: current ?? 1,
          showUnselectedLabels: false,
          showSelectedLabels: false,
          onTap: (index) async {
            switch (index) {
              case 0:
                if (current != 0) {
                  AppMetrica.reportEvent('Переключение на главный экран');
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (_) => const HomeView()),
                  );
                }

                break;
              case 1:
                if (current != 1) {
                  AppMetrica.reportEvent('Переключение на закладки');
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (_) => const WishlistView()),
                  );
                }

                break;
              case 2:
                if (current != 2) {
                  AppMetrica.reportEvent('Переключение на корзину');
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (_) => const CartView()),
                  );
                }

                break;
              case 3:
                if (current != 3) {
                  AppMetrica.reportEvent('Переключение на профиль');
                  if (setting == null) {
                    await Hive.initFlutter();
                    setting = await Hive.openBox('setting');
                  }

                  final contactMap = setting!.get("contact") ?? <String, dynamic>{};
                  Map<String, dynamic> maps = {};

                  if (contactMap != null) {
                    contactMap.forEach((key, value) {
                      maps[key] = value;
                    });
                  }

                  final contact = Contact.fromJson(maps);

                  if (context.mounted) {
                    if (contact.id != null) {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(builder: (_) => const AccountView()),
                      );
                    } else {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(builder: (_) => const LoginView()),
                      );
                    }
                  }
                }

                break;
            }
          },
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              label: '',
              icon: SvgPicture.asset("assets/home.svg", semanticsLabel: 'home', width: 20, height: 20, colorFilter: ColorFilter.mode(Color(current == 0 ? 0xFF12B438 : 0xFF23262C), BlendMode.srcIn)),
            ),
            BottomNavigationBarItem(
              label: '',
              icon: Badge(
                isLabelVisible: wishlistCount != "",
                offset: const Offset(8, -6),
                backgroundColor: const Color(0xFF12B438),
                textColor: Colors.white,
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400
                ),
                label: Text(wishlistCount),
                child: SvgPicture.asset("assets/wishlist.svg", semanticsLabel: 'cart', width: 20, height: 20, colorFilter: ColorFilter.mode(Color(current == 1 ? 0xFF12B438 : 0xFF23262C), BlendMode.srcIn)),
              ),
            ),
            BottomNavigationBarItem(
              label: '',
              icon: Badge(
                isLabelVisible: cartCount != "",
                offset: const Offset(8, -6),
                backgroundColor: const Color(0xFF12B438),
                textColor: Colors.white,
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
                label: Text(cartCount),
                child: SvgPicture.asset("assets/cart.svg", semanticsLabel: 'cart', width: 20, height: 20, colorFilter: ColorFilter.mode(Color(current == 2 ? 0xFF12B438 : 0xFF23262C), BlendMode.srcIn)),
              ),
            ),
            BottomNavigationBarItem(
              label: '',
              icon: SvgPicture.asset("assets/profile.svg", semanticsLabel: 'profile', width: 20, height: 20, colorFilter: ColorFilter.mode(Color(current == 3 ? 0xFF12B438 : 0xFF23262C), BlendMode.srcIn)),
            ),
          ],
        )
    );
  }
}