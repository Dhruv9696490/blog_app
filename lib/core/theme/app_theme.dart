import 'package:flutter/material.dart';

import 'app_pallete.dart';

class AppTheme{
    static  _fieldBorder ([Color color= AppPallete.borderColor])  => OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
            color: color,
            width: 3
        ),
    );
    static final darkThemeMode = ThemeData.dark().copyWith(
        scaffoldBackgroundColor: AppPallete.backgroundColor,
        inputDecorationTheme: InputDecorationTheme(
            contentPadding: const EdgeInsets.all(27),
            enabledBorder: _fieldBorder(),
            disabledBorder: _fieldBorder(),
            focusedBorder: _fieldBorder(AppPallete.gradient2),
          errorBorder: _fieldBorder(AppPallete.errorColor),
          border: _fieldBorder(),
        ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,

      ),
      chipTheme: ChipThemeData(
        color: MaterialStatePropertyAll(AppPallete.backgroundColor)
          // labelPadding: EdgeInsets.symmetric(vertical: 3,horizontal: 7),
    )
    );
}