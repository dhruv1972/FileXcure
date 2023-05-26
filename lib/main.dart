import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' as flutter;
import 'package:splashscreen/splashscreen.dart';
import 'package:mongo_dart/mongo_dart.dart' show Db;
import 'package:mongo_dart_query/mongo_dart_query.dart' hide Db;
import 'package:file_picker/file_picker.dart';
import "dart:io";
import 'package:azstore/azstore.dart';
import "package:path/path.dart" as path;
import 'dart:typed_data';
import 'package:mime/mime.dart';
import 'dart:convert';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'dart:typed_data';

void main() {
  bool debugShowCheckedModeBanner;
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreenWrapper(),
    ),
  );
}

class SplashScreenWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 2,
      navigateAfterSeconds:
          LoginPage(), // Navigate to MyHomePage after splash screen
      title: Text(
        'Secure Here Before Upload There',
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
            fontFamily: 'Helvetica',
            color: Color.fromARGB(255, 0, 0, 0)),
      ),

      image: Image.asset(
        'assets/filexcurelogo-transformed-removebg-preview.png',
      ),
      photoSize: 200,
      backgroundColor: Color.fromARGB(255, 240, 239, 239),
      loaderColor: Colors.blue,
    );
  }
}

class LoginPage extends StatelessWidget {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  void loginUser(BuildContext context) async {
    final username = usernameController.text;
    final password = passwordController.text;

    // Connect to MongoDB Atlas
    final db = await Db.create(
        'mongodb+srv://admin:admin@cluster0.cl35onk.mongodb.net/filexcure?retryWrites=true&w=majority');
    await db.open();
    if (db == null) {
      print('Error connecting to database');
      return;
    }

    // Get a reference to the users collection
    final users = db.collection('users');

    // Check if the user exists and the password matches
    final user = await users.findOne(where.eq('username', username));
    if (user == null || user['password'] != password) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Invalid username or password.'),
      ));
      return;
    }

    // Navigate to home page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double imageWidth = screenSize.width * 0.8; // 80% of screen width
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image:
                AssetImage('assets/back.png'), // Replace with your image path
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
              ),
              SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () {
                  // TODO: Implement login functionality
                  loginUser(context);
                  print('Login button pressed!');
                },
                child: Text('Login'),
              ),
              SizedBox(height: 16.0),
              TextButton(
                onPressed: () {
                  // TODO: Navigate to registration page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegistrationPage()),
                  );
                },
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RegistrationPage extends StatelessWidget {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  void registerUser(BuildContext context) async {
    final username = usernameController.text;
    final password = passwordController.text;

    print(username);
    // Connect to MongoDB Atlas
    final db = await Db.create(
        'mongodb+srv://jaydeep:jaydeep@cluster0.cl35onk.mongodb.net/filexcure?retryWrites=true&w=majority');
    await db.open();
    if (db == null) {
      print('Error connecting to database');
      return;
    }

    // Get a reference to the users collection
    final users = db.collection('users');
    var data = await users.find().toList();
    print(data);
    // Check if the user already existss
    final userExists = await users.findOne(where.eq('username', username));
    if (userExists != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('User already exists.'),
      ));
      return;
    }

    // Insert the new user
    final result =
        await users.insertOne({'username': username, 'password': password});
    if (result.writeConcernError != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('An error occurred while registering.'),
      ));
      return;
    }

    // Show a success message
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Registration successful.'),
    ));

    // Navigate back to login page
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final username = usernameController.text;
    final password = passwordController.text;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image:
                AssetImage('assets/back.png'), // Replace with your image path
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // TODO: Implement registration functionality
                  registerUser(context); // Call the registerUser method here
                  print('Register button pressed!');
                },
                child: Text('Register'),
              ),
              SizedBox(height: 16.0),
              TextButton(
                onPressed: () {
                  // TODO: Navigate back to login page
                  Navigator.pop(context);
                },
                child: Text('Back to Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isUploading = false;
  bool isEncrypting = false;
  Color encbtn = Colors.blue;
  Color selbtn = Colors.green;
  Color dnbtn = Colors.blue;
  var result;
  var file;

  void _handleSelectFile() async {
    try {
      result = await FilePicker.platform.pickFiles();

      if (result != null) {
        file = File(result.files.single.path!);
        // TODO: Process selected file
        // Read the contents of the file
        final contents = await file.readAsBytes();
        setState(() {
          selbtn = Colors.blue;
          encbtn = Colors.green;
        });
      }
    } catch (e) {
      // Handle any exceptions that occur
      print(e.toString());
    }
    print("hello");
    testUploadImage();
  }

  Future<void> testUploadImage() async {
    var storage = AzureStorage.parse(
        'DefaultEndpointsProtocol=https;AccountName=filexcurestorageaccount;AccountKey=zooAxOyAoGOawW4sn5ru4cdN/uTC2+Qg6z/++VzamMms9g7bDvaCqlVDG5QDxLJXeGFmplTTRKZj+AStGWxEuQ==;EndpointSuffix=core.windows.net');

    try {
      String fileName = file.path.split('/').last;
      Uint8List fileContent = await file.readAsBytes();
      // Get the file extension and determine the content type
      // Encrypt the file with AES
      final password = '2b7e151628aed2a6abf7158809cf4f3c';
      final key = encrypt.Key.fromUtf8(password);
      final iv = encrypt.IV.fromLength(16);
      final encrypter = encrypt.Encrypter(encrypt.AES(key));
      final encrypted = encrypter.encryptBytes(fileContent, iv: iv);

      String extension = file.path.split('.').last;
      String? mimeType = lookupMimeType('.$extension');
      String contentTyp = mimeType ?? 'application/octet-stream';
      await storage.putBlob('/file/$fileName',
          bodyBytes: encrypted.bytes, contentType: contentTyp);
      setState(() {
        encbtn = Colors.blue;
        dnbtn = Colors.green;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('File Uploaded successfully.'),
        ));

        Future.delayed(const Duration(milliseconds: 1000), () {
          setState(() {
            dnbtn = Colors.blue;
            selbtn = Colors.green;
          });
        });
      });
    } catch (e) {
      print('exception: $e');
    }
    print("hello");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('fileXcure'),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 100),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/fileXcure.gif'), // Replace with your image path
            fit: BoxFit.fill,
          ),
        ),
        child: Container(
          margin: EdgeInsets.only(top: 350),
          child: flutter.Center(
            child: Stack(alignment: Alignment.center, children: [
              Positioned(
                top: 10,
                left: 0,
                right: 0,
                child: Container(
                  width: 100,
                  height: 100,
                  child: FloatingActionButton(
                    onPressed: _handleSelectFile,
                    child: Icon(Icons.file_upload),
                    backgroundColor: selbtn,
                  ),
                ),
              ),
              Positioned(
                top: 60,
                left: 60,
                child: Container(
                  width: 100,
                  height: 100,
                  child: FloatingActionButton(
                    onPressed: null,
                    child: Icon(Icons.lock),
                    backgroundColor: encbtn,
                  ),
                ),
              ),
              Positioned(
                top: 120,
                left: 0,
                right: 0,
                child: Container(
                  width: 100,
                  height: 100,
                  child: FloatingActionButton(
                    onPressed: null,
                    child: Icon(Icons.cloud_upload),
                    backgroundColor: encbtn,
                  ),
                ),
              ),
              Positioned(
                top: 60,
                right: 60,
                child: Container(
                  width: 100,
                  height: 100,
                  child: FloatingActionButton(
                    onPressed: null,
                    child: Icon(Icons.done),
                    backgroundColor: dnbtn,
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
