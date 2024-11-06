import 'package:aaele/auth/repository/auth_repository.dart';
import 'package:aaele/Insights/screens/custom_bottom_bar.dart';
import 'package:aaele/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _pidController = TextEditingController();

  bool isLoading = false;

  void login() async {
    setState(() {
      isLoading = true;
    });
    AuthRepository homeRepository = AuthRepository();
    String username = _usernameController.text.trim();
    int pid = int.parse(_pidController.text.trim());
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    UserModel user = await homeRepository.logIn(context, username, pid);
    prefs.setInt("student_id", pid);
    prefs.setString("name", user.userName);
    // prefs.setString("meet_id", );
    // ignore: use_build_context_synchronously
    setState(() {
      isLoading = false;
    });
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
    const CustomBottomBar()), (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 180.0,left: 20),
              child: RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                        text: "Video Call\n",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 34,
                            fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: "AAELE login",
                        style: TextStyle(
                            color: Colors.blue.shade700,
                            fontSize: 38,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text("It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. ", style: TextStyle(color: Colors.grey.shade500),),
            ),
            SizedBox(height: 70),
            isLoading ? const Center(child: CircularProgressIndicator()) :  Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 70),
                height: 400,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(width: 1.0, color: Colors.grey.shade300)),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 12, right: 12, top: 22, bottom: 12),
                  child: Column(
                    children: [
                      // Image.asset('assets/userLogo.png'),
                      Icon(Icons.person_outline, size: 40,),
                      const SizedBox(height: 40),
                      SizedBox(
                        width: 350,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            onChanged: (value) {
                              setState(() {
                                _usernameController.text = value;
                              });
                            },
                            controller: _usernameController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                suffix: _usernameController.text.length > 9
                                    ? Container(
                                        height: 16,
                                        width: 16,
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.green),
                                        child: const Icon(
                                          Icons.done_outline_rounded,
                                          size: 12,
                                          color: Colors.white,
                                        ),
                                      )
                                    // ? const Icon(Icons.done_outline_rounded, color: Colors.green, size: 12,)
                                    : null,
                                hintText: "  Enter your username",
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                prefixIcon: Container(
                                  padding: const EdgeInsets.only(
                                      left: 8, right: 8, top: 11.5),
                                  child: InkWell(
                                    onTap: () {
                                      // showCountryPicker(
                                      //   context: context,
                                      //   countryListTheme:
                                      //       CountryListThemeData(
                                      //           bottomSheetHeight:
                                      //               MediaQuery.of(context)
                                      //                       .size
                                      //                       .height /
                                      //                   1.5),
                                      //   onSelect: (value) {
                                      //     setState(() {
                                      //       country = value;
                                      //     });
                                      //   },
                                      // );
                                    },
                                    child: Icon(Icons.email)
                                  ),
                                )),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 350,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            onChanged: (value) {
                              setState(() {
                                _pidController.text = value;
                              });
                            },
                            controller: _pidController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                suffix: _pidController.text.length > 9
                                    ? Container(
                                        height: 16,
                                        width: 16,
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.green),
                                        child: const Icon(
                                          Icons.done_outline_rounded,
                                          size: 12,
                                          color: Colors.white,
                                        ),
                                      )
                                    // ? const Icon(Icons.done_outline_rounded, color: Colors.green, size: 12,)
                                    : null,
                                hintText: "  Enter your password",
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                prefixIcon: Container(
                                  padding: const EdgeInsets.only(
                                      left: 8, right: 8, top: 11.5),
                                  child: InkWell(
                                    onTap: () {
                                      // showCountryPicker(
                                      //   context: context,
                                      //   countryListTheme:
                                      //       CountryListThemeData(
                                      //           bottomSheetHeight:
                                      //               MediaQuery.of(context)
                                      //                       .size
                                      //                       .height /
                                      //                   1.5),
                                      //   onSelect: (value) {
                                      //     setState(() {
                                      //       country = value;
                                      //     });
                                      //   },
                                      // );
                                    },
                                    child: const Icon(Icons.password)
                                  ),
                                )),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      SizedBox(
                        height: 50,
                        width: 320,
                        child: ElevatedButton(
                          onPressed: () {
                            if(_usernameController.text.trim().length ==0 || _pidController.text.trim().length == 0) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Enter valid credentials")));
                            }
                            login();
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 27, 78, 165),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                          child: const Text(
                            "LOGIN",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      RichText(
                          text: const TextSpan(children: [
                        TextSpan(
                            text: "By continuing you are agreeing to our \n",
                            style: TextStyle(
                                color: Colors.black, fontWeight: FontWeight.w400)),
                        TextSpan(
                            text: "Terms & Conditions ",
                            style: TextStyle(
                                color: Colors.blue, fontWeight: FontWeight.w400)),
                        TextSpan(
                            text: "and ",
                            style: TextStyle(
                                color: Colors.black, fontWeight: FontWeight.w400)),
                        TextSpan(
                            text: "Privacy Policy",
                            style: TextStyle(
                                color: Colors.blue, fontWeight: FontWeight.w400)),
                      ]))
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
}