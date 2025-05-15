import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LanguageSelectionPage extends StatefulWidget {
  LanguageSelectionPage(
      {super.key, required this.onSelected1, required this.onSelected2});
  Function onSelected1;
  Function onSelected2;

  @override
  State<LanguageSelectionPage> createState() => _LanguageSelectionPageState();
}

class _LanguageSelectionPageState extends State<LanguageSelectionPage> {
  final Map<String, String> languages = {
    'it': 'Italiano',
    'en': 'Inglese',
    'fr': 'Francese',
    'es': 'Spagnolo',
    'de': 'Tedesco',
    'ru': 'Russo',
  };

  String? selectedLanguage1;
  String? selectedLanguage2;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          SizedBox(
            width: 400,
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Lingua 1',
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.0),
                    borderRadius: BorderRadius.circular(10)),
              ),
              value: selectedLanguage1,
              items: languages.entries
                  .map(
                    (e) => DropdownMenuItem(
                      value: e.key,
                      child: Text(e.value),
                    ),
                  )
                  .toList(),
              onChanged: (val) {
                setState(() {
                  selectedLanguage1 = val;
                  widget.onSelected1.call(selectedLanguage1);
                });
              },
            ),
          ),
          SizedBox(
            height: 10,
          ),

          SizedBox(
            width: 400,
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Lingua 2',
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.0),
                    borderRadius: BorderRadius.circular(10)),
              ),
              value: selectedLanguage2,
              items: languages.entries
                  .map(
                    (e) => DropdownMenuItem(
                      value: e.key,
                      child: Text(e.value),
                    ),
                  )
                  .toList(),
              onChanged: (val) {
                setState(() {
                  selectedLanguage2 = val;
                  widget.onSelected2.call(selectedLanguage2);
                });
              },
            ),
          ),
          // SizedBox(
          //   height: 100,
          // ),
          // Text('Lingua pdf selezionata: ${languages[selectedLanguage1]}'),
          // Text('Lingua  desiderata: ${languages[selectedLanguage2]}'),
        ],
      ),
    );
  }
}
