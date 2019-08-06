import 'dart:math';

import 'package:cat_box_animation/widgets/cat.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> with TickerProviderStateMixin {
  // This stores the value of the animation
  Animation<double> catAnimation;
  Animation<double> rightFlapAnimation;
  Animation<double> leftFlapAnimation;

  // This well, controls the animation(timing, pause, play, reverse functionalities)
  AnimationController catController;
  AnimationController leftFlapController;
  AnimationController rightFlapController;

  @override
  void initState() {
    super.initState();

    // Instantiate animation controller
    catController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    leftFlapController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    rightFlapController = AnimationController(
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

    // Use pi when defining rotation tweens
    leftFlapAnimation = Tween(
      begin: pi * 1.5,
      end: pi * 0.25,
    ).animate(
      CurvedAnimation(
        parent: leftFlapController,
        curve: Curves.easeInOut,
      ),
    );

    rightFlapAnimation = Tween(
      begin: pi * -1.5,
      end: pi * -0.25,
    ).animate(
      CurvedAnimation(
        parent: rightFlapController,
        curve: Curves.easeInOut,
      ),
    );
  }

  // Flaps
  Widget _buildFlap() {
    return Container(
      width: 8.0,
      height: 100.0,
      color: Colors.brown,
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
        ),
      ),
    );
  }

  Widget _buildLeftFlapAnimation() {
    return AnimatedBuilder(
      animation: leftFlapAnimation,
      builder: (BuildContext context, Widget child) {
        return Positioned(
          child: Transform(
            alignment: Alignment.topRight,
            transform: Matrix4.rotationZ(leftFlapAnimation.value),
            child: child,
          ),
          left: 0,
        );
      },
      // We add a child here so we don't have to create it 60x/s in the builder property
      child: _buildFlap(),
    );
  }

  Widget _buildRightFlapAnimation() {
    return AnimatedBuilder(
      animation: rightFlapAnimation,
      builder: (BuildContext context, Widget child) {
        return Positioned(
          child: Transform.rotate(
            alignment: Alignment.topLeft,
            angle: rightFlapAnimation.value,
            child: child,
          ),
          right: 0,
        );
      },
      // We add a child here so we don't have to create it 60x/s in the builder property
      child: _buildFlap(),
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
    if (catController.status == AnimationStatus.dismissed) {
      catController.forward();
      rightFlapController.forward();
      leftFlapController.forward();
    } else {
      catController.reverse();
      leftFlapController.reverse();
      rightFlapController.reverse();
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
              _buildLeftFlapAnimation(),
              _buildRightFlapAnimation(),
            ],
          ),
        ),
      ),
    );
  }
}
