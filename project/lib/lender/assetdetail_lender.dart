import 'dart:io';
import 'package:flutter/material.dart';
import 'package:project/models/product.dart';

class Detaillender extends StatelessWidget {
  final Product product;

  Detaillender({required this.product});

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
      backgroundColor: Color(0xFFD8EDFF), // เปลี่ยนสีพื้นหลังของ Scaffold
      appBar: AppBar(
        title: Text(
          product.title,
          style: TextStyle(color: Colors.white), // กำหนดสีตัวหนังสือเป็นสีขาว
        ),
        backgroundColor: Color(0xFF273948), // สีของ AppBar
        iconTheme: IconThemeData(color: Colors.white), // กำหนดสีของไอคอนใน AppBar
      ),
      body: SingleChildScrollView(
        // ใช้ SingleChildScrollView เพื่อให้สามารถเลื่อนได้
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageWidget(product.image),
            const SizedBox(height: 20),
            SizedBox(height: 20),
            Text('${product.title}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('ID Book : ${product.id}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Row(
              children: [
                Text(
                  'Status : ',
                  style: TextStyle(fontSize: 16), // ขนาดปกติ
                ),
                Text(
                  product.status,
                  style: TextStyle(
                      color: _getStatusColor(product.status),
                      fontSize: 16), // สีของสถานะ
                ),
              ],
            ),
            SizedBox(height: 10),
            Text('Description : ${product.description}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Author : ${product.author}', style: TextStyle(fontSize: 16)),
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
