import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:matrimony_app/Screens/bottomNavigator.dart';
import 'package:matrimony_app/Services/validator.dart';
import 'package:matrimony_app/Widgets/customWidgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  static const routName = "/Login";
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final FocusNode _emailFocus;
  late final FocusNode _passwordFocus;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState(){
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _emailFocus = FocusNode();
    _passwordFocus = FocusNode();
    super.initState();
  }
  @override
  void dispose(){
    if(mounted)
    {
      _emailController.dispose();
      _passwordController.dispose();
      _emailFocus.dispose();
      _passwordFocus.dispose();
    }
    super.dispose();
  }
  
  Future<void> _login() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      try {
        if(_emailController.text == "admin@gmail.com" && _passwordController.text == "admin@123"){
          Fluttertoast.showToast(msg: "Login Successfully");

          final prefs = await SharedPreferences.getInstance();
          prefs.setBool('isLoggedIn', true);

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => RootScreen()),
          );
        }
        else{
          Fluttertoast.showToast(msg: "Invalid Username or Password", backgroundColor: Colors.redAccent);
        }
        
      } catch (error) {
        Fluttertoast.showToast(msg: error.toString(), backgroundColor: Colors.redAccent);
      }
    }
  }

  bool passwordVisible = true;

  @override
  Widget build(BuildContext context) {
    CustomWidgets cw = CustomWidgets();
    return PopScope(
      canPop: false,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text("Log in",style: TextStyle(fontSize: 15,color: Colors.grey),),
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
          ),
          body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("asset/images/login.png",height: 175,),
                    const SizedBox(height: 16,),
                    Text("Welcome To Matrify",style: TextStyle(fontSize: 25),),
                    const SizedBox(
                      height: 20,
                    ),
                    Form(
                      key: _formKey,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            cw.CustomInputField(label: "Email", controller: _emailController ,prefixIcon: Icon(Icons.email), inputType: TextInputType.emailAddress, validator: Validators.emailValidator),
                            const SizedBox(height: 20.0,),
                            cw.CustomInputField(label: "Password", controller: _passwordController, obscureText: passwordVisible, prefixIcon: Icon(Icons.lock), suffixIcon: Icon(passwordVisible ? Icons.visibility_off : Icons.visibility), iconOnPress: () => setState(() => passwordVisible = !passwordVisible), validator: Validators.passwordValidator),
                            const SizedBox(height: 20.0,),
                            ElevatedButton(
                              child: Text("Log in"),
                              onPressed: () => _login(),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
      ),
    );
  }
}


