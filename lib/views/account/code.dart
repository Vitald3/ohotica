import 'dart:async';
import 'dart:io';
import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:ohotika/models/checkout.dart';
import 'package:provider/provider.dart';
import '../../other/values_notifier.dart';
import '../../services/network/api.dart';
import 'account.dart';
import '../header.dart';
import 'login.dart';
import '../navigations.dart';

class CodeView extends StatefulWidget {
  const CodeView({super.key, required this.phone, required this.code});

  final String phone;
  final String code;

  @override
  State<CodeView> createState() => _CodeViewState();
}

class _CodeViewState extends State<CodeView> {
  late final Box setting;
  TextEditingController controller = TextEditingController();
  var maskFormatter = MaskedInputFormatter('####', allowedCharMatcher: RegExp(r'[0-9]'));
  String? get _errorText {
    if (controller.value.text != "" && !maskFormatter.isFilled) {
      return 'Код заполнен неверно';
    }

    return null;
  }
  var submitButton = false;
  final focus = FocusNode();
  late Timer _timer;

  startTimer() {
    Provider.of<ValuesNotifier>(context, listen: false).setTimeCount("5:00");
    int start = 300;

    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
        if (start == 0) {
          timer.cancel();

          Navigator.push(
            context,
            CupertinoPageRoute(builder: (_) => const LoginView()),
          );
        } else {
          start--;
        }

        Provider.of<ValuesNotifier>(context, listen: false).setTimeCount(formattedTime(start));
      },
    );
  }

  formattedTime(int timeInSecond) {
    int sec = timeInSecond % 60;
    int min = (timeInSecond / 60).floor();
    String minute = min.toString().length <= 1 ? "0$min" : "$min";
    String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
    return "$minute:$second";
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
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width - 20;
    final time = Provider.of<ValuesNotifier>(context, listen: true).timeCount;

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
                    'подтверждение входа',
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
                  'Код подтверждения',
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
                      decoration: InputDecoration(
                        hintText: "0000",
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
                        if (maskFormatter.isFilled) {
                          setState(() {});
                        }
                      },
                      keyboardType: TextInputType.number
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Введите последние 4 цифры номера входящего звонка ${widget.phone}',
                  style: const TextStyle(
                      color: Color(0xFF728A9D),
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400
                  ),
                ),
                const SizedBox(height: 15),
                const Center(
                  child: Text(
                    'код действителен в течение',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color(0xFF23262C),
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Center(
                  child: Text(
                    time,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Color(0xFF23262C),
                        fontSize: 14,
                        fontFamily: 'DaysSansBlack',
                        fontWeight: FontWeight.w400
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () async {
                    FocusScope.of(context).unfocus();

                    if (maskFormatter.isFilled) {
                      if (controller.value.text != widget.code) {
                        showCupertinoModalPopup(context: context, builder: (BuildContext context) {
                          return Scaffold(
                            backgroundColor: Colors.transparent,
                            body: SafeArea(
                                top: true,
                                child: Center(
                                    child: Container(
                                      width: width-20,
                                      height: 160,
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
                                              'предупреждение',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Color(0xFF23262C),
                                                  fontSize: 14,
                                                  fontFamily: 'DaysSansBlack',
                                                  fontWeight: FontWeight.w400
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 15),
                                          const SizedBox(
                                            width: double.infinity,
                                            child: Text(
                                              'Код подтверждения введен неверно',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Color(0xFF728A9D),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w400
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 15),
                                          ElevatedButton(
                                            onPressed: () async {
                                              Navigator.of(context).pop();
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

                        return;
                      }

                      if (!submitButton) {
                        setState(() {
                          submitButton = true;
                        });

                        Api.checkCode(Checkout(phone: widget.phone, code: controller.value.text, platform: Platform.isAndroid ? 1 : 0)).then((response) {
                          setState(() {
                            submitButton = false;
                          });

                          if ((response.success ?? false) && response.contact != null) {
                            setting.put("contact", response.contact?.toJson());
                            _timer.cancel();
                            AppMetrica.reportEvent('Клиент ${maskFormatter.applyMask("+${controller.text}").text.trim()} подтвердил вход в личный кабинет');

                            Navigator.push(
                              context,
                              CupertinoPageRoute(builder: (_) => const AccountView()),
                            );
                          } else {
                            var error = response.error ?? "Произошла ошибка";

                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              behavior: SnackBarBehavior.floating,
                              content: Text(error == "" ? "Произошла ошибка" : error),
                            ));
                          }
                        });
                      } else {
                        focus.requestFocus();
                      }
                    }
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
                    'подтвердить',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Center(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(builder: (_) => const LoginView()),
                        );
                      },
                      child: const Text(
                        'изменить номер телефона',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF12B438),
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          height: 0,
                        ),
                      ),
                    )
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: const NavigationView(current: 3)
    );
  }
}