import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Widget getAppBarSearching(TextEditingController searchController,
    VoidCallback onEditingComplete, VoidCallback? onPressed) {
  final outlineBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: const BorderSide(color: Colors.black26));
  return Padding(
    padding: const EdgeInsets.only(right: 60),
    child: SizedBox(
      width: 350,
      height: 40,
      child: TextField(
        controller: searchController,
        onEditingComplete: onEditingComplete,
        style: const TextStyle(color: Colors.black, fontSize: 12),
        cursorColor: Colors.black,
        autofocus: true,
        decoration: InputDecoration(
          hintText: 'Ingresa Placa o Fecha',
          icon: Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) {
              return IconButton(
                  icon: const Icon(Icons.clear), onPressed: onPressed);
            },
          ),
          focusColor: Colors.black12,
          focusedBorder: outlineBorder,
          enabledBorder: outlineBorder,
          suffixIcon: IconButton(
              icon: const Icon(Icons.search), onPressed: onEditingComplete),
        ),
      ),
    ),
  );
}
