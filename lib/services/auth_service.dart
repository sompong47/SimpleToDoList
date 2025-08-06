import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService {
  static const String _usersKey = 'registered_users';
  static const String _currentUserKey = 'current_user';

  // ลงทะเบียนผู้ใช้ใหม่
  static Future<bool> register(String username, String password, String email) async {
    final prefs = await SharedPreferences.getInstance();
    
    // ตรวจสอบว่า username ซ้ำหรือไม่
    final users = await _getAllUsers();
    if (users.any((user) => user.username.toLowerCase() == username.toLowerCase())) {
      return false; // username ซ้ำ
    }

    // สร้าง user ใหม่
    final newUser = UserModel(
      username: username,
      password: password,
      email: email,
    );

    // เพิ่มใน list
    users.add(newUser);
    
    // บันทึกลง storage
    await _saveAllUsers(users);
    return true;
  }

  // เข้าสู่ระบบ
  static Future<bool> login(String username, String password) async {
    final users = await _getAllUsers();
    
    // หา user ที่ตรงกัน
    final user = users.where((u) => 
      u.username.toLowerCase() == username.toLowerCase() && 
      u.password == password
    ).firstOrNull;

    if (user != null) {
      // บันทึก current user
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_currentUserKey, jsonEncode(user.toJson()));
      return true;
    }
    
    return false;
  }

  // ออกจากระบบ
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserKey);
  }

  // ตรวจสอบว่าล็อกอินอยู่หรือไม่
  static Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_currentUserKey);
    
    if (userJson != null) {
      return UserModel.fromJson(jsonDecode(userJson));
    }
    
    return null;
  }

  // รีเซ็ตรหัสผ่าน (จำลอง - ใช้ email)
  static Future<String?> resetPassword(String email) async {
    final users = await _getAllUsers();
    
    // หา user จาก email
    final userIndex = users.indexWhere((u) => u.email.toLowerCase() == email.toLowerCase());
    
    if (userIndex != -1) {
      // สร้างรหัสผ่านใหม่ (จำลอง)
      final newPassword = 'temp${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';
      
      // อัปเดตรหัสผ่าน
      users[userIndex].password = newPassword;
      await _saveAllUsers(users);
      
      return newPassword;
    }
    
    return null; // ไม่พบ email
  }

  // ตรวจสอบว่า email มีอยู่หรือไม่
  static Future<bool> isEmailExists(String email) async {
    final users = await _getAllUsers();
    return users.any((user) => user.email.toLowerCase() == email.toLowerCase());
  }

  // ดึงข้อมูล users ทั้งหมด
  static Future<List<UserModel>> _getAllUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_usersKey);
    
    if (usersJson == null) return [];
    
    final List<dynamic> usersList = jsonDecode(usersJson);
    return usersList.map((json) => UserModel.fromJson(json)).toList();
  }

  // บันทึก users ทั้งหมด
  static Future<void> _saveAllUsers(List<UserModel> users) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = jsonEncode(users.map((user) => user.toJson()).toList());
    await prefs.setString(_usersKey, usersJson);
  }
}