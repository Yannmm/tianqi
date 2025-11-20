import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

const String randomString =
    "In the heart of the bustling city, a small park offered a sanctuary of tranquility.Children's laughter echoed from the playground, mingling with the soft rustling of leaves in the gentle breeze.Joggers navigated winding paths, their steady breaths in rhythm with the chirping of the early morning birds.Nearby, an elderly man sat on a bench, engrossed in a book, oblivious to the world around him.The park was a microcosm of life, a testament to the city's vibrant spirit and the enduring allure of nature's simple pleasures.";

class CollapseDataItem {
  CollapseDataItem(
      {required this.expandedValue,
      required this.headerValue,
      this.isExpanded = false});

  final String expandedValue;
  final String headerValue;
  bool isExpanded;
}

List<CollapseDataItem> generateItems(int numOfItems) {
  return List.generate(numOfItems, (index) {
    return CollapseDataItem(
      headerValue: '标题 $index',
      expandedValue: '$index',
    );
  });
}

class RefuelForm1 extends StatefulWidget {
  @override
  State<RefuelForm1> createState() => _RefuelForm1State();
}

class _RefuelForm1State extends State<RefuelForm1> {
  final List<CollapseDataItem> _cardStyleData = generateItems(5);

  @override
  Widget build(BuildContext context) {
    return TDCollapse(
      style: TDCollapseStyle.card,
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _cardStyleData[index].isExpanded = !isExpanded;
        });
      },
      children: _cardStyleData.map((CollapseDataItem item) {
        return TDCollapsePanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return Text(item.headerValue);
          },
          isExpanded: item.isExpanded,
          body: const Text(randomString),
        );
      }).toList(),
    );
  }
}
