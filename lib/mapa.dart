import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  LatLng? userLocation;
  int _selectedIndex = 2; // Inicia en la pestaña de Mapa

  Future<void> determineAndSetPosition() async {
    final Position position = await determinePosition();
    setState(() {
      userLocation = LatLng(position.latitude, position.longitude);
    });
  }

  Future<Position> determinePosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw 'error';
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Open Street Map',
          style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Center(
        child: _selectedIndex == 2 // Mostrar botón solo en la pestaña de Mapa
            ? (userLocation == null
            ? ElevatedButton(
          onPressed: () {
            determineAndSetPosition();
          },
          child: const Text('Activar localización'),
        )
            : content())
            : Text(_selectedIndex == 0
            ? 'Estás en la pestaña Carro'
            : (_selectedIndex == 1
            ? 'Estás en la pestaña Buscar'
            : (_selectedIndex == 3 ? 'Estás en la pestaña Estadísticas' : 'Estás en la pestaña Socios'))), // Mostrar texto en otras pestañas
      ),
      bottomNavigationBar: Container(
        color: Colors.blue,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
          child: GNav(
            backgroundColor: Colors.blue,
            color: Colors.white,
            activeColor: Colors.black,
            tabBackgroundColor: Colors.white,
            padding: const EdgeInsets.all(18),
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            tabs: const [
              GButton(icon: Icons.drive_eta_outlined, text: 'Carro'),
              GButton(icon: Icons.search, text: 'Buscar'),
              GButton(icon: Icons.location_pin, text: 'Mapa'),
              GButton(icon: Icons.auto_graph, text: 'Estadísticas'),
              GButton(icon: Icons.store, text: 'Socios')
            ],
          ),
        ),
      ),
    );
  }

  Widget content() {
    return FlutterMap(
      options: MapOptions(
        initialCenter: userLocation!,
        initialZoom: 10,
        maxZoom: 20,
        minZoom: 1,
        interactionOptions: const InteractionOptions(flags: ~InteractiveFlag.doubleTapDragZoom),
      ),
      children: [
        openStreetMapTileLayer,
        MarkerLayer(
          markers: [
            Marker(
              point: userLocation!,
              width: 60,
              height: 60,
              alignment: Alignment.centerLeft,
              child: const Icon(
                Icons.person_pin_circle_sharp,
                size: 60,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

TileLayer get openStreetMapTileLayer => TileLayer(
  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
  userAgentPackageName: 'dev.fleaflet.flutter_map.example',
  subdomains: const ['a', 'b', 'c'],
);
