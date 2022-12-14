import 'package:andalucia_dashboard/models/product_model.dart';
import 'package:andalucia_dashboard/widgets/widgets.dart';
import 'package:flutter/material.dart';

class ContentPage extends StatelessWidget {
  String title;

  List<Product>? duplicatedItems;
  List<Product>? nullPricedItems;

  bool gotItems;

  ContentPage({
    super.key,
    required this.title,
    required this.duplicatedItems,
    required this.nullPricedItems,
    required this.gotItems,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: Colors.grey.shade100,
      child: Column(
        children: [
          const SizedBox(height: 40),
          Text(title),
          const SizedBox(height: 70),
          Expanded(
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomList(
                    title: "Prodoctos duplicados",
                    list: duplicatedItems,
                    gotItems: gotItems,
                  ),
                  const SizedBox(width: 30),
                  CustomList(
                    title: "Prodoctos con precio cero",
                    list: nullPricedItems,
                    gotItems: gotItems,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
