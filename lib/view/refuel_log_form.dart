import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tianqi/view/refuel_form1.dart';

class RefuelLogForm extends StatefulWidget {
  const RefuelLogForm({super.key});

  @override
  State<RefuelLogForm> createState() => _RefuelLogFormState();
}

class _RefuelLogFormState extends State<RefuelLogForm> {
  // @override
  // Widget build(BuildContext context) => TDCollapse.accordion(
  //       style: TDCollapseStyle.block,
  //       expansionCallback: (int index, bool isExpanded) {
  //         // setState(() {
  //         //   _accordionData[index].isExpanded = !isExpanded;
  //         // });
  //       },
  //       children: kSections.map((item) {
  //         return TDCollapsePanel(
  //           headerBuilder: (BuildContext context, bool isExpanded) {
  //             return Text(item);
  //           },
  //           isExpanded: true,
  //           body: const Text('xxxxklkjsldfjsdf sklfjklsdfjlsf ksjfllsjdf'),
  //           value: item,
  //         );
  //       }).toList(),
  //     );

  @override
  Widget build(BuildContext context) => SizedBox.shrink();
}

const kSections = ['Purchase', 'Odometer & Tank', 'Notes & Attachments'];
