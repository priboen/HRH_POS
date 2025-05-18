import 'package:flutter/material.dart';

class ItemSalesReportPage extends StatefulWidget {
  const ItemSalesReportPage({super.key});

  @override
  State<ItemSalesReportPage> createState() => _ItemSalesReportPageState();
}

class _ItemSalesReportPageState extends State<ItemSalesReportPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
        ),
      ),
    );
  }
}
