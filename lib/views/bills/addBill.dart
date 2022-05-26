import 'package:billshare/constants.dart';
import 'package:billshare/models/group.dart';
import 'package:billshare/models/user.dart';
import 'package:billshare/services/database.dart';
import 'package:billshare/views/shared/rounded_button.dart';
import 'package:intl/intl.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';

class AddBill extends StatefulWidget {
  final AppUser loggedInUser;
  final Group group;
  const AddBill({Key? key, required this.loggedInUser, required this.group})
      : super(key: key);

  @override
  State<AddBill> createState() => _AddBillState();
}

class _AddBillState extends State<AddBill> {
  String title = '';
  double amount = 0.0;
  String paidBy = "";
  DateTime dueDate = DateTime.now().add(const Duration(days: 1));
  List<bool> splitTypes = [true, false, false];
  Map<String, double> equalShares = {};
  Map<String, double> percentageShares = {};
  Map<String, double> numberShares = {};
  List<bool> _isEqualShareChecked = [];
  int friendsCount = 0;
  String comments = "";
  bool isLoading = false;
  AppUser? searchUser;

  final _formKey = GlobalKey<FormState>();
  final Database _db = Database();

  @override
  void initState() {
    // TODO: implement initState
    friendsCount = widget.group.membersUids.length;
    _isEqualShareChecked = List<bool>.filled(friendsCount, false);
    paidBy = widget.loggedInUser.name!;
    widget.group.members.forEach((key, value) {
      double v = 0.0;
      equalShares[key] = v;
      percentageShares[key] = v;
      numberShares[key] = v;
    });
    super.initState();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: dueDate,
        firstDate: DateTime.now().add(const Duration(days: 1)),
        lastDate: DateTime(2101));

