import 'dart:ui';

class ColorConstant {
  static Color loginboxbgcolor = fromHex('#FFFFFF');
  static Color color1 = fromHex('#002F86');
  static Color colorgrey = fromHex('#727272');
  static Color lightgrey = fromHex("#E5E5E5");
  static Color redbar = fromHex('#002F86');
  static Color colordrawritem = fromHex('#FAFAFA');
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  static Color switchBackground = fromHex("#9D9D9D");
}
