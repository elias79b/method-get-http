import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<TransactionDetails>> fetchAlbum() async {
    final response = await http.get(Uri.parse(
        'https://jsonplaceholder.typicode.com/posts'));
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      final List result = json.decode(response.body);
      return result.map((e) => TransactionDetails.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load data');
    }

  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: Scaffold(
          body: Container(
              child: FutureBuilder<List<TransactionDetails>>(
                future: fetchAlbum(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(snapshot.data![index].id.toString()),
                          trailing:
                          Text(snapshot.data![index].title.toString()),
                          subtitle: Text(snapshot.data![index].body.toString()
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  return const CircularProgressIndicator();
                },
              ),),
        ));
  }
}

class TransactionDetails {
  int? userId;
  int? id;
  String? title;
  String? body;

  TransactionDetails({
    this.userId,
    this.id,
    this.title,
    this.body,
  });

  TransactionDetails.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    id = json['id'];
    title = json['title'];
    body = json['body'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['id'] = id;
    data['title'] = title;
    data['body'] = body;
    return data;
  }
}
