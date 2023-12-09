import 'package:flutter/material.dart';
import 'package:responsi_124210010/meals_page.dart';
import 'package:responsi_124210010/api_data_source.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  // get data from API
  Future<Map<String, dynamic>>? _data;

  @override
  void initState() {
    super.initState();
    _data = ApiDataSource.instance.loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'Meal Categories',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.brown),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _data,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!['categories'];
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MealsPage(
                          category: data[index]['strCategory'],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.brown.shade50),
                    child: Column(
                      children: [
                        Image.network(data[index]['strCategoryThumb']),
                        SizedBox(height: 10),
                        Text(
                          data[index]['strCategory'],
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text(data[index]['strCategoryDescription'])
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
