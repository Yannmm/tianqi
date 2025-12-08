import 'dart:async';

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'dart:math' as math;
import 'package:intl/intl.dart';
import 'package:tianqi/bloc/log_refuel_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:tianqi/utility/num_extension.dart';

class RefuelLogForm extends StatefulWidget {
  const RefuelLogForm({super.key});

  @override
  State<RefuelLogForm> createState() => _RefuelLogFormState();
}

class _RefuelLogFormState extends State<RefuelLogForm> {
  final _formKey = GlobalKey<FormBuilderState>();

  final subscriptions = <StreamSubscription>[];

  final _section1ExpandableController =
      ExpandableController(initialExpanded: false);

  final _section2ExpandableController =
      ExpandableController(initialExpanded: false);

  final _section3ExpandableController =
      ExpandableController(initialExpanded: false);

  /// Section1 description
  final _section1Description = BehaviorSubject<String>.seeded('付款信息');

  final _section2Description = BehaviorSubject<String>.seeded('123123');

  final _actualAmountPaidEditingController = TextEditingController();

  final _fuelQuantityEditingController = TextEditingController();

  final _mileageEditingController = TextEditingController();

  final _gasPriceEditingController = TextEditingController();

  final _actualAmountPaidFocusNode = FocusNode();

  final _fuelQuantityFocusNode = FocusNode();

  final _gasPriceFocusNode = FocusNode();

  final _mileageFocusNode = FocusNode();

  /// Tank level
  final _tankLevel = BehaviorSubject<TankLevel>.seeded(TankLevel.lightOn);

  /// Section1

  @override
  void initState() {
    final bloc = Provider.of<LogRefuelBloc>(context, listen: false);

    bloc.actualAmountPaid.whereNotNull().distinct().listen((value) =>
        _actualAmountPaidEditingController.text = value.toStringAsItIs(2));

    // bloc.fuelQuantity.whereNotNull().distinct().listen((value) =>
    //     _fuelQuantityEditingController.text = value.toStringAsItIs(2));

    bloc.gasPrice.whereNotNull().distinct().listen(
        (value) => _gasPriceEditingController.text = value.toStringAsItIs(2));

    _section1ExpandableController.addListener(() async {
      _section1Description.add(_section1ExpandableController.expanded
          ? "Payment Details"
          : '¥284.3元 = ¥7.04元/L x 45.45L');
    });

    _actualAmountPaidFocusNode.addListener(() {
      _onPaymentSectionFocusChange();
    });

    _fuelQuantityFocusNode.addListener(() {
      _onPaymentSectionFocusChange();
    });

    _gasPriceFocusNode.addListener(() {
      _onPaymentSectionFocusChange();
    });

    _tankLevel
        .map((event) => event.value)
        .pairwise()
        .map((event) => event[1] ?? event[0])
        .listen(bloc.setRemainingOil);

    Rx.combineLatest3(
            bloc.actualAmountPaid.whereNotNull(),
            bloc.fuelQuantity.whereNotNull(),
            bloc.gasPrice.whereNotNull(),
            (a, b, c) =>
                "${a.toStringAsItIs(2)}元 = ${b.toStringAsItIs(2)}L x ${c.toStringAsItIs(2)}元/L")
        .listen(_section1Description.add);

    super.initState();
  }

  void _onPaymentSectionFocusChange() async {
    subscriptions.forEach((s) => s.cancel());
    if ([
          _actualAmountPaidFocusNode.hasFocus,
          _fuelQuantityFocusNode.hasFocus,
          _gasPriceFocusNode.hasFocus
        ].where((event) => event).length >
        1) return;

    final bloc = Provider.of<LogRefuelBloc>(context, listen: false);
    subscriptions.addAll([
      if (_actualAmountPaidFocusNode.hasFocus ||
          _fuelQuantityFocusNode.hasFocus)
        Rx.combineLatest3(
            bloc.actualAmountPaid.whereNotNull().distinct(),
            bloc.fuelQuantity.whereNotNull().distinct(),
            bloc.gasPrice.where((event) => event == null),
            (a, b, _) => a / b).listen(bloc.setGasPrice),
      if (_actualAmountPaidFocusNode.hasFocus || _gasPriceFocusNode.hasFocus)
        Rx.combineLatest3(
            bloc.actualAmountPaid.whereNotNull().distinct(),
            bloc.gasPrice.whereNotNull().distinct(),
            bloc.fuelQuantity.where((event) => event == null),
            (a, b, _) => a / b).listen(bloc.setFuelQuantity),
      if (_fuelQuantityFocusNode.hasFocus || _gasPriceFocusNode.hasFocus)
        Rx.combineLatest3(
            bloc.fuelQuantity.whereNotNull().distinct(),
            bloc.gasPrice.whereNotNull().distinct(),
            bloc.actualAmountPaid.where((event) => event == null),
            (a, b, _) => a * b).listen(bloc.setActualAmountPaid)
    ]);
  }

