import 'package:assurance_bookstore/src/core/controllers/auth/auth_controller.dart';
import 'package:assurance_bookstore/src/core/helper/extension.dart';
import 'package:assurance_bookstore/src/ui/widgets/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/constants.dart';
import '../../../core/controllers/home/home_controller.dart';
import '../../../core/models/home/home_page_data.dart';
import '../../widgets/custom_appbar.dart';
import '../book-details/book-details_Screen.dart';
import 'components/banner_scroll_widget.dart';
import 'components/book_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

final homeController = Get.find<HomeController>();
final authController = Get.find<AuthController>();

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    homeController.fetchHomeData();
    homeController.loadBanners();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),

      body: Obx(() {
        if (homeController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (homeController.isError.value) {
          return Center(child: Text(homeController.errorMessage.value));
        } else if (homeController.isEmpty.value) {
          return const Center(child: Text('No Data Available'));
        } else {
          return RefreshIndicator(
            onRefresh: () async {
              await homeController.fetchHomeData(); // call your API
            },
            child: SingleChildScrollView(
              physics:
                  const AlwaysScrollableScrollPhysics(), // ensure it's always scrollable
              child: buildCategoryList(
                homeController.homePageData.value,
                context,
              ),
            ),
          );
        }
      }),
    );
  }
}

Widget buildCategoryList(List<HomePageData> categories, BuildContext context) {
  final authController = Get.find<AuthController>();
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() {
            if (authController.isLoggedIn) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Icon(Icons.account_circle, color: Colors.black),
                    const SizedBox(width: 8),
                    Text("Hello, ${authController.username.value}"),
                  ],
                ),
              );
            } else {
              return Container();
            }
          }),
          SizedBox(height: 20),
          Container(
            height: MediaQuery.of(context).size.height * 0.90,
            width: Responsive.isSmallScreen(context)
                ? MediaQuery.of(context).size.width * 0.35
                : MediaQuery.of(context).size.width * 0.15,
            color: Colors.grey.shade100,
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'বিষয়',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                ...homeController.homePageData.map((category) {
                  return ExpansionTile(
                    expansionAnimationStyle: AnimationStyle(
                      curve: Curves.easeOut,
                      duration: Duration(milliseconds: 500),
                    ),
                    title: SizedBox(
                      width: Responsive.isSmallScreen(context) ? 120 : 180,
                      child: Text(
                        category.name,
                        style: context.labelMedium!.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                        maxLines: 1,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_drop_down_sharp,
                      color: Colors.grey,
                    ),
                    children: category.subcategories.map((sub) {
                      return ListTile(
                        title: Text(
                          sub.name,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        onTap: () {
                          // handle tap
                        },
                      );
                    }).toList(),
                  );
                }).toList(),
              ],
            ),
          ),

          // RIGHT Main Content (expandable)
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // if (homeController.banners.isNotEmpty)
                  //   Padding(
                  //     padding: const EdgeInsets.symmetric(vertical: 10),
                  //     child: SizedBox(
                  //       height: Responsive.isSmallScreen(context) ? 200 : 300,
                  //       child: ListView.builder(
                  //         scrollDirection: Axis.horizontal,
                  //         itemCount: homeController.banners.length,
                  //         itemBuilder: (context, index) {
                  //           final banner = homeController.banners[index];
                  //           return GestureDetector(
                  //             onTap: () async {
                  //               final url = Uri.parse(banner.link);
                  //               if (await canLaunchUrl(url)) {
                  //                 await launchUrl(url);
                  //               }
                  //             },
                  //             child: Center(
                  //               child: Padding(
                  //                 padding: const EdgeInsets.symmetric(
                  //                   horizontal: 8.0,
                  //                 ),
                  //                 child: ClipRRect(
                  //                   borderRadius: BorderRadius.circular(12),
                  //                   child: Image.network(
                  //                     Constants.imageUrl + banner.image,
                  //                     width: Responsive.isSmallScreen(context)
                  //                         ? MediaQuery.of(context).size.width *
                  //                               0.6
                  //                         : MediaQuery.of(context).size.width *
                  //                               0.7,
                  //                     height: Responsive.isSmallScreen(context)
                  //                         ? MediaQuery.of(context).size.width *
                  //                               0.3
                  //                         : MediaQuery.of(context).size.width *
                  //                               0.3,
                  //
                  //                     fit: BoxFit.fill,
                  //                   ),
                  //                 ),
                  //               ),
                  //             ),
                  //           );
                  //         },
                  //       ),
                  //     ),
                  //   ),
                  AutoScrollBanners(banners: homeController.banners),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: categories.length,
                    itemBuilder: (context, categoryIndex) {
                      final category = categories[categoryIndex];

                      return Padding(
                        padding: EdgeInsets.only(bottom: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Category Header Row
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    category.name,
                                    style: context.labelLarge!.copyWith(
                                      fontSize:
                                          Responsive.isSmallScreen(context)
                                          ? 14
                                          : 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      // TODO: Navigate to "see all"
                                    },
                                    child: Text(
                                      'সব দেখুন →',
                                      style: context.labelLarge!.copyWith(
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(),
                            // Subcategories loop
                            ...category.subcategories.map((sub) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (sub.name.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 16.0,
                                        bottom: 2,
                                      ),
                                      child: Text(
                                        sub.name,
                                        style: context.labelLarge!.copyWith(
                                          color: Colors.redAccent,
                                          fontSize:
                                              Responsive.isSmallScreen(context)
                                              ? 12
                                              : 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  SizedBox(height: 5),
                                  SizedBox(
                                    height: Responsive.isSmallScreen(context)
                                        ? 200
                                        : 300,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: sub.books.length,
                                      itemBuilder: (context, bookIndex) {
                                        return BookCard(
                                          book: sub.books[bookIndex],
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ],
  );
}

Widget buildBookCard(Book book) {
  return GestureDetector(
    onTap: () {
      Get.to(() => BookDetailsScreen(bookId: book.id.toString()));
    },
    child: Container(
      width: 140,
      margin: const EdgeInsets.only(left: 20, right: 8),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(
                  'http://192.168.68.103:8000${book.image}',
                  // already full path in model
                  fit: BoxFit.contain,
                  scale: 0.6,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey.shade300,
                    child: const Center(child: Icon(Icons.broken_image)),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                book.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              // const SizedBox(height: 4),
              // Text(
              //   "Juwel Sheikh",
              //   maxLines: 1,
              //   overflow: TextOverflow.ellipsis,
              //   style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              // ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Text(
                    "৳৮৬০",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "৳৯৮০",
                    style: TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                '২০% ছাড়',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
