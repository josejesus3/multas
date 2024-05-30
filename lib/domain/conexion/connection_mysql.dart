import 'package:multas/domain/conexion/connection_settings.dart';
import 'package:multas/domain/entiti/list_multas.dart';
import 'package:mysql1/mysql1.dart';

class ConnectionMysql {
  final String insertar =
      'insert into registros (municipio,status,placa,importe,fechada,folio,folioPago,cantidad,estado,fecha,foranea) values (?,?,?,?,?,?,?,?,?,?,?)';
  final String actualizar =
      'update registros set municipio=?,status=?,placa=?,importe=?,fechada=?,folio=?,folioPago=?,cantidad=?,estado=?,fecha=?,foranea=? where placa=?';
  final String leer = 'SELECT * FROM registros';
  final String buscar =
      'SELECT `id`, `municipio`, `status`, `placa`, `importe`, `fechada`, `folio`, `folioPago`, `cantidad`, `estado`, `fecha`, `foranea` FROM `registros` WHERE placa = ? OR fecha =?';
  final String delete = 'DELETE FROM registros  WHERE placa=?';

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

  Future<Results> deleteQuery(String placa) async {
    final conn = await DatabaseConnection.connectionSettings();
    Results result = await conn.query(delete, [placa]);
    return result;
  }

  Future<List<ListMultas>> selectQueryBusqueda(String placa, fecha) async {
    List<ListMultas> nuevas = [];
    final conn = await DatabaseConnection.connectionSettings();
    Results result = await conn.query(buscar, [placa, fecha]);
    for (var row in result) {
      bool infraccion = row[9] == 1;
      ListMultas multa = ListMultas(
          municipio: row[1],
          status: row[2],
          placa: row[3],
          cantidad: row[4],
          fecha: row[5],
          folio: row[6],
          folioPago: row[7],
          cantidadPago: row[8],
          infraccion: infraccion,
          fechaPago: row[10],
          foraneas: row[11]);

      nuevas.add(multa);
    }

    return nuevas;
  }

  Future<List<ListMultas>> selectQuery() async {
    List<ListMultas> nuevas = [];
    final conn = await DatabaseConnection.connectionSettings();
    Results result = await conn.query(
      leer,
    );
    for (var row in result) {
      bool infraccion = row[9] == 1;
      ListMultas multa = ListMultas(
          municipio: row[1],
          status: row[2],
          placa: row[3],
          cantidad: row[4],
          fecha: row[5],
          folio: row[6],
          folioPago: row[7],
          cantidadPago: row[8],
          infraccion: infraccion,
          fechaPago: row[10],
          foraneas: row[11]);

      nuevas.add(multa);
    }

    return nuevas;
  }
}
