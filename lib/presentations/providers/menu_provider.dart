import 'package:flutter_riverpod/flutter_riverpod.dart';

class MenuState {
  final int selectedIndex;

  MenuState({required this.selectedIndex});

  MenuState copyWith({int? selectedIndex}) {
    return MenuState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }
}

class MenuNotifier extends StateNotifier<MenuState> {
  MenuNotifier() : super(MenuState(selectedIndex: 0));

  void changeMenuIndex(int index) {
    state = state.copyWith(selectedIndex: index);
  }
}

final menuProvider = StateNotifierProvider<MenuNotifier, MenuState>(
  (ref) => MenuNotifier(),
);
