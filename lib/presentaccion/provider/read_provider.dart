import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multas/domain/entiti/list_multas.dart';

final StateProvider<int> currentIndex = StateProvider<int>((ref) => 0);
final StateProvider<bool> isSearching = StateProvider<bool>((ref) => false);
final StateProvider<bool> checkBox = StateProvider<bool>((ref) => false);
final StateProvider<List<ListMultas>> listaMultaProvider =
    StateProvider<List<ListMultas>>((ref) => []);
