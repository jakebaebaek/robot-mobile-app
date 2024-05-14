import 'dart:html';

import 'package:dartros/dartros.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:lorobot_app/utils/deviceInfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lorobot_app/utils/ros.dart';
import 'package:lorobot_app/utils/constants.dart';
import 'package:lorobot_app/widgets/settings/IPInputFeild.dart';
import 'package:lorobot_app/utils/Connection.dart';

enum WhenObstacleDetects {avoid, stop}

class NetworkWidget extends StatefulWidget{
  const NetworkWidget({super.key});

  @override
  State<NetworkWidget> createState() => _NetworkWidget();
}

class _NetworkWidget extends State<NetworkWidget>{
  final rmsKey = GlobalKey(debugLabel: 'network_rms');
  final rmsTxtKey = GlobalKey(debugLabel: 'network_rms_text');
  final String initialTextValue = '';
  late TextEditingController _textEditingControllerCurrent = TextEditingController();
  late TextEditingController _textEditingControllerHibot = TextEditingController();
  late String _oldTextCurrent;
  late String _oldTextHibot;
  late Text? _alertTexts;
  bool _exceed = false;
  static const ipPattern = r'\d[0-9.]+\d';
  final regexp = RegExp(ipPattern);

  @override
  void initState(){
    super.initState();
    _textEditingControllerCurrent = TextEditingController(text: initialTextValue);
    _textEditingControllerHibot = TextEditingController(text: initialTextValue);
    _oldTextCurrent = initialTextValue; // Current IP용 별도의 상태
    _oldTextHibot = initialTextValue;  // Hibot IP용 별도의 상태
    _alertTexts = const Text('');
  }

  @override
  void dispose() {
    _textEditingControllerCurrent.dispose();
    _textEditingControllerHibot.dispose();
    super.dispose();
  }

  void _connectRos(String uri) async {
    node = await initNode(defaultNodeName, [], rosMasterUri: uri);
  }


  void _formattingIP(String txt, TextEditingController controller, String oldText, Function(String) updateOldText) {
    final TextSelection previousCursorPos = controller.selection;
    List<String> splittedTxt = txt.split('.');
    List<String> txtSublist = [];
    _exceed = false;

    if(oldText.length < txt.length) {
      String res = '';
      for (int index = 0; index < splittedTxt.length; index++) {
        int? value = int.tryParse(splittedTxt[index]) ?? -1;
        if (value > 255) {
          _exceed = true;
          break;
        }
        txtSublist.add(splittedTxt[index]);
        if (index < splittedTxt.length - 1) {
          txtSublist.add('.');
        }
      }
      res = txtSublist.join('');
      if ('.'.allMatches(res).length > 3) {
        int lastDotIndex = res.lastIndexOf('.');
        res = res.substring(0, lastDotIndex);
      }
      controller.text = res;
      updateOldText(res);  // Update the old text state
    }
    controller.selection = previousCursorPos;
    setState(() {});
  }

  @override
  Widget build(BuildContext context){
    var devInfo = DeviceInfo(context: context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: buildSectionEnterIP(),
    );
  }

  Widget buildSectionEnterIP(){
    return SingleChildScrollView(
      key: rmsKey,
        child: Column (
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Column(
                children: [
                  IPInputField(
                    exceed: _exceed,
                    rmsTxtKey: ValueKey('currentIpField'),
                    textEditingController: _textEditingControllerCurrent,
                    formattingIP: (text) => _formattingIP(text, _textEditingControllerCurrent, _oldTextCurrent, (val) => setState(() => _oldTextCurrent = val)),
                    TextonTop: 'Current IP address',
                  ),
                  Padding(padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                    child: IPInputField(
                      exceed: _exceed,
                      rmsTxtKey: ValueKey('hibotIpField'),
                      textEditingController: _textEditingControllerHibot,
                      formattingIP: (text) => _formattingIP(text, _textEditingControllerHibot, _oldTextHibot, (val) => setState(() => _oldTextHibot = val)),
                      TextonTop: 'HIBOT IP address',
                    ),
                  ),
                  Padding(padding: const EdgeInsets.fromLTRB(0, 60, 0, 40),
                      child:Text(
                        textAlign: TextAlign.center,
                        "NOT Connected",
                        style: TextStyle(
                          fontSize: 40
                        ),
                      )
                  ),
                  Padding(padding: const EdgeInsets.all(3.0),
                    child: ConnectionWidget(),
                  )
                ],
              ),
          ],
        ),
      );
  }
}