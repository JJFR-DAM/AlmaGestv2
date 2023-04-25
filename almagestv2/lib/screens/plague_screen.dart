import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:provider/provider.dart';

import 'package:almagestv2/screens/screens.dart';
import 'package:almagestv2/services/services.dart';
import 'package:almagestv2/models/models.dart';

List<PlagueData> plaguesList = [];

class PlagueScreen extends StatefulWidget {
  const PlagueScreen({Key? key}) : super(key: key);

  @override
  State<PlagueScreen> createState() => _PlagueScreenState();
}

class _PlagueScreenState extends State<PlagueScreen> {
  Future refresh() async {
    final opService =
        Provider.of<OpinionsPlaguesService>(context, listen: false);
    setState(() {
      opService.opinions.clear();
      opService.plagues.clear();
      plaguesList.clear();
    });
    await opService.getOpinions();
    await opService.getPlagues();
    plaguesList = opService.plagues.cast<PlagueData>();
  }

  @override
  void initState() {
    super.initState();
    refresh();
  }

  void _onItemTapped(int index) {
    setState(() {
      OpinionScreen.selectedItem = index;
    });
    if (OpinionScreen.selectedItem == 0) {
      Navigator.pushReplacementNamed(context, 'opinions');
    }
  }

  @override
  Widget build(BuildContext context) {
    final opService =
        Provider.of<OpinionsPlaguesService>(context, listen: false);
    final userService = Provider.of<UserService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Plagues'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.login_outlined),
          onPressed: () {
            userService.logout();
            Navigator.pushReplacementNamed(context, 'login');
          },
        ),
        actions: const [],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.list_bullet), label: 'Opinions'),
          BottomNavigationBarItem(
              icon: Icon(Icons.bug_report_outlined), label: 'Plagues'),
        ],
        currentIndex: OpinionScreen.selectedItem,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          Navigator.pushReplacementNamed(context, 'opinions');
        },
        child: builListView(
            context, buildOpinionsPlaguesService(context), plaguesList),
      ),
    );
  }

  OpinionsPlaguesService buildOpinionsPlaguesService(BuildContext context) {
    final opService = Provider.of<OpinionsPlaguesService>(context);
    return opService;
  }

  Widget builListView(BuildContext context, OpinionsPlaguesService opService,
          List<PlagueData> plagues) =>
      ListView.separated(
          padding: const EdgeInsets.all(10),
          itemBuilder: (context, index) {
            final PlagueData plague = plagues[index];
            return SizedBox(
              height: 400,
              child: Card(
                elevation: 25,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              plague.name.toString(),
                              style: const TextStyle(fontSize: 30),
                              textAlign: TextAlign.left,
                            ),
                          ]),
                      const Divider(color: Colors.black),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            plague.img.toString(),
                            style: const TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ]),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return const Divider();
          },
          itemCount: plagues.length);

  void customToast(String s, BuildContext context) {
    showToast(
      s,
      context: context,
      animation: StyledToastAnimation.scale,
      reverseAnimation: StyledToastAnimation.fade,
      position: StyledToastPosition.bottom,
      animDuration: const Duration(seconds: 1),
      duration: const Duration(seconds: 2),
      curve: Curves.elasticOut,
      reverseCurve: Curves.linear,
      backgroundColor: Colors.greenAccent,
    );
  }
}
