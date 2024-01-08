import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:ohotika/views/product.dart';
import '../models/categories.dart';
import '../models/search.dart';
import '../services/network/api.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'category.dart';
import 'header.dart';
import 'navigations.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  var categories = <Categories>[];
  late final Box setting;
  TextEditingController controller = TextEditingController();
  var searchProducts = <SearchProducts>[];

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

  search(String query) async {
    if (query != "") {
      searchProducts = await Api.search(query);
    } else {
      searchProducts = [];
    }

    setState(() {});
  }

  setData() async {
    await Hive.initFlutter();
    setting = await Hive.openBox('setting');
    categories = await Api.getCategoriesByParentId(0);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width - 20;
    final double height = MediaQuery.of(context).size.height;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFFEBF3FB),
        appBar: const HeaderView(),
        body: SafeArea(
          child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                        children: [
                          Visibility(
                            visible: searchProducts.isNotEmpty && controller.text != "",
                            child: Container(
                                constraints: BoxConstraints(maxHeight: 300, minWidth: width),
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: ShapeDecoration(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(width: 1, color: Color(0xFF85A0AA)),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Padding(
                                    padding: const EdgeInsets.only(top: 40),
                                    child: ListView.builder(
                                      itemCount: searchProducts.length,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                            onTap: () {
                                              FocusScope.of(context).unfocus();

                                              Api.getCategory(searchProducts[index].parentId!).then((response) {
                                                Navigator.push(
                                                  context,
                                                  CupertinoPageRoute(builder: (_) => ItemView(id: searchProducts[index].productId!, category: response)),
                                                );
                                              });
                                            },
                                            contentPadding: const EdgeInsets.only(right: 25, left: 7),
                                            title: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                CachedNetworkImage(
                                                    width: 50,
                                                    height: 50,
                                                    imageUrl: searchProducts[index].thumb!,
                                                    errorWidget: (context, url, error) => Image.asset("assets/no-image.png")
                                                ),
                                                const SizedBox(width: 10),
                                                Expanded(child: Text(searchProducts[index].name!))
                                              ],
                                            )
                                        );
                                      },
                                    )
                                )
                            ),
                          ),
                          Container(
                              width: width,
                              height: 48,
                              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(width: 1, color: Color(0xFF85A0AA)),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset("assets/search.svg", semanticsLabel: 'Search', width: 18, height: 18),
                                      const SizedBox(width: 10),
                                      SizedBox(
                                        width: width-100,
                                        height: 20,
                                        child: TextField(
                                            controller: controller,
                                            decoration: InputDecoration(
                                              hintText: "Найти в Охотике",
                                              hintStyle: const TextStyle(
                                                color: Color(0xFF728A9D),
                                                fontSize: 14,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400,
                                              ),
                                              contentPadding: EdgeInsets.zero,
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                  width: 0.1,
                                                  color: Colors.transparent,
                                                ),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              focusedErrorBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                  width: 0.1,
                                                  color: Colors.transparent,
                                                ),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                  width: 0.1,
                                                  color: Colors.transparent,
                                                ),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                  width: 0.1,
                                                  color: Colors.transparent,
                                                ),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                            ),
                                            keyboardType: TextInputType.text,
                                            onSubmitted: (text) {
                                              AppMetrica.reportEvent('Поиск по тексту - $text');
                                              search(text);
                                            },
                                            onChanged: (text) async {
                                              search(text);
                                            }
                                        ),
                                      ),
                                    ],
                                  ),
                                  Visibility(
                                      visible: controller.text != "",
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            searchProducts = [];
                                            controller.text = "";
                                          });
                                        },
                                        child: SvgPicture.asset("assets/close.svg", semanticsLabel: 'Close', width: 18, height: 18),
                                      )
                                  ),
                                ],
                              )
                          ),
                        ]
                    ),
                    const SizedBox(height: 15),
                    if (categories.isNotEmpty) Wrap(
                      spacing: 5,
                      runSpacing: 5,
                      children: List<Widget>.generate(categories.length, (index) {
                        final Categories item = categories[index];

                        return GestureDetector(
                          onTap: () {
                            AppMetrica.reportEvent('Открытие категории ${item.title!}');
                            Navigator.push(
                              context,
                              CupertinoPageRoute(builder: (_) => CategoryView(category: item)),
                            );
                          },
                          child: Stack(
                            children: [
                              Container(
                                width: (width/2) - 5,
                                height: categories.length == 4 ? (height/2) - 100 : 240,
                                decoration: ShapeDecoration(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                clipBehavior: Clip.hardEdge,
                                child: CachedNetworkImage(
                                    imageUrl: item.imageUrl!,
                                    errorWidget: (context, url, error) => Image.asset("assets/no-image.png"),
                                    fit: BoxFit.cover
                                ),
                              ),
                              Container(
                                width: (width/2) - 5,
                                height: categories.length == 4 ? (height/2) - 100 : 240,
                                padding: const EdgeInsets.only(bottom: 6, right: 6),
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      width: 124,
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                                      decoration: ShapeDecoration(
                                        color: Colors.white.withOpacity(0.800000011920929),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                          textAlign: TextAlign.right,
                                          item.title!,
                                          style: const TextStyle(
                                              color: Color(0xFF23262C),
                                              fontSize: 14,
                                              fontFamily: 'DaysSansBlack',
                                              fontWeight: FontWeight.w400
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 3
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      }),
                    )
                  ],
                ),
              )
          ),
        ),
        bottomNavigationBar: const NavigationView(current: 0)
      ),
    );
  }
}