import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../ui/screen/auth/login_screen.dart';
import '../controllers/auth/auth_controller.dart';

int convertStringToInt(String value) {
  try {
    return value.isEmpty ? 0 : int.parse(value);
  } catch (err) {
    return 0;
  }
}

double convertStringToDouble(String value) {
  try {
    return value.isEmpty ? 0.0 : double.parse(value);
  } catch (err) {
    return 0;
  }
}

void showMassage(String? msg, {bool isSuccess = false}) {
  Fluttertoast.showToast(
    msg: msg ?? "",
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: isSuccess ? Colors.green : Colors.red,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

String getToken() {
  // return GetStorage().read(authToken) ?? "";
  return "";
}

String getAuthToken() {
  final token = getToken();
  return token.isNotEmpty ? 'Token $token' : "";
}

Future<bool> isInternetConnection() async {
  final result = await Connectivity().checkConnectivity();
  if (result.contains(ConnectivityResult.none)) {
    return false;
  } else {
    return true;
  }
}

void customModalSheet({
  required BuildContext context,
  required Widget content,
  void Function()? onDismiss,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Theme.of(context).primaryColorLight,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: const Radius.circular(10),
        topRight: const Radius.circular(10),
      ),
    ),
    builder: (ctx) => content,
  ).whenComplete(() {
    if (onDismiss != null) {
      onDismiss();
    }
  });
}

String formatIsoToCustomDate(String isoDate, {bool isTime = false}) {
  if (isoDate.isEmpty) {
    return "";
  }

  try {
    DateTime dateTime = DateTime.parse(isoDate).toLocal();

    String daySuffix = getDaySuffix(dateTime.day);
    String formattedDate = DateFormat(
      "MMM d'$daySuffix' yyyy",
    ).format(dateTime);

    String formattedTime = DateFormat("h:mm a").format(dateTime);

    if (isTime) {
      return "$formattedDate, $formattedTime";
    }

    return formattedDate;
  } catch (e) {
    return isoDate;
  }
}

void logout() {
  final controller = Get.find<AuthController>();
  // GetStorage().remove(authToken);
  // controller.isLogin(false);
  // controller.user.value = UserInfo();
  Get.offAll(() => LoginScreen());
}

String getDaySuffix(int day) {
  if (day >= 11 && day <= 13) {
    return 'th';
  }
  switch (day % 10) {
    case 1:
      return 'st';
    case 2:
      return 'nd';
    case 3:
      return 'rd';
    default:
      return 'th';
  }
}

//convert String datetime to formatted date for exmaple 2022-01-01T00:00:00.000Z to 01/01/2022

String convertStringToFormattedDate(String date) {
  if (date.isEmpty) {
    return "";
  }
  DateTime dateTime = DateTime.parse(date).toUtc();
  return DateFormat('dd/MM/yyyy').format(dateTime);
}

String formatTime(int seconds) {
  if (seconds < 60) {
    return '00:${seconds.toString().padLeft(2, '0')}';
  } else if (seconds < 3600) {
    final int minutes = seconds ~/ 60;
    final int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  } else {
    final int hours = seconds ~/ 3600;
    final int minutes = (seconds % 3600) ~/ 60;
    final int remainingSeconds = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}

Future<void> openUrl(String? url) async {
  if (url == null || url.isEmpty) {
    showMassage("No URL found");
    return;
  }
  try {
    final uri = url.contains("http") ? Uri.parse(url) : Uri.http(url, "");
    if (!await launchUrl(uri)) {
      showMassage("Could not launch $url");
    }
  } catch (err) {
    showMassage("Could not launch $url");
  }
}

Future<String?> getPdfPath() async {
  Directory? directory;
  try {
    if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    } else if (Platform.isAndroid) {
      directory = Directory('/storage/emulated/0/Download/cart24');
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
    }
  } catch (err) {
    Fluttertoast.showToast(msg: "ERROR");
  }
  return directory?.path;
}

String getStringFromCamelCase(String camelCase) {
  String result = "";
  for (int i = 0; i < camelCase.length; i++) {
    if (i == 0) {
      result += camelCase[i].toUpperCase();
      continue;
    }
    if (camelCase[i].toUpperCase() == camelCase[i]) {
      result += " ";
    }
    result += camelCase[i];
  }
  return result;
}

String formatTimeToAmPm(String time) {
  try {
    final parts = time.split(':');
    if (parts.length < 2) return time;
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    final dt = DateTime(0, 1, 1, hour, minute);
    return DateFormat('h:mm a').format(dt);
  } catch (e) {
    return time;
  }
}

Future<bool> checkStoragePermission() async {
  if (Platform.isAndroid) {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    final AndroidDeviceInfo info = await deviceInfoPlugin.androidInfo;
    if ((info.version.sdkInt) >= 33) {
      return true;
    }
  }
  bool isDenied = await Permission.storage.isDenied;
  if (isDenied) {
    // storage read and write permission
    PermissionStatus permissionStatus = await Permission.storage.request();
    if (permissionStatus.isGranted) {
      return true;
    } else {
      return false;
    }
  } else {
    return true;
  }
}

String formatDayName(String day) {
  switch (day.toLowerCase()) {
    case 'mon':
      return 'Monday';
    case 'tue':
      return 'Tuesday';
    case 'wed':
      return 'Wednesday';
    case 'thu':
      return 'Thursday';
    case 'fri':
      return 'Friday';
    case 'sat':
      return 'Saturday';
    case 'sun':
      return 'Sunday';
    default:
      return day;
  }
}

DateTime isoToDateTime(String isoDate) {
  if (isoDate.isEmpty) {
    return DateTime.now();
  }
  try {
    return DateTime.parse(isoDate).toLocal();
  } catch (e) {
    return DateTime.now();
  }
}
