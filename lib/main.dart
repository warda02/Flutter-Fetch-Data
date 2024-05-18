import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unsplash Image Generator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> _imageUrls = [];
  List<int> _imageHeights = [];
  List<int> _imageWidths = [];

  Future<void> _fetchRandomPhotos(int count) async {
    final String accessKey = 'j4kSi5afLMnSMng06A2cS5qsnIitd0cbygf8felTvDo'; // Replace with your Unsplash access key
    final String apiUrl = 'https://api.unsplash.com/photos/random?client_id=$accessKey&count=$count';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        List<String> urls = [];
        List<int> heights = [];
        List<int> widths = [];
        for (var photo in data) {
          urls.add(photo['urls']['regular']);
          heights.add(photo['height']);
          widths.add(photo['width']);
        }
        setState(() {
          _imageUrls = urls;
          _imageHeights = heights;
          _imageWidths = widths;
        });
      } else {
        print('Failed to fetch photos: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching photos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Unsplash Image Generator'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_imageUrls.isNotEmpty)
                Column(
                  children: List.generate(
                    _imageUrls.length,
                        (index) => Column(
                      children: [
                        Image.network(_imageUrls[index]),
                        SizedBox(height: 10),
                        Text('Height: ${_imageHeights[index]}'),
                        Text('Width: ${_imageWidths[index]}'),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                )
              else
                const Text('Press the button to generate images'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _fetchRandomPhotos(3), // Fetch 3 images, you can change this count as needed
                child: const Text('Generate Images'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
