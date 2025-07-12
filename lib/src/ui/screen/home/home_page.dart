import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

final homeController = Get.find<HomeController>();
@override
void initState() {
  super.initState();
  homeController.fetchHomeData();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: Obx(() {
        if (homeController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (homeController.isError.value) {
          return Center(child: Text(homeController.errorMessage.value));
        } else if (homeController.isEmpty.value) {
          return const Center(child: Text('No Data Available'));
        } else {
          return ListView.builder(
            itemCount: homeController.homePageData.length,
            itemBuilder: (context, index) {
              HomePageData data = homeController.homePageData[index];
              return ListTile(
                title: Text(data.name),
                subtitle: Text(data.slug),
              );
            },
          );
        }
      }),
    );
  }
}
