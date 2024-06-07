import 'dart:io';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multas/domain/conexion/connection_mysql.dart';
import 'package:multas/domain/entiti/list_multas.dart';
import 'package:multas/presentaccion/Widget/app_bar_buscador.dart';
import 'package:multas/presentaccion/Widget/custom_botton_navigator.dart';
import 'package:multas/presentaccion/provider/read_provider.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';

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

  void exportToExcel() async {
    // Obtener todos los datos de la base de datos
    List<ListMultas> multas = await ConnectionMysql().selectQuery();

    // Crear un nuevo libro Excel
    var excel = Excel.createExcel();
    var sheet = excel['Multas'];

    // Añadir encabezados
    sheet.appendRow([
      const TextCellValue('Estado'),
      const TextCellValue('Municipio'),
      const TextCellValue('Status'),
      const TextCellValue('Placa'),
      const TextCellValue('Cantidad'),
      const TextCellValue('Fecha'),
      const TextCellValue('Folio'),
      const TextCellValue('Folio de Pago'),
      const TextCellValue('Cantidad de Pago'),
      const TextCellValue('Infracción'),
      const TextCellValue('Fecha'),
      const TextCellValue('Foráneas'),
    ]);

    // Añadir filas de datos
    multas.forEach((multa) {
      sheet.appendRow([
        multa.infraccion!
            ? const TextCellValue('Pagada')
            : const TextCellValue('Sin pagar'),
        IntCellValue(multa.municipio),
        TextCellValue(multa.status),
        TextCellValue(multa.placa.toString()),
        DoubleCellValue(multa
            .cantidad!), // No es necesario llamar a toString() si el tipo es int
        TextCellValue(multa.fecha.toString()),
        TextCellValue(multa.folio.toString()),
        TextCellValue(multa.folioPago.toString()),
        DoubleCellValue(multa
            .cantidadPago!), // No es necesario llamar a toString() si el tipo es int
        BoolCellValue(multa
            .infraccion!), // No es necesario llamar a toString() si el tipo es bool
        TextCellValue(multa.fecha.toString()),
        TextCellValue(multa.foraneas!),
      ]);
    });

    // Guardar el archivo Excel en el almacenamiento externo
    DateTime now = DateTime.now();

    // Formatear la fecha actual en el formato deseado (por ejemplo, YYYY-MM)
    final String formattedDate = DateFormat('yyyy-MM').format(now);

    // Crear el nombre del archivo con la fecha actual
    String outputFile =
        "C:/Users/PC/Documents/MultasBD/multas_$formattedDate.xlsx";
    List<int>? fileBytes = excel.save();
    //print('saving executed in ${stopwatch.elapsed}');
    if (fileBytes != null) {
      File(join(outputFile))
        ..createSync(recursive: true)
        ..writeAsBytesSync(fileBytes);
    }

    // Mostrar un mensaje de éxito
  }

  @override
  Widget build(BuildContext context) {
    final int index = ref.watch(currentIndex);
    final sized = MediaQuery.of(context).size;
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
                      searchMultas(searchController.text, searchController.text,
                          double.parse(searchController.text));
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
                    searchMultas(searchController.text, searchController.text,
                        searchController.text);
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
                        DataColumn(label: Text('Cantidad')),
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
                                DataCell(Text(data.cantidad.toString())),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green.shade400,
        onPressed: exportToExcel,
        child: const Icon(
          Icons.file_download,
          color: Colors.white,
        ),
      ),
    );
  }

  // Función para buscar multas por placa
  void searchMultas(String placa, fecha, cantidad) async {
    List<ListMultas> searchedMultas =
        await ConnectionMysql().selectQueryBusqueda(placa, fecha, cantidad);
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
