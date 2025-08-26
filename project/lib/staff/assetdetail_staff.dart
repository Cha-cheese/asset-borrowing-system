import 'dart:io';
import 'package:flutter/material.dart';
import 'package:project/models/product.dart';

class Detailstaff extends StatelessWidget {
  final Product product;

  Detailstaff({required this.product});

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Available':
        return const Color(0xFF00BF63); // Color for Available
      case 'Pending':
        return const Color.fromARGB(255, 10, 130, 228);
      case 'Borrowed':
        return const Color(0xFFE4B90A); // Color for Borrowed
      case 'Disable':
        return const Color(0xFF68737B); // Color for Disable
      default:
        return Colors.black; // Default color
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD8EDFF),
      appBar: AppBar(
        title: Text(
          product.title,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF273948),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageWidget(product.image),
            const SizedBox(height: 20),
            Text(
              product.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('ID Book : ${product.id}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text('Status : ', style: TextStyle(fontSize: 16)),
                Text(
                  product.status,
                  style: TextStyle(
                    color: _getStatusColor(product.status),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text('Description : ${product.description}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text('Author : ${product.author}',
                style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildImageWidget(String imagePath) {
    return imagePath.startsWith('assets/')
        ? Image.asset(
            imagePath,
            width: double.infinity,
            height: 200,
            fit: BoxFit.contain,
          )
        : Image.file(
            File(imagePath),
            width: double.infinity,
            height: 200,
            fit: BoxFit.contain,
          );
  }
}
