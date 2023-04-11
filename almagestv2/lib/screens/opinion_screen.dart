import 'package:flutter/material.dart';

import 'package:almagestv2/screens/screens.dart';
import 'package:almagestv2/models/models.dart';
import 'package:almagestv2/services/services.dart';

List<OpinionData> opinions = [];

class OpinionScreen extends StatefulWidget {
  const OpinionScreen({Key? key}) : super(key: key);

  @override
  State<OpinionScreen> createState() => _OpinionScreenState();
}

class _OpinionScreenState extends State<OpinionScreen> {
  Future refresh() async {
    setState(() => opinions.clear());
    OpinionsPlaguesService opService = OpinionsPlaguesService();
    await opService.getOpinions();
  }

  @override
  void initState() {
    super.initState();
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    final opService = OpinionsPlaguesService();
    final userService = UserService();
    opinions = opService.opinions.cast<OpinionData>();
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
          setState(() {
            refresh();
          });
          Navigator.pushReplacementNamed(context, 'opinions');
        },
        child: const Text('opinion'),
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
}
