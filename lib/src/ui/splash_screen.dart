import 'package:animated_background/animated_background.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  RandomParticleBehaviour _particleBehaviour = new RandomParticleBehaviour();
  ParticleOptions _particleOptions =
      new ParticleOptions(baseColor: Color(0xFF70DCA9));

  @override
  void initState() {
    super.initState();
    _particleBehaviour.options = _particleOptions;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: AnimatedBackground(
            behaviour: _particleBehaviour,
            vsync: this,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Center(
                  child: Image(
                    fit: BoxFit.fill,
                    image: AssetImage("assets/pocion.png"),
                    width: MediaQuery.of(context).size.width / 3,
                  ),
                ),
              ],
            )) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
