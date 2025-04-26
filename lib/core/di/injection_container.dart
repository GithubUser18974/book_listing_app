import 'package:book_listing_app/features/home/data/repositories/book_repository_impl.dart';
import 'package:book_listing_app/features/home/domain/repositories/book_repository.dart';
import 'package:book_listing_app/features/home/domain/usecases/cache_books_usecase.dart';
import 'package:book_listing_app/features/home/domain/usecases/get_books_usecase.dart';
import 'package:book_listing_app/features/home/domain/usecases/get_cached_books_usecase.dart';
import 'package:book_listing_app/features/home/presentation/cubit/book_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/services/network_service.dart';

final sl = GetIt.instance;

abstract class InjectionContainer {
  static Future<void> init() async {
    // Cubits
    sl.registerFactory(
      () => BookCubit(
        getBooksUseCase: sl(),
        getCachedBooksUseCase: sl(),
        cacheBooksUseCase: sl(),
      ),
    );

    // Use cases
    sl.registerLazySingleton(() => GetBooksUseCase(sl()));
    sl.registerLazySingleton(() => GetCachedBooksUseCase(sl()));
    sl.registerLazySingleton(() => CacheBooksUseCase(sl()));

    // Repositories
    // Register repository
    sl.registerSingleton<BookRepository>(
      BookRepositoryImpl(
        client: sl<http.Client>(),
        sharedPreferences: sl<SharedPreferences>(),
        networkService: sl<NetworkService>(),
      ),
    );

    // Register shared preferences
    final sharedPreferences = await SharedPreferences.getInstance();
    sl.registerSingleton<SharedPreferences>(sharedPreferences);

    // Register HTTP client
    sl.registerSingleton<http.Client>(http.Client());

    // Register network service
    sl.registerSingleton<NetworkService>(NetworkService());
  }
}
