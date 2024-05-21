import 'package:flutter/material.dart';
import 'package:dartros/dartros.dart';
import 'package:lorobot_app/utils/deviceInfo.dart';
import 'package:lorobot_app/utils/connection.dart';
import 'package:lorobot_app/widgets/modulewidgets/IPInputFeild.dart';
import 'package:lorobot_app/widgets/modulewidgets/OutlinedButton.dart';  // Import 변경

enum WhenObstacleDetects {avoid, stop}

class NetworkWidget extends StatefulWidget {
  const NetworkWidget({super.key});

  @override
  State<NetworkWidget> createState() => _NetworkWidget();
}

class _NetworkWidget extends State<NetworkWidget> {
  final rmsKey = GlobalKey(debugLabel: 'network_rms');
  final String initialTextValue = '';
  late TextEditingController _deviceIPController;
  late TextEditingController _robotIPController;
  late String _oldTextCurrent;
  late String _oldTextHibot;
  late Text? _alertTexts;
  bool _exceed = false;
  final ConnectionService _connectionService = ConnectionService();
  String _connectionStatus = 'Not connected';
  String deviceIP = '';
  String robotIP = '';
  static const String defaultNodeName = 'default_node';
  late NodeHandle node;

  @override
  void initState() {
    super.initState();
    _deviceIPController = TextEditingController(text: initialTextValue);
    _robotIPController = TextEditingController(text: initialTextValue);
    _oldTextCurrent = initialTextValue;
    _oldTextHibot = initialTextValue;
    _alertTexts = const Text('');
    _connectionService.onStatusChanged = (status) {
      setState(() {
        _connectionStatus = status;
      });
    };
  }

  @override
  void dispose() {
    _deviceIPController.dispose();
    _robotIPController.dispose();
    super.dispose();
  }

  void _connectRos(String uri) async {
    node = await initNode(defaultNodeName, [], rosMasterUri: uri);
  }

  void _formattingIP(String txt, TextEditingController controller, String oldText, Function(String) setOldText) {
    Future.microtask(() {
      final TextSelection previousCursorPos = controller.selection;
      List<String> splittedTxt = txt.split('.');
      List<String> txtSublist = [];
      bool exceed = false;
      if (oldText.length < txt.length) {
        String res = '';
        int index = 0;
        for (String spspTxt in splittedTxt) {
          int? value = int.tryParse(spspTxt) ?? -1;
          int value1 = value ~/ 10;
          bool checked = false;
          if (value > 255) {
            exceed = true;
            break;
          }
          if (((value1 < 10) && (value1 > 2)) || (value1 > 9)) checked = true;
          if (index < splittedTxt.length) {
            txtSublist = splittedTxt.length > 1
                ? List.from(splittedTxt.sublist(0, index + 1))
                : List.from(splittedTxt);
            if (checked) txtSublist.add('');
          }
          res = txtSublist.join('.');
          index += 1;
        }
        if ('.'.allMatches(res).length > 3) {
          int a = res.lastIndexOf('.');
          res = res.substring(0, a);
        }
        controller.text = res;
      }
      setOldText(controller.text);
      controller.selection = previousCursorPos;
      setState(() {
        _exceed = exceed;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        key: rmsKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                IPInputField(
                  exceed: _exceed,
                  rmsTxtKey: ValueKey('currentIpField'),
                  textEditingController: _deviceIPController,
                  formattingIP: (text) => _formattingIP(text, _deviceIPController, _oldTextCurrent, (val) => _oldTextCurrent = val),
                  textOnTop: 'Current IP address',
                  onChanged: (value) {
                    setState(() {
                      deviceIP = value;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                  child: IPInputField(
                    exceed: _exceed,
                    rmsTxtKey: ValueKey('hibotIpField'),
                    textEditingController: _robotIPController,
                    formattingIP: (text) => _formattingIP(text, _robotIPController, _oldTextHibot, (val) => _oldTextHibot = val),
                    textOnTop: 'HIBOT IP address',
                    onChanged: (value) {
                      setState(() {
                        robotIP = value;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 60, 0, 40),
                  child: Text(
                    textAlign: TextAlign.center,
                    'Connection Status: $_connectionStatus',
                    style: TextStyle(fontSize: 40),
                  ),
                ),
                CustomOutlinedButton(
                  onPressed: () {
                    _connectionService.connectToRos(deviceIP, robotIP);
                  },
                  child: const Text(
                    'Connect🐱',
                    style: TextStyle(fontSize: 30),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
