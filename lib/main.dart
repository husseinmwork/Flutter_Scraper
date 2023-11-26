import 'package:flutter/material.dart';
import 'package:flutter_application_scraping/models/package_model.dart';
import 'package:flutter_application_scraping/services/http_service.dart';
import 'package:flutter_application_scraping/services/scraper_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  List<PackageModel> list = [];
  bool loading = false;

  Future getPackages() async {
    list.clear();
    setState(() {
      loading = true;
    });
    final html = await HttpService.get();
    if (html != null) {
      list = ScraperService.run(html);
    }

    loading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        title: const Text("pub.dev"),
      ),
      body: list.isEmpty
          ? const Center(
              child: Text("Pressed Button" , style: TextStyle(fontSize: 25),),
            )
          : ListView.separated(
              itemCount: list.length,
              separatorBuilder: (context, index) =>
                  const Divider(indent: 8, endIndent: 8),
              itemBuilder: (context, index) => ListTile(
                onTap: () {},
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        list[index].title,
                        style:
                            const TextStyle(color: Colors.green, fontSize: 20),
                      ),
                    ),
                    Text('Likes : ${list[index].likes}')
                  ],
                ),
                subtitle: Column(
                  children: [
                    Text(
                      list[index].description,
                      style: const TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      children: list[index]
                          .tags
                          .map((e) =>
                              OutlinedButton(onPressed: () {}, child: Text(e)))
                          .toList(),
                    )
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await getPackages();
          },
          tooltip: 'Increment',
          child: loading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : const Icon(Icons
                  .get_app_outlined)), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
