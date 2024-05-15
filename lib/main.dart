import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:signupvs/UserDAO.dart';
import 'package:signupvs/payment.dart';
import 'package:signupvs/signUp.dart';

import 'dashBoard.dart';

void main() => runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    )
);

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserDAO userDAO = UserDAO();
  late Future<Image> fetchImage;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> saveImageToGallery(Uint8List imageBytes) async {
    // Get the app's directory for storing images
    final directory = await getApplicationDocumentsDirectory();

    // Create a file with a unique name (e.g., using a timestamp)
    const imageName = 'image_base.jpg';
    final imagePath = '${directory.path}/$imageName';
    final file = File(imagePath);

    // Write the image data to the file
    await file.writeAsBytes(imageBytes);

    // Save the image to the gallery using the image_gallery_saver package
    final result = await ImageGallerySaver.saveFile(imagePath);
    print(result); // Check result to confirm success
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchImage = userDAO.fetchImage();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 400,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/background.png'),
                          fit: BoxFit.fill
                      )
                  ),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: 30,
                        width: 80,
                        height: 200,
                        child: FadeInUp(duration: Duration(seconds: 1), child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/images/light-1.png')
                              )
                          ),
                        )),
                      ),
                      Positioned(
                        left: 140,
                        width: 80,
                        height: 150,
                        child: FadeInUp(duration: Duration(milliseconds: 1200), child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/images/light-2.png')
                              )
                          ),
                        )),
                      ),
                      Positioned(
                        right: 40,
                        top: 40,
                        width: 80,
                        height: 150,
                        child: FadeInUp(duration: Duration(milliseconds: 1300), child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/images/clock.png')
                              )
                          ),
                        )),
                      ),
                      Positioned(
                        child: FadeInUp(duration: Duration(milliseconds: 1600), child: Container(
                          margin: EdgeInsets.only(top: 50),
                          child: Center(
                            child: Text("Sign In", style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),),
                          ),
                        )),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(30.0),
                  child: Column(
                    children: <Widget>[
                      FadeInUp(duration: Duration(milliseconds: 1800), child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade700),
                            boxShadow: [
                              BoxShadow(
                                  color: Color.fromRGBO(143, 148, 251, .2),
                                  blurRadius: 20.0,
                                  offset: Offset(0, 10)
                              )
                            ]
                        ),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color:  Color.fromRGBO(143, 148, 251, 1)))
                              ),
                              child: TextField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Email",
                                    hintStyle: TextStyle(color: Colors.grey[700])
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8.0),
                              child: TextField(
                                obscureText: true,
                                controller: _passwordController,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Password",
                                    hintStyle: TextStyle(color: Colors.grey[700])
                                ),
                              ),
                            )
                          ],
                        ),
                      )),
                      SizedBox(height: 30,),
                      FadeInUp(duration: Duration(milliseconds: 1900), child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(
                                colors: [
                                  Color.fromRGBO(143, 148, 251, 1),
                                  Color.fromRGBO(143, 148, 251, .6),
                                ]
                            )
                        ),
                        child: InkWell(
                          onTap: () async {
                            String _msg = await userDAO.login(_emailController.text, _passwordController.text);
                            print(_msg);
                            if (_msg == "Failed")
                              {const snackBar = SnackBar(
                                content: Text('Your username or password was wrong'),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              }
                            else if (_msg == "Account is lock")
                            {
                              const snackBar = SnackBar(
                                content: Text('Your account was lock!'),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            }
                            else {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context) => dashBoard()),
                                    (Route<dynamic> route) => false,
                              );
                            }
                          },
                          child: Center(
                            child: Text("Sign In", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                          ),
                        ),
                      )),
                      SizedBox(height: 70,),
                      FadeInUp(duration: Duration(milliseconds: 2000), child: InkWell(
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignUp()));
                        },
                          child: Text("Create new account", style: TextStyle(color: Color.fromRGBO(143, 148, 251, 1)),))),
                    ],
                  ),
                )
              ],
            ),
          ),
        )
    );
  }
}