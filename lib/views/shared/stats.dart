import 'package:billshare/constants.dart';
import 'package:flutter/material.dart';

class Stats extends StatefulWidget {
  double getAmount = 0.0;
  double owesAmount = 0.0;
  Stats({required this.getAmount, required this.owesAmount, Key? key})
      : super(key: key);

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
      child: Container(
        decoration: const BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.all(
            Radius.circular(19),
          ),
        ),
        child: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  const SizedBox(height: 10),
                  const Text("You owe",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      )),
                  const SizedBox(height: 10),
                  Text(
                    "\$${widget.owesAmount}",
                    style: const TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const VerticalDivider(
                width: 20,
                thickness: 1,
                color: Colors.white,
              ),
              Column(
                children: <Widget>[
                  const SizedBox(height: 10),
                  const Text("You get",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      )),
                  const SizedBox(height: 10),
                  Text(
                    "\$${widget.getAmount}",
                    style: const TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
