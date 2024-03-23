import 'package:mysql1/mysql1.dart';

class DatabaseConnection {
  static Future<MySqlConnection> connectionSettings() async {
    final Future<MySqlConnection> conn = MySqlConnection.connect(ConnectionSettings(
        host: '192.168.0.7',
        port: 3306,
        user: 'root',
        db: 'multas',
        password: 'root'));

    return conn;
  }
}
