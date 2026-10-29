// initState gọi API → FutureBuilder theo dõi kết quả
// → loading / error / empty / list.
// Retry tạo Future mới và cập nhật giao diện bằng setState.

import 'package:flutter/material.dart';

import '../models/post.dart';
import '../services/post_service.dart';

class PostListScreen extends StatefulWidget {
  const PostListScreen({super.key});

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  // Tạo service để gọi các hàm lấy dữ liệu
  final PostService _postService = PostService();

  // Lưu tác vụ lấy danh sách bài viết
  // Đây là Future, chưa phải List<Post> đã có kết quả
  // late: sẽ gán giá trị trước khi sử dụng
  late Future<List<Post>> _postsFuture;

  @override
  void initState() {
    super.initState();

    // Gọi API một lần khi State của màn hình được tạo
    // Không đặt trong build(), tránh gọi lại mỗi lần rebuild
    _postsFuture = _postService.fetchPosts();
  }

  void _retry() {
    setState(() {
      // Tạo tác vụ mới để gọi lại API
      // setState yêu cầu giao diện cập nhật với Future mới
      _postsFuture = _postService.fetchPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Danh sách bài viết')),
      body: FutureBuilder<List<Post>>(
        // FutureBuilder theo dõi tác vụ này
        future: _postsFuture,

        // snapshot chứa trạng thái, dữ liệu hoặc lỗi của tác vụ
        builder: (context, snapshot) {
          // Đang chờ API trả kết quả → hiện vòng xoay
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Tác vụ thất bại → hiện thông báo và nút gọi lại API.
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Không thể tải bài viết'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _retry,
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }

          // Lấy dữ liệu đã trả về.
          // Nếu data là null, dùng danh sách rỗng.
          final posts = snapshot.data ?? [];

          if (posts.isEmpty) {
            return const Center(child: Text('Chưa có bài viết'));
          }

          return ListView.separated(
            // Tổng số dòng cần hiển thị
            itemCount: posts.length,

            // Widget nằm giữa hai dòng
            separatorBuilder: (context, index) {
              return const Divider(height: 1);
            },

            // Xây dựng dòng tại vị trí index
            itemBuilder: (context, index) {
              // index bắt đầu từ 0
              final post = posts[index];

              return ListTile(
                // Hiện ID ở đầu dòng
                leading: CircleAvatar(child: Text('${post.id}')),
                // Tiêu đề bài viết
                title: Text(post.title),
                // Nội dung tối đa 2 dòng, dài hơn thì hiện dấu ...
                subtitle: Text(
                  post.body,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
