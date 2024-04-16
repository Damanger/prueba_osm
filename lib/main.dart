import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'carro.dart';
import 'buscar.dart';
import 'socios.dart';
import 'estad.dart';

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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title});

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
        title: const SizedBox(
          height: 30,
          child: Text(
            'UnitFinder',
            style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
        toolbarHeight: 20,
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
            : _selectedIndex == 0
            ? const CarroPage()
            : _selectedIndex == 1
            ? const BuscarPage()
            : _selectedIndex == 3
            ? const EstadPage()
            : const SociosPage(), // Mostrar texto en otras pestañas
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
    return Stack(
      children: [
        FlutterMap(
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
        ),
        Positioned(
          bottom: 16.0,
          right: 16.0,
          child: SpeedDial(
            icon: Icons.person,
            activeIcon: Icons.close,
            buttonSize: const Size(56.0, 56.0),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            overlayColor: Colors.black,
            overlayOpacity: 0.35,
            children: [
              SpeedDialChild(
                child: const Icon(Icons.edit),
                label: 'Editar',
                backgroundColor: Colors.green,
                shape: const CircleBorder(),
                onTap: () {
                  // Lógica para la opción "Editar"
                },
              ),
              SpeedDialChild(
                child: const Icon(Icons.delete),
                label: 'Eliminar',
                backgroundColor: Colors.red,
                shape: const CircleBorder(),
                onTap: () {
                  // Lógica para la opción "Eliminar"
                },
              ),
            ],
          ),
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
