import 'package:flutter_riverpod/flutter_riverpod.dart';

final StateProvider<int> currentIndex = StateProvider<int>((ref) => 0);
final StateProvider<bool> isSearching = StateProvider<bool>((ref) => false);
final StateProvider<bool> checkBox = StateProvider<bool>((ref) => false);
