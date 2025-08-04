import 'package:assurance_bookstore/src/core/helper/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CustomPasswordField extends StatelessWidget {
  final TextEditingController textEditingController;
  final String? title;
  final String? placeHolder;
  final Color color;
  final double borderRadius;
  final Function? onValue;
  final Widget? prefixIcon;
  final double height;
  final String? Function(String?)? validator;
  final bool isRequired;

  CustomPasswordField({
    super.key,
    required this.textEditingController,
    this.title,
    this.placeHolder,
    this.isRequired = false,
    this.color = const Color(0xffffffff),
    this.borderRadius = 5,
    this.onValue,
    this.prefixIcon,
    this.validator,
    this.height = 55,
  });

  final obscureText = true.obs;

  final hasError = false.obs;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: title != null,
          child: Text(title ?? "", style: context.displayMedium),
        ),
        SizedBox(height: 5.h),
        Obx(
          () => AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: hasError.value ? (height + 20).h : height.h,
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 1.w,
                  ),
                  borderRadius: BorderRadius.circular(borderRadius).r,
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 1.w),
                  borderRadius: BorderRadius.circular(borderRadius).r,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius).r,
                  borderSide: BorderSide(color: Colors.grey),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red, width: 1.0),
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                contentPadding: const EdgeInsets.all(15).r,
                errorStyle: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                  fontSize: 10.sp,
                ),
                prefixIconConstraints: BoxConstraints(
                  minHeight: 25.w,
                  minWidth: 25.w,
                ),
                fillColor: color,
                filled: true,
                hintText: placeHolder,
                hintStyle: Theme.of(
                  context,
                ).textTheme.displaySmall?.copyWith(color: Colors.grey),
                prefixIcon: prefixIcon,
                suffixIcon: Obx(
                  () => GestureDetector(
                    onTap: () {
                      obscureText.toggle();
                    },
                    child: Icon(
                      obscureText.value
                          ? Icons.remove_red_eye
                          : Icons.remove_red_eye_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
              onChanged: (value) => onValue != null ? onValue!(value) : null,
              controller: textEditingController,
              validator: (value) {
                String? err;
                if (validator != null) {
                  err = validator!(value);
                } else {
                  if (isRequired && (value == null || value.isEmpty)) {
                    err = "This field is required";
                  }
                }
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  hasError.value = err != null;
                });
                return err;
              },
              style: TextStyle(fontSize: 15.sp, color: Colors.black),
              obscureText: obscureText.value,
            ),
          ),
        ),
      ],
    );
  }
}
