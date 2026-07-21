import 'package:eventsapp/features/chat/repository/favorites_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'favorites_state.dart'; 

class FavoritesCubit extends Cubit<FavoritesState> {
  final FavoritesRepository repository;

  FavoritesCubit(this.repository) : super(FavoritesInitial());

  // دالة لجلب القائمة (تُستدعى عند فتح شاشة المفضلة)
  Future<void> fetchFavorites() async {
    emit(FavoritesLoading());
    try {
      final favorites = await repository.getFavorites();
      emit(FavoritesLoaded(favorites));
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }

  // دالة للضغط على القلب (Toggle)
  Future<void> toggleHeart(String listingId) async {
    try {
      // نستدعي الـ API، وسيرجع لنا هل أصبحت مفضلة أم لا
      final isNowFavorited = await repository.toggleFavorite(listingId);
      
      // إذا كنا داخل شاشة قائمة المفضلة، نقوم بتحديث القائمة فوراً
      if (state is FavoritesLoaded) {
          fetchFavorites(); 
      }
    } catch (e) {
      print("Error toggling favorite: $e");
    }
  }
}