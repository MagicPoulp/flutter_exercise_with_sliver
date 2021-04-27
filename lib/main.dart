import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_exercise_with_sliver_thierry/investements_mini_list.dart';

void main() {
  // disable auto-rotation
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
    @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter exercise with a sliver',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.dark,
        primaryColor: Colors.lightBlue[800],
        accentColor: Colors.cyan[600],

        // Define the default font family.
        fontFamily: 'Georgia',

        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, fontFamily: 'Hind'),
        ),
      ),
      home: InvestmentsPage(title: 'Investments'),
    );
  }
}

class InvestmentsPage extends StatefulWidget {
  InvestmentsPage({Key? key, required this.title}) : super(key: key);

  // note: this variable is used using widget.title
  final String title;
  final barHeight = kToolbarHeight; // 30 is smaller

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
    final appBarHeight = mediaInfo.size.width * imageRatio;
    // change SafeArea to Scaffold if you want to use the cutout area
    return SafeArea(
      child: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            snap: false,
            floating: true,
            backgroundColor: Colors.transparent,
            elevation: 0, // removes the shadow
            expandedHeight: appBarHeight,
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
                  child: Image.asset('assets/images/banner_akt_token1.png', fit: BoxFit.contain),
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
            /*
            flexibleSpace: FlexibleSpaceBar(
              child: Image.asset('assets/images/banner_akt_token1.png', fit: BoxFit.contain),
                // 330 x 260
              //background: Image.asset('assets/images/banner_akt_token1.png', fit: BoxFit.contain),
              //title: Text(this.title),
            ),
            */
          ),
/*
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                return Image.asset('assets/images/banner_akt_token1.png', fit: BoxFit.contain);
              },
              childCount: 1,
            ),
          ),
*/

          // doc:
          // "SliverFixedExtentList is more efficient than SliverList because SliverFixedExtentList
          // does not need to perform layout on its children to obtain their extent in the main axis."
          SliverFixedExtentList(
            itemExtent: 50.0,
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                return InvestmentsMiniList();
              },
            ),
          ),
        ],
      ),
    );
  }
}