  @override
  Widget build(BuildContext context) => FormBuilder(
      key: _formKey,
      child: Column(
        children: [_buildSection1(), _buildSection2()],
      ));

  final TDCheckboxGroupController _genderCheckboxGroupController =
      TDCheckboxGroupController();

  final Map<String, String> _radios = {
    '0': '男',
    '1': '女',
    '3': '保密',
    '4': '八分之一'
  };

  Widget _buildSection1() {
    final bloc = Provider.of<LogRefuelBloc>(context, listen: false);

    return _expandableSection(
      _section1Description,
      _section1ExpandableController,
      Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // actualAmountPaidInput(),
              _buildTextField(
                  focusNode: _actualAmountPaidFocusNode,
                  inputType: TextInputType.number,
                  leftLabel: '实付',
                  hintText: '请输入实付金额',
                  textEditingController: _actualAmountPaidEditingController,
                  rightWidget: Text(
                    '元',
                    style: TextStyle(
                      fontSize: TDTheme.of(context).fontTitleLarge?.size,
                      color: TDTheme.of(context).textColorSecondary,
                    ),
                  ),
                  onChanged: (value) =>
                      bloc.setActualAmountPaid(double.tryParse(value))),
              _buildTextField(
                  focusNode: _fuelQuantityFocusNode,
                  inputType: TextInputType.number,
                  leftLabel: '数量',
                  hintText: '请输入加油总量',
                  textEditingController: _fuelQuantityEditingController,
                  rightWidget: Text(
                    '升',
                    style: TextStyle(
                      fontSize: TDTheme.of(context).fontTitleLarge?.size,
                      color: TDTheme.of(context).textColorSecondary,
                    ),
                  ),
                  onChanged: (value) =>
                      bloc.setFuelQuantity(double.tryParse(value))),
              _buildTextField(
                  focusNode: _gasPriceFocusNode,
                  inputType: TextInputType.number,
                  leftLabel: '油价',
                  hintText: '请输入汽油价格',
                  textEditingController: _gasPriceEditingController,
                  rightWidget: Text(
                    '元/升',
                    style: TextStyle(
                      fontSize: TDTheme.of(context).fontTitleLarge?.size,
                      color: TDTheme.of(context).textColorSecondary,
                    ),
                  ),
                  onChanged: (value) =>
                      bloc.setGasPrice(double.tryParse(value))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection2() {
    final bloc = Provider.of<LogRefuelBloc>(context, listen: false);

    Widget tankLevelRating() => TDCell(
        title: '剩余油量',
        noteWidget: TDRate(
          placement: PlacementEnum.none,
          color: [TDTheme.of(context).brandHoverColor],
          allowHalf: false,
          value: 1,
          showText: true,
          icon: const [TDIcons.saturation],
          builderText: (context, value) {
            return StreamBuilder(
                stream: bloc.remainingOil.withLatestFrom(
                    _tankLevel,
                    (b, a) => (
                          switch (a) {
                            TankLevel.custom =>
                              "${((b ?? 0) * 100).toStringAsItIs(0)}%",
                            TankLevel.oneEighth => '1/8 箱',
                            TankLevel.oneFourth => '1/4 箱',
                            TankLevel.oneThird => '1/3 箱',
                            TankLevel.oneHalf => '1/2 箱',
                            TankLevel.lightOn => '灯亮',
                          },
                          a
                        )),
                builder: (context, snapshot) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: TDButton(
                      width: 65,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                      ),
                      icon: snapshot.data?.$2 == TankLevel.lightOn
                          ? TDIcons.lightbulb
                          : null,
                      text: snapshot.data?.$1,
                      size: TDButtonSize.extraSmall,
                      type: snapshot.data?.$2 == TankLevel.custom
                          ? TDButtonType.outline
                          : TDButtonType.fill,
                      shape: TDButtonShape.rectangle,
                      theme: TDButtonTheme.primary,
                      onTap: () => _tankLevel.add(TankLevel.custom),
                    ),
                  );
                });
          },
          onChange: (value) => _tankLevel
              .add(TankLevel.fromValue(value.toInt()) ?? TankLevel.custom),
        ));

    Widget tankLevelSlider() => StreamBuilder(
        stream: bloc.remainingOil,
        builder: (context, snapshot) => TDSlider(
              sliderThemeData: TDSliderThemeData.capsule(
                context: context,
                showThumbValue: false,
                min: 0,
                max: 100,
                scaleFormatter: (value) => value.toInt().toString() + '%',
              ),
              value: ((snapshot.data ?? 0) * 100),
              onChanged: (value) => bloc.setRemainingOil(value / 100),
            ));

    Widget fillUpSwitch() => const TDCell(
          title: '是否加满',
          noteWidget: TDSwitch(),
        );

    Widget missLogSwitch() => const TDCell(
          title: '上次漏记',
          noteWidget: TDSwitch(),
        );

    return _expandableSection(
      _section2Description,
      _section2ExpandableController,
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // actualAmountPaidInput(),
          // fuelQuantityInput(),
          // gasPriceInput()
          _buildTextField(
              focusNode: _mileageFocusNode,
              inputType: TextInputType.number,
              leftLabel: '总里程',
              hintText: '上次里程：123456',
              textEditingController: _mileageEditingController,
              rightWidget: Text(
                '公里',
                style: TextStyle(
                  fontSize: TDTheme.of(context).fontTitleLarge?.size,
                  color: TDTheme.of(context).textColorSecondary,
                ),
              ),
              onChanged: (value) => bloc.setOdometer(double.tryParse(value))),

          tankLevelRating(),
          StreamBuilder(
            stream: _tankLevel.map((event) => event == TankLevel.custom),
            builder: (context, snapshot) => (snapshot.data ?? false)
                ? tankLevelSlider()
                : const SizedBox.shrink(),
          ),
          Container(
            color: Colors.white,
            child: Row(
              children: [
                Expanded(child: missLogSwitch()),
                const TDDivider(
                  direction: Axis.vertical,
                  // color: TDTheme.of(context).brandHoverColor,
                  width: 1,
                  height: 20,
                ),
                Expanded(child: fillUpSwitch()),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTextField({
    FocusNode? focusNode,
    Widget? rightWidget,
    TextInputType? inputType,
    required String leftLabel,
    String? hintText,
    required TextEditingController textEditingController,
    required void Function(String)? onChanged,
  }) =>
      TDInput(
          focusNode: focusNode,
          rightWidget: rightWidget,
          leftLabel: leftLabel,
          rightBtn: null,
          inputType: inputType,
          leftContentSpace: 10,
          hintText: hintText,
          hintTextStyle: TextStyle(
            color: TDTheme.of(context).textColorPlaceholder,
            fontSize: TDTheme.of(context).fontTitleLarge?.size,
          ),
          textStyle: TextStyle(
            fontSize: TDTheme.of(context).fontTitleLarge?.size,
            color: TDTheme.of(context).textColorPrimary,
          ),
          controller: textEditingController,
          additionInfoColor: TDTheme.of(context).errorColor6,
          showBottomDivider: false,
          readOnly: false,
          onChanged: onChanged,
          onClearTap: () {
            // _gasPriceEditingController.clear();
          });

  Widget _expandableSection(Stream<String> sectionDescription,
      ExpandableController expandableController, Widget expanded) {
    return ExpandableNotifier(
        child: Padding(
      padding: const EdgeInsets.all(12),
      child: ScrollOnExpand(
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: <Widget>[
              ExpandablePanel(
                controller: expandableController,
                theme: const ExpandableThemeData(
                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                  tapBodyToExpand: true,
                  tapBodyToCollapse: true,
                  tapHeaderToExpand: true,
                  hasIcon: false,
                ),
                header: Container(
                  color: TDTheme.of(context).brandNormalColor,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        ExpandableIcon(
                          theme: const ExpandableThemeData(
                            expandIcon: TDIcons.arrow_right_down,
                            collapseIcon: TDIcons.arrow_left_up,
                            iconColor: Colors.white,
                            iconSize: 28.0,
                            iconRotationAngle: math.pi / 2,
                            iconPadding: EdgeInsets.only(right: 5),
                            hasIcon: false,
                          ),
                        ),
                        Expanded(
                          child: StreamBuilder(
                              stream: sectionDescription,
                              builder: (context, snapshot) => Text(
                                    snapshot.data ?? '',
                                    style: TextStyle(
                                      fontSize: TDTheme.of(context)
                                          .fontTitleSmall
                                          ?.size,
                                      color: TDTheme.of(context).textColorAnti,
                                    ),
                                  )),
                        ),
                      ],
                    ),
                  ),
                ),
                collapsed: const SizedBox.shrink(),
                expanded: expanded,
              ),
            ],
          ),
        ),
      ),
    ));
  }
}

const kSections = ['Payment', 'Odometer & Tank', 'Notes & Attachments'];

enum TankLevel {
  custom,
  lightOn,
  oneEighth,
  oneFourth,
  oneThird,
  oneHalf;

  static TankLevel? fromValue(int value) => switch (value) {
        0 => TankLevel.custom,
        1 => TankLevel.lightOn,
        2 => TankLevel.oneEighth,
        3 => TankLevel.oneFourth,
        4 => TankLevel.oneThird,
        5 => TankLevel.oneHalf,
        _ => null,
      };

  double? get value => switch (this) {
        TankLevel.custom => null,
        TankLevel.lightOn => 0.1,
        TankLevel.oneEighth => 0.125,
        TankLevel.oneFourth => 0.25,
        TankLevel.oneThird => 0.33,
        TankLevel.oneHalf => 0.5,
      };
}
