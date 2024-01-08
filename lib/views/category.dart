import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:ohotika/models/search.dart';
import 'package:ohotika/views/product.dart';
import 'package:ohotika/views/products.dart';
import '../models/brends.dart';
import '../models/categories.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/products.dart';
import '../services/network/api.dart';
import 'header.dart';
import 'navigations.dart';

class CategoryView extends StatefulWidget {
  const CategoryView({super.key, required this.category, this.child});

  final Categories category;
  final Categories? child;

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  late final Box setting;
  var categories = <Categories>[];
  var searchProducts = <SearchProducts>[];
  Products? categoryProducts;
  Brands? brands;
  TextEditingController controller = TextEditingController();
  var categoriesNotImages = false;
  var sort = "sort";
  var submitFilter = false;
  var resetFilter = false;
  var isLoaded = false;
  var filterSelected = <String, List<String>>{};
  double priceFrom = 0;
  double priceTo = 0;
  double priceFromFix = 0;
  double priceToFix = 0;
  TextEditingController controllerPriceFrom = TextEditingController();
  TextEditingController controllerPriceTo = TextEditingController();
  var keys = <GlobalKey>[];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setData();
    });

    super.initState();
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
    categories = await Api.getCategoriesByParentId(int.parse(widget.category.id!));
    keys = <GlobalKey>[];

    if (categories.isNotEmpty) {
      var count = 0;

      for (var i in categories) {
        keys.add(GlobalKey());

        if ((i.imageUrl ?? "") == "") {
          count++;
        }
      }

      if (count == categories.length) {
        categoriesNotImages = true;
      }
    } else if (widget.child != null) {
      categories = await Api.getCategoriesByParentId(int.parse(widget.category.parentId!));
      categoriesNotImages = true;

      for (var _ in categories) {
        keys.add(GlobalKey());
      }
    }

    if (categoriesNotImages || categories.isEmpty) {
      categoryProducts = await Api.getProducts(int.parse(widget.category.id!), 0, 0, sort, filterSelected);

      if (categoryProducts != null && categoryProducts?.filters != null && categoryProducts!.filters!.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_){
          final filter = categoryProducts!.filters!.firstWhere((element) => element.alias == "cena");

          if (filter.min != null) {
            priceFrom = double.parse(filter.min!);
            priceFromFix = double.parse(filter.min!);
            controllerPriceFrom.text = priceFrom.toStringAsFixed(0);
          }

          if (filter.max != null) {
            priceTo = double.parse(filter.max!);
            priceToFix = double.parse(filter.max!);
            controllerPriceTo.text = priceTo.toStringAsFixed(0);
          }

          setState(() {});
        });
      }

      brands = await Api.getBrands(widget.category.id!);
    }

    isLoaded = true;

    setState(() {});
  }

  void toggleSort() async {
    setState(() {
      submitFilter = true;

      if (sort == "sort" || sort == "ubyv") {
        sort = "vozr";
      } else {
        sort = "ubyv";
      }
    });

    AppMetrica.reportEvent('Отсортировали цену по ${sort == "vozr" ? "возрастанию" : "убыванию"}');

    categoryProducts = await Api.getProducts(int.parse(widget.category.id!), 0, 0, sort, filterSelected);
    submitFilter = false;
    setState(() {});
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
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
                        if (widget.child != null) {
                          Navigator.pushReplacement(
                            context,
                            CupertinoPageRoute(builder: (_) => CategoryView(category: widget.child!)),
                          );
                        } else {
                          Navigator.of(context).pop();
                        }
                      },
                      child: Container(
                        width: width,
                        padding: const EdgeInsets.only(left: 10, right: 10, top: 15),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SvgPicture.asset("assets/left.svg", semanticsLabel: 'back', width: 15, height: 15),
                            SizedBox(
                              width: width - 45,
                              child: Text(
                                widget.category.title!,
                                style: const TextStyle(
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
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
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
                          const SizedBox(height: 5),
                        ],
                      ),
                    ),
                    if (categoryProducts != null && categoryProducts?.filters != null && categoryProducts!.filters!.isNotEmpty) Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                    onPressed: () {
                                      AppMetrica.reportEvent('Открытие фильтров в категории ${widget.category.title}');
                                      showModalBottomSheet<dynamic>(
                                          isScrollControlled: true,
                                          context: context,
                                          useSafeArea: true,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15)),
                                          ),
                                          builder: (BuildContext context) {
                                            return StatefulBuilder(builder: (BuildContext context, StateSetter state) {
                                              final brandScrollController = ScrollController();
                                              final double height = MediaQuery.of(context).size.height;

                                              return Stack(
                                                children: [
                                                  Container(
                                                      alignment: Alignment.topCenter,
                                                      constraints: BoxConstraints(maxHeight: height - MediaQuery.of(context).padding.top-6),
                                                      color: Colors.transparent,
                                                      margin: const EdgeInsets.only(top: 55),
                                                      child: SingleChildScrollView(
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: [
                                                            Visibility(
                                                                visible: categoryProducts?.filters != null && categoryProducts!.filters!.isNotEmpty,
                                                                child: Wrap(
                                                                  spacing: 15,
                                                                  children: List<Widget>.generate(categoryProducts!.filters!.length, (index) {
                                                                    final item = categoryProducts!.filters![index];
                                                                    var values = <FilterValue>[];
                                                                    final scrollController = ScrollController();

                                                                    item.values?.values?.forEach((key, value) {
                                                                      values.add(FilterValue.fromJson(value));
                                                                    });

                                                                    return Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Padding(
                                                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                                                          child: Row(
                                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Text(
                                                                                item.name!,
                                                                                textAlign: TextAlign.center,
                                                                                style: const TextStyle(
                                                                                    color: Color(0xFF23262C),
                                                                                    fontSize: 14,
                                                                                    fontFamily: 'DaysSansBlack',
                                                                                    fontWeight: FontWeight.w400
                                                                                ),
                                                                              ),
                                                                              Visibility(
                                                                                  visible: item.alias == "cena" && priceFrom != priceTo ? (priceFrom > priceFromFix || priceTo < priceToFix) : values.where((element) => filterSelected[item.alias] != null && filterSelected[item.alias]!.contains(element.alias)).isNotEmpty,
                                                                                  child: GestureDetector(
                                                                                    onTap: () {
                                                                                      if (item.alias == "cena") {
                                                                                        priceFrom = priceFromFix;
                                                                                        priceTo = priceToFix;
                                                                                        filterSelected.remove("cena");
                                                                                      } else {
                                                                                        filterSelected.remove(item.alias);
                                                                                      }

                                                                                      state(() {});
                                                                                    },
                                                                                    child: const Text(
                                                                                      'очистить',
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
                                                                        const SizedBox(height: 15),
                                                                        item.alias == "cena" && priceFrom != priceTo ? Column(
                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            SliderTheme(
                                                                              data: SliderTheme.of(context).copyWith(
                                                                                  activeTrackColor: const Color(0xFF728A9D),
                                                                                  inactiveTrackColor: const Color(0xFFEBF2FA),
                                                                                  trackHeight: 3,
                                                                                  thumbColor: Colors.white
                                                                              ),
                                                                              child: RangeSlider(
                                                                                min: priceFromFix,
                                                                                max: priceToFix,
                                                                                labels: RangeLabels(
                                                                                  priceFrom.round().toString(),
                                                                                  priceTo.round().toString(),
                                                                                ),
                                                                                values: RangeValues(priceFrom, priceTo),
                                                                                onChanged: (values) {
                                                                                  AppMetrica.reportEvent('Отфильтровали по цене ${values.start.toStringAsFixed(0)} р. - ${values.end.toStringAsFixed(0)} р.');
                                                                                  state(() {
                                                                                    priceFrom = values.start;
                                                                                    controllerPriceFrom.text = priceFrom.toStringAsFixed(0);
                                                                                    priceTo = values.end;
                                                                                    controllerPriceTo.text = priceTo.toStringAsFixed(0);
                                                                                  });
                                                                                },
                                                                              ),
                                                                            ),
                                                                            const SizedBox(height: 15),
                                                                            Container(
                                                                              width: width-24,
                                                                              height: 47,
                                                                              padding: const EdgeInsets.symmetric(horizontal: 20),
                                                                              child: Row(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                children: [
                                                                                  Column(
                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      const Text(
                                                                                        'мин.цена',
                                                                                        style: TextStyle(
                                                                                            color: Color(0xFF728A9D),
                                                                                            fontSize: 14,
                                                                                            fontFamily: 'Inter',
                                                                                            fontWeight: FontWeight.w400
                                                                                        ),
                                                                                      ),
                                                                                      const SizedBox(height: 5),
                                                                                      SizedBox(
                                                                                        width: 100,
                                                                                        height: 20,
                                                                                        child: TextField(
                                                                                            controller: controllerPriceFrom,
                                                                                            decoration: InputDecoration(
                                                                                              hintStyle: const TextStyle(
                                                                                                  color: Color(0xFF23262C),
                                                                                                  fontSize: 14,
                                                                                                  fontFamily: 'Inter',
                                                                                                  fontWeight: FontWeight.w400
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
                                                                                            keyboardType: TextInputType.number,
                                                                                            onSubmitted: (text) {
                                                                                              if (text != "" && double.parse(text) > priceFromFix) {
                                                                                                state(() {
                                                                                                  priceFrom = double.parse(text);
                                                                                                });
                                                                                              }
                                                                                            }
                                                                                        ),
                                                                                      ),
                                                                                      const SizedBox(height: 5),
                                                                                      Container(
                                                                                        width: 100,
                                                                                        height: 1,
                                                                                        decoration: const BoxDecoration(color: Color(0xFF85A0AA)),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  const SizedBox(width: 5),
                                                                                  SizedBox(
                                                                                    width: 10,
                                                                                    height: 10,
                                                                                    child: Stack(
                                                                                      children: [
                                                                                        Positioned(
                                                                                          left: 0,
                                                                                          top: 5,
                                                                                          child: Container(
                                                                                            width: 10,
                                                                                            height: 1,
                                                                                            decoration: const BoxDecoration(color: Color(0xFF23262C)),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                  const SizedBox(width: 5),
                                                                                  Column(
                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      const Text(
                                                                                        'макс.цена',
                                                                                        style: TextStyle(
                                                                                          color: Color(0xFF728A9D),
                                                                                          fontSize: 14,
                                                                                          fontFamily: 'Inter',
                                                                                          fontWeight: FontWeight.w400,
                                                                                          height: 0,
                                                                                        ),
                                                                                      ),
                                                                                      const SizedBox(height: 5),
                                                                                      SizedBox(
                                                                                        width: 100,
                                                                                        height: 20,
                                                                                        child: TextField(
                                                                                            controller: controllerPriceTo,
                                                                                            decoration: InputDecoration(
                                                                                              hintStyle: const TextStyle(
                                                                                                  color: Color(0xFF23262C),
                                                                                                  fontSize: 14,
                                                                                                  fontFamily: 'Inter',
                                                                                                  fontWeight: FontWeight.w400
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
                                                                                            keyboardType: TextInputType.number,
                                                                                            onSubmitted: (text) {
                                                                                              if (text != "" && double.parse(text) < priceToFix) {
                                                                                                state(() {
                                                                                                  priceTo = double.parse(text);
                                                                                                });
                                                                                              }
                                                                                            }
                                                                                        ),
                                                                                      ),
                                                                                      const SizedBox(height: 5),
                                                                                      Container(
                                                                                        width: 100,
                                                                                        height: 1,
                                                                                        decoration: const BoxDecoration(color: Color(0xFF85A0AA)),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            const SizedBox(height: 20),
                                                                          ],
                                                                        ) : Padding(
                                                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                                                          child: SizedBox(
                                                                              height: 100,
                                                                              child: Stack(
                                                                                alignment: Alignment.topRight,
                                                                                children: [
                                                                                  RawScrollbar(
                                                                                      controller: scrollController,
                                                                                      thumbVisibility: true,
                                                                                      trackVisibility: true,
                                                                                      thickness: 3,
                                                                                      thumbColor: const Color(0xFF12B438),
                                                                                      trackColor: const Color(0xFFEBF2FA),
                                                                                      trackBorderColor: Colors.transparent,
                                                                                      child: ListView.separated(
                                                                                        controller: scrollController,
                                                                                        itemCount: values.length,
                                                                                        separatorBuilder: (BuildContext context, int index) => const Divider(),
                                                                                        itemBuilder: (context, index) {
                                                                                          final value = values[index];

                                                                                          return GestureDetector(
                                                                                              onTap: () {
                                                                                                state(() {
                                                                                                  if (filterSelected[item.alias!] != null) {
                                                                                                    if (!filterSelected[item.alias!]!.contains(value.alias)) {
                                                                                                      AppMetrica.reportEvent('Применили фильтр ${item.name} значение ${value.value}');
                                                                                                      filterSelected[item.alias!]!.add(value.alias!);
                                                                                                    } else {
                                                                                                      AppMetrica.reportEvent('Сняли фильтр ${item.name} значение ${value.value}');
                                                                                                      filterSelected[item.alias!]!.remove(value.alias!);
                                                                                                    }
                                                                                                  } else {
                                                                                                    AppMetrica.reportEvent('Применили фильтр ${item.name} значение ${value.value}');
                                                                                                    filterSelected[item.alias!] = [value.alias!];
                                                                                                  }

                                                                                                  if (filterSelected[item.alias!] != null && filterSelected[item.alias!]!.isEmpty) {
                                                                                                    AppMetrica.reportEvent('Сняли фильтр ${item.name} значение ${value.value}');
                                                                                                    filterSelected.remove(item.alias!);
                                                                                                  }
                                                                                                });
                                                                                              },
                                                                                              child: Padding(
                                                                                                padding: const EdgeInsets.only(top: 10, bottom: 10, right: 15),
                                                                                                child: Row(
                                                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                  children: [
                                                                                                    Expanded(child: Text(value.value!)),
                                                                                                    Container(
                                                                                                      width: 20,
                                                                                                      height: 20,
                                                                                                      decoration: ShapeDecoration(
                                                                                                          shape: RoundedRectangleBorder(
                                                                                                            side: const BorderSide(width: 1, color: Color(0xFF23262C)),
                                                                                                            borderRadius: BorderRadius.circular(2),
                                                                                                          ),
                                                                                                          image: filterSelected[item.alias] != null && filterSelected[item.alias]!.contains(value.alias) ? const DecorationImage(
                                                                                                            image: AssetImage("assets/checkbox.jpg"),
                                                                                                            fit: BoxFit.fill,
                                                                                                          ) : null
                                                                                                      ),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              )
                                                                                          );
                                                                                        },
                                                                                      )
                                                                                  ),
                                                                                  GestureDetector(
                                                                                    onTap: () {
                                                                                      state(() {
                                                                                        if (filterSelected[item.alias!] != null) {
                                                                                          if (!filterSelected[item.alias!]!.contains(values.first.alias)) {
                                                                                            AppMetrica.reportEvent('Применили фильтр ${item.name} значение ${values.first.value}');
                                                                                            filterSelected[item.alias!]!.add(values.first.alias!);
                                                                                          } else {
                                                                                            AppMetrica.reportEvent('Сняли фильтр ${item.name} значение ${values.first.value}');
                                                                                            filterSelected[item.alias!]!.remove(values.first.alias!);
                                                                                          }
                                                                                        } else {
                                                                                          AppMetrica.reportEvent('Применили фильтр ${item.name} значение ${values.first.value}');
                                                                                          filterSelected[item.alias!] = [values.first.alias!];
                                                                                        }

                                                                                        if (filterSelected[item.alias!] != null && filterSelected[item.alias!]!.isEmpty) {
                                                                                          AppMetrica.reportEvent('Сняли фильтр ${item.name} значение ${values.first.value}');
                                                                                          filterSelected.remove(item.alias!);
                                                                                        }
                                                                                      });
                                                                                    },
                                                                                    child: Container(color: Colors.transparent, width: 50, height: 48),
                                                                                  )
                                                                                ],
                                                                              )
                                                                          ),
                                                                        ),
                                                                        if (categoryProducts!.filters!.length-1 > index) const Divider(color: Color(0xFF85A0AA)),
                                                                        if (categoryProducts!.filters!.length-1 > index) const SizedBox(height: 10),
                                                                      ],
                                                                    );
                                                                  }),
                                                                )
                                                            ),
                                                            Visibility(
                                                                visible: brands!.brands!.isNotEmpty,
                                                                child: Column(
                                                                  children: [
                                                                    const Divider(color: Color(0xFF85A0AA)),
                                                                    const SizedBox(height: 10),
                                                                    Padding(
                                                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                                                      child: Row(
                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          const Text(
                                                                            "Бренды",
                                                                            textAlign: TextAlign.center,
                                                                            style: TextStyle(
                                                                                color: Color(0xFF23262C),
                                                                                fontSize: 14,
                                                                                fontFamily: 'DaysSansBlack',
                                                                                fontWeight: FontWeight.w400
                                                                            ),
                                                                          ),
                                                                          Visibility(
                                                                              visible: filterSelected["brands"] != null && brands!.brands!.where((element) => filterSelected["brands"]!.contains(element)).isNotEmpty,
                                                                              child: GestureDetector(
                                                                                onTap: () {
                                                                                  for (var i in brands!.brands!) {
                                                                                    filterSelected["brands"]?.remove(i);
                                                                                  }

                                                                                  if (filterSelected["brands"] != null && filterSelected["brands"]!.isEmpty) {
                                                                                    filterSelected.remove("brands");
                                                                                  }

                                                                                  state(() {});
                                                                                },
                                                                                child: const Text(
                                                                                  'очистить',
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
                                                                    const SizedBox(height: 15),
                                                                    Padding(
                                                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                                                        child: SizedBox(
                                                                            height: 100,
                                                                            child: Stack(
                                                                              alignment: Alignment.topRight,
                                                                              children: [
                                                                                RawScrollbar(
                                                                                  controller: brandScrollController,
                                                                                  thumbVisibility: true,
                                                                                  trackVisibility: true,
                                                                                  thickness: 3,
                                                                                  thumbColor: const Color(0xFF12B438),
                                                                                  trackColor: const Color(0xFFEBF2FA),
                                                                                  trackBorderColor: Colors.transparent,
                                                                                  child: ListView.separated(
                                                                                    controller: brandScrollController,
                                                                                    itemCount: brands!.brands!.length,
                                                                                    separatorBuilder: (BuildContext context, int index) => const Divider(),
                                                                                    itemBuilder: (context, index) {
                                                                                      final item = brands!.brands![index];

                                                                                      return GestureDetector(
                                                                                          onTap: () {
                                                                                            state(() {
                                                                                              if (filterSelected["brands"] != null) {
                                                                                                if (!filterSelected["brands"]!.contains(item)) {
                                                                                                  AppMetrica.reportEvent('Применили фильтр по бренду $item');
                                                                                                  filterSelected["brands"]!.add(item);
                                                                                                } else {
                                                                                                  AppMetrica.reportEvent('Сняли фильтр по бренду $item');
                                                                                                  filterSelected["brands"]!.remove(item);
                                                                                                }
                                                                                              } else {
                                                                                                AppMetrica.reportEvent('Применили фильтр по бренду $item');
                                                                                                filterSelected["brands"] = [item];
                                                                                              }

                                                                                              if (filterSelected["brands"] != null && filterSelected["brands"]!.isEmpty) {
                                                                                                AppMetrica.reportEvent('Сняли фильтр по бренду $item');
                                                                                                filterSelected.remove("brands");
                                                                                              }
                                                                                            });
                                                                                          },
                                                                                          child: Padding(
                                                                                            padding: const EdgeInsets.only(top: 10, bottom: 10, right: 15),
                                                                                            child: Row(
                                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                              children: [
                                                                                                Expanded(child: Text(item)),
                                                                                                Container(
                                                                                                  width: 20,
                                                                                                  height: 20,
                                                                                                  decoration: ShapeDecoration(
                                                                                                      shape: RoundedRectangleBorder(
                                                                                                        side: const BorderSide(width: 1, color: Color(0xFF23262C)),
                                                                                                        borderRadius: BorderRadius.circular(2),
                                                                                                      ),
                                                                                                      image: filterSelected["brands"] != null && filterSelected["brands"]!.contains(item) ? const DecorationImage(
                                                                                                        image: AssetImage("assets/checkbox.jpg"),
                                                                                                        fit: BoxFit.fill,
                                                                                                      ) : null
                                                                                                  ),
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          )
                                                                                      );
                                                                                    },
                                                                                  ),
                                                                                ),
                                                                                GestureDetector(
                                                                                  onTap: () {
                                                                                    state(() {
                                                                                      if (filterSelected["brands"] != null) {
                                                                                        if (!filterSelected["brands"]!.contains(brands!.brands!.first)) {
                                                                                          AppMetrica.reportEvent('Применили фильтр по бренду ${brands!.brands!.first}');
                                                                                          filterSelected["brands"]!.add(brands!.brands!.first);
                                                                                        } else {
                                                                                          AppMetrica.reportEvent('Сняли фильтр по бренду ${brands!.brands!.first}');
                                                                                          filterSelected["brands"]!.remove(brands!.brands!.first);
                                                                                        }
                                                                                      } else {
                                                                                        AppMetrica.reportEvent('Применили фильтр по бренду ${brands!.brands!.first}');
                                                                                        filterSelected["brands"] = [brands!.brands!.first];
                                                                                      }

                                                                                      if (filterSelected["brands"] != null && filterSelected["brands"]!.isEmpty) {
                                                                                        AppMetrica.reportEvent('Сняли фильтр по бренду ${brands!.brands!.first}');
                                                                                        filterSelected.remove("brands");
                                                                                      }
                                                                                    });
                                                                                  },
                                                                                  child: Container(color: Colors.transparent, width: 50, height: 48),
                                                                                )
                                                                              ],
                                                                            )
                                                                        )
                                                                    ),
                                                                  ],
                                                                )
                                                            ),
                                                            const SizedBox(height: 90)
                                                          ],
                                                        ),
                                                      )
                                                  ),
                                                  Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      const SizedBox(height: 20),
                                                      Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            const Text(
                                                              'фильтры',
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(
                                                                  color: Color(0xFF728A9D),
                                                                  fontSize: 12,
                                                                  fontFamily: 'DaysSansBlack',
                                                                  fontWeight: FontWeight.w400
                                                              ),
                                                            ),
                                                            InkWell(
                                                              onTap: () {
                                                                Navigator.of(context).pop();
                                                              },
                                                              child: SvgPicture.asset("assets/close.svg", semanticsLabel: 'close', width: 20, height: 20),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(height: 15),
                                                    ],
                                                  ),
                                                  Container(
                                                    alignment: Alignment.bottomCenter,
                                                    height: height,
                                                    child: Container(
                                                      padding: const EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
                                                      color: Colors.white,
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          ElevatedButton(
                                                              onPressed: () async {
                                                                if (!resetFilter) {
                                                                  resetFilter = true;
                                                                  state(() {});
                                                                  priceFrom = priceFromFix;
                                                                  priceTo = priceToFix;
                                                                  filterSelected = <String, List<String>>{};
                                                                  categoryProducts = await Api.getProducts(int.parse(widget.category.id!), 0, 0, sort, {});
                                                                  resetFilter = false;
                                                                  setState(() {});

                                                                  if (context.mounted) {
                                                                    Navigator.of(context).pop();
                                                                  }
                                                                }
                                                              },
                                                              style: ElevatedButton.styleFrom(
                                                                  backgroundColor: Colors.white,
                                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                                                  minimumSize: Size((width/2)-5, 38),
                                                                  elevation: 0,
                                                                  alignment: Alignment.center
                                                              ),
                                                              child: resetFilter ? const CupertinoActivityIndicator(color: Color(0xFF12B438), radius: 10) : const Text(
                                                                'очистить все',
                                                                textAlign: TextAlign.center,
                                                                style: TextStyle(
                                                                    color: Color(0xFF12B438),
                                                                    fontSize: 14,
                                                                    fontFamily: 'Inter',
                                                                    fontWeight: FontWeight.w400
                                                                ),
                                                              )
                                                          ),
                                                          ElevatedButton(
                                                              onPressed: () async {
                                                                if (!submitFilter) {
                                                                  submitFilter = true;

                                                                  state(() {});

                                                                  filterSelected.remove("cena");
                                                                  var prices = <String>[];

                                                                  if (priceFrom >= priceFromFix) {
                                                                    prices.add(priceFrom.toStringAsFixed(0));
                                                                  }

                                                                  if (priceTo <= priceToFix) {
                                                                    prices.add(priceTo.toStringAsFixed(0));
                                                                  }

                                                                  if (prices.isNotEmpty) {
                                                                    filterSelected["cena"] = prices;
                                                                  }

                                                                  categoryProducts = await Api.getProducts(int.parse(widget.category.id!), 0, 0, sort, filterSelected);
                                                                  submitFilter = false;
                                                                  setState(() {});

                                                                  if (context.mounted) {
                                                                    Navigator.of(context).pop();
                                                                  }
                                                                }
                                                              },
                                                              style: ElevatedButton.styleFrom(
                                                                  backgroundColor: const Color(0xFF12B438),
                                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                                                  minimumSize: Size((width/2)-5, 38),
                                                                  elevation: 0,
                                                                  alignment: Alignment.center
                                                              ),
                                                              child: submitFilter ? const CupertinoActivityIndicator(color: Colors.white, radius: 10) : const Text(
                                                                'применить',
                                                                textAlign: TextAlign.center,
                                                                style: TextStyle(
                                                                    color: Colors.white,
                                                                    fontSize: 14,
                                                                    fontFamily: 'Inter',
                                                                    fontWeight: FontWeight.w400
                                                                ),
                                                              )
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            });
                                          }
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                        minimumSize: Size(width/2, 30),
                                        elevation: 0,
                                        alignment: Alignment.center
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SvgPicture.asset("assets/${filterSelected.isNotEmpty ? "filters_active" : "filters"}.svg", semanticsLabel: 'filters', width: 17, height: 17),
                                        const SizedBox(width: 10),
                                        Text(
                                          'фильтры${filterSelected.isNotEmpty ? " (${filterSelected.length})" : ""}',
                                          style: TextStyle(
                                              color: filterSelected.isNotEmpty ? const Color(0xFF12B438) : const Color(0xFF23262C),
                                              fontSize: 16,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w400
                                          ),
                                        )
                                      ],
                                    )
                                ),
                              ),
                              const SizedBox(width: 11),
                              Expanded(
                                child: ElevatedButton(
                                    onPressed: () async {
                                      if (!submitFilter) toggleSort();
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                        minimumSize: Size(width/2, 30),
                                        elevation: 0,
                                        alignment: Alignment.center
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SvgPicture.asset("assets/$sort.svg", semanticsLabel: 'sort', width: 17, height: 17),
                                        const SizedBox(width: 10),
                                        Text(
                                          'цена',
                                          style: TextStyle(
                                              color: Color(sort != "sort" ? 0xFF12B438 : 0xFF23262C),
                                              fontSize: 16,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w400
                                          ),
                                        )
                                      ],
                                    )
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 5),
                        ],
                      ),
                    ),
                    if (categoriesNotImages && keys.isNotEmpty) Container(
                      padding: const EdgeInsets.only(left: 10),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List<Widget>.generate(categories.length, (index) {
                            final Categories item = categories[index];

                            if (item.id == widget.category.id && keys[index].currentContext != null) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                Scrollable.ensureVisible(keys[index].currentContext!, duration: const Duration(milliseconds: 600));
                              });
                            }

                            return GestureDetector(
                                key: keys[index],
                                onTap: () async {
                                  if (item.id == widget.category.id) {
                                    Api.getCategory(widget.category.parentId!).then((value) {
                                      AppMetrica.reportEvent('Переход в категорию ${value.title}');
                                      Navigator.pushReplacement(
                                        context,
                                        CupertinoPageRoute(builder: (_) => CategoryView(category: value)),
                                      );
                                    });
                                  } else {
                                    AppMetrica.reportEvent('Переход в категорию ${item.title}');
                                    Navigator.pushReplacement(
                                      context,
                                      CupertinoPageRoute(builder: (_) => CategoryView(category: item, child: widget.child ?? widget.category)),
                                    );
                                  }
                                },
                                child: Container(
                                  height: 29,
                                  padding: const EdgeInsets.only(left: 20, right: 30, top: 5, bottom: 5),
                                  margin: const EdgeInsets.only(left: 0, right: 10),
                                  decoration: ShapeDecoration(
                                    color: Color(item.id == widget.category.id ? 0xFF23262C : 0xFFEBF3FB),
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(width: 1, color: Color(item.id == widget.category.id ? 0xFF23262C : 0xFF85A0AA)),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 10,
                                        height: 10,
                                        decoration: ShapeDecoration(
                                          color: Color(item.id == widget.category.id ? 0xFFFFFFFF : 0xFF23262C),
                                          shape: const OvalBorder(),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        item.title!,
                                        style: TextStyle(
                                            color: Color(item.id == widget.category.id ? 0xFFFFFFFF : 0xFF23262C),
                                            fontSize: 16,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                            );
                          }),
                        ),
                      ),
                    ),
                    if (!categoriesNotImages && categories.isNotEmpty) Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Wrap(
                        spacing: 5,
                        runSpacing: 5,
                        children: List<Widget>.generate(categories.length, (index) {
                          final Categories item = categories[index];

                          return GestureDetector(
                              onTap: () {
                                AppMetrica.reportEvent('Переход в категорию ${item.title}');
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(builder: (_) => CategoryView(category: item)),
                                );
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    width: (width/3) - 5,
                                    height: (width/3) - 5,
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
                                        fit: BoxFit.contain
                                    ),
                                  ),
                                  Container(
                                    width: (width/3) - 5,
                                    height: (width/3) - 5,
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
                                          width: 85,
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
                                                  fontSize: 10,
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
                              )
                          );
                        }),
                      ),
                    ),
                    if (categories.isNotEmpty) const SizedBox(height: 15),
                    categoryProducts != null && (categoryProducts!.totalCount ?? 0) > 0 ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Stack(
                          children: [
                            Wrap(
                              spacing: 5,
                              runSpacing: 5,
                              alignment: WrapAlignment.spaceBetween,
                              children: List.generate(categoryProducts!.items!.length, (index) {
                                return ProductView(category: widget.category, product: categoryProducts!.items![index]);
                              }),
                            ),
                            if (submitFilter) Container(
                              color: Colors.white.withOpacity(0.5),
                              width: width,
                              height: categoryProducts!.items!.length * 220,
                              padding: const EdgeInsets.only(top: 200),
                              alignment: Alignment.topCenter,
                              child: const CupertinoActivityIndicator(radius: 20),
                            )
                          ],
                        )
                    ) : Visibility(
                      visible: isLoaded && categoryProducts != null && (categoryProducts!.totalCount ?? 0) > 0 || filterSelected.isNotEmpty,
                      child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            filterSelected.isNotEmpty ? "По заданным параметрам ничего не найдено" : "В данной категории нет товаров",
                            style: const TextStyle(
                                color: Color(0xFF23262C),
                                fontSize: 12,
                                fontFamily: 'DaysSansBlack',
                                fontWeight: FontWeight.w400
                            ),
                          )
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: const NavigationView()
        )
    );
  }
}