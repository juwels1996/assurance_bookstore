import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/controllers/auth/mobile_auth_controller.dart';

class MobileOtpScreen extends StatefulWidget {
  const MobileOtpScreen({Key? key}) : super(key: key);

  @override
  State<MobileOtpScreen> createState() => _MobileOtpScreenState();
}

class _MobileOtpScreenState extends State<MobileOtpScreen> {
  final MobileAuthController controller = Get.put(MobileAuthController());

  final List<TextEditingController> otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (var c in otpControllers) c.dispose();
    for (var f in focusNodes) f.dispose();
    super.dispose();
  }

  void _onOtpChanged(int index, String value) {
    if (value.length == 1 && index < 5) {
      focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      focusNodes[index - 1].requestFocus();
    }

    String otp = otpControllers.map((c) => c.text).join();
    if (otp.length == 6) {
      controller.otpController.text = otp;
      controller.verifyOtp();
    }
  }

  Widget _otpBox(int index) {
    return SizedBox(
      width: 45,
      child: TextField(
        controller: otpControllers[index],
        focusNode: focusNodes[index],
        maxLength: 1,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        decoration: const InputDecoration(
          counterText: "",
          border: OutlineInputBorder(),
        ),
        onChanged: (value) => _onOtpChanged(index, value),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mobile Authentication"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          // Step 1: Show phone input if OTP not sent yet
          if (controller.otpRequestState.value != ApiState.loaded) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Enter your mobile number",
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: controller.phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "e.g. 016xxxxxxxx",
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed:
                      controller.otpRequestState.value == ApiState.loading
                      ? null
                      : () {
                          controller.requestOtp();
                        },
                  child: controller.otpRequestState.value == ApiState.loading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text("Send OTP"),
                ),
              ],
            );
          }

          // Step 2: Show OTP input after OTP is sent
          return Column(
            children: [
              const Text(
                "Enter the 6-digit OTP sent to your phone",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) => _otpBox(index)),
              ),
              const SizedBox(height: 24),
              // Resend OTP Timer
              controller.resendTime.value > 0
                  ? Text(
                      "Resend OTP in ${controller.resendTime.value} seconds",
                      style: const TextStyle(color: Colors.grey),
                    )
                  : TextButton(
                      onPressed: () {
                        controller.requestOtp();
                      },
                      child: const Text("Resend OTP"),
                    ),
              const SizedBox(height: 16),
              // Verify Button
              ElevatedButton(
                onPressed: controller.otpVerifyState.value == ApiState.loading
                    ? null
                    : () {
                        controller.otpController.text = otpControllers
                            .map((c) => c.text)
                            .join();
                        controller.verifyOtp();
                      },
                child: controller.otpVerifyState.value == ApiState.loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text("Verify OTP"),
              ),
            ],
          );
        }),
      ),
    );
  }
}
