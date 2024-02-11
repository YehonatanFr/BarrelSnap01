import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:startertemplate/pages/business/main_page_business.dart';
import 'package:startertemplate/pages/client/main_page_client.dart';
import 'package:startertemplate/services/auth.dart';
import '/pages/role_section_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

final usernameController = TextEditingController();
final passwordController = TextEditingController();

class _LoginPageState extends State<LoginPage> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>(); // Add form key
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/images/backgroung1.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Form(
              // Wrap your content in a Form widget
              key: _formKey, // Assign the form key
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 50),
                      const Icon(
                        Icons.lock,
                        size: 75,
                        color: Color.fromARGB(255, 198, 193, 193),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'Welcome back you\'ve been missed!',
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 25),
                      TextFormField(
                        onChanged: (value) {
                          setState(() => email = value);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter an email';
                          }
                          return null; // Return null if the input is valid
                        },
                        decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade400),
                          ),
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          hintText: 'E-Mail',
                          hintStyle: TextStyle(color: Colors.grey[500]),
                        ),
                        obscureText: false,
                      ),
                      TextFormField(
                        onChanged: (value) {
                          setState(() => password = value);
                        },
                        validator: (value) {
                          if (value == null || value.length < 6) {
                            return 'Enter a password 6+ chars long';
                          }
                          return null; // Return null if the input is valid
                        },
                        decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade400),
                          ),
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          hintText: 'Password',
                          hintStyle: TextStyle(color: Colors.grey[500]),
                        ),
                        obscureText: true,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: Color.fromARGB(255, 255, 253, 253),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),
                      ElevatedButton(
                        onPressed: () async {
                          // Validate the form
                          if (_formKey.currentState!.validate()) {
                            dynamic result = await _auth
                                .signInWithEmailAndPassword(email, password);
                            if (result == null) {
                              setState(() => error =
                                  'Could not sign in with these credentials');
                            } else {
                              // If sign-in is successful, navigate to the MainPageClient
                              final CollectionReference collRefBusiness =
                                  FirebaseFirestore.instance
                                      .collection('business');
                              final CollectionReference collRefUsers =
                                  FirebaseFirestore.instance
                                      .collection('users');

                              User? user = FirebaseAuth.instance.currentUser;
                              final docSnapshotUser =
                                  await collRefUsers.doc(user!.uid).get();

                              final docSnapshotBusiness =
                                  await collRefBusiness.doc(user!.uid).get();

                              if (docSnapshotUser.exists) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const MainPageClient(),
                                  ),
                                );
                              } else if (docSnapshotBusiness.exists) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const MainPageBusiness(),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text('Failed to login in')));
                              }
                            }
                          }
                        },
                        child: const Text('Sign in'),
                      ),
                      SizedBox(height: 12.0),
                      Text(
                        error,
                        style: TextStyle(color: Colors.red, fontSize: 14.0),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 50.0),
                        child: ElevatedButton(
                          child: Text('Sign in anon'),
                          onPressed: () async {
                            dynamic result = await _auth.signInAnon();
                            if (result == null) {
                              print('error sign in');
                            } else {
                              print('signed in');
                              print(result.uid);
                            }
                          },
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Divider(
                                thickness: 0.5,
                                color: Color.fromARGB(255, 255, 254, 254),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 25.0),
                              child: Text(
                                'Or continue with',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                thickness: 0.5,
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: 25),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RoleSelectionScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'Not a member? \n Register now',
                              style: TextStyle(
                                color: Color.fromARGB(255, 254, 255, 255),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
