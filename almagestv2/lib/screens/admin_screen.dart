import 'package:almagestv2/screens/screens.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:provider/provider.dart';

import 'package:almagestv2/Models/models.dart';
import 'package:almagestv2/services/services.dart';

enum Actions { share, delete, archive }

List<UserData> users = [];

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);
  static List<PlagueData> plagues = [];
  static int selectedItem = 0;

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  Future refresh() async {
    setState(() => users.clear());
    var usersService = Provider.of<UserService>(context, listen: false);
    var opService = Provider.of<OpinionsPlaguesService>(context, listen: false);
    await usersService.getUsers();
    await opService.getPlagues();
    AdminScreen.plagues.clear();
    for (var i in opService.plagues.cast<PlagueData>()) {
      if (i.deleted == 0) {
        AdminScreen.plagues.add(i);
      }
    }
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
    if (AdminScreen.selectedItem == 1) {
      Navigator.pushReplacementNamed(context, 'graphic');
    }
  }

  @override
  Widget build(BuildContext context) {
    final usersService = Provider.of<UserService>(context, listen: false);
    users = usersService.users.cast<UserData>();
    List<UserData> usersFinal = [];
    for (int i = 0; i < users.length; i++) {
      if (users[i].deleted == 0 && users[i].type == "u") {
        usersFinal.add(users[i]);
      }
    }
    usersFinal.sort(
        (a, b) => a.firstname.toString().compareTo(b.firstname.toString()));

    return Scaffold(
        appBar: AppBar(
          title: const Text('Admin Menu'),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.login_outlined),
            onPressed: () {
              Provider.of<UserService>(context, listen: false).logout();
              Navigator.pushReplacementNamed(context, 'login');
            },
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.list_bullet), label: 'Users'),
            BottomNavigationBarItem(
                icon: Icon(Icons.donut_small), label: 'Graphic'),
          ],
          currentIndex: OpinionScreen.selectedItem,
          selectedItemColor: Colors.deepPurple,
          onTap: _onItemTapped,
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            Navigator.pushReplacementNamed(context, 'admin');
          },
          child: builListView(context, buildUserService(context), usersFinal),
        ));
  }

  UserService buildUserService(BuildContext context) {
    final userService = Provider.of<UserService>(context);
    return userService;
  }

  List builList(UserService userService) {
    List<UserData> users = userService.users;
    return users;
  }

  Widget builListView(
          BuildContext context, UserService userService, List users) =>
      ListView.separated(
          itemBuilder: (context, index) {
            final user = users[index];
            if (user.actived == 0) {
              return Slidable(
                startActionPane: ActionPane(
                  motion: const StretchMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) {
                        customToast('Activated succesfully', context);
                        setState(() {
                          userService.postActivate(user.id.toString());
                          users[index].actived = 1;
                        });
                      },
                      backgroundColor: const Color(0xFF7BC043),
                      foregroundColor: Colors.white,
                      icon: Icons.person_add_alt,
                      label: 'Activate',
                    )
                  ],
                ),
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) {
                        setState(() {
                          UpdateScreen.userId = user.id.toString();
                          Navigator.pushReplacementNamed(context, 'update');
                        });
                      },
                      backgroundColor: const Color.fromARGB(255, 88, 73, 254),
                      foregroundColor: Colors.white,
                      icon: Icons.change_circle_outlined,
                      label: 'Update',
                    ),
                    SlidableAction(
                      onPressed: (BuildContext _) async {
                        await CoolAlert.show(
                          context: context,
                          type: CoolAlertType.warning,
                          title: 'Confirm',
                          text: 'Are you sure?',
                          showCancelBtn: true,
                          confirmBtnColor: Colors.purple,
                          confirmBtnText: 'Delete',
                          onConfirmBtnTap: () {
                            customToast('Deleted succesfully', context);
                            setState(() {
                              userService.postDelete(user.id.toString());
                              refresh();
                            });
                          },
                          onCancelBtnTap: () => Navigator.pop(context),
                          cancelBtnText: 'Cancel',
                        );
                      },
                      backgroundColor: const Color(0xFFFE4A49),
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Delete',
                    ),
                  ],
                ),
                child: buildUserListTile(user),
              );
            } else {
              return Slidable(
                startActionPane: ActionPane(
                  motion: const StretchMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) {
                        customToast('Deactivated succesfully', context);
                        setState(() {
                          userService.postDeactivate(user.id.toString());
                          users[index].actived = 0;
                        });
                      },
                      backgroundColor: const Color.fromARGB(255, 75, 81, 82),
                      foregroundColor: Colors.white,
                      icon: Icons.person_add_disabled_outlined,
                      label: 'Deactivate',
                    )
                  ],
                ),
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) {
                        setState(() {
                          UpdateScreen.userId = user.id.toString();
                          Navigator.pushReplacementNamed(context, 'update');
                        });
                      },
                      backgroundColor: const Color.fromARGB(255, 88, 73, 254),
                      foregroundColor: Colors.white,
                      icon: Icons.change_circle_outlined,
                      label: 'Update',
                    ),
                    SlidableAction(
                      onPressed: (BuildContext _) async {
                        await CoolAlert.show(
                          context: context,
                          type: CoolAlertType.warning,
                          title: 'Confirm',
                          text: 'Are you sure?',
                          showCancelBtn: true,
                          confirmBtnColor: Colors.purple,
                          confirmBtnText: 'Delete',
                          onConfirmBtnTap: () {
                            customToast('Deleted succesfully', context);
                            setState(() {
                              userService.postDelete(user.id.toString());
                              users.removeAt(index);
                            });
                          },
                          onCancelBtnTap: () => Navigator.pop(context),
                          cancelBtnText: 'Cancel',
                        );
                      },
                      backgroundColor: const Color(0xFFFE4A49),
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Delete',
                    ),
                  ],
                ),
                child: buildUserListTile(user),
              );
            }
          },
          separatorBuilder: (context, index) {
            return const Divider();
          },
          itemCount: users.length);

  Widget buildUserListTile(user) => ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(user.firstname + ' ' + user.secondname),
        subtitle: Text(user.email),
        leading: const CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            backgroundImage: NetworkImage(
                'https://cdn-icons-png.flaticon.com/512/511/511649.png')),
      );

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
