import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'dart:math' as math;

class RefuelLogForm extends StatefulWidget {
  @override
  State<RefuelLogForm> createState() => _RefuelLogFormState();
}

class _RefuelLogFormState extends State<RefuelLogForm> {
  final _controller = ExpandableController(initialExpanded: false);

  final _section1Title = ReplaySubject<String>(maxSize: 1);

  @override
  void initState() {
    _controller.addListener(() {
      _section1Title
          .add(_controller.expanded ? 'Refuel Log Details' : 'Refuel Log');
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    buildItem(String label) {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(label),
      );
    }

    buildList() {
      return Column(
        children: <Widget>[
          for (var i in [1, 2, 3, 4]) buildItem("Item ${i}"),
        ],
      );
    }

    return ExpandableNotifier(
        child: Padding(
      padding: const EdgeInsets.all(12),
      child: ScrollOnExpand(
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: <Widget>[
              ExpandablePanel(
                controller: _controller,
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
                            collapseIcon: TDIcons.arrow_up_down_3,
                            iconColor: Colors.white,
                            iconSize: 28.0,
                            iconRotationAngle: math.pi / 2,
                            iconPadding: EdgeInsets.only(right: 5),
                            hasIcon: false,
                          ),
                        ),
                        Expanded(
                          child: StreamBuilder(
                              stream: _section1Title,
                              builder: (context, snapshot) => Text(
                                    snapshot.data ?? '',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(color: Colors.white),
                                  )),
                        ),
                      ],
                    ),
                  ),
                ),
                collapsed: const SizedBox.shrink(),
                expanded: _buildForm(context),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  // Form test starts
  final _formController = FormController();

  final _editingController1 = TextEditingController();

  final _editingController2 = TextEditingController();

  final TDCheckboxGroupController _genderCheckboxGroupController =
      TDCheckboxGroupController();

  /// 整个表单存放的数据
  Map<String, dynamic> _formData = {
    'name': '',
    'password': '',
    'gender': '',
    'birth': '',
    'place': '',
    'age': '2',
    'description': '2',
    'resume': '',
    'photo': '',
  };

  final Map<String, dynamic> _formItemNotifier = {
    'name': FormItemNotifier(),
    'password': FormItemNotifier(),
    'gender': FormItemNotifier(),
    'birth': FormItemNotifier(),
    'place': FormItemNotifier(),
    'age': FormItemNotifier(),
    'description': FormItemNotifier(),
    'resume': FormItemNotifier(),
    'photo': FormItemNotifier(),
  };

  final Map<String, String> _radios = {'0': '男', '1': '女', '3': '保密'};

  Widget _buildForm(BuildContext context) {
    final theme = TDTheme.of(context);
    return Container(
      color: Colors.red,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TDForm(
            formController: _formController,
            disabled: false,
            data: _formData,
            isHorizontal: true,
            rules: {},
            formContentAlign: TextAlign.left,
            requiredMark: false,

            /// 确定整个表单是否展示提示信息
            formShowErrorMessage: true,
            onSubmit: () {},
            items: [
              // TDFormItem(
              //   label: '用户名',
              //   name: 'name',
              //   type: TDFormItemType.input,
              //   help: '请输入用户名',
              //   labelWidth: 82.0,
              //   formItemNotifier: _formItemNotifier['name'],

              //   /// 控制单个 item 是否展示错误提醒
              //   showErrorMessage: true,
              //   requiredMark: true,
              //   child: TDInput(
              //       leftContentSpace: 0,
              //       inputDecoration: InputDecoration(
              //         hintText: '请输入用户名',
              //         border: InputBorder.none,
              //         hintStyle: TextStyle(
              //           color: TDTheme.of(context).textColorPlaceholder,
              //         ),
              //       ),
              //       controller: _editingController1,
              //       additionInfoColor: TDTheme.of(context).errorColor6,
              //       showBottomDivider: false,
              //       readOnly: false,
              //       onChanged: (val) {
              //         _formItemNotifier['name']?.upDataForm(val);
              //       },
              //       onClearTap: () {
              //         _editingController1.clear();
              //         _formItemNotifier['name']?.upDataForm('');
              //       }),
              // ),
              // TDFormItem(
              //   label: '密码',
              //   name: 'password',
              //   type: TDFormItemType.input,
              //   labelWidth: 82.0,
              //   formItemNotifier: _formItemNotifier['password'],
              //   showErrorMessage: true,
              //   child: TDInput(
              //       leftContentSpace: 0,
              //       inputDecoration: InputDecoration(
              //         hintText: '请输入密码',
              //         border: InputBorder.none,
              //         hintStyle: TextStyle(
              //           color: TDTheme.of(context).textColorPlaceholder,
              //         ),
              //       ),
              //       type: TDInputType.normal,
              //       controller: _editingController2,
              //       obscureText: true,
              //       needClear: false,
              //       readOnly: false,
              //       showBottomDivider: false,
              //       onChanged: (val) {
              //         _formItemNotifier['password']?.upDataForm(val);
              //       },
              //       onClearTap: () {
              //         _editingController2.clear();
              //         _formItemNotifier['password']?.upDataForm('');
              //       }),
              // ),
              TDFormItem(
                label: '性别',
                name: 'gender',
                type: TDFormItemType.radios,
                labelWidth: 82.0,
                showErrorMessage: true,
                formItemNotifier: _formItemNotifier['gender'],
                child: TDRadioGroup(
                  spacing: 0,
                  direction: Axis.horizontal,
                  controller: _genderCheckboxGroupController,
                  directionalTdRadios: _radios.entries.map((entry) {
                    return TDRadio(
                      id: entry.key,
                      title: entry.value,
                      radioStyle: TDRadioStyle.circle,
                      showDivider: false,
                      spacing: 4,
                      checkBoxLeftSpace: 0,
                      customSpace: EdgeInsets.all(0),
                      enable: true,
                    );
                  }).toList(),
                  onRadioGroupChange: (ids) {
                    if (ids == null) {
                      return;
                    }
                    _formItemNotifier['gender']?.upDataForm(ids);
                  },
                ),
              ),
              // TDFormItem(
              //   label: '生日',
              //   name: 'birth',
              //   labelWidth: 82.0,
              //   type: TDFormItemType.dateTimePicker,
              //   contentAlign: TextAlign.left,
              //   tipAlign: TextAlign.left,
              //   formItemNotifier: _formItemNotifier['birth'],
              //   hintText: '请输入内容',
              //   select: _selected_1,
              //   selectFn: (BuildContext context) {
              //     if (_formDisableState) {
              //       return;
              //     }
              //     TDPicker.showDatePicker(context, title: '选择时间',
              //         onConfirm: (selected) {
              //       setState(() {
              //         _selected_1 =
              //             '${selected['year'].toString().padLeft(4, '0')}-${selected['month'].toString().padLeft(2, '0')}-${selected['day'].toString().padLeft(2, '0')}';
              //         _formItemNotifier['birth']?.upDataForm(_selected_1);
              //       });
              //       Navigator.of(context).pop();
              //     },
              //         dateStart: [1999, 01, 01],
              //         dateEnd: [2050, 12, 31],
              //         initialDate: [2012, 1, 1]);
              //   },
              // ),
              // TDFormItem(
              //   label: '籍贯',
              //   name: 'place',
              //   type: TDFormItemType.cascader,
              //   contentAlign: TextAlign.left,
              //   tipAlign: TextAlign.left,
              //   labelWidth: 82.0,
              //   hintText: '请输入内容',
              //   select: _selected_2,
              //   formItemNotifier: _formItemNotifier['place'],
              //   selectFn: (BuildContext context) {
              //     if (_formDisableState) {
              //       return;
              //     }
              //     TDCascader.showMultiCascader(context,
              //         title: '选择地址',
              //         data: _data,
              //         initialData: _initLocalData,
              //         theme: 'step',
              //         onChange: (List<multicascaderlistmodel> selectData) {
              //       setState(() {
              //         var result = [];
              //         var len = selectData.length;
              //         _initLocalData = selectData[len - 1].value!;
              //         selectData.forEach((element) {
              //           result.add(element.label);
              //         });
              //         _selected_2 = result.join('/');
              //         _formItemNotifier['place']?.upDataForm(_selected_2);
              //       });
              //     }, onClose: () {
              //       Navigator.of(context).pop();
              //     });
              //   },
              // ),
              // TDFormItem(
              //     label: '年限',
              //     name: 'age',
              //     labelWidth: 82.0,
              //     type: TDFormItemType.stepper,
              //     formItemNotifier: _formItemNotifier['age'],
              //     child: Padding(
              //       padding: const EdgeInsets.only(right: 18),
              //       child: TDStepper(
              //         theme: TDStepperTheme.filled,
              //         disabled: _formDisableState,
              //         eventController: _stepController!,
              //         value: int.parse(_formData['age']),
              //         onChange: (value) {
              //           _formItemNotifier['age']?.upDataForm('${value}');
              //         },
              //       ),
              //     )),
              // TDFormItem(
              //   label: '自我评价',
              //   name: 'description',
              //   tipAlign: TextAlign.left,
              //   type: TDFormItemType.rate,
              //   labelWidth: 82.0,
              //   formItemNotifier: _formItemNotifier['description'],
              //   child: Align(
              //     alignment: Alignment.centerLeft,
              //     child: Padding(
              //         padding: const EdgeInsets.only(right: 18),
              //         child: TDRate(
              //           count: 5,
              //           value: double.parse(_formData['description']),
              //           allowHalf: false,
              //           disabled: _formDisableState,
              //           onChange: (value) {
              //             setState(() {
              //               _formData['description'] = '${value}';
              //             });
              //             _formItemNotifier['description']?.upDataForm('${value}');
              //           },
              //         )),
              //   ),
              // ),
              // TDFormItem(
              //     label: '个人简介',
              //     labelWidth: 82.0,
              //     name: 'resume',
              //     type: TDFormItemType.textarea,
              //     formItemNotifier: _formItemNotifier['resume'],
              //     child: Padding(
              //       padding:
              //           EdgeInsets.only(top: _isFormHorizontal ? 0 : 8, bottom: 4),
              //       child: TDTextarea(
              //         backgroundColor: Colors.red,
              //         hintText: '请输入个人简介',
              //         maxLength: 500,
              //         indicator: true,
              //         readOnly: _formDisableState,
              //         layout: TDTextareaLayout.vertical,
              //         controller: _controller[2],
              //         showBottomDivider: false,
              //         onChanged: (value) {
              //           _formItemNotifier['resume']?.upDataForm(value);
              //         },
              //       ),
              //     )),
              // TDFormItem(
              //     label: '上传图片',
              //     name: 'photo',
              //     labelWidth: 82.0,
              //     type: TDFormItemType.upLoadImg,
              //     formItemNotifier: _formItemNotifier['photo'],
              //     child: Padding(
              //       padding: EdgeInsets.only(top: 4, bottom: 4),
              //       child: TDUpload(
              //         files: files,
              //         multiple: true,
              //         max: 6,
              //         onError: print,
              //         onValidate: print,
              //         disabled: _formDisableState,
              //         onChange: ((imgList, type) {
              //           if (_formDisableState) {
              //             return;
              //           }
              //           files = _onValueChanged(files ?? [], imgList, type);
              //           List imgs =
              //               files.map((e) =&gt; e.remotePath ?? e.assetPath).toList();
              //           setState(() {
              //             _formItemNotifier['photo'].upDataForm(imgs.join(','));
              //           });
              //         }),
              //       ),
              // ))
            ],
            btnGroup: null,
            // Padding(
            //     padding: const EdgeInsets.all(16),
            //     child: Row(
            //       children: [
            //         Expanded(
            //             child: TDButton(
            //           text: '重置',
            //           size: TDButtonSize.large,
            //           type: TDButtonType.fill,
            //           theme: TDButtonTheme.light,
            //           shape: TDButtonShape.rectangle,
            //           disabled: false,
            //           onTap: () {
            //             //用户名称
            //             _controller[0].clear();
            //             //密码
            //             _controller[1].clear();
            //             // 性别
            //             _genderCheckboxGroupController.toggle('', false);
            //             //个人简介
            //             _controller[2].clear();
            //             //生日
            //             _selected_1 = '';
            //             //籍贯
            //             _selected_2 = '';
            //             //年限
            //             _stepController.add(TDStepperEventType.cleanValue);
            //             //上传图片
            //             files.clear();
            //             _formData = {
            //               'name': '',
            //               'password': '',
            //               'gender': '',
            //               'birth': '',
            //               'place': '',
            //               'age': '0',
            //               'description': '2',
            //               'resume': '',
            //               'photo': ''
            //             };
            //             _formData.forEach((key, value) {
            //               _formItemNotifier[key].upDataForm(value);
            //             });
            //             _formController.reset(_formData);
            //             setState(() {});
            //           },
            //         )),
            //         const SizedBox(
            //           width: 20,
            //         ),
            //         Expanded(
            //             child: TDButton(
            //                 text: '提交',
            //                 size: TDButtonSize.large,
            //                 type: TDButtonType.fill,
            //                 theme: TDButtonTheme.primary,
            //                 shape: TDButtonShape.rectangle,
            //                 // onTap: _onSubmit,
            //                 // disabled: _formDisableState
            //                 )),
            //       ],
            //     ))
            // ]
          ),
        ],
      ),
    );
  }
}

const kSections = ['Purchase', 'Odometer & Tank', 'Notes & Attachments'];
