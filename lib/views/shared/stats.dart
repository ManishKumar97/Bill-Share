import 'package:flutter/material.dart';

class Stats extends StatefulWidget {
  const Stats({Key? key}) : super(key: key);

  @override
  State<Stats> createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 30,
            color: Colors.white,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(6),
                height: 25,
                width: 25,
              ),
              const SizedBox(height: 10),
              const Text(
                "0",
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.red,
                ),
              ),
              const Text("You owe",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontFamily: "DancingScript")),
            ],
          ),
          Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(6),
                height: 25,
                width: 25,
              ),
              const SizedBox(height: 10),
              const Text(
                "0",
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.green,
                ),
              ),
              const Text("You get",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontFamily: "DancingScript")),
            ],
          )
        ],
      ),
    );
  }
}
