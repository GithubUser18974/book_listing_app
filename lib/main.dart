import 'package:book_listing_app/common/constants/app_constants.dart';
import 'package:book_listing_app/common/constants/theme_constants.dart';
import 'package:book_listing_app/features/home/presentation/cubit/book_cubit.dart';
import 'package:book_listing_app/features/home/presentation/screens/book_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/di/injection_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await InjectionContainer.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: AppConstants.designSize,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Book Listing App',
          theme: ThemeConstants.lightTheme,
          darkTheme: ThemeConstants.darkTheme,
          home: BlocProvider(
            create: (context) => sl<BookCubit>(),
            child: const BookListScreen(),
          ),
        );
      },
    );
  }
}
