import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  final List<String> items = ['Item 1', 'Item 2', 'Item 3'];

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return ExpansionTile(
              title: Text(items[index]),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(onPressed: () {}, child: Text('Button 1')),
                    ElevatedButton(onPressed: () {}, child: Text('Button 2')),
                    ElevatedButton(onPressed: () {}, child: Text('Button 3')),
                  ],
                )
              ],
              onExpansionChanged: (value) {
                // You can add your logic here to handle the expansion or collapse of the item
                print('${items[index]} is ${value ? 'expanded' : 'collapsed'}');
              },
            );
          },
        ),
      ),
    );
  }
}
