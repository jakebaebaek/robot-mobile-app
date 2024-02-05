import 'dart:developer';
import 'dart:io';
import 'package:dartros/dartros.dart';
import 'package:flutter/foundation.dart';
import 'package:lorobot_app/utils/deviceInfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lorobot_app/utils/ros.dart';
import 'package:lorobot_app/utils/constants.dart';

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
  late TextEditingController _textEditingController;
  late String _oldText;
  late Text? _alertTexts;
  bool _exceed = false;
  static const ipPattern = r'\d[0-9.]+\d';
  final regexp = RegExp(ipPattern);

  @override
  void initState(){
    super.initState();
    _textEditingController = TextEditingController(text: initialTextValue);
    _oldText = initialTextValue;
    _alertTexts = const Text('');
  }

  @override
  void dispose(){
    _textEditingController.dispose();
    super.dispose();
  }

  void _connectRos(String uri) async {
    node = await initNode(defaultNodeName, [], rosMasterUri: uri);
  }

  void _connectRMS([String? rTxt]){
    var wdt = toString();
    var txt = rTxt ?? _textEditingController.text;
    // log(txt);
    // for(var matched in regexp.allMatches(txt)){
    //   log('$wdt got groupt ${matched.groupCount}');
    //   log('$wdt matched ${matched[0]}');  
    // }
    // rh = RosHandler.withUri(defaultNodeName, 'http://$txt:11311/', []);
    _connectRos('http://$txt:11311/');
  }

  void _formattingIP(String txt){
    final TextSelection previousCursorPos = _textEditingController.selection;
    List<String> splittedTxt = txt.split('.');
    List txtSublist = [];
    _exceed = false;
    sysLog.d(splittedTxt.toString());
    _alertTexts = null;

    if(_oldText.length < txt.length){
      String res = '';
      int index = 0;
      for(String spspTxt in splittedTxt){
        int? value = int.tryParse(spspTxt) ?? -1;
        int value1 = value ~/ 10;
        bool checked = false;
        if(value > 255){
          _exceed = true;
          break;
        }
        if (((value1 < 10) && (value1 > 2)) || (value1 > 9)) checked = true;
        if(index < splittedTxt.length){
          txtSublist = splittedTxt.length > 1 ? 
                    List.from(splittedTxt.sublist(0, index+1)) 
                    : List.from(splittedTxt);
          // log('1 txtSublist is ${txtSublist}');
          if(checked) txtSublist.add('');
        }
        res = txtSublist.join('.');
        index += 1;
      }
      // log('2 txtSublist is ${txtSublist}');
      // log('splittedTxt length is ${splittedTxt.length}');
      if('.'.allMatches(res).length > 3){
        int a = res.lastIndexOf('.');
        res = res.substring(0, a);
      }
      _textEditingController.text = res;
    }
    _oldText = _textEditingController.text;
    _textEditingController.selection = previousCursorPos;
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context){
    var devInfo = DeviceInfo(context: context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        buildSectionEnterIP(),
        
      ]
    );
  }

  Widget buildSectionEnterIP(){
    return Container(
      key: rmsKey,
      child: Flexible(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SizedBox(
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Please write a IP address to connect",
                    hintMaxLines: 1,
                    errorText: _exceed ? "Please check again" : null,
                  ),
                  key: rmsTxtKey,
                  // textAlign: TextAlign.center,
                  keyboardType: const TextInputType.numberWithOptions(),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
                  ],
                  controller: _textEditingController,
                  onChanged: _formattingIP,
                ),
              ),
            ),
            Expanded(
              child: OutlinedButton(
                onPressed: _connectRMS,
                child: const Text('Connect to RMS'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}