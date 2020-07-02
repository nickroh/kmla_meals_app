import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



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
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Meal'),
        ),
        body: FutureBuilder<String>(
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
    if (meal == null) {
      meal = '[] [] []';
    }
    print(meal);
    meal = meal.replaceAll('\n', ' ');


    print(meal);
    List check = new List(3);
    int cnt = 0;
    for (int i = 0; i < meal.length; i++) {
      if (meal[i] == '[') {
        check[cnt] = i;
        cnt++;
      }
    }

    if (cnt == 3) {
      morning = meal.substring(check[0] + 4, check[1]);
      Lunch = meal.substring(check[1] + 4, check[2]);
      Dinner = meal.substring(check[2] + 4);
    }


    Widget getErrorWidget(FlutterErrorDetails error) {
      return Center(
        child: Text("Error appeared."),
      );
    }
    void makeslide() {

    }

    void onDonePress() {
      // Back to the first tab
      this.goToTab(0);
    }

    void onTabChangeCompleted(index) {
      // Index of current tab is focused
    }

    Widget renderNextBtn() {
      return Icon(
        Icons.navigate_next,
        color: Color(0xffffcc5c),
        size: 35.0,
      );
    }

    Widget renderDoneBtn() {
      return Icon(
        Icons.done,
        color: Color(0xffffcc5c),
      );
    }

    Widget renderSkipBtn() {
      return Icon(
        Icons.skip_next,
        color: Color(0xffffcc5c),
      );
    }


    @override
    Widget build(BuildContext context) {

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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}