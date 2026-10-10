import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

// Bước 1: class Student, score có thể null
class Student {
  final String name;
  final double? score;

  const Student({required this.name, this.score});
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ClassScoreScreen(),
    );
  }
}

// Hàm xếp loại dùng lại từ Bài 2
String classify(double score) {
  if (score < 0 || score > 10) {
    return 'Không hợp lệ';
  } else if (score >= 8.0) {
    return 'Giỏi';
  } else if (score >= 6.5) {
    return 'Khá';
  } else if (score >= 5.0) {
    return 'Trung bình';
  } else {
    return 'Yếu';
  }
}

Color gradeColor(String grade) {
  if (grade == 'Giỏi') {
    return const Color(0xFF2E7D32);
  } else if (grade == 'Khá') {
    return const Color(0xFF1565C0);
  } else if (grade == 'Trung bình') {
    return const Color(0xFFB26A00);
  } else if (grade == 'Yếu') {
    return const Color(0xFFD32F2F);
  } else {
    return const Color(0xFF9CA3AF);
  }
}

class ClassScoreScreen extends StatelessWidget {
  const ClassScoreScreen({super.key});

  static const List<Student> students = [
    Student(name: 'Nguyễn Văn An', score: 9.0),
    Student(name: 'Trần Thị Bình', score: 7.2),
    Student(name: 'Lê Minh Chi', score: null),
    Student(name: 'Phạm Quốc Dũng', score: 4.5),
    Student(name: 'Võ Thanh Em', score: 5.8),
  ];

  Widget _stat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 12, color: Color(0xFFB8C4DE))),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Bước 3: dùng for + if để tính thống kê
    double total = 0;
    int counted = 0; // số người có điểm
    int gioiCount = 0;
    int noScoreCount = 0;
    double? highest;

    for (final s in students) {
      final double? sc = s.score;
      if (sc == null) {
        noScoreCount++; // bỏ qua khi tính trung bình
      } else {
        total += sc;
        counted++;
        if (classify(sc) == 'Giỏi') {
          gioiCount++;
        }
        if (highest == null || sc > highest) {
          highest = sc;
        }
      }
    }

    final double average = counted == 0 ? 0 : total / counted;

    // Bước 2: dùng for để dựng danh sách thẻ sinh viên
    final List<Widget> cards = [];
    for (final s in students) {
      final double? sc = s.score;
      String subtitle;
      Color subColor;
      String scoreText;

      if (sc == null) {
        subtitle = 'Chưa có điểm';
        subColor = const Color(0xFF9CA3AF);
        scoreText = '—';
      } else {
        subtitle = classify(sc);
        subColor = gradeColor(subtitle);
        scoreText = sc.toStringAsFixed(1);
      }

      cards.add(
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s.name,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937))),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: subColor)),
                ],
              ),
              Text(scoreText,
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: sc == null
                          ? const Color(0xFF9CA3AF)
                          : const Color(0xFF1F2937))),
            ],
          ),
        ),
      );
      cards.add(const SizedBox(height: 8));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF3F5FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C4A7C),
        foregroundColor: Colors.white,
        title: const Text('Bảng điểm lớp'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thẻ thống kê màu xanh đậm
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2C4A7C),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Điểm trung bình lớp',
                      style:
                          TextStyle(fontSize: 13, color: Color(0xFFB8C4DE))),
                  const SizedBox(height: 4),
                  Text(average.toStringAsFixed(2),
                      style: const TextStyle(
                          fontSize: 44,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  const SizedBox(height: 10),
                  Container(height: 1, color: const Color(0xFF4A6699)),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _stat('Giỏi', '$gioiCount'),
                      _stat('Chưa có điểm', '$noScoreCount'),
                      _stat('Cao nhất',
                          highest == null ? '—' : highest.toStringAsFixed(1)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text('DANH SÁCH · ${students.length} SINH VIÊN',
                style: const TextStyle(
                    fontSize: 12,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6B7280))),
            const SizedBox(height: 8),
            ...cards,
          ],
        ),
      ),
    );
  }
}