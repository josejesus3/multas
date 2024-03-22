import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multas/presentaccion/provider/read_provider.dart';

AppBar getAppBarNotSearching() {
  return AppBar(
    title: const Text('Multas'),
    actions: [
      Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          return IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                ref.read(isSearching.notifier).state = true;
              });
        },
      )
    ],
  );
}

AppBar getAppBarSearching(TextEditingController searchController) {
  return AppBar(
    automaticallyImplyLeading: false,
    leading: Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        return IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              ref.read(isSearching.notifier).state = false;
            });
      },
    ),
    title: Padding(
      padding: const EdgeInsets.only(bottom: 10, right: 10),
      child: TextField(
        controller: searchController,
        onEditingComplete: () {
          //searching!();
        },
        style: const TextStyle(color: Colors.white),
        cursorColor: Colors.white,
        autofocus: true,
        decoration: const InputDecoration(
          focusColor: Colors.white,
          focusedBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          enabledBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        ),
      ),
    ),
  );
}
