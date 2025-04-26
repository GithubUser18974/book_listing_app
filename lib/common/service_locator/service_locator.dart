import 'package:book_listing_app/common/services/network_service.dart';
import 'package:book_listing_app/features/home/data/repositories/book_repository_impl.dart';
import 'package:book_listing_app/features/home/domain/repositories/book_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

abstract class ServiceLocator {
  static Future<void> setupDependencies() async {
    // Register shared preferences
    final sharedPreferences = await SharedPreferences.getInstance();
    getIt.registerSingleton<SharedPreferences>(sharedPreferences);

    // Register HTTP client
    getIt.registerSingleton<http.Client>(http.Client());

    // Register network service
    getIt.registerSingleton<NetworkService>(NetworkService());

    // Register repository
    getIt.registerSingleton<BookRepository>(
      BookRepositoryImpl(
        client: getIt<http.Client>(),
        sharedPreferences: getIt<SharedPreferences>(),
        networkService: getIt<NetworkService>(),
      ),
    );
  }
}
