import 'package:assurance_bookstore/src/core/helper/extension.dart';
import 'package:assurance_bookstore/src/ui/screen/home/subbcategory-widget/subcategory_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/controllers/auth/auth_controller.dart';
import '../../../core/controllers/cart-controller/cart_controller.dart';
import '../../../core/controllers/home/home_controller.dart';
import '../../../core/models/home/home_page_data.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/responsive.dart';
import 'components/banner_scroll_widget.dart';
import 'components/book_card.dart';
import 'components/search_result.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

final homeController = Get.find<HomeController>();
final authController = Get.find<AuthController>();
TextEditingController _searchController = TextEditingController();
bool _isLoading = false;
// final CartController cartController = Get.find();

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
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  // Search Field
                  Container(
                    height: 60,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 8),
                        TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            labelText: 'Search Books',
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.search),
                              onPressed: () {
                                homeController
                                    .searchBooks(_searchController.text)
                                    .then((_) {
                                      if (homeController.books.isNotEmpty) {
                                        Get.to(() => SearchResultScreen());
                                      } else {
                                        // If no results, show a snackbar or message
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
                      ],
                    ),
                  ),

                  buildCategoryList(homeController.homePageData.value, context),
                ],
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
          SizedBox(height: 20),
          Container(
            height: MediaQuery.of(context).size.height * 0.90,
            width: Responsive.isSmallScreen(context)
                ? MediaQuery.of(context).size.width * 0.25
                : MediaQuery.of(context).size.width * 0.15,
            color: Colors.grey.shade100,
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() {
                        if (authController.isLoggedIn) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                const SizedBox(width: 8),
                                Column(
                                  children: [
                                    Text(
                                      " Welcome",
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      " ${authController.username.value}",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        } else {
                          return Container();
                        }
                      }),

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

          // RIGHT Main Content (expandable)
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                                        ? 190
                                        : 292,
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
