import 'package:babyspark/model/book_model.dart';
import 'package:babyspark/widgets/secondary_app_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../service/firebase_book_service.dart';

class BookGridScreen extends StatefulWidget {
  const BookGridScreen({super.key});

  @override
  State<BookGridScreen> createState() => _BookGridScreenState();
}

class _BookGridScreenState extends State<BookGridScreen> {
  final FirebaseBookService _firebaseService = FirebaseBookService();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: size.height * 0.2,
          flexibleSpace: const SecondaryAppBar(title: "Alphabets"),
        ),
        body: StreamBuilder<List<BookModel>>(
          stream: _firebaseService.getBookData("alphabets_data"),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text("Error loading data"));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No alphabets found"));
            }

            final books = snapshot.data!;

            return GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: size.width > 600 ? 4 : 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.8,
              ),
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return Column(
                  children: [
                    Expanded(
                      child: CachedNetworkImage(
                        imageUrl: book.image,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      book.title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
