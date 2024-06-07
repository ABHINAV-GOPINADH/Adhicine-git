import 'package:adhicine/services/Auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_material_pickers/helpers/show_number_picker.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({Key? key}) : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  bool _isObscured = false;
  var age = 25;
  TextEditingController _fname = TextEditingController();
  TextEditingController _lname = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _confirmpassword = TextEditingController();
  TextEditingController _email = TextEditingController();

  int? _selectedAge;
  String? _selectedSex;
  final List<int> _ages = List<int>.generate(100, (index) => index + 1);

  final Auth _auth = Auth();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Container(
              child: Column(
                children: [
                  TextField(
                    controller: _fname,
                    decoration: InputDecoration(
                      labelText: 'First Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    controller: _lname,
                    decoration: InputDecoration(
                      labelText: 'Last Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 160,
                        child: DropdownButtonFormField(
                            value: _selectedAge,
                            decoration: InputDecoration(
                              labelText: 'Select Age',
                              border: OutlineInputBorder(),
                            ),
                            items: _ages.map((int age) {
                              return DropdownMenuItem<int>(
                                  value: age, child: Text(age.toString()));
                            }).toList(),
                            onChanged: (int? newValue) {
                              setState(() {
                                _selectedAge = newValue;
                              });
                            }),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      // Sex Dropdown
                      Container(
                        width: 160, // Set the desired width
                        child: DropdownButtonFormField<String>(
                          value: _selectedSex,
                          decoration: InputDecoration(
                            labelText: 'Select Sex',
                            border: OutlineInputBorder(),
                          ),
                          items: ['Male', 'Female'].map((String sex) {
                            return DropdownMenuItem<String>(
                              value: sex,
                              child: Text(sex),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedSex = newValue;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    controller: _email,
                    decoration: InputDecoration(
                      labelText: 'email address',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    controller: _password,
                    obscureText: _isObscured,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscured ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscured = !_isObscured;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _confirmpassword,
                    obscureText: _isObscured,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscured ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscured = !_isObscured;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                      onPressed: check,
                      child: Text("Sign Up"))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void check() {
    if (_email.text != null ||
        _password.text != null ||
        _confirmpassword.text != null ||
        _selectedAge != null ||
        _fname.text != null ||
        _lname.text != null ||
        _selectedSex != null) {
      if(_password.text==_confirmpassword.text){
        _auth.signUp(context, _email.text.trim(), _password.text.trim(),_fname.text.trim(),_lname.text.trim(),_selectedAge!,_selectedSex!);
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Password do not match")));
      }
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill all the fields")));
    }
  }
}
