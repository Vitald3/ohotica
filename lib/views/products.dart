import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:ohotika/views/product.dart';
import 'package:provider/provider.dart';
import '../models/categories.dart';
import '../models/products.dart';
import '../models/wishlist.dart';
import '../other/values_notifier.dart';
import '../services/database.dart';

class ProductView extends StatefulWidget {
  const ProductView({super.key, required this.category, required this.product, this.wishlistType});

  final Categories category;
  final Items product;
  final Function? wishlistType;

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  late final Box setting;
  var wishlists = <Wishlist>[];
  var carouselController = CarouselController();
  var activeImage = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setData();
    });

    super.initState();
  }

  setData() async {
    wishlists = await DBProvider.db.getWishlists();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width - 20;

    return GestureDetector(
        onTap: () {
          AppMetrica.reportEvent('Переход в товар ${widget.product.name}');
          Navigator.push(
            context,
            CupertinoPageRoute(builder: (_) => ItemView(id: widget.product.id!, category: widget.category)),
          ).then((_) => setState(() {}));
        },
        child: Container(
          width: width >= 492 ? (width/3)-5 : (width/2)-5,
          height: 252,
          padding: const EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 10),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.topRight,
                children: [
                  Column(
                    children: [
                      SizedBox(
                          width: (width/2)-5,
                          height: 135,
                          child: widget.product.images != null && widget.product.images!.length > 1 ? CarouselSlider(
                              options: CarouselOptions(
                                height: 135,
                                disableCenter: false,
                                enlargeCenterPage: true,
                                initialPage: 0,
                                enlargeStrategy: CenterPageEnlargeStrategy.height,
                                viewportFraction: 1,
                                padEnds: false,
                                onPageChanged: (index, _) {
                                  setState(() {
                                    activeImage = index;
                                  });
                                },
                              ),
                              carouselController: carouselController,
                              items: List.generate(widget.product.images!.length, (index) {
                                return Container(
                                  color: Colors.white,
                                  width: double.infinity,
                                  height: double.infinity,
                                  child: CachedNetworkImage(
                                      imageUrl: widget.product.images![index],
                                      errorWidget: (context, url, error) => Image.asset("assets/no-image.png"),
                                      fit: BoxFit.contain
                                  ),
                                );
                              })
                          ) : CachedNetworkImage(
                              imageUrl: widget.product.images != null && widget.product.images!.isNotEmpty ? widget.product.images![0] : widget.product.imageUrl!,
                              errorWidget: (context, url, error) => Image.asset("assets/no-image.png"),
                              fit: BoxFit.contain
                          ),
                      ),
                      SizedBox(height: widget.product.images != null && widget.product.images!.length > 1 ? 8 : 0),
                      widget.product.images != null && widget.product.images!.length > 1 ? Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: List<Widget>.generate(widget.product.images!.length, (int index) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                activeImage = index;
                              });

                              carouselController.jumpToPage(index);
                            },
                            child: Container(
                              height: 10,
                              width: 10,
                              alignment: Alignment.center,
                              child: Container(
                                height: 6,
                                width: 6,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: activeImage != index ? Colors.black : const Color(0xFF12B438),
                                ),
                              ),
                            ),
                          );
                        }),
                      ) : const SizedBox(height: 20),
                      SizedBox(height: widget.product.images != null && widget.product.images!.length > 1 ? 4 : 0),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (wishlists.where((element) => element.pid == widget.product.id).isNotEmpty) {
                          AppMetrica.reportEvent('Товар ${widget.product.name} удален из закладок');
                          DBProvider.db.deleteWishlist(widget.product.id!);
                        } else {
                          AppMetrica.reportEvent('Товар ${widget.product.name} добавлен в закладки');
                          DBProvider.db.addWishlist(Wishlist(pid: widget.product.id, imageUrl: widget.product.imageUrl, name: widget.product.name, price: double.parse(widget.product.price!.replaceAll(" ", "")), category: widget.category));
                        }

                        DBProvider.db.getWishlists().then((value) {
                          setState(() {
                            wishlists = value;
                          });

                          var count = "";

                          if (value.isNotEmpty) {
                            count = "${value.length}";
                          }

                          Provider.of<ValuesNotifier>(context, listen: false).setWishlistCount(count);
                        });

                        if (widget.wishlistType != null) {
                          widget.wishlistType!();
                        }
                      });
                    },
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: Center(
                        child: SvgPicture.asset("assets/${wishlists.where((element) => element.pid == widget.product.id).isNotEmpty ? "heart" : "wishlist"}.svg", semanticsLabel: 'wishlist', width: 14, height: 13),
                      )
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Expanded(
                child:  SizedBox(
                  width: 165,
                  height: 64,
                  child: Text(
                    widget.product.name!,
                    maxLines: 4,
                    style: const TextStyle(
                        color: Color(0xFF23262C),
                        fontSize: 12,
                        fontFamily: 'DaysSansBlack',
                        fontWeight: FontWeight.w400,
                        overflow: TextOverflow.ellipsis
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '${widget.product.price!} руб.',
                style: const TextStyle(
                  color: Color(0xFF23262C),
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400
                ),
              )
            ],
          )
        )
    );
  }
}