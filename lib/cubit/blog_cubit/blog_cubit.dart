import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef FavoriteBlog = Map<String, String>;

class FavoritesState extends Equatable {
  final List<FavoriteBlog> favorites;

  const FavoritesState(this.favorites);

  @override
  List<Object> get props => [favorites];
}

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit() : super(const FavoritesState([])) {
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? storedFavorites = prefs.getStringList('favorites');
    
    if (storedFavorites != null) {
      final favorites = storedFavorites.map((fav) {
        final parts = fav.split('|');
        return {'id': parts[0], 'category': parts[1]};
      }).toList();
      emit(FavoritesState(favorites));
    }
  }

  Future<void> _saveFavorites(List<FavoriteBlog> favorites) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> storedFavorites = favorites
        .map((fav) => "${fav['id']}|${fav['category']}")
        .toList();
    await prefs.setStringList('favorites', storedFavorites);
  }

  bool isFavorite(String id, String category) {
    return state.favorites.any(
      (fav) => fav['id'] == id && fav['category'] == category,
    );
  }

  void toggleFavorite(String id, String category) {
    Logger().i('Add blog to favourite ID:$id, Category:$category');
    final List<FavoriteBlog> updatedFavorites = List.from(state.favorites);

    final existingIndex = updatedFavorites.indexWhere(
      (fav) => fav['id'] == id && fav['category'] == category,
    );

    if (existingIndex >= 0) {
      updatedFavorites.removeAt(existingIndex);
    } else {
      updatedFavorites.add({'id': id, 'category': category});
    }

    emit(FavoritesState(updatedFavorites));
    _saveFavorites(updatedFavorites);
  }
}
