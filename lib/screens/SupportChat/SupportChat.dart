import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show PlatformException, Uint8List, rootBundle;
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mime/mime.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../../Services/SupportChatService.dart';

class SupportChat extends StatelessWidget {
  const SupportChat({super.key});
  static String routeName = "/support_chat";

  @override
  Widget build(BuildContext context) => const MaterialApp(
    home: Directionality(
      textDirection: TextDirection.ltr,
      child: ChatPage(),
    ),
  );
}

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<types.Message> _messages = [];



  final _user = const types.User(
    id: '82091008-a484-4a89-ae75-a22bf8d6f3ac',
  );

  final _server = const types.User(
    id: '55555555-a484-4a89-ae75-a22bf8d6f3ac',
  );


  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;
  List<File> selectedImages = []; // List of selected image

  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }


  void _addMessage(types.Message message) {

    setState(() {
      _messages.insert(0, message);
    });


  }
  void _addMessageR(types.Message message) {
    setState(() {
      _messages.insert(1, message);
    });
  }

  void _handleAttachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: SizedBox(
          height: 144,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  // _pickImage(ImageSource.gallery);
                  getImages();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Photo from Gallery'),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Take a Photo'),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future getImages() async {
    final pickedFile = await _picker.pickMultiImage(
        imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
    List<XFile> xfilePick = pickedFile;

    setState(
          () {
        if (xfilePick.isNotEmpty) {
          for (var i = 0; i < xfilePick.length; i++) {
            selectedImages.add(File(xfilePick[i].path));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Nothing is selected')));
        }
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await _picker.pickImage(
      source: source,
      imageQuality: 70,
      maxWidth: 1440,
    );

    if (pickedImage != null) {
      setState(() {
        _selectedImage = pickedImage;
      });
    }
  }

  void _ServiceChat(types.PartialText message){

    final textMessage = types.TextMessage(
      author: _server,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: "this is the response message from the server",
    );

    _addMessage(textMessage);
  }

  Future<void> _handleSendPressed(types.PartialText message) async {

    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );




    _addMessage(textMessage);

    if (selectedImages != null) {
      for (var image in selectedImages) {

     await _sendImageWithText(image, message.text);
     // Example method to send image with text
      }

      MsgForChatBot(message.text, selectedImages); // Example method to send message with image

      setState(() {
        selectedImages.clear();
      });

    }

    _textController.clear();
  }


  Future<void> _sendImageWithText(File  pickedImage, String text) async {
    final bytes = await pickedImage.readAsBytes();
    final image = await decodeImageFromList(bytes);

    final imageMessage = types.ImageMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      height: image.height.toDouble(),
      id: const Uuid().v4(),
      name:"",
      size: bytes.length,
      uri: pickedImage.path,
      width: image.width.toDouble(),
    );
    _addMessage(imageMessage);
  }

  Future<ui.Image> decodeImageFromList(Uint8List bytes) {
    final completer = Completer<ui.Image>();
    ui.decodeImageFromList(bytes, (ui.Image img) {
      completer.complete(img);
    });
    return completer.future;
  }

  void _handleMessageTap(BuildContext _, types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        try {
          final index = _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage = (_messages[index] as types.FileMessage).copyWith(
            isLoading: true,
          );

          setState(() {
            _messages[index] = updatedMessage;
          });

          final client = http.Client();
          final request = await client.get(Uri.parse(message.uri));
          final bytes = request.bodyBytes;
          final documentsDir = (await getApplicationDocumentsDirectory()).path;
          localPath = '$documentsDir/${message.name}';

          if (!File(localPath).existsSync()) {
            final file = File(localPath);
            await file.writeAsBytes(bytes);
          }
        } finally {
          final index = _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage = (_messages[index] as types.FileMessage).copyWith(
            isLoading: null,
          );

          setState(() {
            _messages[index] = updatedMessage;
          });
        }
      }

      await OpenFilex.open(localPath);
    }
  }

  void _handlePreviewDataFetched(
      types.TextMessage message,
      types.PreviewData previewData,
      ) {
    final index = _messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = (_messages[index] as types.TextMessage).copyWith(
      previewData: previewData,
    );

    setState(() {
      _messages[index] = updatedMessage;
    });
  }

  void _loadMessages() async {
    final response = await rootBundle.loadString('assets/messages.json');
    final messages = (jsonDecode(response) as List)
        .map((e) => types.Message.fromJson(e as Map<String, dynamic>))
        .toList();

    setState(() {
      _messages = messages;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Column(
      children: [
        Expanded(
          child: Chat(
            messages: _messages,
            onAttachmentPressed: _handleAttachmentPressed,
            onMessageTap: _handleMessageTap,
            onPreviewDataFetched: _handlePreviewDataFetched,
            onSendPressed: _handleSendPressed,
            showUserAvatars: true,
            showUserNames: true,
            user: _user,
          ),
        ),

        if (selectedImages != null && selectedImages.isNotEmpty) // Only show if there are selected images
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 300.0, // To show images in a specific area only
                  height: 200.0, // Adjust height as needed
                  child: GridView.builder(
                    itemCount: selectedImages.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 4.0,
                      crossAxisSpacing: 4.0,
                      childAspectRatio: 1.0,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      // Show selected file
                      return Center(
                        child: kIsWeb
                            ? Image.network(selectedImages[index].path)
                            : Image.file(selectedImages[index]),
                      );
                    },
                  ),
                ),
                SizedBox(height: 10), // Spacer between grid and button

                // "X" button to clear images
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      // Call your clearImages method here
                      clearImages();
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red, // Example color for the button
                      ),
                      child: Icon(Icons.clear, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    ),
  );

  void clearImages() {
    setState(() {
      selectedImages.clear();
    });

  }

  Future<void> MsgForChatBot(String text,List<File> pickedImages) async{


    try {
      // Prepare text message part
      final Map<String, String> textMap = {
        'prompt': text,
      };

      // Prepare image parts
      List<http.MultipartFile> imageParts = [];
      for (var file in selectedImages) {
        http.MultipartFile imagePart = convertFileToMultipartFile(file);
        imageParts.add(imagePart);
      }

      // Create multipart request
      var request = http.MultipartRequest('POST', Uri.parse(dotenv.env['BackEndUrI'].toString()+"/SupportChatWithImage"))
        ..fields.addAll(textMap) // Add text fields
        ..files.addAll(imageParts); // Add image files

      // Send request
      var response = await request.send();

      String responseBody = await response.stream.bytesToString();

      // final body = jsonEncode({
      //   'text': text,
      //   'image':pickedImages, // Encode image bytes to base64
      //   // Add any other necessary fields for your API request
      // });
      //
      //
      //
      //
      // final response = await http.post(Uri.parse(dotenv.env['BackEndUrI'].toString()+"/SupportChatWithImage"      ), headers:
      // {'Content-Type': 'application/json'},
      //     body: body
      //
      //    );


      if (response.statusCode == 200) {

        final textMessage = types.TextMessage(
          author: _server,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          id: const Uuid().v4(),
          text: responseBody,
        );

        _addMessage(textMessage);
      }
    } catch (e) {

      final textMessage = types.TextMessage(
        author: _server,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),

        text: "$e",
      );

      _addMessage(textMessage);
    }
  }


  http.MultipartFile convertFileToMultipartFile(File file) {
    final fileStream = http.ByteStream(file.openRead());
    final fileSize = file.lengthSync();
    final fileName = file.path.split('/').last; // Extracting file name from path

    return http.MultipartFile(
      'image', // 'files' should match the parameter name expected by your API
      fileStream,
      fileSize,
      filename: fileName,
    );
  }

}


