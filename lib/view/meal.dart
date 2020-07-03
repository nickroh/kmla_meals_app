import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'intro_slider.dart';
import 'slide_object.dart';
import 'dot_animation_enum.dart';


class Mealview extends StatefulWidget{
  Mealview({Key key}) : super(key:key);

  @override
  MealviewState createState() => new MealviewState();
}

class MealviewState extends State<Mealview>{
  String Meal;

  static var now = new DateTime.now();
  static var date = now.day;
  static String day = date.toString();

  Future<String> getMeal() async {
    String tmp;

    await Firestore.instance
        .collection('meals')
        .document(day)
        .get()
        .then((DocumentSnapshot ds) async {
      // use ds as a snapshot
      tmp = ds['meal'].toString();
    });
    return tmp;

  }

  void initState(){
    print("initial for MealviewState");
    getMeal();
    Firestore.instance
        .collection('meals')
        .document(day)
        .get()
        .then((DocumentSnapshot ds) async {
      // use ds as a snapshot
      var tmp = await ds['meal'];
      Meal = tmp;
    });

    print(Meal);
  }

  Widget _buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }



  @override
  Widget build(BuildContext context){
    return new Container(
        child: FutureBuilder<String>(
          future: getMeal(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot){
            if (snapshot.hasData){
              print(snapshot.data + 'snapshot data');
              return ShowSlides(meal: snapshot.data);
            }else{
              print('no data');
              return _buildWaitingScreen();
            }
          },
        )
      //ShowSlides(meal: Meal),
    );
  }
}

class ShowSlides extends StatefulWidget {
  ShowSlides({Key key, this.meal}) : super(key: key);

  String meal;
  @override
  ShowSlidesState createState() => new ShowSlidesState();
}

class ShowSlidesState extends State<ShowSlides> {
  List<Slide> slides = new List();

  Function goToTab;

  static var now = new DateTime.now();
  static var date = now.day;
  static String day = date.toString();




  static var meal;

  static String morning= "";
  static String Lunch= "";
  static String Dinner = "";


  @override
  void initState() {
    super.initState();
    meal = widget.meal;
    if(meal == null){
      meal = '[] [] []';
    }
    print(meal);
    meal = meal.replaceAll('\n', '\n');
    meal = meal.replaceAll('.', '');
    for(int i=0;i<20;i++){
      meal = meal.replaceAll(i.toString(), '');
    }

    print(meal);
    List check = new List(3);
    int cnt=0;
    for(int i=0;i<meal.length;i++){
      if(meal[i] == '['){
        check[cnt] = i;
        cnt++;
      }
    }

    if(cnt == 3){
      morning = meal.substring(check[0]+4 , check[1]);
      Lunch = meal.substring(check[1]+4, check[2]);
      Dinner = meal.substring(check[2]+4);
    }

    slides.add (
      new Slide (
        title: "Morning",
        styleTitle: TextStyle(
            color: Colors.orangeAccent,
            fontSize: 35.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'RobotoMono'),
        description: morning,
        styleDescription: TextStyle(
            color: Colors.black,
            fontSize: 20.0,
            height: 1.2,
            fontStyle: FontStyle.normal,
            fontFamily: 'Raleway'),
        pathImage: "assets/morning.png",
        backgroundColor: Color(0xfff5a623),
      ),
    );
    slides.add(
      new Slide(
        title: "Lunch",
        styleTitle: TextStyle(
            color: Colors.deepOrangeAccent,
            fontSize: 35.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'RobotoMono'),
        description:
        Lunch,
        styleDescription: TextStyle(
            color: Colors.black,
            fontSize: 20.0,
            height: 1.2,
            fontStyle: FontStyle.normal,
            fontFamily: 'Raleway'),
        pathImage: "assets/lunch.png",
      ),
    );
    slides.add(
      new Slide(
        title: "Dinner",
        styleTitle:
            TextStyle(
                color: Colors.redAccent,
                fontSize: 35.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'RobotoMono'),
        description:
        Dinner,
        styleDescription: TextStyle(
            color: Colors.black,
            fontSize: 20.0,
            height: 1.2,
            fontStyle: FontStyle.normal,
            fontFamily: 'Raleway'),
        pathImage: "assets/dinner.png",
        colorBegin: Color(0xffFFDAB9),
        colorEnd: Color(0xff40E0D0),
      ),
    );
  }
  Widget getErrorWidget(FlutterErrorDetails error) {
    return Center(
      child: Text("Error appeared."),
    );
  }

  void onTabChangeCompleted(index) {
    // Index of current tab is focused
  }

  List<Widget> renderListCustomTabs() {
    List<Widget> tabs = new List();
    for (int i = 0; i < slides.length; i++) {
      Slide currentSlide = slides[i];
      tabs.add(Container(
        width: double.infinity,
        height: double.infinity,
        child: Container(
          margin: EdgeInsets.only(bottom: 60.0, top: 60.0),
          child: ListView(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(35),
              ),
              GestureDetector(
                  child: Image.asset(
                    currentSlide.pathImage,
                    width: 200.0,
                    height: 200.0,
                    fit: BoxFit.contain,
                  )),
              Container(
                child: Text(
                  currentSlide.title,
                  style: currentSlide.styleTitle,
                  textAlign: TextAlign.center,
                ),
                margin: EdgeInsets.only(top: 20.0),
              ),
              Container(
                child: Text(
                  currentSlide.description,
                  style: currentSlide.styleDescription,
                  textAlign: TextAlign.center,
                  maxLines: 20,
                  overflow: TextOverflow.ellipsis,
                ),
                margin: EdgeInsets.all(5.0),
              ),
            ],
          ),
        ),
      ));
    }
    return tabs;
  }

  @override
  Widget build(BuildContext context) {
    return new IntroSlider(
      // List slides
      slides: this.slides,

      // Dot indicator
      colorDot: Color(0xffffcc5c),
      sizeDot: 13.0,
      typeDotAnimation: dotSliderAnimation.SIZE_TRANSITION,

      // Tabs
      listCustomTabs: this.renderListCustomTabs(),
      backgroundColorAllSlides: Colors.white,
      refFuncGoToTab: (refFunc) {
        this.goToTab = refFunc;
      },

      // Show or hide status bar
      shouldHideStatusBar: true,

      // On tab change completed
      onTabChangeCompleted: this.onTabChangeCompleted,
    );
  }

  Widget _buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,

        child: CircularProgressIndicator(),
      ),
    );
  }
}