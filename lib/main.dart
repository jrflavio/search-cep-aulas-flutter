import 'package:flutter/material.dart';
import 'package:search_cep/views/home_page.dart';
import 'package:search_cep/themes/orange_theme.dart';
import 'package:search_cep/themes/dark_theme.dart';
import 'package:dynamic_theme/dynamic_theme.dart';


class SearchCepApp extends StatelessWidget {
      @override
      Widget build(BuildContext context) {
        return DynamicTheme(
          defaultBrightness: Brightness.light,
          data: (brightness) => myLightTheme,
          themedWidgetBuilder: (context, theme) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: theme,
              darkTheme: myDarkTheme,
              home: HomePage(),
            );
          }
        );
      }
}

void main() {
  runApp(
    SearchCepApp()
    );
}
