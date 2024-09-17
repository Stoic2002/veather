import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_dicoding/bloc/weather_bloc.dart';
import '../widgets/weather_display.dart';
import 'package:geolocator/geolocator.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> locations = [
    {'name': 'Jakarta', 'query': 'Jakarta'},
    {'name': 'Surabaya', 'query': 'Surabaya'},
    {'name': 'Bandung', 'query': 'Bandung'},
    {'name': 'Banjarnegara', 'query': 'Banjarnegara'},
    {'name': 'Semarang', 'query': 'Semarang'},
    {'name': 'Makassar', 'query': 'Makassar'},
    {'name': 'Palembang', 'query': 'Palembang'},
    {'name': 'Tangerang', 'query': 'Tangerang'},
    {'name': 'Depok', 'query': 'Depok'},
    {'name': 'Bekasi', 'query': 'Bekasi'},
    {'name': 'Dieng Plateau', 'query': 'Dieng Plateau,Wonosobo,Central Java'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1E88E5), Color(0xFF1565C0)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAppBar(context),
                const SizedBox(height: 20),
                _buildWeatherDisplay(),
                const SizedBox(height: 20),
                _buildPopularLocations(context),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _getCurrentLocation(context),
        child: const Icon(Icons.my_location),
        tooltip: 'Get Current Location',
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Veather',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.location_on, color: Colors.white),
              onPressed: () => _showCoordinateDialog(context),
            ),
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () => _showSearchDialog(context),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWeatherDisplay() {
    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) {
        if (state is WeatherInitial) {
          return const Center(
            child: Text(
              'Select a location to get weather information',
              style: TextStyle(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
          );
        } else if (state is WeatherLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        } else if (state is WeatherLoaded) {
          return WeatherDisplay(weather: state.weather);
        } else if (state is WeatherError) {
          return Center(
            child: Text(
              'Error: ${state.message}',
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          );
        }
        return Container();
      },
    );
  }

  Widget _buildPopularLocations(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Popular Locations',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: locations.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.white.withOpacity(0.1),
                  child: ListTile(
                    title: Text(
                      locations[index]['name'],
                      style: const TextStyle(color: Colors.white),
                    ),
                    trailing:
                        const Icon(Icons.chevron_right, color: Colors.white70),
                    onTap: () {
                      context
                          .read<WeatherBloc>()
                          .add(FetchWeather(locations[index]['query']));
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Search City'),
          content: TextField(
            decoration: InputDecoration(
              hintText: 'Enter city name',
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
            onSubmitted: (String value) {
              context.read<WeatherBloc>().add(FetchWeather(value));
              Navigator.of(context).pop();
            },
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: const Text('Search'),
              onPressed: () {
                // Implement search functionality
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showCoordinateDialog(BuildContext context) {
    String latitude = '';
    String longitude = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Coordinates'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Latitude',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onChanged: (value) => latitude = value,
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Longitude',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onChanged: (value) => longitude = value,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: const Text('Search'),
              onPressed: () {
                if (latitude.isNotEmpty && longitude.isNotEmpty) {
                  context
                      .read<WeatherBloc>()
                      .add(FetchWeather('$latitude,$longitude'));
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _getCurrentLocation(BuildContext context) async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return Future.error('Location services are disabled.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      Position position = await Geolocator.getCurrentPosition();
      context
          .read<WeatherBloc>()
          .add(FetchWeather('${position.latitude},${position.longitude}'));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error getting location: $e')),
      );
    }
  }
}
