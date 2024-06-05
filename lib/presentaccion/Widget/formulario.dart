import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multas/domain/conexion/connection_mysql.dart';
import 'package:multas/domain/entiti/list_multas.dart';
import 'package:multas/presentaccion/provider/read_provider.dart';

class Formulario extends ConsumerStatefulWidget {
  final TextEditingController placaController;
  final TextEditingController cantidadController;
  final TextEditingController fechaController;
  final TextEditingController folioController;
  final TextEditingController folioPagoController;
  final TextEditingController cantidadFolioController;
  final TextEditingController fechasPagoController;
  final TextEditingController foraneasController;

  const Formulario({
    required this.placaController,
    required this.cantidadController,
    required this.fechaController,
    required this.folioController,
    required this.folioPagoController,
    required this.cantidadFolioController,
    required this.fechasPagoController,
    required this.foraneasController,
    super.key,
  });

  @override
  FormularioState createState() => FormularioState();
}

class FormularioState extends ConsumerState<Formulario> {
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
          _Campos(
            textController: widget.placaController,
            label: 'Placa',
            icon: Icons.car_crash_outlined,
          ),
          _Campos(
            textController: widget.cantidadController,
            label: 'Cantidad',
            icon: Icons.currency_exchange,
            numericOnly: true,
          ),
          _Campos(
            textController: widget.fechaController,
            label: 'Fecha',
            icon: Icons.calendar_month_sharp,
            helper: 'Ejemplo: 22/03/2024',
          ),
          _Campos(
            textController: widget.folioController,
            label: 'Folio',
            icon: Icons.car_crash_outlined,
            numericOnly: true,
          ),
          _Campos(
            textController: widget.folioPagoController,
            label: 'Folio de pago',
            icon: Icons.folder_outlined,
          ),
          _Campos(
            textController: widget.cantidadFolioController,
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
            textController: widget.fechasPagoController,
            label: 'Fecha de Pago',
            icon: Icons.calendar_month_outlined,
            helper: 'Ejemplo: 22/03/2024',
          ),
          _Campos(
            textController: widget.foraneasController,
            label: 'Foraneas',
          ),
          _ButtonAction(
            onPressed: () {
              _validacion(
                context,
                municipio,
                status,
                widget.placaController.text,
                widget.cantidadController.text,
                widget.fechaController.text,
                widget.folioController.text,
                widget.folioPagoController.text,
                widget.cantidadFolioController.text,
                check,
                widget.fechasPagoController.text,
                widget.foraneasController.text,
              );
            },
            icon: Icons.add_circle_outlined,
            label: 'Agregar',
          ),
          _ButtonAction(
            onPressed: () {
              _limpiarCampos();
            },
            icon: Icons.delete_forever,
            label: 'Cancelar',
          ),
          _ButtonAction(
            onPressed: () {
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
                placa: widget.placaController.text,
                cantidad: double.parse(
                  widget.cantidadController.text,
                ),
                fecha: widget.fechaController.text,
                folio: int.parse(widget.folioController.text),
                folioPago: widget.folioPagoController.text,
                cantidadPago: double.parse(widget.cantidadFolioController.text),
                infraccion: check,
                fechaPago: widget.fechasPagoController.text,
                foraneas: widget.foraneasController.text,
              );

              ConnectionMysql().updateQuery(multa, widget.placaController.text);
            },
            icon: Icons.add_circle_outlined,
            label: 'Modificar',
          ),
        ],
      ),
    );
  }

  void _limpiarCampos() {
    widget.placaController.clear();
    widget.cantidadController.clear();
    widget.fechaController.clear();
    widget.folioController.clear();
    widget.folioPagoController.clear();
    widget.cantidadFolioController.clear();
    widget.fechasPagoController.clear();
    widget.foraneasController.clear();
    ref.read(checkBox.notifier).state = false;
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
    String foraneas,
  ) {
    if (placa.isEmpty ||
        cantidad.isEmpty ||
        fecha.isEmpty ||
        folio.isEmpty ||
        folioPago.isEmpty ||
        cantidadFolio.isEmpty ||
        fechasPago.isEmpty ||
        foraneas.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(milliseconds: 500),
          backgroundColor: Colors.black12,
          content: ListTile(
            title: Text('Algo salió mal'),
            subtitle: Text('Revisar, existen campos vacíos'),
          ),
        ),
      );
    } else {
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
        foraneas: foraneas,
      );

      ConnectionMysql().insertQuery(multa);
    }
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
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        width: sized.width <= 800 ? sized.width * 0.7 : sized.width * 0.2,
        child: TextField(
          controller: textController,
          keyboardType: numericOnly ? TextInputType.number : null,
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
