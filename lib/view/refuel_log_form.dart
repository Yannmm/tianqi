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

  final _section1Description = BehaviorSubject<String>.seeded('Collapsed');

  final _section2Description = BehaviorSubject<String>.seeded('123123');

  final _actualAmountPaidEditingController = TextEditingController();

  final _fuelQuantityEditingController = TextEditingController();

  final _gasPriceEditingController = TextEditingController();

  final _actualAmountPaidFocusNode = FocusNode();

  final _fuelQuantityFocusNode = FocusNode();

  final _gasPriceFocusNode = FocusNode();

  @override
  void initState() {
    final bloc = Provider.of<LogRefuelBloc>(context, listen: false);

    bloc.actualAmountPaid.whereNotNull().distinct().listen((value) =>
        _actualAmountPaidEditingController.text = value.toStringAsItIs(2));

    bloc.fuelQuantity.whereNotNull().distinct().listen((value) =>
        _fuelQuantityEditingController.text = value.toStringAsItIs(2));

    bloc.gasPrice.whereNotNull().distinct().listen(
        (value) => _gasPriceEditingController.text = value.toStringAsItIs(2));

    _section1ExpandableController.addListener(() async {
      _section1Description.add(_section1ExpandableController.expanded
          ? "Payment Details"
          : '本次加油实付 ¥284.3元 = ¥7.04元/L x 45.45L');
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

  final Map<String, String> _radios = {'0': '男', '1': '女', '3': '保密'};

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
    return _expandableSection(
      _section2Description,
      _section2ExpandableController,
      Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // actualAmountPaidInput(),
              // fuelQuantityInput(),
              // gasPriceInput()
            ],
          ),
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
          leftContentSpace: 20,
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
                  color: Colors.indigoAccent,
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
