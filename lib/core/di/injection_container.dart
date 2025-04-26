import 'package:book_listing_app/features/home/data/datasources/book_local_data_source_impl.dart';
import 'package:book_listing_app/features/home/data/datasources/book_remote_data_source_impl.dart';
import 'package:book_listing_app/features/home/data/repositories/book_repository_impl.dart';
import 'package:book_listing_app/features/home/domain/repositories/book_repository.dart';
import 'package:book_listing_app/features/home/domain/usecases/get_books_usecase.dart';
import 'package:book_listing_app/features/home/presentation/cubit/book_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/services/network_service.dart';
import '../../features/home/data/datasources/book_local_data_source.dart';
import '../../features/home/data/datasources/book_remote_data_source.dart';

final sl = GetIt.instance;

abstract class InjectionContainer {
  static Future<void> init() async {
    // Cubits
    sl.registerFactory(
      () => BookCubit(
        getBooksUseCase: sl(),
      ),
    );

    // Use cases
    sl.registerLazySingleton(() => GetBooksUseCase(sl()));

    // Repositories
    sl.registerLazySingleton<BookRepository>(
      () => BookRepositoryImpl(
        networkService: sl(),
        remoteDataSource: sl(),
        localDataSource: sl(),
      ),
    );

    // Data sources
    sl.registerLazySingleton<BookRemoteDataSource>(
      () => BookRemoteDataSourceImpl(client: sl()),
    );

    sl.registerLazySingleton<BookLocalDataSource>(
      () => BookLocalDataSourceImpl(sharedPreferences: sl()),
    );

    // External
    final sharedPreferences = await SharedPreferences.getInstance();
    sl.registerSingleton<SharedPreferences>(sharedPreferences);
    sl.registerSingleton<http.Client>(http.Client());

    // Register network service
    sl.registerSingleton<NetworkService>(NetworkService());
  }
}
