import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:news_grid/core/data/user.dart';
import 'package:news_grid/core/logic/app_theme_cubit/app_theme_cubit.dart';
import 'package:news_grid/core/logic/connectivity_cubit/connectivity_cubit.dart';
import 'package:news_grid/core/initializer/initializer.dart';
import 'package:news_grid/core/shared_preferences/shared_preferences.dart';
import 'package:news_grid/core/styles/app_theme.dart';
import 'package:news_grid/features/homescreen/homescreen.dart';
import 'package:news_grid/features/homescreen/logic/get_top_headlines_cubit/get_top_headlines_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //initialize classes needed for DI
  Initializer.init();
  //initialize connectivity cubit
  await getIt<ConnectivityCubit>().init();
  getIt<ConnectivityCubit>().listen();
  //initialize storage service
  await StorageService.init();
  StorageService.clear();
  //initialize environment variables
  await dotenv.load(fileName: "app_secrets.env");
  //initialize user
  User? user = await StorageService.getUser();
  if (user != null) {
    if (getIt.isRegistered<User>()) {
      getIt.unregister<User>();
    }
    getIt.registerSingleton<User>(user);
  } else {
    await StorageService.saveUser(getIt<User>());
  }
  //initialize app theme cubit
  await getIt<AppThemeCubit>().init();
  runApp(const NewsGridApp());
}

class NewsGridApp extends StatelessWidget {
  const NewsGridApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: getIt<ConnectivityCubit>()),
        BlocProvider.value(value: getIt<AppThemeCubit>()),
        BlocProvider(create: (context) => GetTopHeadlinesCubit()),
      ],
      child: BlocBuilder<AppThemeCubit, ThemeMode>(
        builder: (context, state) {
          return MaterialApp(
            title: 'NewsGrid',
            theme: AppTheme.getTheme(state),
            debugShowCheckedModeBanner: false,
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
