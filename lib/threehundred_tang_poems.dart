import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/services.dart';

import 'model/poem.dart';

class ThreeHundredTangPoems extends StatelessWidget {
  const ThreeHundredTangPoems({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('唐詩三百首'),
      ),
      body: Center(
        child: FutureBuilder(
          future: loadPoems(),
          builder: (BuildContext context, AsyncSnapshot<Iterable<Poem>> snapshot) {
            if (snapshot.hasData) {
              var poems = snapshot.data!.toList();
              return ListView.builder(
                addAutomaticKeepAlives: false,
                addRepaintBoundaries: false,
                itemCount: poems.length,
                // itemExtent: 108,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      String content = poems[index].content;
                      Navigator.pop(context, content);
                    },
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
                              maxLines: 50,
                              style: Theme.of(context).textTheme.bodyLarge,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              return Center(
                child: Column(
                  children: const <Widget>[
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: CircularProgressIndicator(),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text('Awaiting result...'),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Future<Iterable<Poem>> loadPoems() async {
    var box = await Hive.openBox<Poem>('poemBox');
    if (box.isEmpty) {
      Map<dynamic, Poem> entries = {};
      await rootBundle.loadString('assets/300poems.txt').then((value) {
        final textLines = const LineSplitter().convert(value);
        for (var i = 0; i < textLines.length; i=i+4) {
          var poem = Poem(
              name: textLines[i],
              author: textLines[i+1],
              poetic: textLines[i+2],
              content: textLines[i+3]);
          entries.putIfAbsent(textLines[i], () => poem);
        }
      });
      box.putAll(entries);
    }

    return box.values;
  }
}