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
                : Container(
                    color: const Color.fromARGB(14, 0, 0, 0),
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 50,
                        ),
                        const _TitleWidget(),
                        Expanded(
                          child: ListView.builder(
                            itemCount: multas.length,
                            itemBuilder: (context, index) {
                              final multa = multas[index];
                              return Container(
                                height: 45,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  border: Border(bottom: BorderSide()),
                                ),
                                child: Row(
                                  children: [
                                    const SizedBox(
                                      width: 35,
                                    ),
                                    multa.infraccion != true
                                        ? Icon(
                                            Icons.dangerous_outlined,
                                            color: Colors.red.shade500,
                                          )
                                        : Icon(
                                            Icons.check_circle_outline,
                                            color: Colors.green.shade500,
                                          ),
                                    _Text(data: multa.placa.toString()),
                                    _Text(data: multa.fecha.toString()),
                                    IconButton(
                                        onPressed: () {
                                          ConnectionMysql().deleteQuery(
                                              multa.placa.toString());
                                          setState(() {
                                            ConnectionMysql().selectQuery();
                                          });
                                        },
                                        icon: const Icon(
                                            Icons.delete_forever_outlined)),
                                    const SizedBox(
                                      width: 50,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
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
    return Container(
      color: Colors.amber,
      height: 50,
      width: 100,
      child: Text(
        widget.data,
        style: textStyle,
        textAlign: TextAlign.center,
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
          children: [
            const SizedBox(
              width: 30,
            ),
            Text(
              'Estado',
              style: textStyle.bodyMedium,
            ),
            const Spacer(),
            Text(
              'Placa',
              style: textStyle.bodyMedium,
            ),
            const Spacer(),
            Text(
              'Fechada',
              style: textStyle.bodyMedium,
            ),
            const Spacer(),
            Text(
              'Importe',
              style: textStyle.bodyMedium,
            ),
            const Spacer(),
            Text(
              'Folio de pago',
              style: textStyle.bodyMedium,
            ),
            const SizedBox(
              width: 40,
            ),
          ],
        ),
      ),
    );
  }
}
