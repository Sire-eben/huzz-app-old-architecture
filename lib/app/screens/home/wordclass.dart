import 'package:flutter/material.dart';
import 'package:flutter_scatter/flutter_scatter.dart';
import 'package:huzz/model/payment_item.dart';
import 'package:random_color/random_color.dart';

class WordCloud extends StatelessWidget { 
  List<PaymentItem> itemList;
WordCloud(this.itemList);
  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = <Widget>[];
    for (var i = 0; i < itemList.length; i++) {
      widgets.add(ScatterItem(itemList[i], i));
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

class ScatterItem extends StatelessWidget {
  ScatterItem(this.item, this.index);
  final PaymentItem item;
  final int index;
   RandomColor _randomColor = RandomColor();
  @override
  Widget build(BuildContext context) {
    final TextStyle style = Theme.of(context).textTheme.bodyText1!.copyWith(
       
          color:_randomColor.randomColor(),
        );
    return RotatedBox(
      quarterTurns:  0,
      child: Text(
       item.itemName!,
        style: style,
      ),
    );
  }
}