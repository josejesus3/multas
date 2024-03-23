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

  @override
  Widget build(BuildContext context) {
    final int index = ref.watch(currentIndex);
    return BottomNavigationBar(
      currentIndex: index,
      items: [
        BottomNavigationBarItem(
            icon: IconButton(
              onPressed: () {
                ref.read(currentIndex.notifier).update((state) => 0);
                context.go('/');
              },
              icon: const Icon(
                Icons.home_outlined,
              ),
            ),
            label: 'Inicio'),
        BottomNavigationBarItem(
          icon: IconButton(
            onPressed: () {
              ref.read(currentIndex.notifier).update((state) => 1);
              context.go('/listViewMultas');
            },
            icon: const Icon(Icons.list_alt_outlined),
          ),
          label: 'Lista de Multas',
        ),
      ],
    );
  }
}
