// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:uuid/uuid.dart';
//
// class ChatBot extends StatefulWidget {
//   const ChatBot({super.key});
//   @override
//   ChatBotState createState() => ChatBotState();
// }
//
// class ChatBotState extends State<ChatBot> {
//   final _chatController = InMemoryChatController();
//
//   // === Your Laravel API base ===
//   static const apiBase = 'http://127.0.0.1:8000/api'; // change if emulator: http://10.0.2.2:8000/api
//
//   // Known users
//   static const String userId = 'user1';
//   static const String assistantId = 'assistant';
//
//   @override
//   void dispose() {
//     _chatController.dispose();
//     super.dispose();
//   }
//
//   // Try to parse any top-level JSON object from a string
//   Map<String, dynamic>? _tryExtractJsonObject(String s) {
//     s = s.trim();
//     try {
//       final parsed = jsonDecode(s);
//       if (parsed is Map<String, dynamic>) return parsed;
//     } catch (_) {}
//     final re = RegExp(r'\{(?:[^{}]|(?R))*\}', dotAll: true);
//     final m = re.firstMatch(s);
//     if (m != null) {
//       try {
//         final parsed = jsonDecode(m.group(0)!);
//         if (parsed is Map<String, dynamic>) return parsed;
//       } catch (_) {}
//     }
//     return null;
//   }
//
//   Future<void> _sendToBackend(String text) async {
//     try {
//       final res = await http
//           .post(
//         Uri.parse('$apiBase/ask'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'question': text}),
//       )
//           .timeout(const Duration(seconds: 60));
//
//       final response = jsonDecode(res.body);
//       print(response);
//
//       // ✅ Handle action-based response FIRST
//       if (response != null &&
//           response['key'] == 'post_customer' &&
//           response['parameter'] is Map) {
//
//         _showCustomerForm(
//           Map<String, dynamic>.from(response['parameter']),
//         );
//
//         await _chatController.insertMessage(
//           TextMessage(
//             id: const Uuid().v4(),
//             authorId: assistantId,
//             createdAt: DateTime.now().toUtc(),
//             text: 'Please fill the customer form.',
//           ),
//         );
//         return;
//       }
//
//       if (res.statusCode < 200 || res.statusCode >= 300) {
//         await _chatController.insertMessage(
//           TextMessage(
//             id: const Uuid().v4(),
//             authorId: assistantId,
//             createdAt: DateTime.now().toUtc(),
//             text: _safeMessage(response),
//           ),
//         );
//         return;
//       }
//
//       // ✅ Normal success message
//       await _chatController.insertMessage(
//         TextMessage(
//           id: const Uuid().v4(),
//           authorId: assistantId,
//           createdAt: DateTime.now().toUtc(),
//           text: _safeMessage(response),
//         ),
//       );
//
//     } catch (e) {
//       await _chatController.insertMessage(
//         TextMessage(
//           id: const Uuid().v4(),
//           authorId: assistantId,
//           createdAt: DateTime.now().toUtc(),
//           text: 'Network error. Please try again.',
//         ),
//       );
//     }
//   }
//
//   String _safeMessage(dynamic response) {
//     if (response is Map && response['message'] != null) {
//       return response['message'].toString();
//     }
//     return '--';
//   }
//
//   void _showCustomerForm(Map<String, dynamic> parameter) {
//     final nameCtl  = TextEditingController(text: _initField(parameter['name']));
//     final phoneCtl = TextEditingController(text: _initField(parameter['phone']));
//     final emailCtl = TextEditingController(text: _initField(parameter['email']));
//     final gstCtl   = TextEditingController(text: _initField(parameter['gst']));
//
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       useSafeArea: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//       ),
//       builder: (ctx) {
//         return Padding(
//           padding: EdgeInsets.only(
//             left: 16, right: 16, top: 16,
//             bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Text('Create Customer',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
//               const SizedBox(height: 12),
//               TextField(controller: nameCtl,  decoration: const InputDecoration(labelText: 'Name')),
//               TextField(controller: phoneCtl, decoration: const InputDecoration(labelText: 'Phone (10 digits)'), keyboardType: TextInputType.phone),
//               TextField(controller: emailCtl, decoration: const InputDecoration(labelText: 'Email'), keyboardType: TextInputType.emailAddress),
//               TextField(controller: gstCtl,   decoration: const InputDecoration(labelText: 'GSTIN')),
//               const SizedBox(height: 12),
//               Row(
//                 children: [
//                   Expanded(
//                     child: FilledButton(
//                       onPressed: () async {
//                         final payload = {
//                           "key": "post_customer",
//                           "parameter": {
//                             "name": nameCtl.text.trim(),
//                             "phone": phoneCtl.text.trim(),
//                             "email": emailCtl.text.trim(),
//                             "gst": gstCtl.text.trim(),
//                           }
//                         };
//                         Navigator.of(ctx).pop();
//
//                         try {
//                           final res = await http
//                               .post(
//                             Uri.parse('$apiBase/ask'),
//                             headers: {'Content-Type': 'application/json'},
//                             body: jsonEncode(payload),
//                           )
//                               .timeout(const Duration(seconds: 60));
//                           final body = jsonDecode(res.body);
//
//                           if (res.statusCode >= 200 && res.statusCode < 300) {
//
//                             await _chatController.insertMessage(TextMessage(
//                               id: const Uuid().v4(),
//                               authorId: assistantId,
//                               createdAt: DateTime.now().toUtc(),
//                               text: _prettyJsonOrRaw(body['message']),
//                             ));
//                           } else {
//                             await _chatController.insertMessage(TextMessage(
//                               id: const Uuid().v4(),
//                               authorId: assistantId,
//                               createdAt: DateTime.now().toUtc(),
//                               text: 'Create failed ${body['message']}',
//                             ));
//                           }
//                         } catch (e) {
//                           await _chatController.insertMessage(TextMessage(
//                             id: const Uuid().v4(),
//                             authorId: assistantId,
//                             createdAt: DateTime.now().toUtc(),
//                             text: 'Create failed: $e',
//                           ));
//                         }
//                       },
//                       child: const Text('Submit'),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   String _initField(dynamic v) {
//     final s = (v is String) ? v : '';
//     if (s.startsWith('<')) return '';
//     return s;
//     // This keeps placeholders like "<name>" from pre-filling the field.
//   }
//
//   String _prettyJsonOrRaw(String s) {
//     try {
//       final obj = jsonDecode(s);
//       return const JsonEncoder.withIndent('  ').convert(obj);
//     } catch (_) {
//       return s;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
//
//     return Scaffold(
//       backgroundColor: const Color(0xFF0A141E), // main dark background
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF0A141E), // dark top bar
//         title: const Text(
//           'Sales Assistant',
//           style: TextStyle(
//             fontSize: 17,
//             color: Color(0xFFFAFAFA), // primary text
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios),
//           color: const Color(0xFFFAFAFA), // back arrow color
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: Stack(
//         children: [
//           // Chat messages
//           Chat(
//             chatController: _chatController,
//             currentUserId: userId,
//             backgroundColor: const Color(0xFF1E2832),
//             onMessageSend: (text) async {
//               await _chatController.insertMessage(
//                 TextMessage(
//                   id: const Uuid().v4(),
//                   authorId: userId,
//                   createdAt: DateTime.now().toUtc(),
//                   text: text,
//                 ),
//               );
//               await _sendToBackend(text);
//             },
//             resolveUser: (UserID id) async {
//               if (id == userId) return const User(id: userId, name: 'You');
//               if (id == assistantId) return const User(id: assistantId, name: 'Assistant');
//               return User(id: id, name: 'User');
//             },
//             // Customize message builder to include icon
//             messageBuilder: (context, message, isCurrentUser) {
//               bool isAssistant = message.authorId == assistantId;
//               return Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   if (isAssistant)
//                     Padding(
//                       padding: const EdgeInsets.only(right: 8.0),
//                       child: CircleAvatar(
//                         backgroundColor: Colors.blueAccent,
//                         child: Icon(
//                           Icons.smart_toy, // AI / bot icon
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   Expanded(
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
//                       margin: const EdgeInsets.symmetric(vertical: 4),
//                       decoration: BoxDecoration(
//                         color: isCurrentUser
//                             ? const Color(0xFF4A90E2) // user bubble
//                             : const Color(0xFF2A3A4D), // assistant bubble
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Text(
//                         message.text,
//                         style: const TextStyle(color: Colors.white),
//                       ),
//                     ),
//                   ),
//                 ],
//               );
//             },
//           ),
//
//           // Transparent spacer to push messages up above input + quick actions
//           Positioned(
//             left: 0,
//             right: 0,
//             bottom: 0,
//             height: 100 + keyboardHeight, // input height + quick actions
//             child: IgnorePointer(
//               ignoring: true,
//               child: const SizedBox(),
//             ),
//           ),
//
//           // Quick action buttons above input
//           Positioned(
//             left: 0,
//             right: 0,
//             bottom: 56 + keyboardHeight, // input height
//             child: _quickActions(),
//           ),
//         ],
//       ),
//     );
//   }
//   Widget _quickActions() {
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Row(
//         children: [
//           _actionChip('Create Customer'),
//           _actionChip('Create Quotation'),
//           _actionChip('Create Order'),
//           _actionChip('View Customers'),
//         ],
//       ),
//     );
//   }
//
//   Widget _actionChip(String text) {
//     return Padding(
//       padding:  EdgeInsets.only(right: 8),
//       child: ActionChip(
//         materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//         backgroundColor: Colors.white,
//         label: Text(text),
//         onPressed: () async {
//           await _chatController.insertMessage(
//             TextMessage(
//               id: const Uuid().v4(),
//               authorId: userId,
//               createdAt: DateTime.now().toUtc(),
//               text: text,
//             ),
//           );
//           await _sendToBackend(text);
//         },
//       ),
//     );
//   }
//
// }
//
