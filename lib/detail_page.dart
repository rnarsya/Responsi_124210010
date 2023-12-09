import 'package:flutter/material.dart';
import 'package:responsi_124210010/api_data_source.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailPage extends StatefulWidget {
  final id;

  const DetailPage({super.key, required this.id});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Future<Map<String, dynamic>>? _data;

  @override
  void initState() {
    super.initState();
    _data = ApiDataSource.instance.loadDetail(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _data,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!['meals'][0];
          return Scaffold(
            appBar: AppBar(
                title: Text(
                  data['strMeal'],
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.brown),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Image.network(data['strMealThumb']),
                  SizedBox(height: 30),
                  Text(
                    data['strMeal'],
                    style: const TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Category : " + data['strCategory']),
                      SizedBox(width: 75),
                      Text("Area : " + data['strArea']),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Ingredients
                  Text(
                    "Ingredients",
                    style: const TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 10),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 20,
                    itemBuilder: (context, index) {
                      if (data['strIngredient' + (index + 1).toString()] !=
                          "") {
                        return Row(
                          children: [
                            Text(
                              data['strIngredient' + (index + 1).toString()] +
                                  " : ",
                              style: const TextStyle(fontSize: 15),
                            ),
                            Text(
                              data['strMeasure' + (index + 1).toString()],
                              style: const TextStyle(fontSize: 15),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                  SizedBox(height: 10),
                  // Instructions
                  Text(
                    "Instructions",
                    style: const TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 10),
                  Text(
                    data['strInstructions'],
                    style: const TextStyle(fontSize: 15),
                  ),
                  SizedBox(height: 10),
                  // Launch Url
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.brown,
                      onPrimary: Colors.white,
                    ),
                    onPressed: () {
                      //  Launch URL
                      _launchUrl(data['strYoutube']);
                    },
                    child: const Text('Watch Tutorial'),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Future<void> _launchUrl(String link) async {
    final Uri uri = Uri.parse(link);
    if (!await launchUrl(uri)) {
      throw Exception("gagal buka link : $uri");
    }
  }
}
