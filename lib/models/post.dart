class Post {
  final int id;
  final int userId;
  final String title;
  final String body;

  const Post({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
  });

  /*
  * fromJson: lấy dữ liệu theo key trong Map -> tạo đối tượng Post.
  * */

  // Named factory constructor: tạo Post từ một Map dữ liệu JSON.
  // Map<String, dynamic>:
  // - String: tên khóa, ví dụ 'id','title'.
  // - dynamic: giá trị có thể thuộc nhiều kiểu như int, String...
  factory Post.fromJson(Map<String, dynamic> json) {
    // Đọc từng giá trị trong Map rồi truyền vào constructor Post.
    return Post(
      // Lấy giá trị của khóa 'id', yêu cầu giá trị phải là int.
      id: json['id'] as int,

      // Khóa phải trùng với tên trường trong JSON.
      userId: json['userId'] as int,

      // Lấy tiêu đề và nội dung, yêu cầu kiểu String.
      title: json['title'] as String,
      body: json['body'] as String,
    );
  }
}
