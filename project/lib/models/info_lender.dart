class Info {
  static List<Map<String, String>> books = [
    {
      'title': 'Book Name 1',
      'borrowedDate': '01/01/2023',
      'dueDate': '01/02/2023',
      'username': 'User1',
      'status': 'approved',
      'image': 'assets/images/book1.png'
    },
    {
      'title': 'Book Name 2',
      'borrowedDate': '01/02/2023',
      'dueDate': '01/03/2023',
      'username': 'User2',
      'status': 'approved',
      'image': 'assets/images/book2.png'
    },
    {
      'title': 'Book Name 3',
      'borrowedDate': '01/03/2023',
      'dueDate': '-',
      'username': 'User3',
      'status': 'rejected',
      'image': 'assets/images/book3.png'
    },
  ];
}