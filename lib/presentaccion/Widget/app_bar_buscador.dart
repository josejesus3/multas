import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multas/presentaccion/provider/read_provider.dart';

AppBar getAppBarNotSearching(double sized, GestureTapCallback? onTap) {
  return AppBar(
    title: InkWell(
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 40),
        child: Container(
            width: sized,
            decoration: const BoxDecoration(
                border: BorderDirectional(bottom: BorderSide(width: 0.2))),
            padding: const EdgeInsets.only(
              bottom: 10,
            ),
            child: const Text('Multas')),
      ),
    ),
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
        width: 60,
      )
    ],
  );
}

AppBar getAppBarSearching(TextEditingController searchController,
    VoidCallback onEditingComplete, VoidCallback? onPressed) {
  return AppBar(
    automaticallyImplyLeading: false,
    leading: Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        return IconButton(icon: const Icon(Icons.clear), onPressed: onPressed);
      },
    ),
    title: Padding(
      padding: const EdgeInsets.only(
        bottom: 10,
      ),
      child: TextField(
        controller: searchController,
        onEditingComplete: onEditingComplete,
        style: const TextStyle(color: Colors.black),
        cursorColor: Colors.black,
        autofocus: true,
        decoration: const InputDecoration(
          focusColor: Colors.black12,
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black26)),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black12)),
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
