import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multas/presentaccion/Widget/app_bar_buscador.dart';
import 'package:multas/presentaccion/Widget/formulario.dart';

import 'package:multas/presentaccion/provider/read_provider.dart';

class HomeScreen extends ConsumerWidget {
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
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) => ref.read(currentIndex.notifier).state = value,
        currentIndex: index,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
            ),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.list_alt_outlined,
            ),
            label: 'Lista de Multas',
          ),
        ],
      ),
      body: const SingleChildScrollView(child: Formulario()),
    );
  }
}
