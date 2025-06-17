import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/utils/media_query_helper.dart';
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
    SizeConfig.init(context);
    return MultiRepositoryProvider(
      providers: StateInjector.repositoryProviders,
      child: MultiProvider(
        providers: StateInjector.blocProviders,
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
            inputDecorationTheme: InputDecorationTheme(
              hintStyle: const TextStyle(
                color: Colors.black38,
                fontSize: 15,
                fontWeight: FontWeight.w400,
                fontFamily: "Inter",
              ),
              labelStyle:const TextStyle(
                color: Colors.black38,
                fontSize: 15,
                fontWeight: FontWeight.w400,
                fontFamily: "Inter",
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Color(0xffe2e8f0), width: 1),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Color(0xffe2e8f0), width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Color(0xffe2e8f0), width: 1),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Color(0xffe2e8f0), width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Color(0xffe2e8f0), width: 1),
              ),
              errorStyle: TextStyle(
                fontFamily: "Inter",
                fontWeight: FontWeight.w400,
                fontSize: 15,
              ),
            ),
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
      ),
    );
  }
}
