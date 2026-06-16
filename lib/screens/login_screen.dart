import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/task_controller.dart';
import 'main_navigation.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final _userEdit = TextEditingController();
  final _passEdit = TextEditingController();
  final TaskController controller = Get.put(TaskController());

  void _processAuthentication() {
    if (!_formKey.currentState!.validate()) return;

    String user = _userEdit.text.trim().toLowerCase();
    String pass = _passEdit.text.trim();
    String roleMapping = '';

    // EXACT 5 ROLE PERMISSION ROUTING CHECKS
    if (user == 'admin' && pass == 'admin123') roleMapping = 'Admin';
    if (user == 'manager' && pass == 'manager123') roleMapping = 'Regional Manager';
    if (user == 'lead' && pass == 'lead123') roleMapping = 'Team Lead';
    if (user == 'agent' && pass == 'agent123') roleMapping = 'Field Agent';
    if (user == 'auditor' && pass == 'auditor123') roleMapping = 'Auditor';

    if (roleMapping.isNotEmpty) {
      controller.bootOfflineDatabase(_userEdit.text.trim(), roleMapping);
      Get.offAll(() => MainNavigationHub());
    } else {
      Get.snackbar(
        'Auth Error',
        'Validation failed. Match account parameters given below.',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.security, size: 60, color: Color(0xFFB176FF)),
                const SizedBox(height: 10),
                const Text('FIELD FORCE HUB', textAlign: TextAlign.center, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 2)),
                const Text('secure', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.white38)),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _userEdit,
                  decoration: InputDecoration(
                    labelText: 'Login ID',
                    prefixIcon: const Icon(Icons.person, color: Color(0xFFB176FF)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (v) => v == null || v.isEmpty ? 'Field required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passEdit,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock, color: Color(0xFFB176FF)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (v) => v == null || v.isEmpty ? 'Field required' : null,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFB176FF), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    onPressed: _processAuthentication,
                    child: const Text('Login', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 25),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: const Color(0xFF160D29), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('DEMO LOGINS', style: TextStyle(color: Color(0xFFB176FF), fontSize: 11, fontWeight: FontWeight.bold)),
                      const Divider(color: Colors.white10),
                      _buildHelperText('Admin:', 'admin', 'admin123'),
                      _buildHelperText('Regional Manager:', 'manager', 'manager123'),
                      _buildHelperText('Team Lead:', 'lead', 'lead123'),
                      _buildHelperText('Field Agent:', 'agent', 'agent123'),
                      _buildHelperText('Auditor:', 'auditor', 'auditor123'),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHelperText(String r, String u, String p) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(r, style: const TextStyle(fontSize: 11, color: Colors.white70)),
          Text('ID: $u | Pass: $p', style: const TextStyle(fontSize: 11, color: Colors.white38, fontFamily: 'monospace')),
        ],
      ),
    );
  }
}