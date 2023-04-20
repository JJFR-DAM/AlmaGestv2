import 'package:almagestv2/screens/screens.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';

import 'package:almagestv2/models/models.dart';
import 'package:almagestv2/services/services.dart';
import 'package:provider/provider.dart';

List<OpinionData> opinionsList = [];

class OpinionScreen extends StatefulWidget {
  static List<PlagueData> plagues = [];

  const OpinionScreen({Key? key}) : super(key: key);

  @override
  State<OpinionScreen> createState() => _OpinionScreenState();
}

class _OpinionScreenState extends State<OpinionScreen> {
  Future refresh() async {
    setState(() => opinionsList.clear());
    var opService = Provider.of<OpinionsPlaguesService>(context, listen: false);
    await opService.getOpinions();
    await opService.getPlagues();
  }

  @override
  void initState() {
    super.initState();
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    final opService =
        Provider.of<OpinionsPlaguesService>(context, listen: false);
    final userService = Provider.of<UserService>(context, listen: false);
    opinionsList = opService.opinions.cast<OpinionData>();
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
      ),
      body: RefreshIndicator(
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            opinion.createdAt.toString(),
                            style: const TextStyle(fontSize: 15),
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
                                  Navigator.pushReplacementNamed(
                                      context, 'opinions');
                                },
                                onCancelBtnTap: () => Navigator.pop(context),
                                cancelBtnText: 'Cancel',
                              );
                            },
                            color: Colors.red,
                            child: const Text('Delete',
                                style: TextStyle(color: Colors.white)),
                          ),
                          Column(
                            children: [
                              LikeButton(
                                size: 30,
                                circleColor: const CircleColor(
                                    start: Color.fromARGB(255, 217, 0, 255),
                                    end: Color.fromARGB(255, 217, 0, 255)),
                                bubblesColor: const BubblesColor(
                                  dotPrimaryColor:
                                      Color.fromARGB(255, 217, 0, 255),
                                  dotSecondaryColor:
                                      Color.fromARGB(255, 217, 0, 255),
                                ),
                                likeBuilder: (bool isLiked) {
                                  return Icon(
                                    CupertinoIcons.heart_fill,
                                    color: isLiked
                                        ? Colors.deepPurpleAccent
                                        : Colors.grey,
                                    size: 30,
                                  );
                                },
                                likeCount: opinion.numLikes?.toInt(),
                                countBuilder:
                                    (int? count, bool isLiked, String text) {
                                  var color = isLiked
                                      ? Colors.deepPurpleAccent
                                      : Colors.grey;
                                  Widget result;
                                  if (count == 0) {
                                    result = Text(
                                      "",
                                      style: TextStyle(color: color),
                                    );
                                  } else {
                                    result = Text(
                                      text,
                                      style: TextStyle(color: color),
                                    );
                                  }
                                  return result;
                                },
                              ),
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
}
