import 'package:assurance_bookstore/src/core/helper/extension.dart';
import 'package:assurance_bookstore/src/ui/screen/home/subbcategory-widget/subcategory_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/controllers/auth/auth_controller.dart';
import '../../../core/controllers/home/home_controller.dart';
import '../../../core/models/home/home_page_data.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/responsive.dart';
import 'components/banner_scroll_widget.dart';

import 'components/book_card.dart' hide Responsive;
import 'components/bottom_footer.dart';
import 'components/search_result.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

final homeController = Get.find<HomeController>();
final authController = Get.find<AuthController>();
TextEditingController _searchController = TextEditingController();
final RxInt expandedCategoryId = (-1).obs;

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      homeController.fetchHomeData();
      homeController.loadBanners();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
              await homeController.fetchHomeData();
            },
            child: Stack(
              children: [
                // Main content
                Column(
                  children: [
                    // 🔍 Search Bar
                    Container(
                      margin: const EdgeInsets.all(12),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search Books...',
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.blueAccent,
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.deepPurple,
                            ),
                            onPressed: () {
                              homeController
                                  .searchBooks(_searchController.text)
                                  .then((_) {
                                if (homeController.books.isNotEmpty) {
                                  Get.to(() => SearchResultScreen());
                                } else {
                                  Get.snackbar(
                                    'No results found',
                                    'Try another search',
                                  );
                                }
                              });
                            },
                          ),
                        ),
                      ),
                    ),

                    Expanded(
                      child: buildCategoryList(
                        homeController.homePageData.value,
                        context,
                      ),
                    ),
                  ],
                ),

                // 🟢 Static Chat Icon
                Positioned(
                  bottom: 20,
                  right: 20,
                  height: 50,
                  width: 60,
                  child: GestureDetector(
                    onTap: () {
                      launchUrl(
                        Uri.parse("https://www.facebook.com/share/19n3AGfnZw/"),
                      );
                    },
                    child: Image.asset("assets/images/chat2.png"),
                  ),
                ),
              ],
            ),
          );
        }
      }),
      bottomNavigationBar: Text("Version : 1.0.1 "),
    );
  }
}

