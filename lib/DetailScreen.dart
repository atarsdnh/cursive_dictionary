import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'model/poem.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

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

  loadAsset() async {
    List<Poem> poemList = [];
    await rootBundle.loadString('poems/300poems.csv').then((value) {
      List<List<dynamic>> rowsAsListOfValues =
          const CsvToListConverter().convert(value);
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
                Expanded(
                  child: ListView.builder(
                    itemCount: poems.length,
                    itemExtent: 100,
                    itemBuilder: (context, index) {
                      return InkWell(
                        child: Card(
                          child: Row(
                            children: [
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
                              Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      poems[index].name,
                                    ),
                                  )),
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
