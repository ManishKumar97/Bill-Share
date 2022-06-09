import 'dart:math';

import 'package:billshare/constants.dart';
import 'package:billshare/models/bill.dart';
// import 'package:billshare/models/bill.dart';
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
  Bill? bill;
  AddBill(
      {Key? key, required this.loggedInUser, required this.group, this.bill})
      : super(key: key);

  @override
  State<AddBill> createState() => _AddBillState();
}

class _AddBillState extends State<AddBill> {
  String title = '';
  double amount = 0.0;
  String paidBy = "";
  DateTime dueDate = DateTime.now();
  TimeOfDay dueTime = TimeOfDay.now();
  List<bool> splitTypes = [true, false, false];
  Map<String, double> equalShares = {};
  Map<String, double> percentageShares = {};
  Map<String, double> numberShares = {};
  Map<String, bool> isEqualShareChecked = {};
  List<TextEditingController> controllers = [];
  int friendsCount = 0;
  String comments = "";
  bool isLoading = false;
  String error = "";

  final _formKey = GlobalKey<FormState>();
  final Database _db = Database();

  @override
  void initState() {
    friendsCount = widget.group.membersUids.length;
    paidBy = widget.loggedInUser.uid;
    if (widget.bill != null) {
      title = widget.bill!.title;
      amount = widget.bill!.amount;
      dueDate = widget.bill!.dueDate;
      paidBy = widget.bill!.paidBy;
      comments = widget.bill!.comments!;
    }

    widget.group.members.forEach((key, value) {
      double v = 0.0;
      if (widget.bill != null && widget.bill!.memberShares.containsKey(key)) {
        v = widget.bill!.memberShares[key]!;
        if (widget.bill!.splittype == splitType.equally) {
          equalShares[key] = v;
          isEqualShareChecked[key] = true;
        } else if (widget.bill!.splittype == splitType.percentage) {
          percentageShares[key] = v;
        } else if (widget.bill!.splittype == splitType.number) {
          numberShares[key] = v;
        }
      } else {
        equalShares[key] = v;
        percentageShares[key] = v;
        numberShares[key] = v;
        isEqualShareChecked[key] = false;
      }
    });
    controllers =
        List.generate(2 * friendsCount, (index) => TextEditingController());
    super.initState();
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: dueTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: kPrimaryColor, // header background color
              onPrimary: Colors.white, // header text color
              onSurface: Colors.black, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: kPrimaryColor, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != dueTime) {
      setState(() {
        dueTime = picked;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: kPrimaryColor, // header background color
              onPrimary: Colors.white, // header text color
              onSurface: Colors.black, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: kPrimaryColor, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != dueDate) {
      setState(() {
        dueDate = picked;
      });
    }
  }

  double roundDouble(double value, int places) {
    double mod = pow(10.0, places) as double;
    return ((value * mod).round().toDouble() / mod);
  }

  Future<void> handleSubmit(GlobalKey<FormState> key) async {
    try {
      setState(() {
        error = "";
      });

      if (key.currentState!.validate()) {
        if (splitTypes[0]) {
          int totalmembersCount = 0;
          isEqualShareChecked.forEach((key, value) {
            if (value) ++totalmembersCount;
          });
          if (totalmembersCount == 0) {
            setState(() {
              error = " No users are selected to split";
            });
            return;
          }
          isEqualShareChecked.forEach((key, value) {
            if (value) {
              equalShares[key] = roundDouble(amount / totalmembersCount, 2);
            }
          });
        } else if (splitTypes[1]) {
          double total = 0.0;
          percentageShares.forEach((key, value) {
            total += value;
          });
          if (total != 100.0) {
            setState(() {
              error = "Percentage split do not add up to 100%";
            });
            return;
          }
          percentageShares.forEach((key, value) {
            percentageShares[key] = roundDouble((amount * value) / 100, 2);
          });
        } else if (splitTypes[2]) {
          double total = 0.0;
          numberShares.forEach((key, value) {
            total += value;
          });
          if (total != amount) {
            setState(() {
              error = "Numbers split do not add up to bill amount";
            });
            return;
          }
        }
        Map<String, double> values = {};
        if (splitTypes[0]) {
          values = equalShares;
        } else if (splitTypes[1]) {
          values = percentageShares;
        } else if (splitTypes[2]) {
          values = numberShares;
        }
        if (widget.bill == null) {
          comments += "\n-- ${widget.loggedInUser.name} added the bill";
        } else if (widget.bill != null) {
          comments += "\n-- ${widget.loggedInUser.name} updated the bill";
        }
        dueDate = DateTime(dueDate.year, dueDate.month, dueDate.day,
            dueTime.hour, dueTime.minute);
        String billId = (widget.bill != null) ? widget.bill!.billId : "";
        await _db.addBill(
          billId,
          title,
          amount,
          dueDate,
          paidBy,
          widget.loggedInUser.uid,
          widget.group.groupId,
          comments,
          values,
          splitTypes,
        );
        Navigator.pop(context);
      }
    } catch (e) {
      print("Exception");
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
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: Form(
                key: _formKey,
                child: Column(
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
                        initialValue: title,
                        onChanged: (value) {
                          setState(() => title = value);
                        },
                        validator: (val) => (val != null && val.isEmpty)
                            ? 'Please enter an title'
                            : null,
                        cursorColor: kPrimaryColor,
                        decoration: const InputDecoration(
                          hintText: "Title*",
                          labelText: "Title",
                          labelStyle: TextStyle(color: kPrimaryColor),
                          // helperText: "Enter bill title",
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
                        initialValue: amount.toString(),
                        onChanged: (value) {
                          if (double.tryParse(value) != null) {
                            setState(() => amount = double.parse(value));
                          }
                        },
                        validator: (val) => ((val != null && val.isEmpty) ||
                                (double.tryParse(val!) == null ||
                                    double.parse(val) == 0.0))
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
                          labelText: "Amount",
                          labelStyle: TextStyle(color: kPrimaryColor),
                          helperStyle: TextStyle(fontSize: 14),
                          border: InputBorder.none,
                          icon: Icon(Icons.attach_money, color: kPrimaryColor),
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
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          hintText: "Paid By",
                          labelText: "Paid By",
                          labelStyle: TextStyle(color: kPrimaryColor),
                          // helperText: "Paid By",
                          border: InputBorder.none,
                        ),
                        items: widget.group.members
                            .map((uid, name) {
                              return MapEntry(
                                  uid,
                                  DropdownMenuItem<String>(
                                    value: uid,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 5),
                          width: size.width / 2,
                          decoration: const BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(19.0),
                                bottomLeft: Radius.circular(19.0)),
                          ),
                          child: Column(
                            children: [
                              ElevatedButton.icon(
                                icon: const Icon(
                                  Icons.date_range,
                                  color: Colors.white,
                                  size: 24.0,
                                ),
                                label: Text(DateFormat.yMMMd().format(dueDate)),
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
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 5),
                          width: size.width / 2,
                          decoration: const BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(19.0),
                                bottomRight: Radius.circular(19.0)),
                          ),
                          child: Column(
                            children: [
                              ElevatedButton.icon(
                                icon: const Icon(
                                  Icons.schedule,
                                  color: Colors.white,
                                  size: 24.0,
                                ),
                                label: Text(dueTime.format(context)),
                                onPressed: () {
                                  _selectTime(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: kPrimaryColor,
                                  elevation: 0.0,
                                ),
                              ),
                              const Text(
                                "Due Time",
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
                            for (var element in controllers) {
                              element.clear();
                            }
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
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              width: size.width / 2,
                              decoration: BoxDecoration(
                                // color: Colors.white,
                                borderRadius: BorderRadius.circular(19),
                              ),
                              child: CheckboxListTile(
                                title: Text(val),
                                value: isEqualShareChecked[key],
                                onChanged: (val) {
                                  setState(() {
                                    isEqualShareChecked[key] = val!;
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
                          itemCount: friendsCount,
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
                                        borderRadius: BorderRadius.circular(19),
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
                                      controller: controllers[index],
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
                                      validator: (val) => ((val != null &&
                                                  val.isEmpty) ||
                                              (double.tryParse(val!) == null ||
                                                  double.parse(val) < 0.0 ||
                                                  double.parse(val) > 100.0))
                                          ? 'Please enter a valid percentage'
                                          : null,
                                      cursorColor: kPrimaryColor,
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                        decimal: true,
                                      ),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'^(\d+)?\.?\d{0,2}')),
                                        // NumericalRangeFormatter(
                                        // min: 0.0, max: 100.0),
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
                          itemCount: friendsCount,
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
                                        borderRadius: BorderRadius.circular(19),
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
                                    width: size.width / 2,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(19),
                                    ),
                                    child: TextFormField(
                                      // initialValue:
                                      //     (numberShares[key].toString() != "")
                                      //         ? numberShares[key].toString()
                                      //         : "",
                                      controller:
                                          controllers[index + friendsCount],
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
                                      validator: (val) => ((val != null &&
                                                  val.isEmpty) ||
                                              (double.tryParse(val!) == null ||
                                                  double.parse(val) == 0.0))
                                          ? 'Please enter a valid amount'
                                          : null,
                                      cursorColor: kPrimaryColor,
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                        decimal: true,
                                      ),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'^(\d+)?\.?\d{0,2}')),
                                        // NumericalRangeFormatter(
                                        // min: 0.0, max: amount),
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
                        initialValue: comments,
                        onChanged: (value) {
                          setState(() => comments = value);
                        },
                        cursorColor: kPrimaryColor,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: const InputDecoration(
                          hintText: "comments",
                          labelText: "comments",
                          labelStyle: TextStyle(color: kPrimaryColor),
                          // helperStyle: TextStyle(fontSize: 14),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        error,
                        style: const TextStyle(fontSize: 16, color: Colors.red),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RoundedButton(
                          text: "Done",
                          press: () async {
                            await handleSubmit(_formKey);
                          },
                          widthFactor: 0.6,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
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
