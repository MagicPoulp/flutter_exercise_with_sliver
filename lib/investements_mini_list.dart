import 'package:flutter/material.dart';

import 'package:flutter_exercise_with_sliver_thierry/investment_badge.dart';

class InvestmentsMiniList extends StatelessWidget {
  const InvestmentsMiniList({ Key? key, required this.investmentsDataRow, required this.rowIndex }) : super(key: key);

  final investmentsDataRow;
  final rowIndex;
  final rowHeight = 150.0;

  @override
  Widget build(BuildContext context) {
    var titleHeight = 26.0;
    var row = investmentsDataRow;
    return Container(
      color: Colors.black,
      height: rowHeight,
      margin: EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        // no margin on the first row to keep things aligned with the top bar's content
        margin: rowIndex == 0 ? EdgeInsets.only(bottom: 10.0) : EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: titleHeight, child: Text(row['title'], style: Theme.of(context).textTheme.bodyText1),),
            // we could use Extended here but it is hard to debug the padding it adds between the Text and the ListView
            // instead we can use absolute distances
            Container(
              height: rowHeight - 20 - titleHeight,
              alignment: Alignment.topLeft,
              child: ListView.builder(
                shrinkWrap: true, // interesting option, to occupy less space
                scrollDirection: Axis.horizontal,
                itemCount: row["data"].length,
                itemBuilder: (context, index) {
                  var badgeData = row["data"][index];
                  // note: important knowledge here
                  // wrapping by a Center or an Align is needed or there is a distortion
                  // https://stackoverflow.com/questions/59472726/why-does-aspectratio-not-work-in-a-listview
                  return Align(
                    alignment: Alignment.topLeft,
                    child: InvestmentBadge(
                      name: badgeData["name"],
                      amount: dynamicToDouble(badgeData["amount"]),
                      variation: dynamicToDouble(badgeData["variation"]),
                      color: badgeData["color"],
                      first: index == 0,
                      last: index == row["data"].length - 1,
                    ),
                  );
                },
              ),
            ),
          ],
        )
      ),
    );
  }
}

var dynamicToDouble = (value) {
  return value is int ? (value as int).toDouble() : value;
};
