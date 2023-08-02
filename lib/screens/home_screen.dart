import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:z_task_manager/services/task_controller_provider.dart';
import '../constants/reusable_ui.dart';
import '../structure/CATEGORY.dart';
import 'new_task.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const String id = "Home_Screen";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> cardsList = [];
  FILTER filter = FILTER.TODAY;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 10,
        actions: [
          IconButton(
            icon: Image(
              image: AssetImage("assets/icons/profile.png"),
              width: 30,
            ),
            onPressed: () {},
          ),
        ],
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Image(
          image: AssetImage("assets/logos/backcaps.png"),
          width: 100,
        ),
      ),
      drawer: Drawer(),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Welcome Back!"),
                        Text(
                          "Here's Update Today",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: IconButton(
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        icon: const Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
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
              Consumer<TaskControllerProvider>(
                builder: (context, taskController, _) {

                  final taskList = taskController.tasksList;
                  List<Widget> cardsList = [];
                  if(filter == FILTER.TODAY){
                    cardsList = taskList
                        .where((element) => element.dueDate.day == DateTime.now().day && element.isCompleted==false)
                        .map((task) => TaskCard(taskData: task,))
                        .toList();
                  }
                  else if(filter == FILTER.UPCOMING){
                    cardsList = taskList
                          .where((element) => element.dueDate.day > DateTime.now().day && element.isCompleted == false)
                          .map((task) => TaskCard(taskData: task,))
                          .toList();
                  }
                  else if(filter == FILTER.DONE){
                    cardsList = taskList
                          .where((e) => e.isCompleted)
                          .map((e) => TaskCard(taskData: e))
                          .toList();
                  }


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
    );
  }
}
