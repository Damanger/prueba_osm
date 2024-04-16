import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Lista de carros'),
        ),
        body: const CarroPage(),
      ),
    );
  }
}

class CarroPage extends StatelessWidget {
  const CarroPage({Key? key});

  @override
  Widget build(BuildContext context) {
    // Sample data for three lists
    List<List<String>> listsData = [
      ['Carro 1', 'Carro 2', 'Carro 3'],
      ['Carro A', 'Carro B', 'Carro C', 'Carro D'],
      ['Carro X', 'Carro Y', 'Carro Z'],
      ['Carro P', 'Carro Q', 'Carro R'],
      ['Carro M', 'Carro N', 'Carro O'],
    ];

    // Scroll controller
    ScrollController _scrollController = ScrollController();

    return ListView.builder(
      itemCount: listsData.length,
      controller: _scrollController,
      itemBuilder: (context, index) {
        return Column(
          children: [
            for (var item in listsData[index])
              Column(
                children: [
                  Image.asset('assets/car.png', width: 200, height: 200),
                  CarroCard(item: item),
                ],
              ),
          ],
        );
      },
    );
  }
}

class CarroCard extends StatelessWidget {
  final String item;

  const CarroCard({Key? key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          ListTile(
            title: Text(item),
          ),
        ],
      ),
    );
  }
}
