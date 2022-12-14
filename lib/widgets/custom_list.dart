import 'package:collection/collection.dart';
import 'package:andalucia_dashboard/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomList extends StatelessWidget {
  String title;
  List<Product>? list;
  bool gotItems;

  CustomList({
    super.key,
    required this.title,
    required this.list,
    required this.gotItems,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(title),
          const SizedBox(height: 30),
          Container(
              width: 535,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(9.0)),
                color: Colors.grey.shade400,
              ),
              child: list != null && list!.isNotEmpty
                  ? SizedBox(
                      height: 353,
                      child: title == "Prodoctos duplicados"
                          ? ListView(
                              children: groupBy(list!, (p0) => p0.name)
                                  .entries
                                  .map((ele) {
                                return ExpansionTile(
                                  title: Text(ele.key),
                                  children: ele.value
                                      .map(
                                        (e) => ListTile(
                                          title: Text(e.url),
                                          onTap: () async {
                                            if (await canLaunchUrl(
                                                Uri.parse(e.url))) {
                                              await launchUrl(Uri.parse(e.url));
                                            } else {
                                              Clipboard.setData(ClipboardData(
                                                      text: e.url))
                                                  .then((_) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                        "no puede abrir la url en el navegador, la url se ha añadido al portapapeles"),
                                                  ),
                                                );
                                              });
                                            }
                                          },
                                        ),
                                      )
                                      .toList(),
                                );
                              }).toList(),
                            )
                          : ListView.builder(
                              itemCount: list!.length,
                              itemBuilder: (_, index) {
                                final item = list![index];
                                return ListTile(
                                  title: Text(item.name),
                                  subtitle: Text(item.url),
                                  onTap: () async {
                                    if (await canLaunchUrl(
                                        Uri.parse(item.url))) {
                                      await launchUrl(Uri.parse(item.url));
                                    } else {
                                      Clipboard.setData(
                                              ClipboardData(text: item.url))
                                          .then((_) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                "no puede abrir la url en el navegador, la url se ha añadido al portapapeles"),
                                          ),
                                        );
                                      });
                                    }
                                  },
                                );
                              },
                            ),
                    )
                  : !gotItems
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 167.7, bottom: 167.7),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : const Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 167.7, bottom: 167.7),
                            child: Text("No hay productos incorrectos"),
                          ),
                        )),
        ],
      ),
    );
  }
}
