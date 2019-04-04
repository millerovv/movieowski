import 'package:flutter/material.dart';
import 'package:movieowski/src/utils/consts.dart';

/// Get color for rating circle depending on rating value
Color calculateRatingColor(double rating) {
  if (rating >= 7.5) {
    return AppColors.green;
  } else if (rating >= 6.5) {
    return AppColors.lightGreen;
  } else if (rating >= 5.5) {
    return AppColors.yellow;
  } else if (rating >= 4.5) {
    return AppColors.orange;
  } else if (rating != 0.0) {
    return AppColors.red;
  } else {
    return AppColors.hintGrey;
  }
}