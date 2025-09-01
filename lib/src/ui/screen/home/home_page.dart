import 'package:assurance_bookstore/src/core/helper/extension.dart';
import 'package:assurance_bookstore/src/ui/screen/home/subbcategory-widget/subcategory_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
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
              await homeController.fetchHomeData(); // refresh API
            },
            child: Column(
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
                      prefixIcon: Icon(Icons.search, color: Colors.blueAccent),
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
          );
        }
      }),
    );
  }
}

/// Redesigned Category + Subcategory + Banner Section
Widget buildCategoryList(List<HomePageData> categories, BuildContext context) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // 📂 Left Sidebar
      Container(
        height: Get.height * 0.9,
        width: Responsive.isSmallScreen(context)
            ? MediaQuery.of(context).size.width * 0.35
            : MediaQuery.of(context).size.width * 0.18,
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
                'বিষয়',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ),

            // 📌 Categories with colorful icons
            ...homeController.homePageData.map((category) {
              return ExpansionTile(
                leading: Icon(
                  Icons.bookmark,
                  color:
                      Colors.primaries[category.id %
                          Colors.primaries.length], // colorful
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
                          Colors.primaries[sub.id %
                              Colors.primaries.length], // colorful
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
              // 🖼️ Banner first
              return AutoScrollBanners(banners: homeController.banners);
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
                              color:
                                  Colors.primaries[category.id %
                                      Colors.primaries.length],
                            ),
                            const SizedBox(width: 8),
                            Text(
                              category.name,
                              style: context.labelLarge!.copyWith(
                                fontSize: Responsive.isSmallScreen(context)
                                    ? 14
                                    : 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const Divider(),

                    // 🎨 Subcategories shown immediately after banner
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
                                    color:
                                        Colors.primaries[sub.id %
                                            Colors.primaries.length],
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
                            height: Responsive.isSmallScreen(context)
                                ? 190
                                : 250,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: sub.books.length,
                              itemBuilder: (context, bookIndex) {
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
