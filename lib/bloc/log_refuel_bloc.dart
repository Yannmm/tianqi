import 'package:rxdart/rxdart.dart';

class LogRefuelBloc {
  /// Time
  final _time = BehaviorSubject<DateTime>.seeded(DateTime.now());

  Stream<DateTime> get time => _time;

  void setTime(DateTime value) => _time.add(value);

  /// Actual amount paid
  final _actualAmountPaid = BehaviorSubject<double?>.seeded(null);

  Stream<double?> get actualAmountPaid => _actualAmountPaid;

  void setActualAmountPaid(double? value) => _actualAmountPaid.add(value);

  /// Fuel quantity
  final _fuelQuantity = BehaviorSubject<double?>.seeded(null);

  Stream<double?> get fuelQuantity => _fuelQuantity;

  void setFuelQuantity(double? value) => _fuelQuantity.add(value);

  /// Gas price
  final _gasPrice = BehaviorSubject<double?>.seeded(null);

  Stream<double?> get gasPrice => _gasPrice;

  void setGasPrice(double? value) => _gasPrice.add(value);

  /// Odometer
  final _odometer = ReplaySubject<double?>(maxSize: 1);

  Stream<double?> get odometer => _odometer;

  void setOdometer(double? value) => _odometer.add(value);

  /// Tank level
  final _tankLevel = BehaviorSubject<double?>.seeded(null);

  Stream<double?> get tankLevel => _tankLevel;

  void setTankLevel(double? value) => _tankLevel.add(value);

  LogRefuelBloc() {
    _bind();
  }

  void _bind() {
    // Rx.combineLatest3(
    //     _actualAmountPaid.whereNotNull(),
    //     _fuelQuantity.whereNotNull(),
    //     _gasPrice.where((event) => event == null),
    //     (a, b, c) => a / b).listen(_gasPrice.add);
  }
}
