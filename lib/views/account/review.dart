import 'dart:async';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/api_response.dart';
import '../../services/network/api.dart';
import '../header.dart';
import '../navigations.dart';
import 'dart:io';

import 'account.dart';

class ReviewView extends StatefulWidget {
  const ReviewView({super.key});

  @override
  State<ReviewView> createState() => _ReviewViewState();
}

class _ReviewViewState extends State<ReviewView> {
  late final Box setting;
  final _formKey = GlobalKey<FormState>();
  TextEditingController controller = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  FocusNode focus = FocusNode();
  FocusNode focus2 = FocusNode();
  final ImagePicker picker = ImagePicker();
  var photo = "";
  var submitButton = false;

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
    final contactMap = setting.get("contact") ?? <String, dynamic>{};
    Map<String, dynamic> maps = {};

    contactMap.forEach((key, value){
      maps[key] = value;
    });

    final contactMaps = Contact.fromJson(maps);

    Api.getContact(int.parse(contactMaps.id!)).then((value) {
      if (value.contact != null) {
        controller.text = value.contact!.email!;
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
        setState(() {
          photo = media.path;
        });
      }
    } catch (e) {
      //
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
                            "написать отзыв",
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
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Form(
                            key: _formKey,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            child: Column(
                                children: [
                                  SizedBox(
                                    width: width-20,
                                    child: TextFormField(
                                        validator: (value) => EmailValidator.validate(value!) ? null : "Email адрес заполнен неккоректно",
                                        focusNode: focus,
                                        controller: controller,
                                        decoration: InputDecoration(
                                          hintText: "Email",
                                          filled: true,
                                          fillColor: Colors.white,
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
                                  const SizedBox(height: 10),
                                  SizedBox(
                                    width: width-20,
                                    child: TextFormField(
                                        validator: (value) => value != "" ? null : "Напишите ваш отзыв",
                                        focusNode: focus2,
                                        controller: controller2,
                                        decoration: InputDecoration(
                                          hintText: "Сообщение",
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
                                        maxLines: 5,
                                        keyboardType: TextInputType.multiline,
                                        textInputAction: TextInputAction.done
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                ]
                            )
                        ),
                        const SizedBox(height: 5),
                        GestureDetector(
                          onTap: () {
                            selectImage();
                          },
                          child: Row(
                            children: [
                              photo == "" ? SvgPicture.asset("assets/attach.svg", semanticsLabel: 'attach', width: 35, height: 30) : CircleAvatar(
                                radius: 39,
                                backgroundColor: Colors.brown,
                                backgroundImage: Image.file(
                                  File(photo),
                                  errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                                    return const Center(child: Text('Тип изображения не поддерживается'));
                                  },
                                ).image,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                '${photo == "" ? "прикрепить" : "изменить"} фото',
                                style: const TextStyle(
                                    color: Color(0xFF12B438),
                                    fontSize: 14,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400
                                ),
                              ),
                            ],
                          ),
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

                                Api.setReview(photo, {
                                  "email": controller.value.text,
                                  "comment": controller2.value.text,
                                }).then((response) {
                                  var text = "";

                                  if (response.success ?? false) {
                                    text = "Ваш отзыв будет опубликован после модерации";

                                    Timer(const Duration(seconds: 3), () {
                                      Navigator.pushReplacement(
                                        context,
                                        CupertinoPageRoute(builder: (_) => const AccountView()),
                                      );
                                    });
                                  } else {
                                    text = response.error ?? "";

                                    if (text == "") {
                                      text = "Произошла ошибка";
                                    }

                                    setState(() {
                                      submitButton = false;
                                    });
                                  }

                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(text),
                                  ));
                                });
                              }
                            } else {
                              setState(() {
                                submitButton = false;
                              });

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
                            'отправить',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400
                            ),
                          ),
                        ),
                      ],
                    )
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const NavigationView()
    );
  }
}