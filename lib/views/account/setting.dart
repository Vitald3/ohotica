import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/adapters.dart';
import '../../models/api_response.dart';
import '../../models/contact.dart';
import '../../services/network/api.dart';
import '../header.dart';
import '../home.dart';
import '../navigations.dart';
import 'package:image_picker/image_picker.dart';
import '../policy.dart';

class SettingView extends StatefulWidget {
  const SettingView({super.key});

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  late final Box setting;
  var maskFormatter = MaskedInputFormatter('+# (###) ###-##-##', allowedCharMatcher: RegExp(r'[0-9]'));
  TextEditingController controller = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  TextEditingController controller3 = TextEditingController();
  FocusNode focus = FocusNode();
  FocusNode focus2 = FocusNode();
  var contact = ContactResponse();
  var submitButton = false;
  final _formKey = GlobalKey<FormState>();
  var contactId = "";
  var avatar = "";
  final ImagePicker picker = ImagePicker();

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
    avatar = setting.get("avatar") ?? "";
    final contactMap = setting.get("contact") ?? <String, dynamic>{};
    Map<String, dynamic> maps = {};

    contactMap.forEach((key, value){
      maps[key] = value;
    });

    final contactMaps = Contact.fromJson(maps);
    contactId = contactMaps.id!;
    controller2.text = contactMaps.phone ?? "";

