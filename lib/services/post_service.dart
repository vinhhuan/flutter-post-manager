import 'dart:convert';

// Gọi các hàm HTTP qua tên http, ví dụ http.get()
import 'package:http/http.dart'
    as http; // Run 'flutter pub add http' in Terminal

import '../models/post.dart';

class PostService {
  // Hàm bất đồng bộ, kết quả nhận được sau này là List<Post>
  Future<List<Post>> fetchPosts() async {
    // Chuyển địa chỉ dạng String thành Uri để gửi request
    final url = Uri.parse('https://jsonplaceholder.typicode.com/posts');

    // Gửi GET request và chờ phản hồi
    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Không thể tải bài viết: HTTP ${response.statusCode}');
    }

    // response.body là chuỗi JSON
    // jsonDecode chuyển chhuooxi thành dữ liệu Dart
    // API này trả mảng JSON nên yêu cầu kết quả là List
    final jsonList = jsonDecode(response.body) as List<dynamic>;

    // Duyệt từng phần tử JSON và chuyển thành đối tượng Post
    final posts = jsonList.map((item) {
      // Mỗi phần tử là Map có key String
      // fromJson đọc các key rồi tạo một Post
      return Post.fromJson(item as Map<String, dynamic>);
    }).toList(); // Chuyển Iterable<Post> thành List<Post>

    // Trả danh sách đối tượng cho nơi gọi hàm
    return posts;
  }
}
