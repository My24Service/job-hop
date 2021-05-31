import 'package:flutter/material.dart';
import 'package:jobhop/company/models/models.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Job-Hop',
      home: JobHopHome(),
    ),
  );
}

class JobHopHome extends StatefulWidget {
  @override
  State createState() => JobHopHomeState();
}

class JobHopHomeState extends State<JobHopHome> {
  StudentUser? _user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Job-Hop'),
        ),
        body: ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: _buildBody(),
        ));
  }

  @override
  void initState() {
    super.initState();
    _doAsync();
  }

  _doAsync() async {
    await _getUser();
  }

  Future<StudentUser> _getUser() async {
    return null;
  }

  Widget _buildBody() {
    if (_user != null) {
      // load orders or show menu?
      return Column(

      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          const Text("You are not currently signed in."),
          ElevatedButton(
            child: const Text('SIGN IN'),
            onPressed: () => {},
          ),
        ],
      );
    }
  }
}
