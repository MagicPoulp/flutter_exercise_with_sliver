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
  final barHeight = 30.0;

  @override
  _InvestmentsPageState createState() => _InvestmentsPageState();
}

// https://stackoverflow.com/questions/53622598/changing-sliverappbar-title-color-in-flutter-application
class _InvestmentsPageState extends State<InvestmentsPage> {
  ScrollController _scrollController = new ScrollController();

  bool lastStatus = true;

  _scrollListener() {
    if (isShrink != lastStatus) {
      setState(() {
        lastStatus = isShrink;
      });
    }
  }

  bool get isShrink {
    return _scrollController.hasClients &&
    _scrollController.offset > (200 - kToolbarHeight);
  }

  @override
  void initState() {
    _scrollController = ScrollController();
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
                Image.asset('assets/images/banner_akt_token1.png', fit: BoxFit.contain),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  //bottom: 0,
                  //child: Container(
                  //  color: Colors.blue,
                  //),
                  child: Opacity(
                    opacity: 1,
                    child: Container(
                      height: widget.barHeight,
                      color: Colors.blue,
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: widget.barHeight,
                  //bottom: 0,
                  //child: Container(
                  //  color: Colors.blue,
                  //),
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
