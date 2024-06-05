import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multas/domain/conexion/connection_mysql.dart';
import 'package:multas/domain/entiti/list_multas.dart';
import 'package:multas/presentaccion/Widget/app_bar_buscador.dart';
import 'package:multas/presentaccion/Widget/custom_botton_navigator.dart';
import 'package:multas/presentaccion/Widget/formulario.dart';
import 'package:multas/presentaccion/provider/read_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  static const String name = 'HomeScreen';

  const HomeScreen({Key? key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen> {
  TextEditingController placaController = TextEditingController();
  TextEditingController cantidadController = TextEditingController();
  TextEditingController fechaController = TextEditingController();
  TextEditingController folioController = TextEditingController();
  TextEditingController folioPagoController = TextEditingController();
  TextEditingController cantidadFolioController = TextEditingController();
  TextEditingController insfraccionController = TextEditingController();
  TextEditingController fechasPagoController = TextEditingController();
  TextEditingController foraneasController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final int index = ref.watch(currentIndex);
    final textStyle = Theme.of(context).textTheme;
    TextEditingController searchController = TextEditingController();

    void searchMultas(String placa, String fecha) async {
      List<ListMultas> searchedMultas =
          await ConnectionMysql().selectQueryBusqueda(placa, fecha);
      if (searchedMultas.isNotEmpty) {
        // Mostrar los datos encontrados en los TextField
        setState(() {
          placaController.text = searchedMultas[0].placa!;
          cantidadController.text = searchedMultas[0].cantidadPago.toString();
          fechaController.text = searchedMultas[0].fecha!;
          folioController.text = searchedMultas[0].folio.toString();
          folioPagoController.text = searchedMultas[0].folioPago!;
          cantidadFolioController.text =
              searchedMultas[0].cantidadPago.toString();
          // Ajusta los demás campos según sea necesario
        });
      } else {
        // Si no se encontraron datos, puedes mostrar un mensaje o limpiar los campos
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(milliseconds: 500),
            backgroundColor: Colors.black12,
            content: ListTile(
              title: Text('No se encontraron multas'),
            ),
          ),
        );
        // Limpiar los TextField
        setState(() {
          placaController.clear();
          cantidadController.clear();
          fechaController.clear();
          folioController.clear();
          folioPagoController.clear();
          cantidadFolioController.clear();
          // Limpia los demás campos según sea necesario
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            const SizedBox(
              width: 20,
            ),
            Text(
              'Multas',
              style: textStyle!.titleLarge,
            ),
            const SizedBox(
              width: 20,
            ),
            Text(
              'Municipio: 72',
              style: textStyle.bodyLarge,
            ),
            const SizedBox(
              width: 20,
            ),
            Text(
              'Status: A',
              style: textStyle.bodyLarge,
            ),
            const Spacer(),
            getAppBarSearching(searchController, () {
              setState(() {
                searchMultas(searchController.text, searchController.text);
              });
            }, () {}),
          ],
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(10),
          child: Divider(),
        ),
      ),
      backgroundColor: Colors.white,
      bottomNavigationBar: CustomBottonNavigation(index: index, ref: ref),
      body: SingleChildScrollView(
        child: Formulario(
          placaController: placaController,
          cantidadController: cantidadController,
          fechaController: fechaController,
          folioController: folioController,
          folioPagoController: folioPagoController,
          cantidadFolioController: cantidadFolioController,
          insfraccionController: insfraccionController,
          fechasPagoController: fechasPagoController,
          foraneasController: foraneasController,
        ),
      ),
    );
  }
}
