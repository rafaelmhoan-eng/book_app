import 'package:flutter/material.dart';
import '../models/book.dart';
import 'star_rating.dart';

class BookTile extends StatelessWidget {
  final Book book;
  final ValueChanged<bool?> onChanged;
  final VoidCallback onTap;

  const BookTile({
    super.key,
    required this.book,
    required this.onChanged,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

      child: ListTile(
        onTap: onTap,

        leading: Checkbox(
          value: book.isRead,
          onChanged: onChanged,
          activeColor: Colors.deepPurple,
        ),

        title: Text(
          book.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            decoration: book.isRead
                ? TextDecoration.lineThrough
                : TextDecoration.none,
          ),
        ),

        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(book.author),

            const SizedBox(height: 5),

            Text(
              book.genre.label,
              style: const TextStyle(color: Colors.deepPurple, fontSize: 12),
            ),
          ],
        ),

        trailing: book.rating != null
            ? StarRating(rating: book.rating!, size: 16)
            : const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}
