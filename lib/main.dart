import 'dart:ui';

import 'package:csv/csv.dart';
import 'package:cursive_dictionary/threehundred_tang_poems.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:flutter/services.dart' show rootBundle;
import 'package:screenshot/screenshot.dart';

import 'model/poem.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Hive.registerAdapter(PoemAdapter());
  await Hive.openBox<Poem>('poemBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '草書字典',
      theme: ThemeData(
        brightness: Brightness.dark,
        /* light theme settings */
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        /* dark theme settings */
      ),
      themeMode: ThemeMode.dark,
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown
        },
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: '草書字典'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ScreenshotController screenshotController = ScreenshotController();

  final _controller = TextEditingController();
  List<String> searchStrings = [];
  String poems = '';
  List<Poem> poemList = [];
  void loadAsset() async {
    await rootBundle.loadString('assets/300poems.csv').then((value) {
      poems = value;
      List<List<dynamic>> rowsAsListOfValues =
          const CsvToListConverter().convert(poems);
      for (var i = 1; i < rowsAsListOfValues.length; i++) {
        List<dynamic> value = rowsAsListOfValues[i];
        var poem = Poem(
            name: value[0],
            author: value[1],
            poetic: value[2],
            content: value[3]);
        poemList.add(poem);
      }
    });
  }

  /// Regex of Chinese character.
  // static const String regexZh = '[\\u4e00-\\u9fa5]';

  @override
  void initState(){
    super.initState();
    // loadAsset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Screenshot(
                controller: screenshotController,
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: searchStrings.length,
                    itemExtent: 100,
                    itemBuilder: (BuildContext context, int index) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              searchStrings[index],
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                          Expanded(
                            child: FittedBox(
                              fit: BoxFit.fitHeight,
                              child: Text(searchStrings[index],
                                  style: const TextStyle(fontFamily: 'CaoShu')),
                            ),
                          ),
                          Expanded(
                              child: FittedBox(
                            fit: BoxFit.fitHeight,
                            child: Text(searchStrings[index],
                                style: const TextStyle(
                                    fontFamily: 'HYSunWanMinCaoShuW')),
                          )),
                          Expanded(
                            child: FittedBox(
                              fit: BoxFit.fitHeight,
                              child: Text(searchStrings[index],
                                  style: const TextStyle(
                                      fontFamily: 'KouzanBrushFontSousyo')),
                            ),
                          ),
                          Expanded(
                            child: FittedBox(
                              fit: BoxFit.fitHeight,
                              child: Text(searchStrings[index],
                                  style: const TextStyle(
                                      fontFamily: 'LiuJianMaoCao')),
                            ),
                          ),
                          Expanded(
                            child: FittedBox(
                              fit: BoxFit.fitHeight,
                              child: Text(searchStrings[index],
                                  style:
                                      const TextStyle(fontFamily: 'SunGuoting')),
                            ),
                          ),
                          Expanded(
                            child: FittedBox(
                              fit: BoxFit.fitHeight,
                              child: Text(searchStrings[index],
                                  style: const TextStyle(fontFamily: 'YuYouren')),
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                        ],
                      );
                    }),
              ),
            ),
            Row(
              children: [
                SizedBox(
                  width: 80,
                  child: IconButton(
                    onPressed: () {
                      _navigateAndDisplaySelection(context);
                    },
                    icon: const Icon(Icons.book),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      textInputAction: TextInputAction.search,
                      onSubmitted: (value) {
                        _onSearchClick();
                      },
                      controller: _controller,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: _controller.clear,
                          icon: const Icon(Icons.clear),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: const BorderSide(
                            color: Colors.blue,
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(15.0),
                        hintText: '輸入文字',
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 80,
                  child: IconButton(
                    onPressed: () => {_onSearchClick()},
                    icon: const Icon(Icons.search),
                  ),
                ),
                // SizedBox(
                //   width: 80,
                //   child: IconButton(
                //     onPressed: () => {_onCameraClick()},
                //     icon: const Icon(Icons.photo_camera),
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _navigateAndDisplaySelection(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ThreeHundredTangPoems()),
    );

    if (!mounted) return;

    if(result==null) return;
    _controller.text = result;
    _onSearchClick();
  }

  _onSearchClick() {
    searchStrings.clear();
    TextEditingValue value = _controller.value;
    for (int i = 0; i < value.text.length; i++) {
      searchStrings.add(value.text[i]);
    }
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {});
  }

  // _onCameraClick() {
  //   screenshotController
  //       .capture(delay: Duration(milliseconds: 10))
  //       .then((capturedImage) async {
  //     ShowCapturedWidget(context, capturedImage!);
  //   }).catchError((onError) {
  //     print(onError);
  //   });
  // }

  Future<dynamic> ShowCapturedWidget(
      BuildContext context, Uint8List capturedImage) {
    return showDialog(
      useSafeArea: false,
      context: context,
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: Text("Captured widget screenshot"),
        ),
        body: Center(
            child: capturedImage != null
                ? Image.memory(capturedImage)
                : Container()),
      ),
    );
  }

}
