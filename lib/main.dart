// ignore_for_file: prefer_const_constructors



import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'food.dart';
import 'dart:math';
void main() {
  runApp(const eathical_app());
}

class eathical_app extends StatelessWidget {
  const eathical_app({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eathical',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Eathical'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String foodName = "";
  num foodEmission = 0.00;
  num totalEmission = 0.00;

  int index = 0;

  List _todayFood = [];
  List _todayEmissions = [0];

  List<Food> foodToday = [];

  List<dynamic> data = [];

  Future<void> readJson() async {
    final String response =
        await rootBundle.loadString('assets/json/FoodCo2Emissions.json');
    data = await json.decode(response);
  }

  void initState() {
    super.initState();

    readJson();
  }

  String capitalize(String string) {
    if (string.isEmpty) {
      return string;
    }

   

    return string[0].toUpperCase() + string.substring(1);
  }

  void findCO2(String query) async {
    foodName = "";
    foodEmission = 0.00;

    String searchFood = capitalize(query);
    if (query != "") {
      data.forEach((foodItem) {
        if (foodItem["Food Item"].contains(searchFood)) {
          foodName = foodItem["Food Item"];
          foodEmission = foodItem["CO2 Emissions"];
        }
      });

      setState(() {
        // _todayFood.add(searchFood);
        // _todayEmissions.add(foodEmission);
        // totalEmission += foodEmission;
        // index++;
        // print(index);

        foodToday.add(Food(searchFood, foodEmission));
        totalEmission += foodEmission;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Color.fromARGB(255, 98, 235, 103),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            Row(
              children: [
                Text( "Today's carbon dioxide emissions:",
                  style: TextStyle(
                    color: Color.fromARGB(255, 61, 61, 61),
                    fontSize: 15
                  )
                )],
            ),
            SizedBox(height: 5),
            Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
              Text(totalEmission.toString() + "KG ",
              style: TextStyle(
                  color: Color.fromARGB(255, 56, 56, 56),
                  fontWeight: FontWeight.bold,
                  fontSize: 60
                ),),
              Text(
                "C02",
                style: TextStyle(
                  color: Color.fromARGB(255, 123, 255, 127),
                  fontWeight: FontWeight.bold,
                  fontSize: 30
                ),
              
              ),
            ],),

            SizedBox(height: 70),

            SearchForm(onSearch: findCO2),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: foodToday
                    .map(
                      (element) => Card(
                          child: ListTile(
                        title: Text(element.foodName),
                        subtitle: Text("C02 Emissions: " + element.emission.toString()),
                        leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                "https://spoonacular.com/cdn/ingredients_100x100/" +
                                    element.foodName +
                                    "apple.jpg")),
                      )),
                    )
                    .toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SearchForm extends StatefulWidget {
  SearchForm({required this.onSearch});

  final void Function(String search) onSearch;

  @override
  State<SearchForm> createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {
  final _formKey = GlobalKey<FormState>();
  String _search = "";

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: "Enter food items",
              border: OutlineInputBorder(),
              filled: true,
            ),
            onChanged: (value) {
              _search = value;
            },
          ),
          SizedBox(height: 15),
          
          Text( "Enter major ingredients of the food you ate. \nFor Example: Lasagana would be Meat, Cheese & Pasta.",
                  style: TextStyle(
                    color: Color.fromARGB(255, 155, 155, 155),
                    fontSize: 15
                  )),
          SizedBox(height: 20),
          SizedBox(
            child: TextButton(
              onPressed: () {
                setState(() {
                  widget.onSearch(_search);
                });
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromARGB(255, 93, 255, 98)),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                child: Text(
                  "Add",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
