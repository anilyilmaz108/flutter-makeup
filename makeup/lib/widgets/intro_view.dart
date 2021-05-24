import 'package:animated_text/animated_text.dart';
import 'package:flutter/material.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:makeup/screens/sign_in_page.dart';

class IntroView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pages = [
      PageViewModel(
        pageColor: const Color(0xFF03A9F4),
        body: const Text(
          'makeup provides you with a stylish interface',
        ),
        title: const Text(
          'Stylish Interface',
        ),
        titleTextStyle:
        const TextStyle(color: Colors.white),
        bodyTextStyle: const TextStyle(color: Colors.white),
        mainImage: Image.asset(
          'assets/interface.jpeg',
          height: 285.0,
          width: 285.0,
          alignment: Alignment.center,
        ),
      ),
      PageViewModel(
        pageColor: const Color(0xFF8BC34A),
        body: const Text(
          'Thanks to its easy use, you can finish your work without wasting time',
        ),
        title: const Text('Easy to Use'),
        mainImage: Image.asset(
          'assets/using.jpeg',
          height: 285.0,
          width: 285.0,
          alignment: Alignment.center,
        ),
        titleTextStyle:
        const TextStyle(color: Colors.white),
        bodyTextStyle: const TextStyle(color: Colors.white),
      ),
      PageViewModel(
        pageBackground: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              stops: [0.0, 1.0],
              begin: FractionalOffset.topCenter,
              end: FractionalOffset.bottomCenter,
              tileMode: TileMode.repeated,
              colors: [
                Colors.orange,
                Colors.purpleAccent,
              ],
            ),
          ),
        ),
        body: const Text(
          'It offers more affordable prices in front of you. So it thinks of your pocket for you.',
        ),
        title: const Text('Thinks Your Pocket'),
        mainImage: Image.asset(
          'assets/price.jpeg',
          height: 285.0,
          width: 285.0,
          alignment: Alignment.center,
        ),
        titleTextStyle:
        const TextStyle(color: Colors.white),
        bodyTextStyle: const TextStyle(color: Colors.white),
      ),
      PageViewModel(

        pageBackground: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              stops: [0.0, 1.0],
              begin: FractionalOffset.topCenter,
              end: FractionalOffset.bottomCenter,
              tileMode: TileMode.repeated,
              colors: [
                Colors.yellow,
                Colors.pink,
              ],
            ),
          ),
          child: AnimatedText(
            alignment: Alignment.center,
            speed: Duration(milliseconds: 1000),
            controller: AnimatedTextController.loop,
            displayTime: Duration(milliseconds: 1000),
            wordList: ['Unleash', 'your', 'beauty'],
            textStyle: TextStyle(
                color: Colors.white,
                fontSize: 55,
                fontWeight: FontWeight.w700),
            onAnimate: (index) {
              print("Animating index:" + index.toString());
            },
            onFinished: () {
              print("Animtion finished");
            },
          ),
        ),

      ),
    ];
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      title: 'IntroViews Flutter',
      home: Builder(
        builder: (context) => IntroViewsFlutter(
          pages,
          showNextButton: true,
          showBackButton: true,
          onTapDoneButton: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => SignInPage()),
            );
          },
          pageButtonTextStyles: const TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }
}
