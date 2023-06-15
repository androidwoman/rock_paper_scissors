import 'dart:math';

import 'package:flutter/material.dart';
import 'package:untitled1/models/game_object.dart';
class RockPaperScissorsGame extends StatefulWidget {
  const RockPaperScissorsGame({super.key});

  @override
  RockPaperScissorsGameState createState() => RockPaperScissorsGameState();
}

class RockPaperScissorsGameState extends State<RockPaperScissorsGame>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<GameObject> _objects = [];
  final double _objectSize = 50;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      createObjects();
      _controller = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 1),
      )..addListener(() {
        moveObjects();
        checkCollisions();
        setState(() {});
      });

      _controller.repeat();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void createObjects() {
    for (int i = 0; i < 5; i++) {
      _addObject(i, ObjectType.rock);
    }

    for (int i = 5; i < 10; i++) {
      _addObject(i, ObjectType.paper);
    }

    for (int i = 10; i < 15; i++) {
      _addObject(i, ObjectType.scissors);
    }
  }

  void _addObject(int i, ObjectType type) {
    GameObject newObj;
    do {
      final double x = _random.nextDouble() *
          (MediaQuery.of(context).size.width - _objectSize);
      final double y = _random.nextDouble() *
          (MediaQuery.of(context).size.height - _objectSize);
      final double dx = _random.nextDouble() * 2 - 1;
      final double dy = _random.nextDouble() * 2 - 1;

      newObj = GameObject(
        id: i,
        type: type,
        x: x,
        y: y,
        dx: dx,
        dy: dy,
      );
    } while (checkCollisionsForObject(newObj));

    _objects.add(newObj);
  }

  bool checkCollisionsForObject(GameObject newObj) {
    for (final obj in _objects) {
      if (isColliding(obj, newObj)) {
        return true;
      }
    }
    return false;
  }

  void moveObjects() {
    for (GameObject obj in _objects) {
      obj.x += obj.dx;
      obj.y += obj.dy;

      if (obj.x <= 0 ||
          obj.x >= MediaQuery.of(context).size.width - _objectSize) {
        obj.dx = -obj.dx;
      }

      if (obj.y <= 0 ||
          obj.y >= MediaQuery.of(context).size.height - _objectSize) {
        obj.dy = -obj.dy;
      }
    }
  }

  void checkCollisions() {
    for (int i = 0; i < _objects.length; i++) {
      for (int j = i + 1; j < _objects.length; j++) {
        final GameObject obj1 = _objects[i];
        final GameObject obj2 = _objects[j];

        if (isColliding(obj1, obj2)) {
          if (obj1.type == obj2.type) {
            final double tempDx = obj1.dx;
            final double tempDy = obj1.dy;
            obj1.dx = obj2.dx;
            obj1.dy = obj2.dy;
            obj2.dx = tempDx;
            obj2.dy = tempDy;
          } else {
            if (obj1.type == ObjectType.rock &&
                obj2.type == ObjectType.scissors ||
                obj1.type == ObjectType.scissors &&
                    obj2.type == ObjectType.paper ||
                obj1.type == ObjectType.paper && obj2.type == ObjectType.rock) {
              _objects.removeWhere((obj) => obj.id == obj2.id);
              obj1.dx = -obj1.dx;
              obj1.dy = -obj1.dy;
            } else {
              _objects.removeWhere((obj) => obj.id == obj1.id);
              obj2.dx = -obj2.dx;
              obj2.dy = -obj2.dy;
            }
          }
        }
      }
    }
  }

  bool isColliding(GameObject obj1, GameObject obj2) {
    return obj1.x < obj2.x + _objectSize &&
        obj1.x + _objectSize > obj2.x &&
        obj1.y < obj2.y + _objectSize &&
        obj1.y + _objectSize > obj2.y;
  }

  Color getObjectColor(ObjectType type) {
    switch (type) {
      case ObjectType.rock:
        return Colors.greenAccent;
      case ObjectType.paper:
        return Colors.lightBlueAccent;
      case ObjectType.scissors:
        return Colors.purpleAccent;
    }
  }

  String getText(ObjectType type) {
    switch (type) {
      case ObjectType.rock:
        return '✊';
      case ObjectType.paper:
        return '✋';
      case ObjectType.scissors:
        return '✌';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background_image.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: _objects
              .map(
                (obj) => Positioned(
              left: obj.x,
              top: obj.y,
              child: Container(
                  width: _objectSize,
                  height: _objectSize,
                  decoration: BoxDecoration(
                      color: getObjectColor(obj.type),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 2,
                          //offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      borderRadius:
                      const BorderRadius.all(Radius.circular(8))),
                  child: Center(
                      child: Text(
                        getText(obj.type),
                        style: const TextStyle(fontSize: 30),
                      ))),
            ),
          )
              .toList(),
        ),
      ),
    );
  }
}