/// Redesigned Category + Subcategory + Banner Section
/// Redesigned Category + Subcategory + Banner Section
Widget buildCategoryList(List<HomePageData> categories, BuildContext context) {
  final isSmall = Responsive.isSmallScreen(context);

  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // 📂 Left Sidebar (only visible on large screen)
      if (!isSmall)
        Container(
          height: Get.height * 0.9,
          width: MediaQuery.of(context).size.width * 0.18,
          color: Colors.grey.shade100,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              // 👤 User Welcome
              Obx(() {
                if (authController.isLoggedIn) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue.shade100,
                      child: Icon(Icons.person, color: Colors.blue),
                    ),
                    title: Text(
                      "Welcome",
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    subtitle: Text(
                      authController.username.value,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              }),

              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'ক্যাটেগরি',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),

              // Category Expansion list for large screen
              ...homeController.homePageData.map((category) {
                return ExpansionTile(
                  leading: Icon(
                    Icons.bookmark,
                    color:
                        Colors.primaries[category.id % Colors.primaries.length],
                  ),
                  title: Text(
                    category.name,
                    style: context.labelMedium!.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  children: category.subcategories.map((sub) {
                    return ListTile(
                      leading: Icon(
                        Icons.arrow_right_alt,
                        color:
                            Colors.primaries[sub.id % Colors.primaries.length],
                      ),
                      title: Text(sub.name),
                      onTap: () {
                        Get.to(
                          () => SubcategoryScreen(
                            subcategoryId: sub.id.toString(),
                            subcategoryName: sub.name,
                          ),
                        );
                      },
                    );
                  }).toList(),
                );
              }).toList(),
            ],
          ),
        ),

      // 📚 Right Content
      Expanded(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: categories.length + 2,
          itemBuilder: (context, categoryIndex) {
            if (categoryIndex == 0) {
              return Column(
                children: [
                  AutoScrollBanners(banners: homeController.banners),

                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     GestureDetector(
                  //       onTap: () {
                  //         launchUrl(Uri.parse("tel:01341-875192"));
                  //       },
                  //       child: Image.asset(
                  //         'assets/images/call.png',
                  //         height: 100.h,
                  //       ),
                  //     ),
                  //
                  //     SizedBox(width: 15.w),
                  //
                  //     // Live Chat
                  //     GestureDetector(
                  //       onTap: () {
                  //         launchUrl(
                  //           Uri.parse(
                  //             "https://www.facebook.com/share/19n3AGfnZw/",
                  //           ),
                  //         );
                  //       },
                  //       child: Image.asset(
                  //         'assets/images/chat.png',
                  //         height: 100.h,
                  //       ),
                  //     ),
                  //
                  //     // ✅ New Image (Your feature)
                  //   ],
                  // ),
                  // Add this at the top of your widget (if using inside a GetBuilder or Obx)
                  if (isSmall)
                    Obx(
                      () => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 2,
                          runSpacing: 8,
                          children: List.generate(categories.length, (index) {
                            final category = categories[index];

                            // Filter subcategories that have books
                            final availableSubcategories = category
                                .subcategories
                                .where((sub) => sub.books.isNotEmpty)
                                .toList();

                            if (availableSubcategories.isEmpty)
                              return SizedBox.shrink();

                            final bool isExpanded =
                                expandedCategoryId.value == category.id;

                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Category title (clickable)
                                GestureDetector(
                                  onTap: () {
                                    if (isExpanded) {
                                      expandedCategoryId.value = -1;
                                    } else {
                                      expandedCategoryId.value = category.id;
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white70,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.grey),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // Icon(
                                        //   isExpanded
                                        //       ? Icons.keyboard_arrow_down
                                        //       : Icons.keyboard_arrow_right,
                                        //   size: 18,
                                        //   color: Colors.blue,
                                        // ),
                                        // SizedBox(width: 4),
                                        Text(
                                          category.name,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // Subcategories (visible only when expanded)
                                if (isExpanded)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6.0),
                                    child: Wrap(
                                      spacing: 4,
                                      runSpacing: 4,
                                      children: availableSubcategories.map((
                                        sub,
                                      ) {
                                        return ElevatedButton(
                                          onPressed: () {
                                            Get.to(
                                              () => SubcategoryScreen(
                                                subcategoryId:
                                                    sub.id.toString(),
                                                subcategoryName: sub.name,
                                              ),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 6,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text("📚"),
                                              SizedBox(width: 4),
                                              Text(
                                                sub.name,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                              ],
                            );
                          }),
                        ),
                      ),
                    ),
                ],
              );
            } else if (categoryIndex == categories.length + 1) {
              return BottomFooter();
            } else {
              final category = categories[categoryIndex - 1];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (category.subcategories.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.category,
                              color: Colors.primaries[
                                  category.id % Colors.primaries.length],
                            ),
                            const SizedBox(width: 8),
                            Text(
                              category.name,
                              style: context.labelLarge!.copyWith(
                                fontSize: isSmall ? 14 : 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const Divider(),

                    // 🎨 Subcategories
                    ...category.subcategories.map((sub) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (sub.books.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.primaries[
                                        sub.id % Colors.primaries.length],
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    sub.name,
                                    style: context.labelLarge!.copyWith(
                                      color: Colors.redAccent,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Spacer(),
                                  TextButton(
                                    onPressed: () {
                                      Get.to(
                                        () => SubcategoryScreen(
                                          subcategoryId: sub.id.toString(),
                                          subcategoryName: sub.name,
                                        ),
                                      );
                                    },
                                    child: const Text("সব দেখুন →"),
                                  ),
                                ],
                              ),
                            ),
                          const SizedBox(height: 5),
                          SizedBox(
                            height: isSmall ? 300 : 350,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: sub.books.length,
                              itemBuilder: (context, bookIndex) {
                                // final reversedBooks = sub.books.reversed
                                //     .toList();
                                return BookCard(book: sub.books[bookIndex]);
                              },
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              );
            }
          },
        ),
      ),
    ],
  );
}
