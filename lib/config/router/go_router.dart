import 'package:go_router/go_router.dart';
import 'package:multas/presentaccion/Screen/home_screen.dart';
import 'package:multas/presentaccion/Screen/listview_multas.dart';

final goRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: HomeScreen.name,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/listViewMultas',
      name: ListViewMultas.name,
      builder: (context, state) => const ListViewMultas(),
    ),
  ],
);