    if (picked != null && picked != dueDate) {
      setState(() {
        dueDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Bill",
          style: TextStyle(fontFamily: "DancingScript", color: kPrimaryColor),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: kPrimaryColor, //change your color here
        ),
        elevation: 0.0,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Form(
          key: _formKey,
          child: SizedBox(
            height: size.height,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ListView(
                    shrinkWrap: true,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          "Enter Bill details below",
                          style: TextStyle(fontSize: 16, color: kPrimaryColor),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        width: size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(19),
                        ),
                        child: TextFormField(
                          onChanged: (value) {
                            setState(() => title = value);
                          },
                          validator: (val) => (val != null && val.isEmpty)
                              ? 'Please enter an title'
                              : null,
                          cursorColor: kPrimaryColor,
                          decoration: const InputDecoration(
                            hintText: "Title*",
                            helperText: "Enter bill title",
                            helperStyle: TextStyle(fontSize: 14),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        width: size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(19),
                        ),
                        child: TextFormField(
                          onChanged: (value) {
                            if (double.tryParse(value) != null) {
                              setState(() => amount = double.parse(value));
                            }
                          },
                          validator: (val) => (val != null &&
                                  double.tryParse(val) != null &&
                                  double.parse(val) > 0.0)
                              ? 'Please enter a valid amount'
                              : null,
                          cursorColor: kPrimaryColor,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^(\d+)?\.?\d{0,2}')),
                          ],
                          decoration: const InputDecoration(
                            hintText: "Amount* ",
                            helperText: "Enter bill amount here ",
                            helperStyle: TextStyle(fontSize: 14),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            width: size.width / 2,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(19),
                            ),
                            child: DropdownButtonFormField<String>(
                              decoration: const InputDecoration(
                                hintText: "Paid By",
                                helperText: "Paid By",
                                border: InputBorder.none,
                                // enabledBorder: OutlineInputBorder(
                                //     borderRadius: BorderRadius.circular(10),
                                //     borderSide: const BorderSide(color: kPrimaryColor)),
                              ),
                              items: widget.group.members
                                  .map((uid, name) {
                                    return MapEntry(
                                        name,
                                        DropdownMenuItem<String>(
                                          value: name,
                                          child: Text(name),
                                        ));
                                  })
                                  .values
                                  .toList(),
                              value: paidBy,
                              onChanged: (String? newvalue) {
                                if (newvalue != null) {
                                  setState(() {
                                    paidBy = newvalue;
                                  });
                                }
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            width: size.width / 2,
                            decoration: BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius: BorderRadius.circular(19),
                            ),
                            child: Column(
                              children: [
                                ElevatedButton.icon(
                                  icon: const Icon(
                                    Icons.date_range,
                                    color: Colors.white,
                                    size: 24.0,
                                  ),
                                  label:
                                      Text(DateFormat.yMMMd().format(dueDate)),
                                  onPressed: () {
                                    _selectDate(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: kPrimaryColor,
                                    elevation: 0.0,
                                  ),
                                ),
                                const Text(
                                  "Due date",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        child: Center(
                          child: ToggleButtons(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: const [
                                    Text(
                                      'Equally',
                                    ),
                                    Icon(
                                      Icons.balance,
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: const [
                                    Text(
                                      '%',
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: const [
                                    Text(
                                      'Number',
                                    ),
                                    Icon(
                                      Icons.pin,
                                    )
                                  ],
                                ),
                              ),
                            ],
                            color: kPrimaryColor,
                            selectedColor: Colors.white,
                            fillColor: kPrimaryColor,
                            isSelected: splitTypes,
                            onPressed: (int index) {
                              setState(() {
                                for (int i = 0; i < splitTypes.length; i++) {
                                  splitTypes[i] = i == index;
                                }
                              });
                            },
                            borderRadius: BorderRadius.circular(19.0),
                          ),
                        ),
                      ),
                      if (splitTypes[0])
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: widget.group.members.length,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              String key =
                                  widget.group.members.keys.elementAt(index);
                              String val = widget.group.members[key]!;
                              return Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                width: size.width / 2,
                                decoration: BoxDecoration(
                                  // color: Colors.white,
                                  borderRadius: BorderRadius.circular(19),
                                ),
                                child: CheckboxListTile(
                                  title: Text(val),
                                  value: _isEqualShareChecked[index],
                                  onChanged: (val) {
                                    setState(() {
                                      _isEqualShareChecked[index] = val!;
                                    });
                                  },
                                  checkColor: Colors.white,
                                  activeColor: kPrimaryColor,
                                ),
                              );
                            }),
                      if (splitTypes[1])
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: widget.group.members.length,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              String key =
                                  widget.group.members.keys.elementAt(index);
                              String val = widget.group.members[key]!;
                              return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 5),
                                        width: size.width / 2,
                                        decoration: BoxDecoration(
                                          // color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(19),
                                        ),
                                        child: Text(
                                          val,
                                          style: const TextStyle(fontSize: 17),
                                        )),
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 5),
                                      width: size.width / 3,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(19),
                                      ),
                                      child: TextFormField(
                                        textAlign: TextAlign.center,
                                        onChanged: (value) {
                                          if (double.tryParse(value) != null) {
                                            if (double.parse(value) > 100) {
                                              value = "100.00";
                                            } else {
                                              setState(() =>
                                                  percentageShares[key] =
                                                      double.parse(value));
                                            }
                                          }
                                        },
                                        validator: (val) => (val != null &&
                                                double.tryParse(val) != null &&
                                                double.parse(val) > 0.0)
                                            ? 'Please enter a valid amount'
                                            : null,
                                        cursorColor: kPrimaryColor,
                                        keyboardType: const TextInputType
                                            .numberWithOptions(
                                          decimal: true,
                                        ),
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'^(\d+)?\.?\d{0,2}')),
                                          NumericalRangeFormatter(
                                              min: 0.0, max: 100.0),
                                        ],
                                        decoration: const InputDecoration(
                                          hintText: "%",
                                          helperStyle: TextStyle(fontSize: 14),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ]);
                            }),
                      if (splitTypes[2])
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: widget.group.members.length,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              String key =
                                  widget.group.members.keys.elementAt(index);
                              String val = widget.group.members[key]!;
                              return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 5),
                                        width: size.width / 2,
                                        decoration: BoxDecoration(
                                          // color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(19),
                                        ),
                                        child: Text(
                                          val,
                                          style: const TextStyle(fontSize: 17),
                                        )),
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 5),
                                      width: size.width / 3,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(19),
                                      ),
                                      child: TextFormField(
                                        textAlign: TextAlign.center,
                                        onChanged: (value) {
                                          if (double.tryParse(value) != null) {
                                            if (double.parse(value) > amount) {
                                              value = "$amount";
                                            } else {
                                              setState(() => numberShares[key] =
                                                  double.parse(value));
                                            }
                                          }
                                        },
                                        validator: (val) => (val != null &&
                                                double.tryParse(val) != null &&
                                                double.parse(val) > 0.0)
                                            ? 'Please enter a valid amount'
                                            : null,
                                        cursorColor: kPrimaryColor,
                                        keyboardType: const TextInputType
                                            .numberWithOptions(
                                          decimal: true,
                                        ),
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'^(\d+)?\.?\d{0,2}')),
                                          NumericalRangeFormatter(
                                              min: 0.0, max: amount),
                                        ],
                                        decoration: const InputDecoration(
                                          hintText: "123",
                                          helperStyle: TextStyle(fontSize: 14),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ]);
                            }),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        width: size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(19),
                        ),
                        child: TextFormField(
                          onChanged: (value) {
                            setState(() => comments = value);
                          },
                          cursorColor: kPrimaryColor,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: const InputDecoration(
                            hintText: "comments",
                            helperStyle: TextStyle(fontSize: 14),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      RoundedButton(
                        text: "Done",
                        press: () {},
                        widthFactor: 0.6,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NumericalRangeFormatter extends TextInputFormatter {
  final double min;
  final double max;

  NumericalRangeFormatter({required this.min, required this.max});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text == '') {
      return const TextEditingValue();
    } else if (double.parse(newValue.text) < min) {
      return const TextEditingValue().copyWith(text: '$min');
    }

    return double.parse(newValue.text) > max
        ? const TextEditingValue().copyWith(text: '$max')
        : newValue;
  }
}
