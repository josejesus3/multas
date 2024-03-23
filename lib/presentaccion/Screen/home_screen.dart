import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multas/presentaccion/Widget/app_bar_buscador.dart';
import 'package:multas/presentaccion/Widget/custom_botton_navigator.dart';
import 'package:multas/presentaccion/Widget/formulario.dart';

import 'package:multas/presentaccion/provider/read_provider.dart';

class HomeScreen extends ConsumerWidget {
  static const String name = 'HomeScreen';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int index = ref.watch(currentIndex);
    final bool searching = ref.watch(isSearching);
    TextEditingController searchController = TextEditingController();

    return Scaffold(
      appBar: !searching
          ? getAppBarNotSearching()
          : getAppBarSearching(searchController),
      bottomNavigationBar: CustomBottonNavigation(index: index, ref: ref),
      body: const SingleChildScrollView(child: Formulario()),
    );
  }
}
