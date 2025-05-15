import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_traslate_pdf/ui/folder_picker.dart';
import 'package:path_provider/path_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _pathController = TextEditingController();
  TextEditingController _nameSavingController = TextEditingController();
  TextEditingController _fromPage = TextEditingController();
  TextEditingController _toPage = TextEditingController();
  String? selectedLanguage1;
  String? selectedLanguage2;
  String output = '';
  bool running = false;
  String? path;
  bool allPage = true;
  bool isHovered = false;
  bool isEnabled = false;
  double progress = 0.0;

  @override
  void initState() {
    super.initState();

    // Aggiungi listener ai controller
    _pathController.addListener(_updateButtonState);
    _nameSavingController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _pathController.dispose();
    _nameSavingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/logo.png'))),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 400,
                            height: 60,
                            child: TextField(
                              controller: _pathController,
                              decoration: InputDecoration(
                                label: Text('Seleziona Percorso file'),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    pickPdfAndRunScript(_pathController);
                                  },
                                  icon: Icon(Icons.file_upload),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                focusColor: Colors.white,
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 1.0),
                                    borderRadius: BorderRadius.circular(10)),
                                hintText: 'Seleziona Percorso file',
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                        ],
                        // children: [TextField()],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: 400,
                        height: 50,
                        child: TextField(
                          controller: _nameSavingController,
                          decoration: InputDecoration(
                            label: Text('Inserisci nome salvataggio file'),
                            filled: true,
                            fillColor: Colors.white,
                            focusColor: Colors.white,
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.black, width: 1.0),
                                borderRadius: BorderRadius.circular(10)),
                            hintText: 'Inserisci nome salvataggio file',
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: 400,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Traduci tutte le pagine',
                              style: TextStyle(fontSize: 18),
                            ),
                            Checkbox(
                                value: allPage,
                                onChanged: (value) {
                                  setState(() {
                                    allPage = value!;
                                  });
                                }),
                          ],
                        ),
                      ),
                      if (!allPage)
                        SizedBox(
                          width: 400,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('Da pagina:'),
                              SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                width: 40,
                                height: 40,
                                child: TextField(
                                  controller: _fromPage,
                                  textAlign: TextAlign.center,
                                  textAlignVertical: TextAlignVertical.bottom,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    focusColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 1.0),
                                    ),
                                    hintText: '0',
                                    hintStyle: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text('a pagina:'),
                              SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                width: 60,
                                height: 40,
                                child: TextField(
                                  textAlign: TextAlign.center,
                                  textAlignVertical: TextAlignVertical.bottom,
                                  controller: _toPage,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    focusColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 1.0),
                                    ),
                                    hintText: '9',
                                    hintStyle: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      LanguageSelectionPage(
                        onSelected1: (value) {
                          selectedLanguage1 = value;
                        },
                        onSelected2: (value) {
                          selectedLanguage2 = value;
                          _updateButtonState();
                        },
                      ),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        onEnter: (_) => setState(() => isHovered = true),
                        onExit: (_) => setState(() => isHovered = false),
                        child: GestureDetector(
                          onTap: () async {
                            await runTranslateScript(
                                selectedLanguage1!, selectedLanguage2!);
                          },
                          child: Padding(
                            padding: EdgeInsets.only(top: 30.0),
                            child: Container(
                              height: 50,
                              width: 150,
                              child: Center(
                                child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: isEnabled
                                            ? (isHovered
                                                ? Colors.blueAccent
                                                : Color(0xFF1877f2))
                                            : Colors.grey,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Text(
                                      'Inizia Conversione',
                                      style: TextStyle(color: Colors.white),
                                    )),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: SizedBox(
                            height: 10,
                            width: 300,
                            child: LinearProgressIndicator(
                              value: progress,
                              backgroundColor: Colors.grey[200],
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(30),
                            )),
                      ),
                      Text(
                        '${(progress * 100).toStringAsFixed(1)}% Completato',
                        style: TextStyle(fontSize: 16),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Text(
                          '*Troverai il tuo file nella cartella download',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _updateButtonState() {
    setState(() {
      isEnabled = enableButton();
    });
  }

  bool enableButton() {
    return _pathController.text.isNotEmpty &&
        _nameSavingController.text.isNotEmpty &&
        (selectedLanguage1?.isNotEmpty ?? false) &&
        (selectedLanguage2?.isNotEmpty ?? false);
  }

  Future<void> pickPdfAndRunScript(TextEditingController pathController) async {
    // Apri il file picker per selezionare solo PDF
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result == null || result.files.isEmpty) {
      print('Nessun file selezionato');
      return;
    }

    // Prendi il percorso del file selezionato
    final inputPdfPath = result.files.single.path;
    if (inputPdfPath == null) {
      print('Errore: percorso file nullo');
      return;
    }

    print('File selezionato: $inputPdfPath');
    setState(() {
      pathController.text = inputPdfPath;
      path = inputPdfPath;
    });

    // await runTranslateScript(inputPdfPath);
  }

  Future<void> runTranslateScript(
      String inputLanguage, String languageTarget) async {
    try {
      final tempDir = await getTemporaryDirectory();

      // 1) Estrai script Python
      final scriptData =
          await rootBundle.load('assets/python/translate_pdf.py');
      final scriptFile = File('${tempDir.path}/translate_pdf.py');
      await scriptFile.writeAsBytes(scriptData.buffer.asUint8List());

      // 2) Estrai font
      final fontData = await rootBundle.load('assets/fonts/FreeSerif.ttf');
      final fontFile = File('${tempDir.path}/FreeSerif.ttf');
      await fontFile.writeAsBytes(fontData.buffer.asUint8List());

      // Controlla se il file inserito esiste
      final inputPdfFile = File(path!);
      if (!(await inputPdfFile.exists())) {
        print('Errore: file PDF di input non trovato a $path');
        return;
      }

      // // 3) Copia PDF di input dagli asset nella cartella temporanea
      // final pdfData = await rootBundle.load('assets/python/libro_cam.pdf');
      // final inputPdfFile = File('${tempDir.path}/libro_cam.pdf');
      // await inputPdfFile.writeAsBytes(pdfData.buffer.asUint8List());

      // 4) Controlla se il file è stato copiato correttamente
      final inputPdfPath = inputPdfFile.path;
      final fileExists = await inputPdfFile.exists();
      print('File PDF di input esiste? $fileExists, path: $inputPdfPath');
      if (!fileExists) {
        print('Errore: file PDF di input non trovato. Interrompo.');
        return;
      }

      final outputPdfPath = '${tempDir.path}/output.pdf';

      // 5) Parametri python
      final pythonPath = '/usr/bin/python3'; // Cambia se serve
      final pages = allPage == true
          ? ''
          : generatePagesRange(_fromPage.text, _toPage.text);
      final fontPath = fontFile.path;

      // 6) Avvia processo python
      final process = await Process.start(
        pythonPath,
        [
          scriptFile.path,
          inputPdfPath,
          outputPdfPath,
          inputLanguage, // 3° parametro: lingua originale
          languageTarget, // 4° parametro: lingua traduzione
          pages, // 5° parametro: pagine da tradurre
          fontPath, // 6° parametro: font path
        ],
      );

      // 7) Leggi stdout e stderr in parallelo
      process.stdout
          .transform(utf8.decoder)
          .transform(LineSplitter())
          .listen((line) {
        if (line.startsWith('PAGE_PROGRESS')) {
          final parts = line.split(' ')[1].split('/');
          final currentPage = int.parse(parts[0]);
          final totalPages = int.parse(parts[1]);
          setState(() {
            progress = currentPage / totalPages;
            // progressText = 'Traduzione pagina $currentPage di $totalPages';
          });
        } else {
          print('PYTHON STDOUT: $line');
        }
      });

      process.stderr
          .transform(utf8.decoder)
          .transform(LineSplitter())
          .listen((line) => print('PYTHON STDERR: $line'));

      // 8) Attendi terminazione
      final exitCode = await process.exitCode;
      print('Python script exited with code $exitCode');
      print('Output PDF dovrebbe essere in: $outputPdfPath');
      final tempOutputPath = '${tempDir.path}/output.pdf';
      await copyOutputPdfToDownloads(
          tempOutputPath, '${_nameSavingController.text}.pdf');
    } catch (e) {
      print('Errore durante l\'esecuzione dello script Python: $e');
    }
  }
}

Future<bool> copyOutputPdfToDownloads(
    String tempOutputPath, String desiredFileName) async {
  try {
    final downloadsDir = await getDownloadsDirectory();
    if (downloadsDir == null) {
      print('Impossibile trovare la cartella Download.');
      return false;
    }

    final outputFile = File(tempOutputPath);
    if (!await outputFile.exists()) {
      print('File di output non esiste: $tempOutputPath');
      return false;
    }

    final destinationPath = '${downloadsDir.path}/$desiredFileName';
    final destinationFile = File(destinationPath);

    // Copia il file nella cartella Download
    await outputFile.copy(destinationPath);
    print('File copiato in: $destinationPath');
    return true;
  } catch (e) {
    print('Errore nel copiare il file in Downloads: $e');
    return false;
  }
}

String generatePagesRange(String start, String end) {
  if (int.parse(start) > int.parse(end)) {
    throw ArgumentError(
        'Il numero di inizio deve essere minore o uguale al numero di fine.');
  }
  return List.generate(int.parse(end) - int.parse(start) + 1,
      (index) => int.parse(start) + index).join(',');
}
