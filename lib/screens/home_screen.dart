import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../model/movie.dart';
import '../service/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController c = TextEditingController();
  final ApiService api = ApiService();

  Movie? movie;
  bool isLoading = false;
  String errorText = '';

  Future<void> searchMovie() async {
    if (c.text.trim().isEmpty) {
      setState(() {
        errorText = 'Фильм атауын енгізіңіз';
        movie = null;
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorText = '';
    });

    try {
      final result = await api.fetchMovie(c.text.trim());
      setState(() {
        movie = result;
        if (result == null) {
          errorText = 'Фильм табылмады';
        }
      });
    } catch (e) {
      setState(() {
        errorText = 'Қате шықты: $e';
        movie = null;
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  Widget info(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  @override
  void dispose() {
    c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Info App'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: c,
              decoration: InputDecoration(
                hintText: 'Фильм атауын жазыңыз',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: IconButton(
                  onPressed: searchMovie,
                  icon: const Icon(Icons.search),
                ),
              ),
              onSubmitted: (_) => searchMovie(),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: searchMovie,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Іздеу',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (isLoading) const CircularProgressIndicator(),
            if (errorText.isNotEmpty)
              Text(
                errorText,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            if (movie != null)
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: CachedNetworkImage(
                          imageUrl: movie!.poster,
                          height: 300,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.broken_image, size: 100),
                        ),
                      ),
                      const SizedBox(height: 16),
                      info('Атауы', movie!.title),
                      info('Жылы', movie!.year),
                      info('Жанры', movie!.genre),
                      info('IMDb рейтингі', movie!.imdbRating),
                      info('Режиссер', movie!.director),
                      info('Актерлер', movie!.actors),
                      info('Сипаттамасы', movie!.plot),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
