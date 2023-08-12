import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
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
  void initState() {
    super.initState();
    Provider.of<TaskControllerProvider>(context, listen: false)
        .tasksFromHandler();
  }

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
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.white, // <-- SEE HERE
              statusBarIconBrightness: Brightness.dark, //<-- For Android SEE HERE (dark icons)
              statusBarBrightness: Brightness.light),
          leading: IconButton(
            onPressed: () {
              final provider =
                  Provider.of<TaskControllerProvider>(context, listen: false);
              provider.clearForDispose();
              _auth.signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()));
            },
            icon: const Icon(Icons.logout),
          ),
          scrolledUnderElevation: 10,
          actions: [
            IconButton(
                onPressed: () {
                  showAboutDialog(
                    children: [
                      Text("-> Initial builds may include bugs"),
                    ],
                    context: context,
                    applicationName: "Z-Tasker",
                    applicationVersion: "v1.0",
                    applicationIcon: const Expanded(
                      child: Hero(
                        tag: "backcapsLogo",
                        child: Image(
                          image: AssetImage("assets/logos/backcaps.png"),
                          width: 40,
                        ),
                      ),
                    ),
                  );
                },
                icon: Icon(Icons.info_outline)),
            // _buildPopupMenuButton(),
          ],
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0,
          backgroundColor: Colors.white,
          title: const Center(
            child: Hero(
              tag: "backcapsLogo",
              child: Image(
                image: AssetImage("assets/logos/backcaps.png"),
                width: 100,
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            setState(() {
              Navigator.pushNamed(context, NewTaskScreen.id);
            });
          },
        ),
        body: SingleChildScrollView(
          child: ListView(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            children: [
              _buildWelcomeSearchRow(context),
              _buildTabSwitcher(),
              const Divider(),
              _buildCardsList(),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Consumer<TaskControllerProvider> _buildCardsList() {
    return Consumer<TaskControllerProvider>(
      builder: (context, taskController, _) {
        List<Task> taskList = [];
        if (searchField.controller.text != "") {
          taskList = taskController.tasksList
              .where((element) => element.text
                  .toLowerCase()
                  .contains(searchField.controller.text.toLowerCase()))
              .toList();
        } else {
          taskList = taskController.tasksList;
        }

        List<Widget> cardsList = [];
        DateTime currentTime = DateTime.now();
        if (filter == FILTER.TODAY) {
          cardsList = taskList
              .where((element) =>
                  element.dueDate.compareTo(currentTime) > 0 &&
                  element.dueDate.day == currentTime.day &&
                  element.isCompleted == false)
              .map((task) => _buildDismissibleCard(task))
              .toList();
        } else if (filter == FILTER.UPCOMING) {
          cardsList = taskList
              .where((element) =>
                  element.dueDate.day > currentTime.day &&
                  element.isCompleted == false)
              .map((task) => _buildDismissibleCard(task))
              .toList();
        } else if (filter == FILTER.DONE) {
          cardsList = taskList
              .where((task) => task.isCompleted)
              .map((task) => _buildDismissibleCard(task))
              .toList();
        } else if (filter == FILTER.PASTDUE) {
          cardsList = taskList
              .where((task) =>
                  task.dueDate.compareTo(currentTime) < 0 && !task.isCompleted)
              .map((task) => _buildDismissibleCard(task))
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
    );
  }

  Padding _buildTabSwitcher() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: DefaultTabController(
        length: 4,
        child: TabBar(
            padding: EdgeInsets.zero,
            labelPadding: EdgeInsets.zero,
            onTap: (index) {
              setState(() {
                if (index == 0) {
                  filter = FILTER.TODAY;
                } else if (index == 1) {
                  filter = FILTER.UPCOMING;
                } else if (index == 2) {
                  filter = FILTER.DONE;
                } else if (index == 3) {
                  filter = FILTER.PASTDUE;
                } else {
                  print("Something went wrong");
                }
              });
            },
            unselectedLabelColor: Colors.black,
            indicator: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.all(Radius.elliptical(20, 20)),
            ),
            labelStyle: const TextStyle(
              color: Colors.white,
            ),
            indicatorColor: Colors.black,
            splashBorderRadius:
                const BorderRadius.all(Radius.elliptical(20, 20)),
            tabs: [
              _buildTab("Today"),
              _buildTab("Upcoming"),
              _buildTab("Done"),
              _buildTab("Past Due"),
            ]),
      ),
    );
  }

  Padding _buildWelcomeSearchRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 21.0, vertical: 15.0),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          AnimatedOpacity(
            opacity: searchToggle ? 0 : 1.0,
            duration: const Duration(milliseconds: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Welcome Back ${_auth.currentUser!.displayName}!"),
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
                width: searchToggle ? MediaQuery.of(context).size.width : 40,
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
                          color: searchToggle ? Colors.black : Colors.white,
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 30.0),
                            child: TextField(
                              controller: searchField.controller,
                              autofocus: true,
                              decoration: kTaskManagerDecoration.copyWith(
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
    );
  }

  PopupMenuButton<int> _buildPopupMenuButton() {
    return PopupMenuButton(
        onSelected: (value) {
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
                      Text("Delete", style: TextStyle(color: Colors.black)),
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
                      Text("About", style: TextStyle(color: Colors.black)),
                    ],
                  ),
                ),
              )
            ]);
  }

  Padding _buildTab(String tabTitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        tabTitle,
        style: TextStyle(
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildDismissibleCard(Task task) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Dismissible(
            onDismissed: (direction) {
              if (direction == DismissDirection.endToStart) {
                setState(() =>
                    Provider.of<TaskControllerProvider>(context, listen: false)
                        .removeTaskFromList(task));
              }
              // else if (direction == DismissDirection.startToEnd) {
              //   task.isCompleted = true;
              // }
            },
            key: ObjectKey(task),
            direction: DismissDirection.endToStart,
            background: buildSwipingContainer(
                Colors.red, "Delete", Icons.delete, Alignment.centerRight),
            // background: buildSwipingContainer(
            //     Colors.green, "Done", Icons.check_circle, Alignment.centerLeft),
            child: TaskCard(taskData: task),
          ),
        ),
      );

  Widget buildSwipingContainer(
          Color color, String text, IconData icon, Alignment alignment) =>
      Container(
        color: color,
        alignment: alignment,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white),
              Text(text, style: const TextStyle(color: Colors.white)),
            ],
          ),
        ),
      );
}
