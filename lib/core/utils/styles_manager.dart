import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'font_manager.dart';

TextStyle _getTextStyle(double fontSize, FontWeight fontWeight, Color color) {
  return GoogleFonts.montserrat(
      fontWeight: fontWeight, color: color, fontSize: fontSize);
}

// regular style

TextStyle getRegularStyle({double fontSize = 12, required Color color}) {
  return _getTextStyle(fontSize, FontWeightManager.regular, color);
}

// medium style

TextStyle getMediumStyle({double fontSize = 12, required Color color}) {
  return _getTextStyle(fontSize, FontWeightManager.medium, color);
}

// medium style

TextStyle getLightStyle({double fontSize = 12, required Color color}) {
  return _getTextStyle(fontSize, FontWeightManager.light, color);
}

// bold style

TextStyle getBoldStyle({double fontSize = 12, required Color color}) {
  return _getTextStyle(fontSize, FontWeightManager.bold, color);
}

// semiBold style

TextStyle getSemiBoldStyle({double fontSize = 12, required Color color}) {
  return _getTextStyle(fontSize, FontWeightManager.semiBold, color);
}
