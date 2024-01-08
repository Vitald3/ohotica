import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'other/values_notifier.dart';
import 'views/home.dart';
import 'views/splash.dart';
import 'other/extensions.dart';
import 'package:appmetrica_plugin/appmetrica_plugin.dart';

AppMetricaConfig get _config => const AppMetricaConfig('acb486f5-214a-42cf-add5-de1dc6027f0e', logs: true);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize("95555cf7-cd3d-4e4b-97cb-dd74dbbe0a44");
  OneSignal.Notifications.requestPermission(true);
  AppMetrica.activate(_config);
  AppMetrica.reportEvent('Открытие приложения');
  AppMetrica.setStatisticsSending(true);
  runApp(ChangeNotifierProvider<ValuesNotifier>(
    create: (context) => ValuesNotifier(),
    child: const App(),
  ));
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (_) => const HomeView(),
        'splash': (_) => const SplashView()
      },
      initialRoute: 'splash',
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/':
            return CupertinoPageRoute(builder: (_) => const HomeView(), settings: settings);
          case 'splash':
            return CupertinoPageRoute(builder: (_) => const SplashView(), settings: settings);
          default:
            return CupertinoPageRoute(builder: (_) => const HomeView(), settings: settings);
        }
      },
      onUnknownRoute: (settings) => CupertinoPageRoute(
          builder: (context) {
            return const HomeView();
          }
      ),
      debugShowCheckedModeBanner: false,
      title: 'Ohotika',
      theme: ThemeData(
        primarySwatch: const Color(0xFF23262C).asMaterialColor,
        textTheme: const TextTheme(
          displayLarge: TextStyle(color: Color(0xFF23262C)),
          displayMedium: TextStyle(color: Color(0xFF23262C)),
          bodyMedium: TextStyle(color: Color(0xFF23262C)),
          titleMedium: TextStyle(color: Color(0xFF23262C)),
        ),
      ),
      builder: (context, widget) {
        Widget error = Column(
          children: [
            const Center(child: Text('Ведутся технические работы, подождите немного.')),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                Navigator.pushReplacement(
                  context,
                  CupertinoPageRoute(builder: (_) => const HomeView()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF12B438),
                minimumSize: const Size(260, 38),
                elevation: 0,
                alignment: Alignment.center,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: const BorderSide(width: 1, color: Color(0xFF12B438))
                ),
              ),
              child: const Text(
                'На главную',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400
                ),
              ),
            ),
            const SizedBox(height: 20)
          ],
        );
        if (widget is Scaffold || widget is Navigator) {
          error = Scaffold(body: Container(alignment: Alignment.center, padding: const EdgeInsets.all(15), child: error));
        }
        ErrorWidget.builder = (errorDetails) => error;
        if (widget != null) return widget;
        throw StateError('widget is null');
      },
    );
  }
}
