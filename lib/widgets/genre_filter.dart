import 'package:flutter/material.dart';
import '../models/book.dart';

class GenreFilter extends StatelessWidget {
  final BookGenre? selectedGenre;
  final Function(BookGenre?) onSelected;

  const GenreFilter({
    super.key,
    required this.selectedGenre,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          ChoiceChip(
            label: const Text('Բոլորը'),
            selected: selectedGenre == null,
            onSelected: (_) => onSelected(null),
          ),
          ...BookGenre.values.map((genre) {
            return Padding(
              padding: const EdgeInsets.only(left: 8),
              child: ChoiceChip(
                label: Text(genre.title),
                selected: selectedGenre == genre,
                onSelected: (_) => onSelected(genre),
              ),
            );
          }),
        ],
      ),
    );
  }
}
