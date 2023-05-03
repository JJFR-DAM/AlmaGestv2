import 'package:almagestv2/screens/screens.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

import 'package:almagestv2/models/models.dart';
import 'package:almagestv2/services/services.dart';
import 'package:provider/provider.dart';

List<OpinionData> opinionsList = [];

class OpinionScreen extends StatefulWidget {
  static List<PlagueData> plagues = [];
  static int selectedItem = 0;

  const OpinionScreen({Key? key}) : super(key: key);

  @override
  State<OpinionScreen> createState() => _OpinionScreenState();
}

class _OpinionScreenState extends State<OpinionScreen> {
  Future refresh() async {
    final opService =
        Provider.of<OpinionsPlaguesService>(context, listen: false);

    setState(() {
      opService.opinions.clear();
      opService.plagues.clear();
      opinionsList.clear();
      OpinionScreen.plagues.clear();
    });
    await opService.getOpinions();
    await opService.getPlagues();
    for (var i in opService.opinions.cast<OpinionData>()) {
      if (i.deleted == 0) {
        opinionsList.add(i);
      }
    }
    opinionsList
        .sort((a, b) => a.headline.toString().compareTo(b.headline.toString()));
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
    if (OpinionScreen.selectedItem == 1) {
      Navigator.pushReplacementNamed(context, 'plagues');
    }
  }

  @override
  Widget build(BuildContext context) {
    final opService =
        Provider.of<OpinionsPlaguesService>(context, listen: false);
    final userService = Provider.of<UserService>(context, listen: false);
    OpinionScreen.plagues = opService.plagues.cast<PlagueData>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Opinions'),
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
                      opinionsList.clear();
                      for (var i in opService.opinions.cast<OpinionData>()) {
                        if (i.deleted == 0) {
                          if (i.plagueName
                              .toString()
                              .toLowerCase()
                              .contains(value!.name.toString().toLowerCase())) {
                            opinionsList.add(i);
                          }
                        }
                      }
                    }),
                items: OpinionScreen.plagues.map((e) {
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
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.list_bullet), label: 'Opinions'),
          BottomNavigationBarItem(
              icon: Icon(Icons.bug_report_outlined), label: 'Plagues'),
        ],
        currentIndex: OpinionScreen.selectedItem,
        selectedItemColor: Colors.deepPurple,
        onTap: _onItemTapped,
      ),
      body: RefreshIndicator(
        color: Colors.deepPurple,
        onRefresh: () async {
          Navigator.pushReplacementNamed(context, 'opinions');
        },
        child: builListView(context, buildUserService(context), opinionsList),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const FormOpinionScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  OpinionsPlaguesService buildUserService(BuildContext context) {
    final opService = Provider.of<OpinionsPlaguesService>(context);
    return opService;
  }

  Widget builListView(BuildContext context, OpinionsPlaguesService opService,
          List<OpinionData> opinions) =>
      ListView.separated(
          padding: const EdgeInsets.all(10),
          itemBuilder: (context, index) {
            final OpinionData opinion = opinions[index];
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
                              opinion.headline.toString(),
                              style: const TextStyle(fontSize: 30),
                              textAlign: TextAlign.left,
                            ),
                          ]),
                      const Divider(color: Colors.black),
                      Column(
                        children: [
                          const Text(
                            'Created at:',
                            style: TextStyle(fontSize: 15),
                          ),
                          const Divider(
                            color: Colors.white,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                'Time: ${opinion.createdAt.toString().split('T')[1].substring(0, 8)}',
                                style: const TextStyle(fontSize: 15),
                              ),
                              Text(
                                'Date: ${opinion.createdAt.toString().split('T')[0]}',
                                style: const TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Divider(color: Colors.black),
                      Text(opinion.description.toString(),
                          style: const TextStyle(fontSize: 20)),
                      const Divider(color: Colors.black),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          MaterialButton(
                            color: Colors.red,
                            highlightColor: Colors.red,
                            focusColor: Colors.red[800],
                            splashColor: Colors.red[800],
                            minWidth: 100.0,
                            height: 30.0,
                            onPressed: () {
                              CoolAlert.show(
                                context: context,
                                type: CoolAlertType.warning,
                                title: 'Confirm',
                                text: 'Are you sure?',
                                showCancelBtn: true,
                                confirmBtnColor: Colors.purple,
                                confirmBtnText: 'Delete',
                                onConfirmBtnTap: () {
                                  opService
                                      .deleteOpinion(opinion.id.toString());
                                  customToast('Deleted succesfully', context);
                                  Navigator.pushReplacementNamed(
                                      context, 'opinions');
                                },
                                onCancelBtnTap: () => Navigator.pop(context),
                                cancelBtnText: 'Cancel',
                              );
                            },
                            child: const Text('Delete',
                                style: TextStyle(color: Colors.white)),
                          ),
                          Column(
                            children: [
                              Row(
                                children: [
                                  MaterialButton(
                                    splashColor: Colors.purpleAccent,
                                    onPressed: () => setState(() {
                                      opService.postLike(opinion.id.toString());
                                      opinion.numLikes = opinion.numLikes! + 1;
                                    }),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          CupertinoIcons.heart_solid,
                                          color: Colors.deepPurple,
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          opinion.numLikes.toString(),
                                          style: const TextStyle(
                                              fontSize: 20,
                                              color: Colors.deepPurple),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              )
                            ],
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
          itemCount: opinions.length);

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
