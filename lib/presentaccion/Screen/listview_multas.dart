import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multas/domain/conexion/connection_mysql.dart';
import 'package:multas/domain/entiti/list_multas.dart';
import 'package:multas/presentaccion/Widget/app_bar_buscador.dart';
import 'package:multas/presentaccion/Widget/custom_botton_navigator.dart';
import 'package:multas/presentaccion/provider/read_provider.dart';

class ListViewMultas extends ConsumerStatefulWidget {
  static String name = 'ListViewMultas';
  const ListViewMultas({super.key});

  @override
  ListViewMultasState createState() => ListViewMultasState();
}

class ListViewMultasState extends ConsumerState<ListViewMultas> {
  List<ListMultas> multas = [];

  @override
  void initState() {
    super.initState();
    getMultas(); // Obtener multas al inicio
  }

  // Función para obtener todas las multas
  void getMultas() async {
    List<ListMultas> allMultas = await ConnectionMysql().selectQuery();
    setState(() {
      multas = allMultas;
    });
  }

  @override
  Widget build(BuildContext context) {
    final int index = ref.watch(currentIndex);
    final sized = MediaQuery.of(context).size;
    final bool searching = ref.watch(isSearching);
    TextEditingController searchController = TextEditingController();

    return Scaffold(
      bottomNavigationBar: CustomBottonNavigation(
        index: index,
        ref: ref,
      ),
      body: multas.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  getAppBarSearching(searchController, () {
                    setState(() {
                      searchMultas(
                          searchController.text, searchController.text);
                    });
                  }, () {
                    ref.read(isSearching.notifier).state = false;
                    setState(() {
                      getMultas();
                    });
                  }),
                  const Text('LO SIENTO, NO HAY REGISTROS'),
                  const SizedBox(
                    height: 10,
                  ),
                  const Icon(Icons.assignment_late_outlined)
                ],
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(
                  height: 30,
                ),
                getAppBarSearching(searchController, () {
                  setState(() {
                    searchMultas(searchController.text, searchController.text);
                  });
                }, () {
                  ref.read(isSearching.notifier).state = false;
                  setState(() {
                    getMultas();
                  });
                }),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 60),
                  child: SizedBox(
                    width: sized.width * 0.9,
                    child: DataTable(
                      border: TableBorder.all(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.black12,
                      ),
                      columns: const [
                        DataColumn(label: Text('Estado')),
                        DataColumn(label: Text('Placa')),
                        DataColumn(label: Text('Fecha')),
                        DataColumn(label: Text('Importe')),
                        DataColumn(label: Text('Folio de pago')),
                        DataColumn(label: Text('Acciones')),
                      ],
                      rows: multas
                          .map(
                            (data) => DataRow(
                              cells: [
                                DataCell(
                                  Row(
                                    children: [
                                      data.infraccion == false
                                          ? Container(
                                              decoration: BoxDecoration(
                                                color: Colors.red.shade200,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              width: 70,
                                              child: const Text(
                                                'Sin pagar',
                                                textAlign: TextAlign.center,
                                              ),
                                            )
                                          : Container(
                                              decoration: BoxDecoration(
                                                color: Colors.green.shade100,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              width: 70,
                                              child: const Text(
                                                'Pagada',
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                                DataCell(Text(data.placa.toString())),
                                DataCell(Text(data.fecha.toString())),
                                DataCell(Text(data.cantidadPago.toString())),
                                DataCell(Text(data.folioPago.toString())),
                                DataCell(
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        deleteMulta(data.placa.toString());
                                      });
                                    },
                                    icon: Icon(
                                      Icons.delete_forever,
                                      color: Colors.red.shade300,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  // Función para buscar multas por placa
  void searchMultas(String placa, fecha) async {
    List<ListMultas> searchedMultas =
        await ConnectionMysql().selectQueryBusqueda(placa, fecha);
    setState(() {
      multas = searchedMultas;
    });
  }

  // Función para eliminar una multa
  void deleteMulta(String placa) async {
    await ConnectionMysql().deleteQuery(placa);
    // Restaurar todas las multas después de eliminar
    getMultas();
  }
}
