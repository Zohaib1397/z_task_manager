import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:z_task_manager/constants/constants.dart';
import 'package:z_task_manager/screens/login_screen.dart';
import 'package:z_task_manager/services/task_controller_provider.dart';
import '../structure/CATEGORY.dart';
import '../structure/Task.dart';
import '../structure/TextFieldHandler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'widgets/TaskCard.dart';

import 'new_task.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const String id = "Home_Screen";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = FirebaseAuth.instance;

  FILTER filter = FILTER.TODAY;
  bool searchToggle = false;
  TextFieldHandler searchField = TextFieldHandler();

  @override
  Widget build(BuildContext context) {
    if (!searchToggle) {
      searchField.controller.text = "";
    }
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Provider.of<TaskControllerProvider>(context, listen: false).clearForDispose();
              _auth.signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()));
            },
            icon: const Icon(Icons.logout),
          ),
          scrolledUnderElevation: 10,
          actions: [
            PopupMenuButton(
                onSelected: (value){
                  print(value as int);
                },
                padding: EdgeInsets.zero,
                itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 1,
                        child: GestureDetector(
                          child: const Row(
                            children: [
                              Icon(
                                Icons.delete,
                                color: Colors.black,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text("Delete",
                                  style: TextStyle(color: Colors.black)),
                            ],
                          ),
                        ),
                      ),
                      PopupMenuItem(
                        value: 2,
                        child: GestureDetector(
                          child: const Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Colors.black,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text("About",
                                  style: TextStyle(color: Colors.black)),
                            ],
                          ),
                        ),
                      )
                    ]),
          ],
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0,
          backgroundColor: Colors.white,
          title: const Center(
            child: Image(
              image: AssetImage("assets/logos/backcaps.png"),
              width: 100,
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            setState(() {
              Navigator.pushNamed(context, NewTaskScreen.id);
              // Navigator.pushNamed(context, NewTaskScreen.id);
              //Previously I was using bottom sheet widget
              // showModalBottomSheet(context: context, showDragHandle: true, shape: RoundedRectangleBorder(
              //   borderRadius: BorderRadius.circular(kBottomSheetRoundedCorners),
              // ), builder: (BuildContext context){
              //   return NewTaskScreen();
              // });
            });
          },
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: ListView(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              children: [
                Padding(
                  padding: const EdgeInsets.all(11.0),
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      AnimatedOpacity(
                        opacity: searchToggle ? 0 : 1.0,
                        duration: const Duration(milliseconds: 100),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                "Welcome Back ${_auth.currentUser!.displayName}!"),
                            const Text(
                              "Here's Update Today",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Material(
                          elevation: searchToggle ? 10 : 0,
                          color: searchToggle ? Colors.white : Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: AnimatedContainer(
                            width: searchToggle
                                ? MediaQuery.of(context).size.width
                                : 40,
                            duration: const Duration(milliseconds: 200),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: IconButton(
                                    visualDensity: VisualDensity.compact,
                                    padding: EdgeInsets.zero,
                                    icon: Icon(
                                      Icons.search,
                                      color: searchToggle
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        searchToggle = !searchToggle;
                                      });
                                    },
                                  ),
                                ),
                                searchToggle
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 30.0),
                                        child: TextField(
                                          controller: searchField.controller,
                                          autofocus: true,
                                          decoration:
                                              kTaskManagerDecoration.copyWith(
                                            hintText: "Search..",
                                            fillColor: Colors.transparent,
                                          ),
                                          onChanged: (value) {
                                            setState(() {});
                                          },
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: DefaultTabController(
                    length: 3,
                    child: TabBar(
                        onTap: (index) {
                          setState(() {
                            if (index == 0) {
                              filter = FILTER.TODAY;
                            } else if (index == 1) {
                              filter = FILTER.UPCOMING;
                            } else if (index == 2) {
                              filter = FILTER.DONE;
                            } else {
                              print("Something went wrong");
                            }
                          });
                        },
                        unselectedLabelColor: Colors.black,
                        indicator: const BoxDecoration(
                          color: Colors.black,
                          borderRadius:
                              BorderRadius.all(Radius.elliptical(20, 20)),
                        ),
                        labelStyle: const TextStyle(
                          color: Colors.white,
                        ),
                        indicatorColor: Colors.black,
                        splashBorderRadius:
                            const BorderRadius.all(Radius.elliptical(20, 20)),
                        tabs: const [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 14.0),
                            child: Text("Today"),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 14.0),
                            child: Text("Upcoming"),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 14.0),
                            child: Text("Done"),
                          ),
                        ]),
                  ),
                ),
                Divider(),
                Consumer<TaskControllerProvider>(
                  builder: (context, taskController, _) {
                    List<Task> taskList = [];
                    if (searchField.controller.text != "") {
                      taskList = taskController.tasksList
                          .where((element) => element.text
                              .contains(searchField.controller.text))
                          .toList();
                    } else {
                      taskList = taskController.tasksList;
                    }

                    List<Widget> cardsList = [];
                    if (filter == FILTER.TODAY) {
                      cardsList = taskList
                          .where((element) =>
                              element.dueDate.day == DateTime.now().day &&
                              element.isCompleted == false)
                          .map((task) => TaskCard(
                                taskData: task,
                              ))
                          .toList();
                    } else if (filter == FILTER.UPCOMING) {
                      cardsList = taskList
                          .where((element) =>
                              element.dueDate.day > DateTime.now().day &&
                              element.isCompleted == false)
                          .map((task) => TaskCard(
                                taskData: task,
                              ))
                          .toList();
                    } else if (filter == FILTER.DONE) {
                      cardsList = taskList
                          .where((e) => e.isCompleted)
                          .map((e) => TaskCard(taskData: e))
                          .toList();
                    }

                    // return taskList.isEmpty? Center(
                    //   child: Column(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       Image(image: AssetImage("assets/icons/empty_folder.png"),
                    //         width: 150,
                    //       ),
                    //       const Text("Nothing found here"),
                    //     ],
                    //   ),
                    // ) :
                    return Column(
                      children: cardsList,
                    );
                  },
                ),
                SizedBox(
                  height: 80,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
