extension DoubleExtension on double {
  /// Formats the double to a string, removing unnecessary decimal places.
  String toStringAsItIs(int decimalPlaces) {
    // Round to the specified decimal places
    double rounded = double.parse(toStringAsFixed(decimalPlaces));
    // If the rounded value is an integer, return without decimals
    if (rounded % 1 == 0) {
      return rounded.toInt().toString();
    } else {
      // Remove trailing zeros after decimal point
      return rounded.toString().replaceFirst(RegExp(r'\.?0+$'), '');
    }
  }
}
