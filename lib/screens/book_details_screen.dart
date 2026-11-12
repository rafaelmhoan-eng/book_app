import 'package:flutter/material.dart';
import '../models/book.dart';

class BookDetailsScreen extends StatefulWidget {
  final Book book;

  const BookDetailsScreen({super.key, required this.book});

  @override
  State<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  late int rating;

  @override
  void initState() {
    super.initState();
    rating = widget.book.rating ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final book = widget.book;

    return Scaffold(
      appBar: AppBar(title: const Text('Գրքի մանրամասներ')),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            const SizedBox(height: 30),

            const Icon(
              Icons.menu_book,
              size: 100,
              color: Color.fromARGB(255, 182, 156, 226),
            ),

            const SizedBox(height: 20),

            Text(
              book.title,
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 10),

            Text(book.author, style: const TextStyle(fontSize: 18)),

            const SizedBox(height: 15),

            Chip(label: Text(book.genre.title)),

            const SizedBox(height: 50),

            const Text(
              'Գնահատական',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,

              children: List.generate(5, (index) {
                return IconButton(
                  onPressed: () {
                    setState(() {
                      rating = index + 1;
                    });
                  },

                  icon: Icon(
                    index < rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 38,
                  ),
                );
              }),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,

              child: ElevatedButton(
                onPressed: rating == 0
                    ? null
                    : () {
                        Navigator.pop(context, rating);
                      },

                child: const Text('Պահպանել', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
