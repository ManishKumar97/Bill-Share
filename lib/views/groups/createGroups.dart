import 'package:billshare/constants.dart';
import 'package:billshare/models/user.dart';
import 'package:billshare/services/database.dart';
import 'package:billshare/views/shared/rounded_button.dart';
import "package:flutter/material.dart";

class CreateGroups extends StatefulWidget {
  final AppUser loggedInUser;
  const CreateGroups({required this.loggedInUser, Key? key}) : super(key: key);

  @override
  State<CreateGroups> createState() => _CreateGroupsState();
}

class _CreateGroupsState extends State<CreateGroups> {
  Map<String, bool> selectedFriends = {};
  String title = "";
  String error = "";

  final _formKey = GlobalKey<FormState>();
  final Database _db = Database();
  @override
  void initState() {
    // TODO: implement initState
    for (String friendUId in widget.loggedInUser.friends!.keys) {
      selectedFriends[friendUId] = false;
    }
    super.initState();
  }

  Future<void> handleSubmit(GlobalKey<FormState> key) async {
    try {
      setState(() {
        error = "";
      });

      if (key.currentState!.validate()) {
        await _db.addGroup(widget.loggedInUser, selectedFriends, title);
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() {
        error = "Unable to create group";
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
                            labelText: "Title",
                            labelStyle: TextStyle(color: kPrimaryColor),
                            // helperText: "Enter bill title",
                            helperStyle: TextStyle(fontSize: 14),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          "Please select group members from below",
                          style: TextStyle(fontSize: 16, color: kPrimaryColor),
                        ),
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.loggedInUser.friends!.keys.length,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            String key = widget.loggedInUser.friends!.keys
                                .elementAt(index);
                            String val = widget.loggedInUser.friends![key]!;
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
                                value: selectedFriends[key],
                                onChanged: (val) {
                                  setState(() {
                                    selectedFriends[key] = val!;
                                  });
                                },
                                checkColor: Colors.white,
                                activeColor: kPrimaryColor,
                              ),
                            );
                          }),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          error,
                          style:
                              const TextStyle(fontSize: 16, color: Colors.red),
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
                  )),
            ),
          ],
        ),
      ),
    );
  }
}


// import 'package:billshare/constants.dart';
// import 'package:billshare/models/user.dart';
// import 'package:billshare/services/database.dart';
// import 'package:billshare/views/shared/loading.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import "package:flutter/material.dart";
// import 'package:billshare/models/group.dart';
// import 'package:billshare/views/shared/rounded_button.dart';

// class CreateGroups extends StatefulWidget {
//   final AppUser loggedInUser;
//   const CreateGroups({Key? key, required this.loggedInUser}) : super(key: key);

//   @override
//   State<CreateGroups> createState() => _CreateGroupsState();
// }

// class _CreateGroupsState extends State<CreateGroups> {
//   bool isSelectionMode = false;
//   int listLength = 1;
//   late List<bool> _selected;
//   bool _selectAll = false;

//   @override
//   void initState() {
//     super.initState();
//     initializeSelection();
//   }

//   void initializeSelection() {
//     _selected = List<bool>.generate(listLength, (_) => false);
//   }

