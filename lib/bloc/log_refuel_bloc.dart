import 'package:rxdart/rxdart.dart';

class LogRefuelBloc {
  /// Time
  final _time = BehaviorSubject<DateTime>.seeded(DateTime.now());

  Stream<DateTime> get time => _time;

  void setTime(DateTime value) => _time.add(value);

  /// Actual amount paid
  final _actualAmountPaid = ReplaySubject<double>(maxSize: 1);

  Stream<double> get actualAmountPaid => _actualAmountPaid;

  void setActualAmountPaid(double value) => _actualAmountPaid.add(value);

  /// Fuel quantity
  final _fuelQuantity = ReplaySubject<double>(maxSize: 1);

  Stream<double> get fuelQuantity => _fuelQuantity;

  void setFuelQuantity(double value) => _fuelQuantity.add(value);

  /// Gas price
  final _gasPrice = ReplaySubject<double>(maxSize: 1);

  Stream<double> get gasPrice => _gasPrice;

  void setGasPrice(double value) => _gasPrice.add(value);
}
