import 'package:flutter/material.dart';

import '../models/book.dart';
import '../data/books_data.dart';
import '../widgets/book_tile.dart';
import '../widgets/genre_filter.dart';
import 'book_details_screen.dart';

class BooksScreen extends StatefulWidget {
  const BooksScreen({super.key});

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  List<Book> books = List.from(initialBooks);

  String searchText = '';
  BookGenre? selectedGenre;

  final TextEditingController searchController = TextEditingController();

  // Որոնում և ֆիլտրում
  List<Book> get filteredBooks {
    return books.where((book) {
      final matchesSearch =
          book.title.toLowerCase().contains(searchText.toLowerCase()) ||
          book.author.toLowerCase().contains(searchText.toLowerCase());

      final matchesGenre = selectedGenre == null || book.genre == selectedGenre;

      return matchesSearch && matchesGenre;
    }).toList();
  }

  // Կարդացված գրքերի քանակ
  int get readCount {
    return books.where((book) => book.isRead).length;
  }

  // Checkbox
  void toggleRead(Book book, bool? value) {
    final index = books.indexWhere((item) => item.id == book.id);

    if (index == -1) return;

    setState(() {
      books[index] = books[index].copyWith(isRead: value ?? false);
    });
  }

  // Գրքի մանրամասների էջ
  Future<void> openDetails(Book book) async {
    final result = await Navigator.push<int>(
      context,
      MaterialPageRoute(
        builder: (context) {
          return BookDetailsScreen(book: book);
        },
      ),
    );

    if (!mounted) return;

    if (result != null) {
      setState(() {
        final index = books.indexWhere((item) => item.id == book.id);

        if (index != -1) {
          books[index] = books[index].copyWith(rating: result, isRead: true);
        }
      });
    }
  }

  // Ջնջել գիրքը
  void deleteBook(Book book) {
    final index = books.indexOf(book);

    if (index == -1) return;

    setState(() {
      books.removeAt(index);
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${book.title} ջնջվեց'),

        action: SnackBarAction(
          label: 'Վերականգնել',

          onPressed: () {
            setState(() {
              final restoreIndex = index > books.length ? books.length : index;

              books.insert(restoreIndex, book);
            });
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final displayedBooks = filteredBooks;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '📚 Իմ գրքերը',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),

            child: Center(
              child: Text(
                'Կարդացված՝ $readCount',
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),
        ],
      ),

      body: Column(
        children: [
          // Որոնման դաշտ
          Padding(
            padding: const EdgeInsets.all(12),

            child: TextField(
              controller: searchController,

              decoration: InputDecoration(
                hintText: 'Որոնել գիրք կամ հեղինակ...',

                prefixIcon: const Icon(Icons.search),

                suffixIcon: IconButton(
                  icon: const Icon(Icons.close),

                  onPressed: () {
                    searchController.clear();

                    setState(() {
                      searchText = '';
                    });
                  },
                ),

                filled: true,
                fillColor: Colors.white,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),

              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
            ),
          ),

          // Ժանրերի ֆիլտր
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),

            child: GenreFilter(
              selectedGenre: selectedGenre,

              onSelected: (genre) {
                setState(() {
                  selectedGenre = genre;
                });
              },
            ),
          ),

          const SizedBox(height: 8),

          // Գրքերի ցուցակ
          Expanded(
            child: displayedBooks.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        Icon(Icons.menu_book, size: 65, color: Colors.grey),

                        SizedBox(height: 12),

                        Text(
                          'Գիրք չի գտնվել',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.only(bottom: 12),

                    itemCount: displayedBooks.length,

                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 2);
                    },

                    itemBuilder: (context, index) {
                      final book = displayedBooks[index];

                      return Dismissible(
                        key: ValueKey(book.id),

                        direction: DismissDirection.endToStart,

                        background: Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 5,
                          ),

                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),

                          alignment: Alignment.centerRight,

                          padding: const EdgeInsets.only(right: 20),

                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),

                        onDismissed: (direction) {
                          deleteBook(book);
                        },

                        child: BookTile(
                          book: book,

                          onChanged: (value) {
                            toggleRead(book, value);
                          },

                          onTap: () {
                            openDetails(book);
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
}
