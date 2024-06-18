import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../components/addmedince.dart';
import '../components/navigationpage.dart';
import '../services/Auth.dart';
import '../utils/fontstyles.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _auth = AuthService();
  late Future<DocumentSnapshot<Map<String, dynamic>>> _userData;

  final List<String> days = [
    'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun',
  ];

  final List<int> dates = [
    DateTime.now().day,
    for (int i = 1; i < 7; i++) (DateTime.now().add(Duration(days: i))).day,
  ];

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _userData = _fetchUserData();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> _fetchUserData() async {
    return _auth.getUserData();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showTextFieldDialog(BuildContext context) {
    TextEditingController _textFieldController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter Text'),
          content: TextField(
            controller: _textFieldController,
            decoration: InputDecoration(hintText: "Enter text here"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                // Process the entered text here
                print(_textFieldController.text);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildPageContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomeContent();
      case 1:
        return Center(child: Text('Report Page')); // Replace with your Report Page
      default:
        return _buildHomeContent();
    }
  }

  Widget _buildHomeContent() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          child: Container(
            child: Column(
              children: [
                SizedBox(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      future: _userData,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          var userData = snapshot.data?.data(); // Access data from the snapshot
                          if (userData != null) {
                            return Text(userData['fname'], style: Styles.headline1); // Accessing 'fname'
                          } else {
                            return Text('User data is null', style: Styles.headline1);
                          }
                        } else {
                          return Text('No user data found', style: Styles.headline1);
                        }
                      },
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.local_pharmacy,
                          size: 48, // Adjust size as needed
                          color: Colors.blue, // Adjust color as needed
                        ),
                        CircleAvatar(
                          radius: 25, // Adjust the radius as needed
                          backgroundImage: AssetImage('assets/men.jpg'),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(width: 5,),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("5 medicine left"),
                )
              ],
            ),
          ),
        ),
        Container(
          height: 100, // Adjust the height as needed
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: days.length,
            itemBuilder: (context, index) {
              return Container(
                width: 100, // Adjust the width as needed
                margin: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        days[index],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        dates[index].toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Text("Morning 8:00"),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildPageContent(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          // Navigate to the AddMedicine screen
          AddMedicine(context);
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: NavigationPage(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemTapped,
        onFabPressed: () {
          // Action when the FAB is pressed
          _showTextFieldDialog(context);
        },
      ),
    );
  }
}
