import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multas/domain/conexion/connection_mysql.dart';
import 'package:multas/domain/entiti/list_multas.dart';
import 'package:multas/presentaccion/Widget/custom_botton_navigator.dart';
import 'package:multas/presentaccion/provider/read_provider.dart';

class ListViewMultas extends ConsumerStatefulWidget {
  static String name = 'ListViewMultas';
  const ListViewMultas({super.key});

  @override
  ListViewMultasState createState() => ListViewMultasState();
}

class ListViewMultasState extends ConsumerState<ListViewMultas> {
  @override
  Widget build(BuildContext context) {
    final int index = ref.watch(currentIndex);
    final sized = MediaQuery.of(context).size;
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

            return multas.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('lO SIENTO NO TIENES REGISTROS'),
                        SizedBox(
                          height: 10,
                        ),
                        Icon(Icons.assignment_late_outlined)
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 50, horizontal: 60),
                    child: SizedBox(
                        width: sized.width * 0.9,
                        child: DataTable(
                          border: TableBorder.all(),
                          columns: const [
                            DataColumn(label: Text('Estado')),
                            DataColumn(label: Text('Placa')),
                            DataColumn(label: Text('Fecha')),
                            DataColumn(label: Text('Importe')),
                            DataColumn(label: Text('Folio de pago')),
                          ],
                          rows: multas
                              .map((data) => DataRow(cells: [
                                    DataCell(Icon(data.infraccion == false
                                        ? Icons.error_outline
                                        : Icons.check_box)),
                                    DataCell(Text(data.placa.toString())),
                                    DataCell(Text(data.fecha.toString())),
                                    DataCell(
                                        Text(data.cantidadPago.toString())),
                                    DataCell(Row(
                                      children: [
                                        Text(data.folioPago.toString()),
                                        IconButton(
                                            onPressed: () {
                                              setState(() {
                                                ConnectionMysql().deleteQuery(
                                                    data.placa.toString());
                                              });
                                            },
                                            icon: const Icon(
                                                Icons.delete_forever))
                                      ],
                                    )),
                                  ]))
                              .toList(),
                        )
                        // Fila de encabezado

                        ),
                  );
          }
        },
      ),
    );
  }
}

class _Text extends StatefulWidget {
  final String data;
  const _Text({super.key, required this.data});

  @override
  State<_Text> createState() => _TextState();
}

class _TextState extends State<_Text> {
  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyMedium;
    return SizedBox(
      height: 50,
      width: 100,
      child: Center(
        child: Text(
          widget.data,
          style: textStyle,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _TitleWidget extends StatelessWidget {
  const _TitleWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        height: 50,
        padding: const EdgeInsets.only(bottom: 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(),
          ),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'Estado',
              style: textStyle.bodyMedium,
            ),
            Text(
              'Placa',
              style: textStyle.bodyMedium,
            ),
            Text(
              'Fechada',
              style: textStyle.bodyMedium,
            ),
            Text(
              'Importe',
              style: textStyle.bodyMedium,
            ),
            Text(
              'Folio de pago',
              style: textStyle.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
