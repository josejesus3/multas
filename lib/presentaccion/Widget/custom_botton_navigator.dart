import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:multas/presentaccion/provider/read_provider.dart';

class CustomBottonNavigation extends StatelessWidget {
  final WidgetRef ref;
  const CustomBottonNavigation({
    super.key,
    required this.index,
    required this.ref,
  });

  final int index;
  void selectIndex(BuildContext context, int value) {
    switch (value) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/listViewMultas');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final int index = ref.watch(currentIndex);
    return BottomNavigationBar(
      currentIndex: index,
      onTap: (value) {
        ref.read(currentIndex.notifier).state = value;
        selectIndex(context, value);
      },
      items: const [
        BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
            ),
            label: 'Inicio'),
        BottomNavigationBarItem(
          icon: Icon(Icons.list_alt_outlined),
          label: 'Lista de Multas',
        ),
      ],
    );
  }
}
