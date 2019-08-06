import 'package:cat_box_animation/widgets/cat.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> with TickerProviderStateMixin {
  // This stores the value of the animation
  Animation<double> catAnimation;

  // This well, controls the animation(timing, pause, play, reverse functionalities)
  AnimationController catController;

  @override
  void initState() {
    super.initState();

    // Instantiate animation controller
    catController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );

    // Define animation tween
    catAnimation = Tween(
      begin: 0.0,
      end: -80.0,
    ).animate(
      CurvedAnimation(
        parent: catController,
        curve: Curves.easeInOut,
      ),
    );
  }

  Widget _buildBox() {
    return Container(
      color: Colors.brown,
      height: 200.0,
      width: 200.0,
      child: Center(
          child: Text(
        'Click for a surprise!',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      )),
    );
  }

  Widget _buildCatAnimation() {
    return AnimatedBuilder(
      animation: catAnimation,
      builder: (context, child) {
        return Positioned(
          child: child,
          top: catAnimation.value,
          right: 0.0,
          left: 0.0,
        );
      },
      // We add a child here so we don't have to create it 60x/s in the builder property
      child: Cat(),
    );
  }

  _onCatTap() {
    if (catAnimation.value == 0.0) {
      catController.forward();
    } else {
      catController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cat Box Animation'),
      ),
      body: GestureDetector(
        onTap: _onCatTap,
        child: Center(
          child: Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              _buildCatAnimation(),
              _buildBox(),
            ],
          ),
        ),
      ),
    );
  }
}
