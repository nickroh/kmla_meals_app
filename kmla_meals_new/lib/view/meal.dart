import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/dot_animation_enum.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:firebase_core/firebase_core.dart';


class Mealview extends StatefulWidget{
  Mealview({ required this.day });

  String day;
  @override
  State<StatefulWidget> createState() => new MealviewState();
}

class MealviewState extends State<Mealview>{
  var Meal;
  late String day;



  static Future<String> getMeal(String day) async {
    String tmp="";
    print(day);
    Firebase.initializeApp();
    await FirebaseFirestore.instance
        .collection('meals')
        .doc(day)
        .get()
        .then((DocumentSnapshot ds) async {
      tmp = ds['meal'].toString();
    });

    return tmp;
  }
  // void _read() async {
  //   DocumentSnapshot documentSnapshot;
  //   try {
  //     documentSnapshot = await FirebaseFirestore.collection('meals').doc('16').get();
  //     print(documentSnapshot.data());
  //   } catch (e) {
  //     print(e);
  //   }
  // }
  void initState(){
    print("initial for MealviewState");
    day = widget.day;

    super.initState();
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
    return FutureBuilder(
      // Initialize FlutterFire
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          print("err");
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return new Container(
              child: FutureBuilder<String>(
                future: getMeal(day),
                builder: (BuildContext context, AsyncSnapshot<String> snapshot){
                  if (snapshot.hasData){
                    print(snapshot.data! + 'snapshot data');
                    return ShowSlides(meal: snapshot.data, );
                  }else{
                    print('no data..');
                    return _buildWaitingScreen();
                  }
                },
              )
            //ShowSlides(meal: Meal),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return _buildWaitingScreen();
      },
    );

  }
}

class ShowSlides extends StatefulWidget {
  ShowSlides({ this.meal});
  var meal;
  @override
  ShowSlidesState createState() => new ShowSlidesState();
}

class ShowSlidesState extends State<ShowSlides> {
  List<Slide> slides = [];

  late Function goToTab;
  static var meal;
  static String morning= "";
  static String Lunch= "";
  static String Dinner = "";

  void formatmeal(){
    if(meal == null){
      meal = '[] [] []';
    }
    print(meal);
    meal = meal.replaceAll('\n', '\n');
    meal = meal.replaceAll('.', '');
    meal = meal.replaceAll('+', '');
    for(int i=0;i<50;i++){
      meal = meal.replaceAll(i.toString(), '');
    }
print("==========================");
    print(meal);
    var check = List.filled(3, 0);
    int cnt=0;
    for(int i=0;i<meal.length;i++){
      if(meal[i] == '['){
        check[cnt] = i;
        cnt++;
      }
    }
    print("#####################");
    if(cnt == 3){
      morning = meal.substring(check[0]+4 , check[1]);
      Lunch = meal.substring(check[1]+4, check[2]);
      Dinner = meal.substring(check[2]+4);
    }
  }

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });

    meal = widget.meal;
    print("++++++++++++++++++++++");
    formatmeal();
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
    List<Widget> tabs = [];
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
                    currentSlide.pathImage?? 'default',
                    width: 200.0,
                    height: 200.0,
                    fit: BoxFit.contain,
                  )),
              Container(
                child: Text(
                  currentSlide.title ?? 'default',
                  style: currentSlide.styleTitle,
                  textAlign: TextAlign.center,
                ),
                margin: EdgeInsets.only(top: 20.0),
              ),
              Container(
                child: Text(
                  currentSlide.description ?? 'default',
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
    return new Scaffold(
      body: new IntroSlider(
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
        hideStatusBar: true,
        // On tab change completed
        onTabChangeCompleted: this.onTabChangeCompleted,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          var currenttime = new DateTime.now();
          var year = currenttime.year;
          var month = currenttime.month;
          DatePicker.showDatePicker(context,
              showTitleActions: true,
              minTime: DateTime(year, month, 1),
              maxTime: DateTime(year, month, 31), onChanged: (date) {
                print('change $date');
              }, onConfirm: (date) {
                print('confirm $date');
                String newday = date.day.toString();
                print(newday);
                Navigator.push(context, MaterialPageRoute(builder: (context) => Mealview(day: newday)));
              }, currentTime: DateTime.now(), locale: LocaleType.en);
//          Navigator.push(context, MaterialPageRoute(builder: (context) => Mealview(day: '4',)));
          // Add your onPressed code here!
        },
        child: Icon(Icons.calendar_today),
        backgroundColor: Colors.green,
      ),
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