//   @override
//   void dispose() {
//     _selected.clear();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final Database _db = Database();
//     final Map<String, String> members;
//     final List<String> membersUids;
//     String groupName;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Create Group",
//             style: TextStyle(
//               fontFamily: "DancingScript",
//               color: kPrimaryColor,
//             )),
//         backgroundColor: Colors.white,
//         elevation: 0.0,
//         iconTheme: const IconThemeData(
//           color: kPrimaryColor,
//         ),
//         leading: isSelectionMode
//             ? IconButton(
//                 icon: const Icon(Icons.close),
//                 onPressed: () {
//                   setState(() {
//                     isSelectionMode = false;
//                   });
//                   initializeSelection();
//                 },
//               )
//             : BackButton(
//                 color: kPrimaryColor,
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//               ),
//         // actions: <Widget>[
//         //   if (isSelectionMode)
//         //     TextButton(
//         //         child: !_selectAll
//         //             ? const Text(
//         //                 'select all',
//         //                 style: TextStyle(color: kPrimaryColor),
//         //               )
//         //             : const Text(
//         //                 'unselect all',
//         //                 style: TextStyle(color: kPrimaryColor),
//         //               ),
//         //         onPressed: () {
//         //           _selectAll = !_selectAll;
//         //           setState(() {
//         //             _selected = List<bool>.generate(1, (_) => _selectAll);
//         //           });
//         //         }),
//         //   TextButton(
//         //     child: const Text(
//         //       'Save',
//         //       style: TextStyle(color: kPrimaryColor),
//         //     ),
//         //     onPressed: () {},
//         //   ),
//         // ],
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: SizedBox(
//               // height: 50,
//               // width: 300,
//               child: TextField(
//                 onChanged: (value) {
//                   setState(() => groupName = value);
//                 },
//                 decoration: InputDecoration(
//                   filled: true,
//                   fillColor: const Color.fromARGB(16, 224, 210, 210),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                     borderSide: BorderSide.none,
//                   ),
//                   hintText: "Enter group name",
//                   hintStyle: const TextStyle(
//                     fontSize: 15,
//                     fontWeight: FontWeight.normal,
//                     color: Color.fromARGB(143, 0, 0, 0),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(
//             height: 20,
//             width: 20,
//           ),
//           const Text(
//             "Select group members from the below",
//             textAlign: TextAlign.left,
//             style: TextStyle(fontSize: 16, color: kPrimaryColor),
//           ),
//           Expanded(
//             child: StreamBuilder<QuerySnapshot<Group>>(
//               stream: _db.groupsRef
//                   .where('type', isEqualTo: 1)
//                   .where('membersUids', arrayContains: widget.loggedInUser.uid)
//                   .withConverter<Group>(
//                       fromFirestore: ((snapshot, options) =>
//                           Group.fromJson(snapshot.data()!)),
//                       toFirestore: (group, _) => group.toJson())
//                   .snapshots(),
//               builder: (BuildContext context,
//                   AsyncSnapshot<QuerySnapshot<Group>> snapshot) {
//                 if (snapshot.hasData) {
//                   listLength = snapshot.data!.docs.length;
//                   initializeSelection();
//                   return ListBuilder(
//                       isSelectionMode: isSelectionMode,
//                       selectedList: _selected,
//                       onSelectionChange: (bool x) {
//                         setState(() {
//                           isSelectionMode = x;
//                         });
//                       },
//                       snapshot: snapshot,
//                       currentUser: widget.loggedInUser);
//                 }
//                 // for (var i=0; i < _selected.length; ++i) {
//                 //   if (_selected[i]) {
//                 //     Group grp = snapshot.data!.docs[i].data();

//                 //   }
//                 // }
//                 return const Loading();
//               },
//             ),
//           ),
//           RoundedButton(
//               text: "Save",
//               widthFactor: 0.8,
//               press: () async {
//                 // bool result = await _db.createGroup();
//                 // if (result) {
//                 //   Navigator.pop(context);
//                 // }
//               })
//         ],
//       ),
//     );
//   }
// }

// class ListBuilder extends StatefulWidget {
//   final bool isSelectionMode;
//   final List<bool> selectedList;
//   final Function(bool)? onSelectionChange;
//   final AsyncSnapshot<QuerySnapshot<Group>> snapshot;
//   final AppUser currentUser;

//   const ListBuilder({
//     Key? key,
//     required this.selectedList,
//     required this.isSelectionMode,
//     required this.onSelectionChange,
//     required this.snapshot,
//     required this.currentUser,
//   }) : super(key: key);

//   @override
//   State<ListBuilder> createState() => _ListBuilderState();
// }

// class _ListBuilderState extends State<ListBuilder> {
//   String? name;

//   void _toggle(int index) {
//     if (widget.isSelectionMode) {
//       setState(() {
//         widget.selectedList[index] = !widget.selectedList[index];
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//         itemCount: widget.selectedList.length,
//         itemBuilder: (_, int index) {
//           Group grp = widget.snapshot.data!.docs[index].data();
//           grp.members.forEach((uid, username) {
//             if (uid != widget.currentUser.uid) name = username;
//           });
//           return ListTile(
//             contentPadding:
//                 const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
//             leading: const Icon(
//               Icons.person,
//               color: kPrimaryColor,
//             ),
//             title: Text(
//               name!,
//               style: const TextStyle(fontSize: 16, color: kPrimaryColor),
//             ),
//             onTap: () => _toggle(index),
//             onLongPress: () {
//               if (!widget.isSelectionMode) {
//                 setState(() {
//                   widget.selectedList[index] = true;
//                 });
//                 widget.onSelectionChange!(true);
//               }
//             },
//             trailing: widget.isSelectionMode
//                 ? Checkbox(
//                     value: widget.selectedList[index],
//                     onChanged: (bool? x) => _toggle(index),
//                   )
//                 : const SizedBox.shrink(),
//           );
//         });
//   }
// }
