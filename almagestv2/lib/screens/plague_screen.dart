import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:provider/provider.dart';

import 'package:almagestv2/screens/screens.dart';
import 'package:almagestv2/services/services.dart';
import 'package:almagestv2/models/models.dart';

class PlagueScreen extends StatefulWidget {
  static List<ProductData> products = [];

  static List<PlagueData> plaguesList = [];

  const PlagueScreen({Key? key}) : super(key: key);

  @override
  State<PlagueScreen> createState() => _PlagueScreenState();
}

class _PlagueScreenState extends State<PlagueScreen> {
  Future refresh() async {
    final opService =
        Provider.of<OpinionsPlaguesService>(context, listen: false);
    final pService = Provider.of<ProductsService>(context, listen: false);
    setState(() {
      opService.plagues.clear();
      PlagueScreen.plaguesList.clear();
      PlagueScreen.products.clear();
    });
    await opService.getPlagues();
    await pService.getProducts();

    setState(() {
      for (var i in opService.plagues.cast<PlagueData>()) {
        if (i.deleted == 0) {
          PlagueScreen.plaguesList.add(i);
        }
      }
      PlagueScreen.plaguesList
          .sort((a, b) => a.name.toString().compareTo(b.name.toString()));
    });
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
    final pService = Provider.of<ProductsService>(context, listen: false);
    PlagueScreen.products = pService.products.cast<ProductData>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
        actions: [
          SizedBox(
            width: 150,
            child: TextField(
              onChanged: (value) => setState(() {
                PlagueScreen.plaguesList.clear();
                for (var i in opService.plagues.cast<PlagueData>()) {
                  if (i.name
                          .toString()
                          .toLowerCase()
                          .contains(value.toLowerCase()) &&
                      i.deleted == 0) {
                    PlagueScreen.plaguesList.add(i);
                  }
                  PlagueScreen.plaguesList.sort(
                      (a, b) => a.name.toString().compareTo(b.name.toString()));
                }
              }),
            ),
          )
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
          Navigator.pushReplacementNamed(context, 'plagues');
        },
        child: builListView(context, buildOpinionsPlaguesService(context),
            PlagueScreen.plaguesList),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const FormPlagueScreen()));
        },
        child: const Icon(Icons.add),
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
          padding: const EdgeInsets.all(50),
          itemBuilder: (context, index) {
            final PlagueData plague = plagues[index];
            return Card(
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              elevation: 50,
              shadowColor: Colors.deepPurple.withOpacity(0.5),
              child: Column(
                children: [
                  Card(
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: FadeInImage(
                      image: NetworkImage(plague.img.toString()),
                      placeholder: const AssetImage('assets/jar-loading.gif'),
                      fit: BoxFit.contain,
                    ),
                  ),
                  Container(
                    alignment: AlignmentDirectional.center,
                    padding: const EdgeInsets.only(top: 10, bottom: 15),
                    child: Text(
                      plague.name.toString(),
                      style: const TextStyle(fontSize: 20),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
            );
          },
          separatorBuilder: (context, index) {
            return Divider(
              height: 0,
              color: Colors.deepPurple.withOpacity(0),
            );
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
