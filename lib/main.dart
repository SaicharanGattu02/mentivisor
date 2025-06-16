import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/utils/color_constants.dart';
import 'StateInjector.dart';
import 'app_routes/router.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: StateInjector.repositoryProviders,
      child: MaterialApp.router(
        title: 'MentiVisor',
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          scaffoldBackgroundColor: Colors.white,
          dialogBackgroundColor: Colors.white,
          cardColor: Colors.white,
          searchBarTheme: const SearchBarThemeData(),
          tabBarTheme: const TabBarThemeData(),
          dialogTheme: const DialogThemeData(
            shadowColor: Colors.white,
            surfaceTintColor: Colors.white,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
          ),
          buttonTheme: const ButtonThemeData(),
          popupMenuTheme: const PopupMenuThemeData(
            color: Colors.white,
            shadowColor: Colors.white,
          ),
          appBarTheme: AppBarTheme(surfaceTintColor: Colors.white),
          cardTheme: CardThemeData(
            shadowColor: Colors.white,
            surfaceTintColor: Colors.white,
            color: Colors.white,
          ),
          inputDecorationTheme: InputDecorationTheme(
            hintStyle: const TextStyle(
              color: hintColor,
              fontFamily: "Inter",
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
            labelStyle: const TextStyle(
              color: hintColor,
              fontFamily: "Inter",
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: borderColor,width: 1)
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: borderColor,width: 1)
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: borderColor,width: 1)
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: borderColor,width: 1)
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: borderColor,width: 1)
            ),
            errorStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 13,
              fontFamily: "Inter",
              color: Colors.red,
            ),
          ),
          textButtonTheme: TextButtonThemeData(style: ButtonStyle()),
          elevatedButtonTheme: ElevatedButtonThemeData(style: ButtonStyle()),
          outlinedButtonTheme: OutlinedButtonThemeData(style: ButtonStyle()),
          bottomSheetTheme: const BottomSheetThemeData(
            surfaceTintColor: Colors.white,
            backgroundColor: Colors.white,
          ),
          colorScheme: const ColorScheme.light(
            background: Colors.white,
          ).copyWith(background: Colors.white),
          fontFamily: 'Inter',
        ),
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter,
      ),
    );
  }
}
