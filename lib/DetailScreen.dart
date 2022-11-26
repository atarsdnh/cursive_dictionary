import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'main.dart';
class DetailScreen extends StatelessWidget {
  DetailScreen({super.key});

  static const List<String> poetics = [
    '全部',
    '五言絕句',
    '七言絕句',
    '五言律詩',
    '七言律詩',
    '五言古詩',
    '七言古詩',
    '樂府',
  ];

  final List<Poem> poemList = [];
  loadAsset() async {
    var strings = [];
    await rootBundle.loadString('assets/poems.csv').then((value) {
      List<List<dynamic>> rowsAsListOfValues =
          const CsvToListConverter().convert(value);
      for (var i = 1; i < rowsAsListOfValues.length; i++) {
        List<dynamic> value = rowsAsListOfValues[i];
        value[0].toString().runes.forEach((element) {
          var character=String.fromCharCode(element);
          strings.add(character);
        });
        value[1].toString().runes.forEach((element) {
          var character=String.fromCharCode(element);
          strings.add(character);
        });
        value[2].toString().runes.forEach((element) {
          var character=String.fromCharCode(element);
          strings.add(character);
        });
        value[3].toString().runes.forEach((element) {
          var character=String.fromCharCode(element);
          strings.add(character);
        });
        if(value[3].toString().length==40){
          var poem = Poem(
              name: value[0],
              author: value[1],
              poetic: value[2],
              content: value[3]);

          poemList.add(poem);
        }
      }
    });
    // poemList.sort((a,b)=>a.content.length.compareTo(b.content.length));
    poemList.insert(0, Poem(name: 'ContentSet', author: 'null', poetic: 'null', content: strings.toSet().toList().join("")));
    // poemList.add(Poem(name: 'ContentSet', author: 'null', poetic: 'null', content: strings.toSet().toList().join("")));
    return poemList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('唐詩三百首'),
      ),
      body: FutureBuilder(
          future: loadAsset(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            List<Widget> children;
            if (snapshot.hasData) {
              List<Poem> poems = snapshot.data;
              children = <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(children: [
                    Text('作者'),Text('詩體'),Text('詩名')
                  ],),
                ),
                Expanded(
                  child: ListView.builder(
                    addAutomaticKeepAlives: false,
                    addRepaintBoundaries: false,
                    itemCount: poems.length,
                    itemExtent: 116,
                    itemBuilder: (context, index) {
                      return InkWell(
                        child: Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          style: Theme.of(context).textTheme.titleLarge,
                                          poems[index].name,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                        width: 45,
                                        child: Text(
                                          poems[index].author,
                                          style: Theme.of(context).textTheme.titleSmall,
                                        )),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                        width: 60,
                                        child: Text(
                                          poems[index].poetic,
                                          style: Theme.of(context).textTheme.titleSmall,
                                        )),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      '${poems[index].content.length}字',
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  poems[index].content,
                                  maxLines: 2,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          String content = poems[index].content;
                          Navigator.pop(context, content);
                        },
                      );
                    },
                  ),
                ),
              ];
            } else if (snapshot.hasError) {
              children = <Widget>[
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text('Error: ${snapshot.error}'),
                ),
              ];
            } else {
              children = const <Widget>[
                SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text('Awaiting result...'),
                ),
              ];
            }
            return Column(
              children: children,
            );
          }),
    );
  }
}
