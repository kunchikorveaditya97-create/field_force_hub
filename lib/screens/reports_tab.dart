import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/task_controller.dart';
import '../data/task_model.dart';

class ReportsTab extends StatefulWidget {
  final FieldTask? selectedTask;
  final VoidCallback onSubmissionSuccess;

  const ReportsTab({super.key, this.selectedTask, required this.onSubmissionSuccess});

  @override
  State<ReportsTab> createState() => _ReportsTabState();
}

class _ReportsTabState extends State<ReportsTab> {
  final _formKey = GlobalKey<FormState>();
  final _notesEdit = TextEditingController();
  final TaskController controller = Get.find<TaskController>();
  bool _runningAI = false;

  @override
  void initState() {
    super.initState();
    if (widget.selectedTask != null) {
      _notesEdit.text = widget.selectedTask!.visitNotes;
    }
  }

  void _submitReportLog() async {
    if (widget.selectedTask == null || !_formKey.currentState!.validate()) return;

    setState(() { _runningAI = true; });
    await Future.delayed(const Duration(milliseconds: 1000)); // Dynamic simulation handshake latency delay

    controller.submitFieldAuditLogs(widget.selectedTask!, _notesEdit.text.trim());
    setState(() { _runningAI = false; });

    Get.snackbar('Success', 'Dynamic note tracking logs compiled with Hive persistence storage arrays.', backgroundColor: const Color(0xFFB176FF), colorText: Colors.black);
    widget.onSubmissionSuccess();
  }

  @override
  Widget build(BuildContext context) {
    final task = widget.selectedTask;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (task == null) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: const Color(0xFF160D29), borderRadius: BorderRadius.circular(12)),
                  child: const Center(child: Text('Select an active execution node element within the standard checklist structure tab view layout to deploy audit entry sheets.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white38, fontSize: 12))),
                )
              ] else ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: const Color(0xFF1E0B36), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('TARGET SITE: ${task.id}', style: const TextStyle(color: Color(0xFFB176FF), fontSize: 12, fontFamily: 'monospace', fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(task.siteName, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _notesEdit,
                  maxLines: 4,
                  enabled: task.status != 'Completed',
                  decoration: InputDecoration(
                    hintText: 'Type audit tracking parameters... (Use trigger testing tags: "broken", "theft", or "normal")',
                    fillColor: const Color(0xFF160D29), filled: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (v) => v == null || v.isEmpty ? 'Audit values required' : null,
                ),
                const SizedBox(height: 16),
                if (task.status != 'Completed')
                  _runningAI
                      ? const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Color(0xFFB176FF))))
                      : SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFB176FF)),
                      onPressed: _submitReportLog,
                      child: const Text('SUBMIT DATA & PROCESS MOCK AI', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    ),
                  ),
                if (task.status == 'Completed') ...[
                  const SizedBox(height: 20),
                  const Text('MOCK AI DIAGNOSTIC INSIGHT ENGINE REPORT LOGS', style: TextStyle(color: Colors.greenAccent, fontSize: 11, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: const Color(0xFF0D251D), borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('AI Evaluation Threat Alert Priority: ${task.aiFlag.toUpperCase()}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        const Divider(color: Colors.white10),
                        Text(task.aiSummary, style: const TextStyle(fontSize: 12, height: 1.4)),
                      ],
                    ),
                  )
                ]
              ]
            ],
          ),
        ),
      ),
    );
  }
}