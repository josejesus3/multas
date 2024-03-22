import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multas/domain/conexion/connection_mysql.dart';
import 'package:multas/domain/entiti/list_multas.dart';
import 'package:multas/presentaccion/Widget/custom_botton_navigator.dart';
import 'package:multas/presentaccion/provider/read_provider.dart';

class ListViewMultas extends ConsumerWidget {
  static const String name = 'ListViewMultas';
  const ListViewMultas({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int index = ref.watch(currentIndex);

    return Scaffold(
      bottomNavigationBar: CustomBottonNavigation(
        index: index,
        ref: ref,
      ),
      body: FutureBuilder<List<ListMultas>>(
        future: ConnectionMysql().selectQuery(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // Muestra un indicador de carga mientras se espera la respuesta de la base de datos.
          } else if (snapshot.hasError) {
            print('${snapshot.error}');
            return Text('Error: ${snapshot.error}');
          } else {
            final List<ListMultas> multas =
                snapshot.data ?? []; // Obtiene los datos del snapshot

            return ListView.builder(
              itemCount: multas.length,
              itemBuilder: (context, index) {
                final multa = multas[index];
                return Text(multa.status);
              },
            );
          }
        },
      ),
    );
  }
}
