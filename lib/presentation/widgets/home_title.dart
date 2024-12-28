import 'package:flutter/material.dart';
import 'package:hrh_pos/core/core.dart';
import 'package:hrh_pos/core/extensions/extensions.dart';

import '../../../core/components/search_input.dart';
import '../../../core/constants/colors.dart';



class HomeTitle extends StatelessWidget {
  final TextEditingController controller;
  final Function(String value)? onChanged;

  const HomeTitle({
    super.key,
    required this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              Assets.images.logo.path,
              width: MediaQuery.of(context).size.width * 0.05,
              height: 100,
              color: AppColors.primary,
            ),
            const Text(
              'Point on Sale',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              DateTime.now().toFormattedDate(),
              style: const TextStyle(
                color: AppColors.subtitle,
                fontSize: 16,
              ),
            ),
          ],
        ),
        SizedBox(
          width: 260.0,
          child: SearchInput(
            controller: controller,
            onChanged: onChanged,
            hintText: 'Search for food, coffe, etc..',
          ),
        ),
      ],
    );
  }
}
