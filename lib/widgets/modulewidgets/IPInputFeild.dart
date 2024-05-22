import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class IPInputField extends StatelessWidget {
  final bool exceed;
  final Key rmsTxtKey;
  final TextEditingController textEditingController;
  final Function(String) formattingIP;
  final String textOnTop;
  final ValueChanged<String> onChanged;

  IPInputField({
    required this.exceed,
    required this.rmsTxtKey,
    required this.textEditingController,
    required this.formattingIP,
    required this.textOnTop,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(textOnTop),
        TextFormField(
          decoration: InputDecoration(
            hintText: "Please write an IP address to connect",
            hintMaxLines: 1,
            errorText: exceed ? "Please check again" : null,
          ),
          key: rmsTxtKey,
          keyboardType: TextInputType.numberWithOptions(),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
          ],
          controller: textEditingController,
          onChanged: (value) {
            onChanged(value);
            formattingIP(value);
          },
        ),
      ],
    );
  }
}

class UnderlineInput extends StatelessWidget {
  // final TextEditingController textEditingController;
  final String TextonTop;
  final String HintText;
  final TextKey;

  UnderlineInput({
    // required this.textEditingController,
    required this.TextonTop,
    required this.HintText,
    required this.TextKey,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$TextonTop'),
        TextFormField(
          decoration: InputDecoration(
            hintText: HintText,
            hintMaxLines: 1,
          ),
          key: TextKey,
          keyboardType: const TextInputType.numberWithOptions(),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
          ],
          // controller: textEditingController,
        ),
      ],
    );
  }
}