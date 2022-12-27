import 'package:flutter/material.dart';
import 'package:huzz/core/constants/app_themes.dart';

const dropdownNormalBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Corners.smRadius),
    borderSide: BorderSide(
      width: 0.9,
      color: AppColors.primaryColor,
    ));

const dropdownErrorBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Corners.smRadius),
    borderSide: BorderSide(
      width: 0.9,
      color: AppColors.error,
    ));
