class Product {
  final int id;
  String title, description, image, author;
  String status;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.status,
    required this.author,
  });

  void toggleStatus() {
    if (status == 'Available') {
      status = 'Disable';
    } else if (status == 'Disable') {
      status = 'Available';
    }
  }
}

// รายการของสินค้า (List of products)
List<Product> products = [
  Product(
    id: 1,
    title: "ผจญภัยในท้องทะเล",
    image: "assets/images/book1.png",
    description:
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
    status: "Available",
    author: "Author 1",
  ),
  Product(
    id: 2,
    title: "Book 1",
    image: "assets/images/book1.png",
    description:
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
    status: "Disable",  // เปลี่ยนจาก Not Available เป็น Disable
    author: "Author 2",
  ),
  Product(
    id: 3,
    title: "Book 2",
    image: "assets/images/book2.png",
    description:
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
    status: "Available",
    author: "Author 3",
  ),
  Product(
    id: 4,
    title: "Book 3",
    image: "assets/images/book3.png",
    description:
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
    status: "Borrowed",  // สถานะใหม่ที่เพิ่มเข้ามา
    author: "Author 4",
  ),
  Product(
    id: 5,
    title: "Book 4",
    image: "assets/images/book4.png",
    description:
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
    status: "Pending",  // เปลี่ยนจาก Not Available เป็น Disable
    author: "Author 5",
  ),
  Product(
    id: 6,
    title: "Book 5",
    image: "assets/images/book5.png",
    description:
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
    status: "Available",
    author: "Author 6",
  ),
  Product(
    id: 7,
    title: "Book 6",
    image: "assets/images/book1.png",
    description:
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
    status: "Available",
    author: "Author 7",
  ),
  Product(
    id: 8,
    title: "สวัสดีไทยแลนด์",
    image: "assets/images/book2.png",
    description:
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
    status: "Disable",  // เปลี่ยนจาก Not Available เป็น Disable
    author: "Author 8",
  ),
];
