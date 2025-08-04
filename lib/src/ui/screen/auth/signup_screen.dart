// import 'package:assurance_bookstore/src/core/helper/extension.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import '../../../core/controllers/auth/auth_controller.dart';
// import '../../widgets/custom_textfield.dart';
// import '../../widgets/custpm_password_field.dart';
// import 'login_screen.dart';
//
// class SignupScreen extends StatelessWidget {
//   SignupScreen({super.key});
//
//   final firstNameController = TextEditingController();
//   final lastNameController = TextEditingController();
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   final confirmPasswordController = TextEditingController();
//   final formKey = GlobalKey<FormState>();
//
//   final controller = Get.find<AuthController>();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           // Top banner section
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.only(top: 50, bottom: 20),
//             decoration: const BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage(
//                   'assets/images/starter_image2.png',
//                 ), // Add this image
//                 fit: BoxFit.cover,
//               ),
//             ),
//             child: Column(
//               children: [
//                 Image.asset(
//                   'assets/images/small_logo.png', // Your YO-LER logo
//                   height: 40,
//                 ),
//                 const SizedBox(height: 20),
//                 const Text(
//                   "Let's Get\nStarted",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//           ),
//
//           // Form Section
//           Expanded(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//               child: Form(
//                 key: formKey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       "What’s Your name?",
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//
//                     CustomTextField(
//                       textEditingController: firstNameController,
//                       title: "First Name",
//                       placeHolder: "Enter your first name",
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter your first name';
//                         }
//                         return null;
//                       },
//                       height: 50,
//                     ),
//
//                     SizedBox(height: 10),
//
//                     CustomTextField(
//                       textEditingController: lastNameController,
//                       title: "Last Name",
//                       placeHolder: "Enter your last name",
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter your last name';
//                         }
//                         return null;
//                       },
//                       height: 50,
//                     ),
//
//                     SizedBox(height: 10),
//
//                     CustomTextField(
//                       textEditingController: emailController,
//                       title: "Email",
//                       placeHolder: "Enter your email",
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter your email';
//                         } else if (!GetUtils.isEmail(value)) {
//                           return 'Please enter a valid email';
//                         }
//                         return null;
//                       },
//                       textInputType: TextInputType.emailAddress,
//                       height: 50,
//                     ),
//                     SizedBox(height: 10),
//
//                     CustomPasswordField(
//                       textEditingController: passwordController,
//                       title: "Password",
//                       placeHolder: "Enter your password",
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter your password';
//                         } else if (value.length < 6) {
//                           return 'Password must be at least 6 characters';
//                         }
//                         return null;
//                       },
//                     ),
//                     SizedBox(height: 10),
//
//                     CustomPasswordField(
//                       textEditingController: confirmPasswordController,
//                       title: "Confirm Password",
//                       placeHolder: "Re-enter your password",
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please confirm your password';
//                         } else if (value != passwordController.text) {
//                           return 'Passwords do not match';
//                         }
//                         return null;
//                       },
//                     ),
//
//                     const SizedBox(height: 10),
//
//                     // Obx(
//                     //   () =>
//                     //       controller.isSignupLoading.value ||
//                     //           controller.isSendOtpLoading.value
//                     //       ? CustomCircleLoading()
//                     //       : ElevatedButton(
//                     //           style: ElevatedButton.styleFrom(
//                     //             backgroundColor: Colors.black,
//                     //             minimumSize: const Size.fromHeight(50),
//                     //             shape: RoundedRectangleBorder(
//                     //               borderRadius: BorderRadius.circular(10),
//                     //             ),
//                     //           ),
//                     //           onPressed: () async {
//                     //             if (formKey.currentState!.validate()) {
//                     //               final user = SignupUserModel(
//                     //                 firstName: firstNameController.text,
//                     //                 lastName: lastNameController.text,
//                     //                 email: emailController.text,
//                     //                 password: passwordController.text,
//                     //               );
//                     //
//                     //               final isSendOtp = await controller.sendOtp(
//                     //                 email: emailController.text,
//                     //               );
//                     //
//                     //               if (isSendOtp) {
//                     //                 final result = await Get.to(
//                     //                   () => VerifyOtpScreen(
//                     //                     email: emailController.text,
//                     //                   ),
//                     //                 );
//                     //
//                     //                 if (result == true) {
//                     //                   final status = await controller.signup(
//                     //                     model: user,
//                     //                   );
//                     //
//                     //                   if (status) {
//                     //                     Get.offAll(() => HomeScreen());
//                     //                   }
//                     //                 }
//                     //               }
//                     //             }
//                     //           },
//                     //           child: Text(
//                     //             "Sign Up",
//                     //             style: context.labelMedium!.copyWith(
//                     //               fontSize: 14,
//                     //               color: Colors.white,
//                     //             ),
//                     //           ),
//                     //         ),
//                     // ),
//                     const SizedBox(height: 16),
//                     const Text(
//                       "Please note that your name is used locally within\nthe app to personalise your learner journey.",
//                       style: TextStyle(fontSize: 14, color: Colors.grey),
//                     ),
//                     const SizedBox(height: 20),
//                     Row(
//                       children: const [
//                         Expanded(child: Divider(thickness: 1)),
//                         Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 8),
//                           child: Text("or"),
//                         ),
//                         Expanded(child: Divider(thickness: 1)),
//                       ],
//                     ),
//                     const SizedBox(height: 20),
//                     ElevatedButton(
//                       onPressed: () {
//                         Get.back();
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.white,
//                         foregroundColor: Colors.black,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                           side: BorderSide(color: Colors.grey),
//                         ),
//                         minimumSize: const Size.fromHeight(50),
//                       ),
//                       child: const Text(
//                         "Login for users",
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w400,
//                         ),
//                       ),
//                     ),
//
//                     SizedBox(height: 30),
//
//                     Padding(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 24,
//                         vertical: 16,
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Spacer(),
//                           const Row(
//                             children: [
//                               Icon(Icons.circle, size: 10, color: Colors.green),
//                               SizedBox(width: 6),
//                               Icon(Icons.circle, size: 10, color: Colors.grey),
//                             ],
//                           ),
//                           Spacer(),
//                           IconButton(
//                             onPressed: () {
//                               Get.to(LoginScreen());
//                             },
//                             icon: Icon(
//                               Icons.arrow_forward,
//                               color: Colors.black,
//                               size: 20,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//
//           // Bottom dots and arro
//         ],
//       ),
//     );
//   }
// }
