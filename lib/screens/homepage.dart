import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
    31, 1, 2, 3, 4, 5, 6 // Assuming today is June 6th, adjust the dates accordingly
  ];

  Future<DocumentSnapshot<Map<String, dynamic>>> _fetchUserData() async {
    return _auth.getUserData();
  }

  @override
  void initState() {
    super.initState();
    _userData = _fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
                            var userData = snapshot.data!.data();
                            print('hello');
                            print(userData);
                            if (userData != null) {
                              return Text("Hi ${userData['fname']}", style: Styles.headline1);
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
      ),
    );
  }
}
