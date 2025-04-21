// all_exports.dart
// imports
import '/core/utils/cache-helper.dart';

export 'functions.dart';
export 'constants.dart';
export 'cache-helper.dart';
export 'package:flutter/cupertino.dart';
export '/Layout.dart';
export '/core/pages/pages.dart';
export 'dart:developer' hide Flow;

String isDarkModekey = 'isDarkMode';
bool? isDarkMode = CacheHelper.getData(isDarkModekey);
String isLoggedInkey = 'isLoggedIn';
bool isLoggedIn = CacheHelper.getData(isLoggedInkey) ?? false;

//bool isLoggedIn = true;
