import 'package:collection/collection.dart';
import 'package:andalucia_dashboard/models/product_model.dart';
import 'package:flutter/material.dart';

import 'content_page.dart';
import '../utils/utils.dart';

class HomePage extends StatefulWidget {
  String title = "Pinturas Andalucia";

  List<Product> andaluciaProducts = [];
  bool gotAndaluciaProducts = false;
  bool andaaluciaPerforming = false;

  List<Product> andaluciaDuplicatedItems = [];
  List<Product> andaluciaNullPricedItems = [];

  List<Product> emucrilProducts = [];
  bool gotEmucrilProducts = false;
  bool emucrilPerforming = false;

  List<Product> emucrilDuplicatedItems = [];
  List<Product> emucrilNullPricedItems = [];

  String _selected = "PA";

  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void setSelected(String selected) {
    setState(() {
      if (selected == "PA" || selected == "PE") {
        widget._selected = selected;
        switch (selected) {
          case "PA":
            widget.title = "Pinturas Andalucia";
            break;
          case "PE":
            widget.title = "Pinturas Emucril";
            break;
        }
      }
    });
  }

  void setAndaluciaProducts(value) {
    setState(() {
      widget.andaluciaProducts = value;
    });
  }

  void getAndaluciaProducts() async {
    setState(() {
      widget.andaaluciaPerforming = true;
    });
    List<Product> res = [];
    while (res.isEmpty) {
      res = (await Requests.getAndaluciaProducts());
    }
    List<String> tmpArray = [];
    List<Product> tmpDuplicated = [];
    groupBy(res, (p0) => p0.name).forEach((key, value) {
      var gBUrl = groupBy(value, (p1) => p1.url);
      if (gBUrl.keys.length > 1) {
        gBUrl.forEach((key, value) => tmpDuplicated.add(value[0]));
      }
    });
    List<Product> tmpNullPrice = [];
    for (var element in res) {
      if (element.price == 0.0 && !tmpNullPrice.contains(element)) {
        tmpNullPrice.add(element);
      }
    }
    setState(() {
      widget.andaluciaDuplicatedItems.addAll(tmpDuplicated);
      widget.andaluciaNullPricedItems.addAll(tmpNullPrice);
      widget.andaaluciaPerforming = false;
      widget.gotAndaluciaProducts = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.gotAndaluciaProducts && !widget.andaaluciaPerforming) {
      getAndaluciaProducts();
    }

    return ContentPage(
      title: "Pinturas Andalucia",
      duplicatedItems: widget.andaluciaDuplicatedItems,
      gotItems: widget.gotAndaluciaProducts,
      nullPricedItems: widget.andaluciaNullPricedItems,
    );
  }
}
