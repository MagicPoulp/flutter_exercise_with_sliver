import 'package:flutter/material.dart';
import 'dart:math' as math;

class InvestmentBadge extends StatelessWidget {
  const InvestmentBadge(
      { Key? key, required this.name, required this.amount, required this.variation, required this.color,
      required this.first, required this.last}) : super(key: key);

  final String name;
  final double amount;
  final double variation;
  final String color;
  final bool first;
  final bool last;

  // hard-coded colors should be moved to the them config, in the MaterialApp widget
  @override
  Widget build(BuildContext context) {
    var variationStyle = variation >= 0 ?
      Theme.of(context).textTheme.headline5
        : Theme.of(context).textTheme.headline6;
    // these 2 variables must be adjusted together
    var intersticeMargin = 5.0;
    var percentagesContainerWidth = 50.0;
    // the first and the last badge skip the margin to towards the outside.
    var sideMargin = EdgeInsets.symmetric(vertical: 0.0, horizontal: intersticeMargin);
    if (first) {
      sideMargin = EdgeInsets.only(right: intersticeMargin);
    }
    if (last) {
      sideMargin = EdgeInsets.only(left: intersticeMargin);
    }
    return Container(
      margin: sideMargin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(bottom: 5.0),
            child: SizedBox(
              width: 50,
              height: 50,
              child: Container(color: Color(int.parse(color),),),
            ),
          ),
          Text(name, style: Theme.of(context).textTheme.headline3),
          // missing currency symbol but it could be in the string already
          Text(amount.toString(), style: Theme.of(context).textTheme.headline4),
          Stack(
            alignment: Alignment.topLeft,
            children: <Widget>[

              Positioned(
                left: 0,
                top: variation >= 0 ? 2 : -4,
                child:
                  Transform.rotate(
                    angle: variation >= 0 ? 45 * math.pi / 180 : - 45 * math.pi / 180,
                    child: Text(variation >= 0 ? "\u2303 " : "\u2304 ", style: variationStyle),
                  ),
              ),

              Positioned(
                left: 14,
                top: 0,
                child: Text(variation.toString() + "%", style: variationStyle),
              ),

              Container(
                width: percentagesContainerWidth,
                height: 15,
              ),
            ],
          ),
        ],
      ),
    );
  }
}