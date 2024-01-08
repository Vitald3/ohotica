import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:ohotika/models/checkout.dart';
import 'package:ohotika/views/policy.dart';
import '../../services/network/api.dart';
import 'code.dart';
import '../header.dart';
import '../navigations.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final Box setting;
  TextEditingController controller = TextEditingController();
  var maskFormatter = MaskedInputFormatter('+# (###) ###-##-##', allowedCharMatcher: RegExp(r'[0-9]'));
  String? get _errorText {
    if (controller.value.text != "" && !maskFormatter.isFilled) {
      return 'Номер телефона заполнен неккоректно';
    }

    return null;
  }
  var submitButton = false;
  final focus = FocusNode();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setData();
    });

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  setData() async {
    await Hive.initFlutter();
    setting = await Hive.openBox('setting');
  }

  send(BuildContext context) {
    if (controller.text.isEmpty || controller.text == "+7") {
      controller.text = "+7 (9";
    }

    FocusScope.of(context).unfocus();

    if (maskFormatter.isFilled) {
      AppMetrica.reportEvent('Клиент ${maskFormatter.applyMask("+${controller.text}").text.trim()} выполнил вход в личный кабинет');

      if (!submitButton) {
        setState(() {
          submitButton = true;
        });

        Api.getCode(Checkout(phone: "+${maskFormatter.unmaskedValue}")).then((response) {
          setState(() {
            submitButton = false;
          });

          if ((response.success ?? false) && response.code != "") {
            Navigator.push(
              context,
              CupertinoPageRoute(builder: (_) => CodeView(phone: "+${maskFormatter.unmaskedValue}", code: response.code!)),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text(response.error ?? "Произошла ошибка"),
            ));
          }
        });
      }
    } else {
      focus.requestFocus();
    }
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
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    'регистрация / вход',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color(0xFF23262C),
                        fontSize: 14,
                        fontFamily: 'DaysSansBlack',
                        fontWeight: FontWeight.w400
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Номер вашего телефона',
                  style: TextStyle(
                      color: Color(0xFF23262C),
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600
                  ),
                ),
                const SizedBox(height: 5),
                SizedBox(
                  width: width,
                  child: TextField(
                      controller: controller,
                      focusNode: focus,
                      inputFormatters: [maskFormatter],
                      autocorrect: false,
                      decoration: InputDecoration(
                        hintText: "+7 (000) 000-00-00",
                        fillColor: Colors.white,
                        filled: true,
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
                          setState(() {});
                        }
                      },
                      onSubmitted: (val) {
                        if (maskFormatter.isFilled) {
                          send(context);
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
                const SizedBox(height: 5),
                const Text(
                  'Будет совершен звонок. Введите последние 4 цифры номера входящего звонка',
                  style: TextStyle(
                      color: Color(0xFF728A9D),
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () async {
                    send(context);
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
                    'запросить звонок',
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
                                text: 'нажимая на кнопку «запросить звонок», вы соглашаетесь с',
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
                const SizedBox(height: 10)
              ],
            ),
          ),
        ),
        bottomNavigationBar: const NavigationView(current: 3)
    );
  }
}