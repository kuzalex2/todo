import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) =>
      const Center(child: CircularProgressIndicator());
}

class MyErrorWidget extends StatelessWidget {
  const MyErrorWidget(this.error, {super.key, this.onRetry});

  final Object error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Error: $error', style: const TextStyle(color: Colors.red)),
        IconButton(icon: const Icon(Icons.refresh), onPressed: onRetry),
      ],
    ),
  );
}
