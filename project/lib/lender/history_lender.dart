import 'package:flutter/material.dart';
import 'package:project/models/info_lender.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  String appBarTitle = 'Book List';
  String searchQuery = ''; // ตัวแปรเก็บข้อความค้นหา

  // ข้อมูลหนังสือจาก Info.dart
  List<Map<String, String>> books = Info.books;

  // ข้อมูลหนังสือที่ฟิลเตอร์แล้ว
  List<Map<String, String>> filteredBooks = [];

  @override
  void initState() {
    super.initState();
    // เริ่มต้นด้วยการแสดงหนังสือทั้งหมด
    filteredBooks = books;
  }

  // ฟังก์ชันสำหรับการค้นหา
  void _filterBooks(String query) {
    setState(() {
      searchQuery = query;
      filteredBooks = books
          .where((book) =>
              book['title']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  // ฟังก์ชันสำหรับเลือกสีของสถานะ
  Color _getStatusColor(String status) {
    if (status.toLowerCase() == 'approved') {
      return Colors.green; // สีเขียวสำหรับ Approved
    } else if (status.toLowerCase() == 'rejected') {
      return Colors.red; // สีแดงสำหรับ Rejected
    } else {
      return Colors.black; // สีดำสำหรับสถานะอื่นๆ
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color.fromARGB(255, 216, 237, 255),
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
          child: Column(
            children: [
              // ใช้ SearchBar สำหรับการค้นหา
              SearchBar(onSearch: _filterBooks),
              const SizedBox(
                  height: 16.0), // เพิ่มช่องว่างระหว่าง SearchBar และ ListView
              Expanded(
                child: filteredBooks.isEmpty
                    ? const Center(
                        child: Text(
                          'No results found',
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredBooks.length,
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  Image.asset(
                                    filteredBooks[index]['image']!,
                                    width: 100,
                                    height: 120,
                                  ),
                                  const SizedBox(width: 16.0),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        filteredBooks[index]['title']!,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                          'Borrowed Date: ${filteredBooks[index]['borrowedDate']}'),
                                      Text(
                                          'Date Due: ${filteredBooks[index]['dueDate']}'),
                                      Text(
                                          'Username: ${filteredBooks[index]['username']}'),
                                      Row(
                                        children: [
                                          const Text('Status: ',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black)),
                                          Text(
                                            filteredBooks[index]['status']!,
                                            style: TextStyle(
                                              color: _getStatusColor(
                                                  filteredBooks[index]
                                                      ['status']!),
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// คลาส SearchBar สำหรับกล่องค้นหา
class SearchBar extends StatelessWidget {
  final Function(String) onSearch;

  const SearchBar({required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        onChanged: onSearch,
        decoration: InputDecoration(
          hintText: 'Search book',
          hintStyle: const TextStyle(color: Colors.grey),
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        ),
      ),
    );
  }
}
