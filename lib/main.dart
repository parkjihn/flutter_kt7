import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dio Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _getResponse = '';
  String _postResponse = '';
  List<Post> _posts = [];

  void _fetchGetData() async {
    try {
      final response = await Dio().get('https://jsonplaceholder.typicode.com/posts');
      final List<dynamic> data = response.data;
      setState(() {
        _posts = data.map((json) => Post.fromJson(json)).toList();
        _getResponse = 'Fetched ${_posts.length} posts';
      });
    } catch (e) {
      setState(() {
        _getResponse = 'Failed to fetch data: $e';
      });
    }
  }

  void _fetchPostData() async {
    try {
      final response = await Dio().post(
        'https://jsonplaceholder.typicode.com/posts',
        data: {'title': 'Dio Example', 'body': 'This is a post request example'},
      );
      setState(() {
        _postResponse = response.data.toString();
      });
    } catch (e) {
      setState(() {
        _postResponse = 'Failed to post data: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dio Example'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _fetchGetData,
                child: const Text('Get Data'),
              ),
              const SizedBox(height: 16.0),
              Text(_getResponse),
              const SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: _fetchPostData,
                child: const Text('Post Data'),
              ),
              const SizedBox(height: 16.0),
              Text(_postResponse),
              const SizedBox(height: 32.0),
              if (_posts.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: _posts.length,
                  itemBuilder: (context, index) {
                    final post = _posts[index];
                    return ListTile(
                      title: Text(post.title),
                      subtitle: Text(post.body),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class Post {
  final int id;
  final String title;
  final String body;

  Post({required this.id, required this.title, required this.body});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}
