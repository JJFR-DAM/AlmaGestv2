import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pie_chart/pie_chart.dart';

import 'package:almagestv2/models/models.dart';
import 'package:almagestv2/screens/admin_screen.dart';
import 'package:almagestv2/services/services.dart';

List<OpinionData> opinionList = [];
Map<String, double> dataMap = {};
Map<String, double> auxMap = {};
DateTime now = DateTime.now();

class GraphicScreen extends StatefulWidget {
  const GraphicScreen({Key? key}) : super(key: key);

  @override
  State<GraphicScreen> createState() => _GraphicScreenState();
}

class _GraphicScreenState extends State<GraphicScreen> {
  Future refresh() async {
    final opService =
        Provider.of<OpinionsPlaguesService>(context, listen: false);

    setState(() {
      opService.opinions.clear();
      opService.plagues.clear();
      opinionList.clear();
      dataMap.clear();
      auxMap.clear();
    });
    await opService.getOpinions();
    await opService.getPlagues();
    AdminScreen.selectedItem = 1;

    setState(() {
      for (var i in opService.opinions.cast<OpinionData>()) {
        if (i.deleted == 0) {
          opinionList.add(i);
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    refresh();
  }

  void _onItemTapped(int index) {
    setState(() {
      AdminScreen.selectedItem = index;
    });
    if (AdminScreen.selectedItem == 0) {
      Navigator.pushReplacementNamed(context, 'admin');
    }
  }

  @override
  Widget build(BuildContext context) {
    final opService =
        Provider.of<OpinionsPlaguesService>(context, listen: false);
    final userService = Provider.of<UserService>(context, listen: false);

    for (int i = 0; i < 6; i++) {
      double count = 0;
      final entrie = <String, double>{
        now.subtract(Duration(days: i * 30)).month.toString(): 0.0
      };
      dataMap.addEntries(entrie.entries);
      for (var opinion in opinionList) {
        List<String>? time =
            opinion.createdAt?.toString().substring(0, 10).split("-");

        DateTime two = DateTime(
            int.parse(time![0]), int.parse(time[1]), int.parse(time[2]));

        final difference = now.difference(two).inDays;

        if (difference < 180) {
          if (now.subtract(Duration(days: i * 30)).month.toString() ==
              two.month.toString()) {
            count++;
          }
        }
        final entrie = <String, double>{
          now.subtract(Duration(days: i * 30)).month.toString(): count
        };
        dataMap.addEntries(entrie.entries);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Graphics'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.login_outlined),
          onPressed: () {
            userService.logout();
            Navigator.pushReplacementNamed(context, 'login');
          },
        ),
        actions: [
          SizedBox(
            width: 150,
            child: DropdownButtonFormField(
                hint: const Text(
                  'Select a Plague',
                  style: TextStyle(color: Colors.white),
                ),
                iconSize: 20,
                iconEnabledColor: Colors.white,
                iconDisabledColor: Colors.white,
                focusColor: Colors.deepPurpleAccent,
                dropdownColor: Colors.deepPurple,
                onChanged: (value) => setState(() {
                      opinionList.clear();
                      for (var i in opService.opinions.cast<OpinionData>()) {
                        if (i.deleted == 0) {
                          if (i.plagueName
                              .toString()
                              .contains(value!.name.toString())) {
                            opinionList.add(i);
                          }
                        }
                      }
                    }),
                items: AdminScreen.plagues.map((e) {
                  return DropdownMenuItem(
                    value: e,
                    child: Text(
                      e.name.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }).toList(),
                validator: (value) {
                  return (value!.name != null) ? null : 'Select a Plague';
                }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacementNamed(context, 'graphic');
        },
        child: const Icon(Icons.refresh_rounded),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.list_bullet), label: 'Users'),
          BottomNavigationBarItem(
              icon: Icon(Icons.donut_small), label: 'Graphic'),
        ],
        currentIndex: AdminScreen.selectedItem,
        selectedItemColor: Colors.deepPurple,
        onTap: _onItemTapped,
      ),
      body: SizedBox(
          child: PieChart(
        dataMap: dataMap,
        animationDuration: const Duration(milliseconds: 3000),
        chartLegendSpacing: 15,
        chartRadius: MediaQuery.of(context).size.width / 2,
        initialAngleInDegree: 0,
        legendOptions: const LegendOptions(
          showLegendsInRow: false,
          legendShape: BoxShape.rectangle,
          legendPosition: LegendPosition.right,
          showLegends: true,
          legendTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        chartValuesOptions: const ChartValuesOptions(
          showChartValueBackground: true,
          showChartValues: true,
          showChartValuesInPercentage: false,
          showChartValuesOutside: false,
          decimalPlaces: 1,
        ),
      )),
    );
  }
}
