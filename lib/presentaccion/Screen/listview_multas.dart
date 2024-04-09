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
    final size = MediaQuery.of(context).size;
    final textStyle = Theme.of(context).textTheme;

    return Scaffold(
      bottomNavigationBar: CustomBottonNavigation(
        index: index,
        ref: ref,
      ),
      body: FutureBuilder<List<ListMultas>>(
        future: ConnectionMysql().selectQuery(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              strokeWidth: 2,
            )); // Muestra un indicador de carga mientras se espera la respuesta de la base de datos.
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final List<ListMultas> multas =
                snapshot.data ?? []; // Obtiene los datos del snapshot

            return ListView.builder(
              itemCount: multas.length,
              itemBuilder: (context, index) {
                final multa = multas[index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  child: Container(
                    height: 65,
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        multa.infraccion != true
                            ? Icon(
                                Icons.dangerous_outlined,
                                color: Colors.red.shade500,
                              )
                            : Icon(
                                Icons.check_circle_outline,
                                color: Colors.green.shade500,
                              ),
                        Text('Placa:  ${multa.placa.toString()}',
                            style: textStyle.titleLarge),
                        Text('Fechada:  ${multa.fecha.toString()}',
                            style: textStyle.titleLarge),
                        Text('Importe:  ${multa.cantidad.toString()}',
                            style: textStyle.titleLarge),
                        Text('Folio Pago:  ${multa.folioPago}',
                            style: textStyle.titleLarge),
                        IconButton(
                            onPressed: () {
                              ConnectionMysql()
                                  .deleteQuery(multa, multa.placa.toString());
                            },
                            icon: const Icon(Icons.delete_forever_outlined))
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
