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
  final subscriptions = <StreamSubscription>[];

  final _expandableController = ExpandableController(initialExpanded: false);

  final _paymentDescription = BehaviorSubject<String>.seeded('Collapsed');

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

    _expandableController.addListener(() {
      _paymentDescription.add(
          _expandableController.expanded ? 'Payment Details' : 'Collapsed');
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
  Widget build(BuildContext context) {
    final bloc = Provider.of<LogRefuelBloc>(context, listen: false);
    return _buildForm();
  }

  final TDCheckboxGroupController _genderCheckboxGroupController =
      TDCheckboxGroupController();

  final Map<String, String> _radios = {'0': '男', '1': '女', '3': '保密'};

  final _formKey = GlobalKey<FormBuilderState>();

  Widget _buildForm() => FormBuilder(
      key: _formKey,
      child: Column(
        children: [_buildSection1()],
      ));

  Widget _buildSection1() {
    return _expandableSection(Column(
      children: [
        FormBuilderField<DateTime?>(
          name: 'date',
          builder: (FormFieldState field) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildActualAmountPaidInput(),
              _buildFuelQuantityInput(),
              _buildGasPriceInput()
            ],
          ),
        ),
      ],
    ));
  }

  Widget _buildActualAmountPaidInput() {
    final bloc = Provider.of<LogRefuelBloc>(context, listen: false);
    return TDInput(
        focusNode: _actualAmountPaidFocusNode,
        rightWidget: Text(
          '元',
          style: TextStyle(
            fontSize: TDTheme.of(context).fontTitleLarge?.size,
            color: TDTheme.of(context).textColorSecondary,
          ),
        ),
        leftLabel: '实付',
        rightBtn: null,
        inputType: TextInputType.number,
        leftContentSpace: 20,
        hintText: '请输入实付金额',
        hintTextStyle: TextStyle(
          color: TDTheme.of(context).textColorPlaceholder,
          fontSize: TDTheme.of(context).fontTitleLarge?.size,
        ),
        textStyle: TextStyle(
          fontSize: TDTheme.of(context).fontTitleLarge?.size,
          color: TDTheme.of(context).textColorPrimary,
        ),
        controller: _actualAmountPaidEditingController,
        additionInfoColor: TDTheme.of(context).errorColor6,
        showBottomDivider: false,
        readOnly: false,
        onChanged: (value) {
          bloc.setActualAmountPaid(double.tryParse(value));
        },
        onClearTap: () {
          _actualAmountPaidEditingController.clear();
        });
  }

  Widget _buildFuelQuantityInput() => TDInput(
      focusNode: _fuelQuantityFocusNode,
      rightWidget: Text(
        '升',
        style: TextStyle(
          fontSize: TDTheme.of(context).fontTitleLarge?.size,
          color: TDTheme.of(context).textColorSecondary,
        ),
      ),
      leftLabel: '总量',
      rightBtn: null,
      inputType: TextInputType.number,
      leftContentSpace: 20,
      hintText: '请输入加油数量',
      hintTextStyle: TextStyle(
        color: TDTheme.of(context).textColorPlaceholder,
        fontSize: TDTheme.of(context).fontTitleLarge?.size,
      ),
      textStyle: TextStyle(
        fontSize: TDTheme.of(context).fontTitleLarge?.size,
        color: TDTheme.of(context).textColorPrimary,
      ),
      controller: _fuelQuantityEditingController,
      additionInfoColor: TDTheme.of(context).errorColor6,
      showBottomDivider: false,
      readOnly: false,
      onChanged: (value) {
        Provider.of<LogRefuelBloc>(context, listen: false)
            .setFuelQuantity(double.tryParse(value));
      },
      onClearTap: () {
        _fuelQuantityEditingController.clear();
      });

  Widget _buildGasPriceInput() => TDInput(
      focusNode: _gasPriceFocusNode,
      rightWidget: Text(
        '元/升',
        style: TextStyle(
          fontSize: TDTheme.of(context).fontTitleLarge?.size,
          color: TDTheme.of(context).textColorSecondary,
        ),
      ),
      leftLabel: '油价',
      rightBtn: null,
      inputType: TextInputType.number,
      leftContentSpace: 20,
      hintText: '请输入汽油价格',
      hintTextStyle: TextStyle(
        color: TDTheme.of(context).textColorPlaceholder,
        fontSize: TDTheme.of(context).fontTitleLarge?.size,
      ),
      textStyle: TextStyle(
        fontSize: TDTheme.of(context).fontTitleLarge?.size,
        color: TDTheme.of(context).textColorPrimary,
      ),
      controller: _gasPriceEditingController,
      additionInfoColor: TDTheme.of(context).errorColor6,
      showBottomDivider: false,
      readOnly: false,
      onChanged: (value) {
        Provider.of<LogRefuelBloc>(context, listen: false)
            .setGasPrice(double.tryParse(value));
      },
      onClearTap: () {
        _gasPriceEditingController.clear();
      });

  Widget _expandableSection(Widget expanded) {
    return ExpandableNotifier(
        child: Padding(
      padding: const EdgeInsets.all(12),
      child: ScrollOnExpand(
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: <Widget>[
              ExpandablePanel(
                controller: _expandableController,
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
                              stream: _paymentDescription,
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
