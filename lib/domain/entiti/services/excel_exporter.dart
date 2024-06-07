import 'dart:io';
import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';

class ExcelExporter {
  static void export(List<dynamic> data) {
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
    data.forEach((rowData) {
      sheet.appendRow(rowData);
    });

    // Guardar el archivo Excel en el almacenamiento externo
    DateTime now = DateTime.now();

    // Formatear la fecha actual en el formato deseado (por ejemplo, YYYY-MM)
    final String formattedDate = DateFormat('yyyy-MM').format(now);

    // Crear el nombre del archivo con la fecha actual
    String outputFile =
        "C:/Users/PC/Documents/MultasBD/multas_$formattedDate.xlsx";
    List<int>? fileBytes = excel.save();
    if (fileBytes != null) {
      File(join(outputFile))
        ..createSync(recursive: true)
        ..writeAsBytesSync(fileBytes);
    }
  }
}
