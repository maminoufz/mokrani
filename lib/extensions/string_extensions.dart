import 'package:flutter/material.dart';
import '../services/app_localizations.dart';

extension StringExtension on String {
  String tr(BuildContext context) {
    return AppLocalizations.of(context).translate(this);
  }
}
