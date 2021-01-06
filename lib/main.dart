// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert' show base64Decode, jsonEncode, utf8;

import 'package:convert/convert.dart' show hex;
import 'package:webcrypto/webcrypto.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _output = '-';
  final _input = TextEditingController(text: "3nle6RpFx77jwrksoNUb1Q==");

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Key Import Test'),
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Text(
                'Click the button to import the raw key.\n'
                'Output will be key in jwk form or an error message.',
              ),
              Text(
                'input',
                textScaleFactor: 1.2,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              _textEntry(),
              SizedBox(height: 50),
              Text(
                'output',
                textScaleFactor: 1.2,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('$_output'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textEntry() {
    return Row(
      children: <Widget>[
        Expanded(
          child: TextField(
            controller: _input,
            autofocus: true,
            autocorrect: false,
            enableSuggestions: false,
          ),
        ),
        IconButton(
          icon: Icon(Icons.autorenew),
          tooltip: 'import key',
          onPressed: _importRawKey,
        )
      ],
    );
  }

  Future<void> _importRawKey() async {
    final keyData = base64Decode(_input.text);
    try {
      final key = await AesGcmSecretKey.importRawKey(keyData);
      final jwk = await key.exportJsonWebKey();
      setState(() {
        _output = jsonEncode(jwk);
      });
    } catch (e, stack) {
      setState(() {
        _output = "import failed: $e \n\n $stack";
      });
    }
  }
}
