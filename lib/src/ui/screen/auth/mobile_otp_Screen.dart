import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../core/controllers/auth/mobile_auth_controller.dart';

// ---- Brand palette (tweak as you like) ----
class _Brand {
  static const Color primary = Color(0xFF635BFF);
  static const Color accent = Color(0xFF19C3FB);
  static const Color bgDark = Color(0xFF0F1222);
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFFFB020);
  static const Color danger = Color(0xFFEF4444);
}

class MobileOtpScreen extends StatefulWidget {
  const MobileOtpScreen({Key? key}) : super(key: key);

  @override
  State<MobileOtpScreen> createState() => _MobileOtpScreenState();
}

class _MobileOtpScreenState extends State<MobileOtpScreen>
    with SingleTickerProviderStateMixin {
  final MobileAuthController controller = Get.put(MobileAuthController());

  final List<TextEditingController> otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

  // UI state
  int focusedIndex = 0;
  late final AnimationController _glowCtrl;

  @override
  void initState() {
    super.initState();
    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    for (int i = 0; i < focusNodes.length; i++) {
      focusNodes[i].addListener(() {
        if (focusNodes[i].hasFocus) {
          setState(() => focusedIndex = i);
        }
      });
    }
  }

  @override
  void dispose() {
    _glowCtrl.dispose();
    for (var c in otpControllers) c.dispose();
    for (var f in focusNodes) f.dispose();
    super.dispose();
  }

  void _onOtpChanged(int index, String value) {
    // Allow only digits
    if (value.isNotEmpty && !RegExp(r'^\d$').hasMatch(value)) {
      otpControllers[index].text = '';
      return;
    }

    if (value.length == 1 && index < 5) {
      focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      focusNodes[index - 1].requestFocus();
    }

    final otp = otpControllers.map((c) => c.text).join();
    if (otp.length == 6) {
      controller.otpController.text = otp;
      controller.verifyOtp();
    }
    setState(() {}); // refresh filled state UI
  }

  Future<void> _pasteFromClipboard() async {
    final data = await Clipboard.getData('text/plain');
    final text = (data?.text ?? '').replaceAll(RegExp(r'\D'), '');
    if (text.length >= 6) {
      for (int i = 0; i < 6; i++) {
        otpControllers[i].text = text[i];
      }
      FocusScope.of(context).unfocus();
      controller.otpController.text = text.substring(0, 6);
      controller.verifyOtp();
      setState(() {});
    }
  }

  Widget _otpBox(int index, {double size = 56}) {
    final filled = otpControllers[index].text.isNotEmpty;
    final isFocused = focusedIndex == index && focusNodes[index].hasFocus;

    return SizedBox(
      width: size,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: isFocused
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    _Brand.primary.withOpacity(0.35),
                    _Brand.accent.withOpacity(0.35),
                  ],
                )
              : null,
          color: isFocused
              ? null
              : Colors.white.withOpacity(0.12), // glass fill
          border: Border.all(
            color: isFocused
                ? _Brand.accent.withOpacity(0.9)
                : (filled
                      ? Colors.white.withOpacity(0.35)
                      : Colors.white.withOpacity(0.18)),
            width: isFocused ? 1.4 : 1.0,
          ),
          boxShadow: isFocused
              ? [
                  BoxShadow(
                    blurRadius: 18,
                    spreadRadius: 1,
                    color: _Brand.accent.withOpacity(0.18),
                  ),
                ]
              : null,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Center(
          child: TextField(
            controller: otpControllers[index],
            focusNode: focusNodes[index],
            maxLength: 1,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              letterSpacing: 1.2,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
            decoration: const InputDecoration(
              counterText: "",
              border: InputBorder.none,
            ),
            onChanged: (value) => _onOtpChanged(index, value),
          ),
        ),
      ),
    );
  }

  Widget _brandGradientBackground() {
    // Animated, soft moving blobs (very subtle)
    return AnimatedBuilder(
      animation: _glowCtrl,
      builder: (_, __) {
        final t = _glowCtrl.value;
        return Stack(
          children: [
            // Base gradient
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(-1, -1),
                  end: Alignment(1, 1),
                  colors: [Color(0xFF1B1F3B), _Brand.bgDark],
                ),
              ),
            ),
            // Floating radial accents
            Positioned(
              left: -120 + 40 * t,
              top: -100 + 30 * (1 - t),
              child: _radial(260, _Brand.primary.withOpacity(0.30)),
            ),
            Positioned(
              right: -100 + 30 * (1 - t),
              bottom: -120 + 40 * t,
              child: _radial(320, _Brand.accent.withOpacity(0.26)),
            ),
          ],
        );
      },
    );
  }

  Widget _radial(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [BoxShadow(blurRadius: 64, color: color, spreadRadius: 12)],
      ),
    );
  }

  Widget _glassPanel({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Colors.white.withOpacity(0.08),
            border: Border.all(color: Colors.white.withOpacity(0.16)),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _phoneEntry(BuildContext context, bool isLarge) {
    return _glassPanel(
      child: Padding(
        padding: EdgeInsets.all(isLarge ? 32 : 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Heading
            Text(
              "Verify your phone",
              style: TextStyle(
                fontSize: isLarge ? 32 : 24,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "We’ll send a 6-digit code to your mobile number.",
              style: TextStyle(
                fontSize: isLarge ? 16 : 14,
                color: Colors.white.withOpacity(0.85),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: controller.phoneController,
              keyboardType: TextInputType.phone,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "e.g. 016xxxxxxxx",
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                filled: true,
                fillColor: Colors.white.withOpacity(0.08),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.18)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: _Brand.accent,
                    width: 1.4,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: controller.otpRequestState.value == ApiState.loading
                    ? null
                    : () => controller.requestOtp(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _Brand.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: controller.otpRequestState.value == ApiState.loading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        "Send OTP",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _otpEntry(BuildContext context, bool isLarge) {
    final w = MediaQuery.of(context).size.width;
    final boxSize = w >= 1000 ? 64 : (w >= 600 ? 58 : 52);

    String maskedPhone(String raw) {
      final digits = raw.replaceAll(RegExp(r'\D'), '');
      if (digits.length < 11) return raw;
      return "${digits.substring(0, 3)}****${digits.substring(digits.length - 4)}";
    }

    return _glassPanel(
      child: Padding(
        padding: EdgeInsets.all(isLarge ? 32 : 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Heading + helper
            Text(
              "Enter verification code",
              style: TextStyle(
                fontSize: isLarge ? 30 : 22,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "We sent a 6-digit code to ${maskedPhone(controller.phoneController.text)}",
              style: TextStyle(
                fontSize: isLarge ? 16 : 14,
                color: Colors.white.withOpacity(0.85),
              ),
            ),
            const SizedBox(height: 24),

            // OTP boxes
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                6,
                (i) => _otpBox(i, size: boxSize.toDouble()),
              ),
            ),

            const SizedBox(height: 16),

            // Tiny progress bar for resend time
            Obx(() {
              final remaining = controller.resendTime.value;
              final max = 60; // add this in controller if not present
              final progress = remaining > 0 ? (1 - (remaining / max)) : 1.0;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 6,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: progress.clamp(0, 1),
                        backgroundColor: Colors.white.withOpacity(0.10),
                        color: _Brand.accent,
                        minHeight: 6,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: remaining > 0
                        ? Text(
                            "Resend OTP in ${remaining}s",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                            ),
                          )
                        : TextButton(
                            onPressed: () => controller.requestOtp(),
                            style: TextButton.styleFrom(
                              foregroundColor: _Brand.accent,
                            ),
                            child: const Text("Resend OTP"),
                          ),
                  ),
                ],
              );
            }),

            const SizedBox(height: 4),

            // Helper row: paste from clipboard
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.content_paste_go,
                  size: 18,
                  color: Colors.white.withOpacity(0.9),
                ),
                const SizedBox(width: 6),
                TextButton(
                  onPressed: _pasteFromClipboard,
                  style: TextButton.styleFrom(foregroundColor: Colors.white),
                  child: const Text("Paste code"),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Verify button
            SizedBox(
              height: 56,
              child: Obx(() {
                final isLoading =
                    controller.otpVerifyState.value == ApiState.loading;
                return ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          controller.otpController.text = otpControllers
                              .map((c) => c.text)
                              .join();
                          controller.verifyOtp();
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _Brand.accent,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text(
                          "Verify",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLarge =
        MediaQuery.of(context).size.width >=
        1000; // bigger than your 800 breakpoint for split
    final isSmall = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: _Brand.bgDark,
      body: Stack(
        children: [
          _brandGradientBackground(),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isLarge ? 48 : 20,
                vertical: isSmall ? 16 : 24,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Obx(() {
                    final isOtpPhase =
                        controller.otpRequestState.value == ApiState.loaded;

                    // Split layout on large screens, stacked on small/medium
                    if (isLarge) {
                      return Row(
                        children: [
                          // Left: Art panel / value prop
                          Expanded(
                            child: _glassPanel(
                              child: Container(
                                padding: const EdgeInsets.all(28),
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Logo circle
                                    Container(
                                      width: 84,
                                      height: 84,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.white.withOpacity(0.25),
                                            Colors.white.withOpacity(0.12),
                                          ],
                                        ),
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.2),
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.lock_rounded,
                                        size: 40,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    const Text(
                                      "Secure Sign-In",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "Your one-time code keeps your account safe.\nFast, simple, protected.",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.85),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 24),
                          // Right: Form panel
                          Expanded(
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 280),
                              child: isOtpPhase
                                  ? _otpEntry(context, true)
                                  : _phoneEntry(context, true),
                            ),
                          ),
                        ],
                      );
                    }

                    // Small/Medium screens: stacked card
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 280),
                      child: isOtpPhase
                          ? _otpEntry(context, false)
                          : _phoneEntry(context, false),
                    );
                  }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
