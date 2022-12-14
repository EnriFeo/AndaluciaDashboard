import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart';
import 'package:html/parser.dart';

import '../models/product_model.dart';

class Requests {
  static Future<Document?> _get(String url) async {
    return await http
        .get(
          Uri.parse(url),
        )
        .then(
          (res) => Document.html(res.body),
        )
        .catchError(
      (error) {
        if (error is HandshakeException) {
          print("handshake Exception");
          return null;
        } else {
          return null;
        }
      },
    );
  }

  static Future<List<Product>> getAndaluciaProducts() async {
    String URL = "https://pinturas-andalucia.com/";

    var partenza = DateTime.now();
    print("inizio");
    var doc = await _get(URL);
    if (doc != null) {
      var urls = [];
      if (doc.querySelector("#cbp-hrmenu-tab-7 > a") != null) {
        urls.add(
            doc.querySelector("#cbp-hrmenu-tab-7 > a")!.attributes['href']);
      }
      if (doc.querySelector("#cbp-hrmenu-tab-11 > a") != null) {
        urls.add(
            doc.querySelector("#cbp-hrmenu-tab-11 > a")!.attributes['href']);
      }
      if (doc.querySelector("#cbp-hrmenu-tab-12 > a") != null) {
        urls.add(
            doc.querySelector("#cbp-hrmenu-tab-12 > a")!.attributes['href']);
      }
      var pages = await Future.wait(
        urls.map(
          (url) => _get(
            Uri.parse(Uri.parse(URL).origin).resolve(url).toString(),
          ).then(
            (doc) {
              if (doc != null) {
                var sections = doc.querySelectorAll(
                    ".product-list-subcategories > .row > .col-6.col-md-6.col-lg-2");
                if (sections.isNotEmpty) {
                  return sections.map((section) => section
                      .querySelector("a.subcategory-name")!
                      .attributes['href']);
                }
              }
            },
          ),
        ),
      );
      List<String> newPages = <String>[];
      for (int i = 0; i < pages.length; i++) {
        if (pages[i] != null) {
          for (int j = 0; j < pages[i]!.length; j++) {
            if ((pages.elementAt(i))!.elementAt(j) != null) {
              newPages.add(
                  "${((pages.elementAt(i))!.elementAt(j) as String)}?resultsPerPage=9999999");
            }
          }
        }
      }

      var results = await Future.wait(
        newPages
            .map(
              (page) => _get(page).then((doc) async {
                if (doc == null) {
                  return [];
                }
                return doc
                    .querySelectorAll(
                  "#js-product-list > div.products.row.products-grid > div",
                )
                    .map(
                  (item) {
                    return Product(
                      img: item
                          .querySelector(
                              "article > div.thumbnail-container > a > img")!
                          .attributes["src"],
                      name: item
                          .querySelector(
                              "article > div.product-description > div > h3")!
                          .text
                          .trim(),
                      url: item
                          .querySelector(
                              "article > div.product-description > div > h3 > a")!
                          .attributes['href']!,
                      price: double.parse(parseFragment(item
                              .querySelector(
                                  "article > div.product-description > div > div.product-price-and-shipping > span")!
                              .text
                              .trim())
                          .text!
                          .split(RegExp('\\s+'))
                          .first
                          .trim()
                          .replaceAll(RegExp("\\."), "")
                          .replaceAll(",", ".")),
                    );
                  },
                ).toList();
              }).catchError((error) {
                if (error is HandshakeException) {
                  print("handShakeError");
                } else {}
                return null;
              }),
            )
            .toList(),
      );
      List<Product> ret = <Product>[];
      print("fine - tempo: ${DateTime.now().difference(partenza)}");
      for (var i in results) {
        for (var j in i) {
          ret.add(j);
        }
      }
      return ret;
    } else {
      return [];
    }
  }
}
