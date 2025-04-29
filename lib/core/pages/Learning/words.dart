import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WordsPage extends StatefulWidget {
  const WordsPage({super.key});

  @override
  State<WordsPage> createState() => _WordsPageState();
}

class _WordsPageState extends State<WordsPage> {
  @override
  void initState() {
    getData();
    super.initState();
  }

  Future getData() async {
    var url = Uri.https('dog.ceo', '/api/breeds/image/random');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var dog = jsonDecode(response.body);
      var dogPhoto = dog['message'];
      print(dogPhoto);
      return dogPhoto;
    }
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("Words"),
        transitionBetweenRoutes: true,
        previousPageTitle: "Back",
      ),
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FutureBuilder(
                future: getData(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CupertinoActivityIndicator();
                  }
                  if (snapshot.hasData) {
                    var photo = snapshot.data;
                    return Image.network(photo);
                  } else {
                    return Center(child: Text("Error"));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
