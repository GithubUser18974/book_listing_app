import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:book_listing_app/common/constants/theme_constants.dart';
import 'package:book_listing_app/common/services/network_service.dart';
import 'package:book_listing_app/features/home/data/repositories/book_repository_impl.dart';
import 'package:book_listing_app/features/home/domain/repositories/book_repository.dart';
import 'package:book_listing_app/features/home/presentation/cubit/book_cubit.dart';
import 'package:book_listing_app/features/home/presentation/screens/book_list_screen.dart';

final getIt = GetIt.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencies();
  runApp(const MyApp());
}

Future<void> setupDependencies() async {
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Book Listing App',
          theme: ThemeConstants.lightTheme,
          darkTheme: ThemeConstants.darkTheme,
          home: BlocProvider(
            create: (context) => BookCubit(
              repository: getIt<BookRepository>(),
            ),
            child: const BookListScreen(),
          ),
        );
      },
    );
  }
}
