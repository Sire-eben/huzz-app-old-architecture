import 'package:flutter/material.dart';
import 'package:flutter_scatter/flutter_scatter.dart';
import 'package:huzz/model/payment_item.dart';
import 'package:random_color/random_color.dart';

// ignore: must_be_immutable
class WordCloud extends StatelessWidget {
  List<PaymentItem> itemList;
  WordCloud(this.itemList);
  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = <Widget>[];
    List<String> values = itemList.map((e) => e.itemName!).toSet().toList();
    for (var i = 0; i < values.length; i++) {
      widgets.add(ScatterItem(values[i], i));
    }

    final screenSize = MediaQuery.of(context).size;
    final ratio = screenSize.width / screenSize.height;

    return Center(
      child: FittedBox(
        child: Scatter(
          fillGaps: true,
          delegate: ArchimedeanSpiralScatterDelegate(ratio: ratio),
          children: widgets,
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class ScatterItem extends StatelessWidget {
  ScatterItem(this.item, this.index);
  final String item;
  final int index;
  RandomColor _randomColor = RandomColor();
  @override
  Widget build(BuildContext context) {
    final TextStyle style = Theme.of(context).textTheme.bodyText1!.copyWith(
          color: _randomColor.randomColor(),
        );
    return RotatedBox(
      quarterTurns: 0,
      child: Text(
        item,
        style: style,
      ),
    );
  }
}
