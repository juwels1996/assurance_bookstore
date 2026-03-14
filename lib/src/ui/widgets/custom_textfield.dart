import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';


class CustomTextField extends StatelessWidget {
  final TextEditingController? textEditingController;
  final String? title;
  final String? placeHolder;
  final bool readOnly;
  final bool isRequired;
  final int maxLine;
  final Color color;
  final double borderRadius;
  final TextInputType textInputType;
  final Function? onValue;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  final String? Function(String)? onFieldSubmitted;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? hintStyle;
  final TextStyle? style;
  final TextStyle? labelStyle;
  final double height;
  final BoxDecoration? decoration;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;

  CustomTextField({
    super.key,
    this.textEditingController,
    this.title,
    this.placeHolder,
    this.readOnly = false,
    this.isRequired = false,
    this.color = const Color(0xffffffff),
    this.borderRadius = 5,
    this.maxLine = 1,
    this.height = 55,
    this.textInputType = TextInputType.text,
    this.prefixIcon,
    this.onValue,
    this.validator,
    this.contentPadding,
    this.inputFormatters,
    this.decoration,
    this.hintStyle,
    this.style,
    this.labelStyle,
    this.focusNode,
    this.onFieldSubmitted,
    this.suffixIcon,
  });

  final hasError = false.obs;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: title != null,
          child: Column(
            children: [
              Row(
                children: [
                  Visibility(
                    visible: isRequired,
                    child: Text(
                      "* ",
                      style: Theme.of(
                        context,
                      ).textTheme.titleSmall?.copyWith(color: Colors.red),
                    ),
                  ),
                  Text(title ?? "", style: labelStyle),
                ],
              ),
              SizedBox(height: 5),
            ],
          ),
        ),
        Obx(
              () => AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: hasError.value ? (height + 20) : height,
            decoration: decoration,
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              focusNode: focusNode,
              onFieldSubmitted: onFieldSubmitted,
              decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 1),
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red, width: 1.0),
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                contentPadding: contentPadding ?? const EdgeInsets.all(10),
                errorStyle: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                ),
                fillColor: color,
                filled: true,
                prefixIconConstraints: BoxConstraints(
                  minHeight: 25,
                  minWidth: 25,
                ),
                prefixIcon: prefixIcon,
                hintText: placeHolder,
                hintStyle:
                hintStyle ??
                    Theme.of(
                      context,
                    ).textTheme.displaySmall?.copyWith(color: Colors.grey),
                labelStyle: labelStyle,
                suffixIcon: suffixIcon,
              ),
              onChanged: (value) => onValue != null ? onValue!(value) : null,
              controller: textEditingController,
              readOnly: readOnly,
              validator: (value) {
                final error =
                isRequired && (value == null || value.isEmpty)
                    ? "$title is required"
                    : (validator != null ? validator!(value) : null);
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  hasError.value = error != null;
                });
                return error;
              },
              keyboardType: textInputType,
              inputFormatters: inputFormatters,
              style:
              style ??
                  TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
              maxLines: maxLine,
            ),
          ),
        ),
      ],
    );
  }
}
