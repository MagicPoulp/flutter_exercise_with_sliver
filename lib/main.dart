import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_exercise_with_sliver_thierry/investements_mini_list.dart';
import 'package:flutter_exercise_with_sliver_thierry/modules/custom_button.dart';
import 'package:flutter_exercise_with_sliver_thierry/parse_json.dart';

void main() {
  // disable auto-rotation
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  parseJsonFromAssets("assets/data/investments_data.json")
      .then((investmentsData) {
    runApp(MyApp(investmentsData: investmentsData));
  });
}

class MyApp extends StatelessWidget {

  MyApp({required this.investmentsData}) : super();

  final investmentsData;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter exercise with a sliver',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.dark,
        primaryColor: Color(0xFF0080ff,), // left part is for the alpha, then RGB
        // const Color(0x0080ff),
        //focusColor: Colors.cyan[600],

        // Define the default font family.
        fontFamily: 'Georgia',

        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, fontFamily: 'Hind'),
          bodyText1: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, color: Colors.white60),

          headline3: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold, color: Colors.white),
          headline4: TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal, color: Colors.white70),
          headline5: TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal, color: Colors.green),
          headline6: TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal, color: Colors.red),
        ),
      ),
      home: InvestmentsPage(title: 'Investments', investmentsData: investmentsData),
    );
  }
}

class InvestmentsPage extends StatefulWidget {
  InvestmentsPage({Key? key, required this.title, required this.investmentsData }) : super(key: key);

  // note: this variable is used using widget.title
  final String title;
  final barHeight = kToolbarHeight; // 30 is smaller
  final investmentsData;

  @override
  _InvestmentsPageState createState() => _InvestmentsPageState();
}

// inspired from:
// https://stackoverflow.com/questions/53622598/changing-sliverappbar-title-color-in-flutter-application
class _InvestmentsPageState extends State<InvestmentsPage> {
  ScrollController _scrollController = new ScrollController();

  double lastTopBarOpacity = 0;

  _scrollListener() {
    if (topBarOpacity != lastTopBarOpacity) {
      setState(() {
        lastTopBarOpacity = topBarOpacity;
      });
    }
  }

  double get topBarOpacity {
    // this factor adjusts the speed of the fade effect.
    // we cannot put a too high factor here or the image can be seen while it is leaving the view
    int slowingFactor = 8;
    double barHeight2 = widget.barHeight * slowingFactor;
    if (!_scrollController.hasClients) {
      return 0;
    }
    if (_scrollController.offset > barHeight2) {
      return 1;
    }

    return 1 - (barHeight2 - _scrollController.offset) / barHeight2 ;
  }

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaInfo = MediaQuery.of(context);
    // note: this ratio preserving fitting of the image will not look good on tablets with very large screens
    double imageRatio = 260 / 330;
    final imageHeight = mediaInfo.size.width * imageRatio;
    double topBarBottomHeight = 100;
    double topBarTotalHeight = imageHeight + topBarBottomHeight;
    // change SafeArea to Scaffold if you want to use the cutout area
    return SafeArea(
      child: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            snap: false,
            floating: false,
            backgroundColor: Colors.transparent,
            elevation: 0, // removes the shadow
            expandedHeight: topBarTotalHeight,
            //title: Text(widget.title),
            //centerTitle: true,
            // note:
            // it would look better in my opinion to put the image in the view list, not in the AppBar
            // However, it is more time consuming whilst the exercise wants a basic silver mechanism.
            flexibleSpace: new Stack(
              alignment: Alignment.topLeft,
              children: <Widget>[
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: topBarTotalHeight,
                  child: renderTopBarContent(
                      imageHeight: imageHeight,
                      topBarBottomHeight: topBarBottomHeight,
                      context: context
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Opacity(
                    opacity: topBarOpacity,
                    child: Container(
                      height: widget.barHeight,
                      color: Colors.black,
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: widget.barHeight,
                  child: Center(child: Text(widget.title, style: Theme.of(context).textTheme.headline1,)),
                ),
              ],
            ),
          ),

          // if we put the banner image here in a SilverList (with childCount=1), it would look nicer in my opinion.
          // But it is complex (not a clean SliverAppBar) to superpose the appBar with an image here.

          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {

                    return InvestmentsMiniList(
                      investmentsDataRow: widget.investmentsData["data"][index],
                      rowIndex: index, // the index is used for styling
                    );
              },
              childCount: 4,
            ),
          ),

          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                return Container(color: Colors.white, height: mediaInfo.size.height);
              },
              childCount: 1,
            ),
          ),

        ]
      ),
    );
  }
}

var renderTopBarContent = ({imageHeight, topBarBottomHeight, context}) {
  return  Column(
    children: <Widget>[
      SizedBox(
        height: imageHeight,
        child: Image.asset('assets/images/banner_akt_token1.png', fit: BoxFit.contain),
      ),
      Container(
      // uncomment this blue color and the other green color to check the alignment of the CustomButton below
      //color: Colors.blue,
      child: SizedBox(
        height: topBarBottomHeight,
        child: Column(
          children: <Widget>[
            Container(height: 5), // just a small padding
            Text('Purchase our exclusive token now with 25% bonus', style: Theme.of(context).textTheme.bodyText1),
            Text('and get your lifetime Elite membership now', style: Theme.of(context).textTheme.bodyText1),
            Expanded(child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Container(
                  height: constraints.maxHeight,
                  alignment: Alignment.center,
                  // uncomment this color to check the alignment of the CustomButton below
                  // color: Colors.green,
                  // we translate to correct an optical effect. the bottom of the text seems further away
                  // due to letters that go down (y, j, etc)
                  //transform: Transform.translate(offset: Offset(0.0,-2.0)).transform,
                  child: CustomButton(
                    text: 'Learn more',
                    image: 'assets/images/fontawesome/arrow-right.png',
                    onPressed: () {
                      // open a dialog or change of page
                    },
                  ),
                  //   ),
                );
              },
            ),
            )
          ],
        ),
      ),
      ),
    ],
  );
};