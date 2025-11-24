import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubits/dog_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ЛР6: Dog API',
      theme: ThemeData(primarySwatch: Colors.brown),
      home: BlocProvider(
        create: (_) => DogCubit()..loadImages(),
        child: const DogGalleryPage(),
      ),
    );
  }
}

class DogGalleryPage extends StatelessWidget {
  const DogGalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Собаки с API (Sol 100 analog)')),
      body: BlocBuilder<DogCubit, DogState>(
        builder: (context, state) {
          if (state is DogLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is DogLoaded) {
            return ListView.builder(
              itemCount: state.imageUrls.length,
              itemBuilder: (context, index) {
                final url = state.imageUrls[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Image.network(
                        url,
                        height: 200,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(child: CircularProgressIndicator());
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const SizedBox(
                            height: 200,
                            child: Center(child: Text('⚠️ Не загрузилось')),
                          );
                        },
                      ),
                      ListTile(
                        title: Text('Изображение #${index + 1}'),
                        subtitle: Text(url.split('/').last),
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (state is DogError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.pets, size: 48),
                  const SizedBox(height: 16),
                  Text('Ошибка: ${state.message}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<DogCubit>().loadImages(),
                    child: const Text('Попробовать снова'),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('Старт...'));
          }
        },
      ),
    );
  }
}