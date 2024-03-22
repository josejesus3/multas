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
      ),
      const SizedBox(
        width: 40,
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
      padding: const EdgeInsets.only(
        bottom: 10,
      ),
      child: TextField(
        controller: searchController,
        onEditingComplete: () {
          //searching!();
        },
        style: const TextStyle(color: Colors.black),
        cursorColor: Colors.black,
        autofocus: true,
        decoration: const InputDecoration(
          focusColor: Colors.black12,
          focusedBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
          enabledBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
        ),
      ),
    ),
    actions: [
      IconButton(icon: const Icon(Icons.search), onPressed: () {}),
      const SizedBox(
        width: 40,
      )
    ],
  );
}
