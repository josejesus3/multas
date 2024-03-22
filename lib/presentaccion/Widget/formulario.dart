import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multas/domain/conexion/connection_mysql.dart';
import 'package:multas/domain/entiti/list_multas.dart';
import 'package:multas/presentaccion/provider/read_provider.dart';

class Formulario extends ConsumerStatefulWidget {
  const Formulario({
    super.key,
  });

  @override
  FormularioState createState() => FormularioState();
}

class FormularioState extends ConsumerState<Formulario> {
  TextEditingController placaController = TextEditingController();
  TextEditingController cantidadController = TextEditingController();
  TextEditingController fechaController = TextEditingController();
  TextEditingController folioController = TextEditingController();
  TextEditingController folioPagoController = TextEditingController();
  TextEditingController cantidadFolioController = TextEditingController();
  TextEditingController insfraccionController = TextEditingController();
  TextEditingController fechasPagoController = TextEditingController();
  TextEditingController foraneasController = TextEditingController();
  final int municipio = 72;
  final String status = 'A';
  @override
  Widget build(BuildContext context) {
    final sized = MediaQuery.of(context).size;
    final bool check = ref.watch(checkBox);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Wrap(
        children: [
          _TEXT(
            text: 'Municipio: ${municipio.toString()}',
            icon: Icons.house_outlined,
          ),
          _TEXT(
            text: 'Status: $status',
            icon: Icons.check_circle_outline,
          ),
          _Campos(
            textController: placaController,
            label: 'Placa',
            icon: Icons.car_crash_outlined,
          ),
          _Campos(
            textController: cantidadController,
            label: 'Cantidad',
            icon: Icons.currency_exchange,
            numericOnly: true,
          ),
          _Campos(
            textController: fechaController,
            label: 'Fecha',
            icon: Icons.calendar_month_sharp,
            helper: 'Ejemplo: 22/03/2024',
          ),
          _Campos(
            textController: folioController,
            label: 'Folio',
            icon: Icons.car_crash_outlined,
            numericOnly: true,
          ),
          _Campos(
            textController: folioPagoController,
            label: 'Folio de pago',
            icon: Icons.folder_outlined,
          ),
          _Campos(
            textController: cantidadFolioController,
            label: 'Cantidad de folio',
            icon: Icons.currency_exchange,
            numericOnly: true,
          ),
          Padding(
            padding: const EdgeInsets.all(30),
            child: SizedBox(
              width: sized.width <= 800 ? sized.width * 0.7 : sized.width * 0.2,
              child: CheckboxListTile(
                value: check,
                onChanged: (value) {
                  ref.read(checkBox.notifier).update((state) => !state);
                },
                title: const Text('Estado'),
                secondary: const Icon(Icons.check_circle_outlined),
              ),
            ),
          ),
          _Campos(
            textController: fechasPagoController,
            label: 'Fecha de Pago',
            icon: Icons.calendar_month_outlined,
            helper: 'Ejemplo: 22/03/2024',
          ),
          _Campos(
            textController: foraneasController,
            label: 'Foraneas',
          ),
          _ButtonAction(
            onPressed: () {
              setState(() {
                _validacion(
                    context,
                    municipio,
                    status,
                    placaController.text,
                    cantidadController.text,
                    fechaController.text,
                    folioController.text,
                    folioPagoController.text,
                    cantidadFolioController.text,
                    check,
                    fechasPagoController.text,
                    foraneasController.text);
              });
              print(check);
            },
            icon: Icons.add_circle_outlined,
            label: 'Agregar',
          ),
          _ButtonAction(
            onPressed: () {
              setState(() {
                placaController.clear();
                cantidadController.clear();
                fechaController.clear();
                folioController.clear();
                folioPagoController.clear();
                cantidadFolioController.clear();
                insfraccionController.clear();
                fechasPagoController.clear();
                foraneasController.clear();
              });
              ref.read(checkBox.notifier).state = false;
            },
            icon: Icons.delete_forever,
            label: 'Cancelar',
          )
        ],
      ),
    );
  }
}

class _TEXT extends StatelessWidget {
  final String text;
  final IconData icon;
  const _TEXT({required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, top: 38, right: 10),
      child: Container(
        width: 135,
        height: 40,
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color.fromARGB(62, 0, 0, 0), width: 1.8),
          ),
        ),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(
              width: 10,
            ),
            Text(text),
          ],
        ),
      ),
    );
  }
}

class _ButtonAction extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData? icon;
  final String label;
  const _ButtonAction({
    required this.onPressed,
    this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 45, horizontal: 10),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
      ),
    );
  }
}

class _Campos extends StatelessWidget {
  final TextEditingController textController;
  final IconData? icon;
  final String label;
  final bool numericOnly;
  final String? helper;
  const _Campos({
    required this.textController,
    required this.label,
    this.icon,
    this.helper,
    this.numericOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: Colors.black,
      ),
    );
    final sized = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(30),
      child: SizedBox(
        width: sized.width <= 800 ? sized.width * 0.7 : sized.width * 0.2,
        child: TextField(
          controller: textController,
          keyboardType: numericOnly
              ? TextInputType.number
              : null, // Solo números si se indica
          inputFormatters: numericOnly
              ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))]
              : null,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(8),
            label: Text(label),
            helperText: helper,
            prefixIcon: Icon(icon),
            focusedBorder: inputBorder,
          ),
        ),
      ),
    );
  }
}

void _validacion(
    BuildContext context,
    int municipio,
    String status,
    String placa,
    String cantidad,
    String fecha,
    String folio,
    String folioPago,
    String cantidadFolio,
    bool check,
    String fechasPago,
    String foraneas) {
  if (placa.isEmpty ||
      cantidad.isEmpty ||
      fecha.isEmpty ||
      folio.isEmpty ||
      folioPago.isEmpty ||
      cantidadFolio.isEmpty ||
      fechasPago.isEmpty ||
      foraneas.isEmpty) {
    print('entro');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        duration: Duration(milliseconds: 500),
        backgroundColor: Colors.black12,
        content: ListTile(
          title: Text('Algo salio Mal'),
          subtitle: Text('Revisar, Existen campos vacios'),
        ),
      ),
    );
  } else {
    print('entro excelente');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        duration: Duration(milliseconds: 500),
        backgroundColor: Colors.black12,
        content: ListTile(
          title: Text('Excelente'),
          subtitle: Text('Todo bien'),
        ),
      ),
    );
    ListMultas multa = ListMultas(
        municipio: municipio,
        status: status,
        placa: placa,
        cantidad: double.parse(cantidad),
        fecha: fecha,
        folio: int.parse(folio),
        folioPago: folioPago,
        cantidadPago: double.parse(cantidad),
        infraccion: check,
        fechaPago: fechasPago,
        foraneas: foraneas);

    ConnectionMysql().insertQuery(multa);
  }
}
