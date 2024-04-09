import 'package:mysql1/mysql1.dart';

class DatabaseConnection {
  static Future<MySqlConnection> connectionSettings() async {
    final Future<MySqlConnection> conn = MySqlConnection.connect(
        ConnectionSettings(
            host: 'localhost',
            port: 3306,
            user: 'root',
            db: 'multas',
            password: 'root'));

    return conn;
  }
}
