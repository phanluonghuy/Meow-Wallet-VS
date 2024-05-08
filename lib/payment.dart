import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signupvs/UserDAO.dart';

class Payment extends StatefulWidget {
  const Payment({super.key});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  UserDAO userDao = UserDAO();
  String _imagepath = '';
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _captchaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _login = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _login = false;
  }

  Widget payment() {
    return Padding(
      padding: EdgeInsets.fromLTRB(33, 35, 33, 0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(4, 0, 4, 22),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Available Balance',
                  style: GoogleFonts.getFont(
                    'Roboto Condensed',
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    height: 1.2,
                    letterSpacing: 0.1,
                    color: Color(0xFF878787),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(4, 0, 4, 31),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  '\$2,85,856.20',
                  style: GoogleFonts.getFont(
                    'Roboto Condensed',
                    fontWeight: FontWeight.w700,
                    fontSize: 35,
                    height: 0.6,
                    letterSpacing: 0.1,
                    color: Color(0xFF5163BF),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(2, 0, 2, 40),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Please, upload your base image to pay',
                  style: GoogleFonts.getFont(
                    'Roboto Condensed',
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                    color: Color(0xFF878787),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 17),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Upload Image',
                  style: GoogleFonts.getFont(
                    'Roboto Condensed',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xFF5265BE),
                  ),
                ),
              ),
            ),
            Stack(
              children: [
                (_imagepath.isEmpty)
                    ? SizedBox()
                    : Image.file(
                        File(_imagepath),
                        fit: BoxFit.cover,
                        opacity: const AlwaysStoppedAnimation(0.7),
                      ),
                FutureBuilder(
                    future: userDao.getImage(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return snapshot?.data ?? SizedBox();
                      }
                      return SizedBox();
                    }),
              ],
            ),
            SizedBox(height: 20),
            // (_imagepath.isEmpty) ? SizedBox() : Image.file(
            //   File(_imagepath),
            //   fit: BoxFit.cover,
            // ),
            (_imagepath.isEmpty)
                ? IconButton(
                    icon: Icon(Icons.upload),
                    iconSize: 30,
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? image =
                          await picker.pickImage(source: ImageSource.gallery);
                      if (image != null) {
                        setState(() {
                          _imagepath = image.path;
                        });
                      }
                    },
                  )
                : Wrap(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Enter captcha in screen',
                            style: GoogleFonts.getFont(
                              'Roboto Condensed',
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                      Form(
                        key: _formKey,
                        child: TextFormField(
                          controller: _captchaController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter captcha!";
                            }
                            if (value.toLowerCase() !=
                                userDao.captcha.toLowerCase()) {
                              return "Wrong captcha";
                            }
                          },
                          decoration: InputDecoration(
                              border: UnderlineInputBorder(),
                              hintText: 'Captcha',
                              hintStyle: TextStyle(
                                  color: Colors.black26, fontSize: 15)),
                        ),
                      ),
                    ],
                  ),
            SizedBox(height: 50),
            Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: 153,
                height: 72,
                child: Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 13),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF5265BE),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Container(
                          width: 153,
                          height: 59,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: ImageFiltered(
                          imageFilter: ImageFilter.blur(
                            sigmaX: 100,
                            sigmaY: 100,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFF5265BE),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Container(
                              width: 153,
                              height: 59,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 53,
                        top: 16,
                        child: InkWell(
                          onTap: () {
                            print("click");
                            if (_formKey.currentState!.validate()) {
                              print("oke");
                            }
                          },
                          child: SizedBox(
                            height: 26,
                            child: Text(
                              'PAY',
                              style: GoogleFonts.getFont(
                                'Roboto Condensed',
                                fontWeight: FontWeight.w600,
                                fontSize: 22,
                                color: Color(0xFFFFFFFF),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget login() {
    return Container(
      padding: EdgeInsets.fromLTRB(33, 73, 33, 52),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Log in',
              style: GoogleFonts.getFont(
                'Roboto Condensed',
                fontWeight: FontWeight.w600,
                fontSize: 40,
                height: 1.3,
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Email Address',
                  style: GoogleFonts.getFont(
                    'Roboto Condensed',
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  hintText: 'example@mail.com',
                  hintStyle: TextStyle(color: Colors.black26, fontSize: 15)),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 18, 0, 0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Password',
                  style: GoogleFonts.getFont(
                    'Roboto Condensed',
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  hintText: 'Password',
                  hintStyle: TextStyle(color: Colors.black26, fontSize: 15),
                  suffixIcon: Icon(Icons.visibility_off)),
            ),
            SizedBox(height: 40),
            Center(
              child: InkWell(
                onTap: () async {
                  if (await userDao.login(
                      _emailController.text, _passwordController.text)) {
                    setState(() {
                      _login = true;
                    });
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF5063BF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    width: 201,
                    height: 59,
                    child: Center(
                      child: Text(
                        'Login',
                        style: GoogleFonts.getFont('Roboto Condensed',
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            Center(
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 11, 14, 7),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFB1B1B1),
                        ),
                        child: Container(
                          width: 79,
                          height: 1,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 15.9, 0),
                      child: Text(
                        'or',
                        style: GoogleFonts.getFont(
                          'Roboto Condensed',
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Color(0xFFB1B1B1),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 11, 0, 7),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFB1B1B1),
                        ),
                        child: Container(
                          width: 79,
                          height: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: SizedBox(
                  width: 120,
                  height: 120,
                  child: Icon(Icons.facebook, size: 60)),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 21, 0),
              child: Align(
                alignment: Alignment.topCenter,
                child: RichText(
                  text: TextSpan(
                    style: GoogleFonts.getFont(
                      'Roboto Condensed',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Color(0xFF5063BF),
                    ),
                    children: [
                      TextSpan(
                        text: 'Don’t have an account?',
                        style: GoogleFonts.getFont(
                          'Roboto Condensed',
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          height: 1.3,
                          color: Color(0xFF878787),
                        ),
                      ),
                      TextSpan(
                        text: ' ',
                        style: GoogleFonts.getFont(
                          'Roboto Condensed',
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          height: 1.3,
                        ),
                      ),
                      TextSpan(
                        text: 'Sign Up',
                        style: GoogleFonts.getFont(
                          'Roboto Condensed',
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          decoration: TextDecoration.underline,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (_login) ? payment() : login(),
    );
  }
}
