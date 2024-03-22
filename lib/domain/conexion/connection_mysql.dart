import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multas/domain/conexion/connection_settings.dart';
import 'package:multas/domain/entiti/list_multas.dart';
import 'package:multas/presentaccion/provider/read_provider.dart';
import 'package:mysql1/mysql1.dart';

class ConnectionMysql {
  final String insertar =
      'insert into registros (municipio,status,placa,importe,fechada,folio,folioPago,cantidad,estado,fecha,foranea) values (?,?,?,?,?,?,?,?,?,?,?)';
  final String actualizar =
      'update registros set municipio=?,status=?,placa=?,importe=?,fechada=?,folio=?,folioPago=?,cantidad=?,estado=?,fecha=?,foranea=? where placa=?';
  final String leer = 'select * from registros';

  Future<Results> insertQuery(ListMultas multa) async {
    final MySqlConnection conn = await DatabaseConnection.connectionSettings();
    Results result = await conn.query(insertar, [
      multa.municipio,
      multa.status,
      multa.placa,
      multa.cantidad,
      multa.fecha,
      multa.folio,
      multa.folioPago,
      multa.cantidadPago,
      multa.infraccion,
      multa.fecha,
      multa.foraneas,
    ]);
    return result;
  }

  Future<Results> updateQuery(ListMultas multa, String placa) async {
    final conn = await DatabaseConnection.connectionSettings();
    Results result = await conn.query(actualizar, [
      multa.municipio,
      multa.status,
      multa.placa,
      multa.cantidad,
      multa.fecha,
      multa.folio,
      multa.folioPago,
      multa.cantidadPago,
      multa.infraccion,
      multa.fecha,
      multa.foraneas,
      placa
    ]);
    return result;
  }

  Future<List<ListMultas>> selectQuery() async {
    List<ListMultas> nuevas = [];
    final conn = await DatabaseConnection.connectionSettings();
    Results result = await conn.query(
      leer,
    );
    for (var row in result) {
      ListMultas lista = ListMultas(
        municipio: row[0],
        status: row[1],
        fechaPago: row[2].toString(),
      );

      nuevas.add(lista);
    }

    return nuevas;
  }
}
