import 'package:flutter/material.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> items = [
      'Item 1',
      'Item 2',
      'Item 3',
      // 'Item 4',
      // 'Item 5',
      // 'Item 6',
      // 'Item 7',
      // 'Item 8',
      // 'Item 9',
      // 'Item 10',
    ];

    final List<String> subtitles = [
      'First item details',
      'Second item details',
      'Third item details',
      // 'Fourth item details',
      // 'Fifth item details',
      // 'Sixth item details',
      // 'Seventh item details',
      // 'Eighth item details',
      // 'Ninth item details',
      // 'Tenth item details',
    ];

    final List<IconData> icons = [
      Icons.home,
      Icons.star,
      Icons.favorite,
      // Icons.settings,
      // Icons.person,
      // Icons.email,
      // Icons.phone,
      // Icons.map,
      // Icons.camera,
      // Icons.shopping_cart,
    ];

    const double rating = 4.5;

//     MaterialApp(
//   home: Scaffold(
//     appBar: AppBar(
//       title: const Text('Home'),
//     ),
//   ),
//   debugShowCheckedModeBanner: false,
// )
    return MaterialApp(
      title: 'Test Screen',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Test Screen'),
        ),
        body: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, i) {
            return ListTile(
              leading: Icon(icons[i], color: Colors.blue),
              title: Text(items[i]),
              subtitle: Text(subtitles[i]),
              trailing: Container(
                width: 50,
                child: Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(rating.toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            );
          },
          itemCount: items.length,
        ),
      ),
    );
  }
}