    Api.getContact(int.parse(contactId)).then((value) {
      if (value.contact != null) {
        controller.text = value.contact!.name ?? "";
        controller2.text = maskFormatter.applyMask("+${value.contact!.phone}").text;
        controller3.text = value.contact!.email ?? "";
      }

      setState(() {});
    });
  }

  Future<void> selectImage() async {
    try {
      final XFile? media = await picker.pickImage(
        imageQuality: 100,
        source: ImageSource.gallery
      );

      if (media != null) {
        setting.put("avatar", media.path);

        setState(() {
          avatar = media.path;
        });
      }
    } catch (e) {
      //
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width - 20;

    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
            backgroundColor: const Color(0xFFEBF3FB),
            appBar: const HeaderView(),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset("assets/left.svg", semanticsLabel: 'back', width: 15, height: 15),
                            const SizedBox(width: 10),
                            SizedBox(
                              width: width - 25,
                              child: const Text(
                                "настройки",
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              width: width,
                              height: 98,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              alignment: Alignment.centerLeft,
                              child: InkWell(
                                  onTap: () {
                                    selectImage();
                                  },
                                  child: avatar == "" ? SvgPicture.asset("assets/user.svg", semanticsLabel: 'back', width: 78, height: 78) : Stack(
                                    alignment: Alignment.topRight,
                                    children: [
                                      CircleAvatar(
                                        radius: 39,
                                        backgroundColor: Colors.brown,
                                        backgroundImage: Image.file(
                                          File(avatar),
                                          errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                                            return const Center(child: Text('Тип изображения не поддерживается'));
                                          },
                                        ).image,
                                      ),
                                      Transform.translate(offset: const Offset(-4, 6), child: SvgPicture.asset("assets/set.svg", semanticsLabel: 'back', width: 15, height: 15))
                                    ],
                                  )
                              )
                          ),
                          const SizedBox(height: 5),
                          Container(
                              width: width,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              alignment: Alignment.centerLeft,
                              child: Form(
                                  key: _formKey,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Stack(
                                        alignment: Alignment.topRight,
                                        children: [
                                          SizedBox(
                                            width: width-20,
                                            child: TextFormField(
                                                controller: controller,
                                                focusNode: focus,
                                                decoration: InputDecoration(
                                                  hintText: "Имя",
                                                  hintStyle: const TextStyle(
                                                    color: Color(0xFF85A0AA),
                                                    fontSize: 14,
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                  contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderSide: const BorderSide(
                                                      width: 1,
                                                      strokeAlign: BorderSide.strokeAlignOutside,
                                                      color: Color(0xFF85A0AA),
                                                    ),
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  focusedErrorBorder: OutlineInputBorder(
                                                    borderSide: const BorderSide(
                                                      width: 1,
                                                      strokeAlign: BorderSide.strokeAlignOutside,
                                                      color: Colors.red,
                                                    ),
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  errorBorder: OutlineInputBorder(
                                                    borderSide: const BorderSide(
                                                      width: 1,
                                                      strokeAlign: BorderSide.strokeAlignOutside,
                                                      color: Colors.red,
                                                    ),
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderSide: const BorderSide(
                                                      width: 1,
                                                      strokeAlign: BorderSide.strokeAlignOutside,
                                                      color: Color(0xFF85A0AA),
                                                    ),
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                ),
                                                keyboardType: TextInputType.text
                                            ),
                                          ),
                                          Visibility(
                                              visible: controller.value.text != "",
                                              child: InkWell(
                                                  onTap: () {
                                                    focus.requestFocus();
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(right: 15, top: 14),
                                                    child: SvgPicture.asset("assets/edit.svg", semanticsLabel: 'back', width: 20, height: 20),
                                                  )
                                              )
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      SizedBox(
                                        width: width-20,
                                        child: TextFormField(
                                            controller: controller2,
                                            readOnly: true,
                                            decoration: InputDecoration(
                                              hintText: "+7 (000) 000-00-00",
                                              fillColor: Colors.white,
                                              filled: true,
                                              hintStyle: const TextStyle(
                                                color: Color(0xFF85A0AA),
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
                                            keyboardType: TextInputType.number
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Stack(
                                        alignment: Alignment.topRight,
                                        children: [
                                          SizedBox(
                                            width: width-20,
                                            child: TextFormField(
                                                focusNode: focus2,
                                                controller: controller3,
                                                decoration: InputDecoration(
                                                  hintText: "Email",
                                                  hintStyle: const TextStyle(
                                                    color: Color(0xFF85A0AA),
                                                    fontSize: 14,
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                  contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderSide: const BorderSide(
                                                      width: 1,
                                                      strokeAlign: BorderSide.strokeAlignOutside,
                                                      color: Color(0xFF85A0AA),
                                                    ),
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  focusedErrorBorder: OutlineInputBorder(
                                                    borderSide: const BorderSide(
                                                      width: 1,
                                                      strokeAlign: BorderSide.strokeAlignOutside,
                                                      color: Colors.red,
                                                    ),
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  errorBorder: OutlineInputBorder(
                                                    borderSide: const BorderSide(
                                                      width: 1,
                                                      strokeAlign: BorderSide.strokeAlignOutside,
                                                      color: Colors.red,
                                                    ),
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderSide: const BorderSide(
                                                      width: 1,
                                                      strokeAlign: BorderSide.strokeAlignOutside,
                                                      color: Color(0xFF85A0AA),
                                                    ),
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                ),
                                                keyboardType: TextInputType.emailAddress
                                            ),
                                          ),
                                          Visibility(
                                              visible: controller3.value.text != "",
                                              child: InkWell(
                                                  onTap: () {
                                                    focus2.requestFocus();
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(right: 15, top: 14),
                                                    child: SvgPicture.asset("assets/edit.svg", semanticsLabel: 'back', width: 20, height: 20),
                                                  )
                                              )
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      ElevatedButton(
                                        onPressed: () async {
                                          FocusScope.of(context).unfocus();

                                          if (_formKey.currentState!.validate()) {
                                            if (!submitButton) {
                                              setState(() {
                                                submitButton = true;
                                              });

                                              Api.saveSetting(avatar, {
                                                "name": controller.value.text,
                                                "email": controller3.value.text,
                                                "contactId": contactId
                                              }).then((response) {
                                                setState(() {
                                                  submitButton = false;
                                                });

                                                if (response.success ?? false) {
                                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                    content: Text("Данные успешно сохранены"),
                                                  ));
                                                } else {
                                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                    content: Text(response.error ?? "Произошла ошибка"),
                                                  ));
                                                }
                                              });
                                            }
                                          } else {
                                            focus.requestFocus();
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
                                          'сохранить',
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
                                                      text: 'нажимая на кнопку «получить код», вы соглашаетесь с',
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
                                                          fontWeight: FontWeight.w400
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                              )
                          ),
                          const SizedBox(height: 5),
                          GestureDetector(
                              onTap: () {
                                setting.put("contact", {});

                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(builder: (_) => const HomeView()),
                                );
                              },
                              child: Container(
                                width: width,
                                height: 49,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                alignment: Alignment.centerLeft,
                                child: const Text(
                                  'выйти из аккаунта',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Color(0xFF12B438),
                                      fontSize: 14,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400
                                  ),
                                ),
                              )
                          ),
                          const SizedBox(height: 5),
                          GestureDetector(
                              onTap: () {
                                Api.removeProfile(int.parse(contactId)).then((response) {
                                  if (response.success ?? false) {
                                    setting.put("contact", {});
                                    setting.put("avatar", "");

                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                      content: Text("Ваш аккаунт успешно удален, вы сможете войти по новой через окно входа и регистрации"),
                                    ));

                                    Timer(const Duration(seconds: 2), () {
                                      Navigator.push(
                                        context,
                                        CupertinoPageRoute(builder: (_) => const HomeView()),
                                      );
                                    });
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: Text(response.error ?? "Произошла ошибка"),
                                    ));
                                  }
                                });
                              },
                              child: Container(
                                width: width,
                                height: 49,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                alignment: Alignment.centerLeft,
                                child: const Text(
                                  'удалить аккаунт',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Color(0xFF12B438),
                                      fontSize: 14,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400
                                  ),
                                ),
                              )
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: const NavigationView()
        )
    );
  }
}