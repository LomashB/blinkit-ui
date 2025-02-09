import 'package:blinkit/repository/screens/bottomnav/bottomnavscreen.dart';
import 'package:blinkit/repository/widgets/uihelper.dart';
import 'package:flutter/material.dart';

class loginscreen extends StatelessWidget {
  const loginscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFFFFFFF),
      body: Center(
        child: Column(
          children: [
            UiHelper.CustomImage(img: "Blinkit Onboarding Screen.png"),
            SizedBox(
              height: 10,
            ),
            UiHelper.CustomImage(img: "image 10.png"),
            SizedBox(
              height: 10,
            ),
            UiHelper.CustomText(
                text: "India's Last Minute Delivery app.",
                color: Color(0XFF000000),
                fontweight: FontWeight.bold,
                fontSize: 18,
                fontfamily: "bold"),
            SizedBox(
              height: 20,
            ),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Container(
                height: 200,
                width: 350,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0XFFFFFFFF)),
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    UiHelper.CustomText(
                        text: "Lomash",
                        color: Color(0xFF000000),
                        fontweight: FontWeight.w500,
                        fontSize: 14),
                    SizedBox(
                      height: 5,
                    ),
                    UiHelper.CustomText(
                        text: "63529XXXXX",
                        color: Color(0xFF9c9c9c),
                        fontweight: FontWeight.bold,
                        fontSize: 14),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 48,
                      width: 295,
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>BottomNavScreen()));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFE23744),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              UiHelper.CustomText(
                                  text: "Login with",
                                  color: Color(0xFFFFFFFF),
                                  fontweight: FontWeight.bold,
                                  fontSize: 14,
                                  fontfamily: "bold"),
                              SizedBox(
                                width: 5,
                              ),
                              UiHelper.CustomImage(img: "image 9.png"),
                            ],
                          )),
                    ),
                    SizedBox(height: 8,),
                    UiHelper.CustomText(
                        text: "Acess your saved address from zomato directly.",
                        color: Color(0xFF9c9c9c),
                        fontweight: FontWeight.normal,
                        fontSize: 10,
                        ),
                    SizedBox(height: 10,),
                    UiHelper.CustomText(
                      text: "or Login with Phone number.",
                      color: Color(0xFF269237),
                      fontweight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
