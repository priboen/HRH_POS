import 'package:flutter/material.dart';
import 'package:hrh_pos/core/constants/constants.dart';
import 'package:hrh_pos/core/core.dart';
import 'package:hrh_pos/core/extensions/build_context_ext.dart';

class QrisDialogPage extends StatelessWidget {
  final String imageUrl;
  final VoidCallback? onPayPressed;
  const QrisDialogPage({super.key, required this.imageUrl, this.onPayPressed});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'QRIS',
            style: TextStyle(
              color: AppColors.black,
              fontSize: 28,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Image.network(
            imageUrl,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Button.filled(
                width: 100, height: 40,
                onPressed: () {
                  context.pop();
                },
                label: 'Tutup',
              ),
              Spacer(),
              Button.filled(
                width: 100, height: 40,
                onPressed: () {
                  if(onPayPressed != null) {
                    onPayPressed!();
                  }
                  context.pop();
                },
                label: 'Bayar',
              ),
            ],
          )
        ],
      ),
    );
  }
}
