import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth= MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/login_screen_background.jpeg'),
                fit: BoxFit.cover
            )
        ),
        child: Center(
            child: Container(
                color:Colors.transparent,
                child:Column(
                  children:<Widget> [
                    SizedBox(height: screenHeight * 0.3),
                    Container(
                      width:screenWidth * 0.8,
                      child: Text("Cattle Plus",
                          textAlign: TextAlign.center,
                          style:TextStyle(fontWeight: FontWeight.bold,fontSize: screenWidth*0.1,color: Colors.white)
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.2),
                    Container(
                      width:screenWidth * 0.6 ,
                      child: ElevatedButton(
                        onPressed: (){

                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue, // Button background color
                          onPrimary: Colors.white, // Text color
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/google_logo.png',
                              height: screenHeight * 0.1,
                              width: screenWidth * 0.1,
                            ),
                            SizedBox(width: screenWidth * 0.05,),
                            Text("Login With Google")
                          ],
                        ),
                      ),
                    )
                  ],
                )
            )
        ),
      ),
    );
  }
}
