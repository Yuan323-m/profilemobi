import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

const List<String> startingHobbies = [
  'Doomscrolling',
  'Eating',
  'Sleeping',
  'Watching KDrama',
  'Reading',
];

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int likes = 0;
  String name = 'Yuan Manarang';
  String email = '';
  List<String> hobbies = List.from(startingHobbies);
  Uint8List? profilePicture;

  Future<void> editProfile() async {
    final ProfileData? updatedProfile = await Navigator.push<ProfileData>(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfilePage(
          name: name,
          email: email,
          hobbies: hobbies,
          profilePicture: profilePicture,
        ),
      ),
    );

    if (updatedProfile == null || !mounted) return;

    setState(() {
      name = updatedProfile.name;
      email = updatedProfile.email;
      hobbies = updatedProfile.hobbies;
      profilePicture = updatedProfile.profilePicture;
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Profile saved')));
  }

  void openDetailsPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileDetailsPage(
          name: name,
          email: email,
          profilePicture: profilePicture,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            tooltip: 'Edit profile',
            onPressed: editProfile,
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text('My Profile'),
              ),
            ),
            ListTile(
              title: const Text('View details'),
              onTap: () {
                Navigator.pop(context);
                openDetailsPage();
              },
            ),
            ListTile(
              title: const Text('Edit profile'),
              onTap: () {
                Navigator.pop(context);
                editProfile();
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Quick edit profile',
        onPressed: editProfile,
        child: const Icon(Icons.edit),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                border: Border.all(),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Tooltip(
                    message: 'Edit profile picture',
                    child: GestureDetector(
                      onTap: editProfile,
                      child: Stack(
                        children: [
                          Hero(
                            tag: 'profile-picture',
                            child: ProfileAvatar(
                              profilePicture: profilePicture,
                              radius: 60,
                              iconSize: 70,
                            ),
                          ),
                          const Positioned(
                            right: 0,
                            bottom: 0,
                            child: CircleAvatar(
                              radius: 15,
                              child: Icon(Icons.edit, size: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text('Student'),
                  if (email.isNotEmpty) Text(email),
                  const SizedBox(height: 12),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person),
                      SizedBox(width: 32),
                      Icon(Icons.email),
                      SizedBox(width: 32),
                      Icon(Icons.phone),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            likes++;
                          });
                        },
                        child: const Text('Like'),
                      ),
                      const SizedBox(width: 12),
                      Text('$likes Likes'),
                    ],
                  ),
                  TextButton(
                    onPressed: openDetailsPage,
                    child: const Text('View details'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'My Hobbies',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: hobbies.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.star_border),
                    title: Text(hobbies[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileDetailsPage extends StatelessWidget {
  final String name;
  final String email;
  final Uint8List? profilePicture;

  const ProfileDetailsPage({
    super.key,
    required this.name,
    required this.email,
    required this.profilePicture,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile Details')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: 'profile-picture',
              child: ProfileAvatar(
                profilePicture: profilePicture,
                radius: 100,
                iconSize: 120,
              ),
            ),
            const SizedBox(height: 20),
            Text(name, style: const TextStyle(fontSize: 28)),
            const Text('Student'),
            if (email.isNotEmpty) Text(email),
          ],
        ),
      ),
    );
  }
}

class ProfileAvatar extends StatelessWidget {
  final Uint8List? profilePicture;
  final double radius;
  final double iconSize;

  const ProfileAvatar({
    super.key,
    required this.profilePicture,
    required this.radius,
    required this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundImage: profilePicture == null
          ? null
          : MemoryImage(profilePicture!),
      child: profilePicture == null ? Icon(Icons.person, size: iconSize) : null,
    );
  }
}

class ProfileData {
  final String name;
  final String email;
  final List<String> hobbies;
  final Uint8List? profilePicture;

  const ProfileData({
    required this.name,
    required this.email,
    required this.hobbies,
    required this.profilePicture,
  });
}

class EditProfilePage extends StatefulWidget {
  final String name;
  final String email;
  final List<String> hobbies;
  final Uint8List? profilePicture;

  const EditProfilePage({
    super.key,
    required this.name,
    required this.email,
    required this.hobbies,
    required this.profilePicture,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController hobbiesController;
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController ageController = TextEditingController();
  late Uint8List? profilePicture;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.name);
    emailController = TextEditingController(text: widget.email);
    hobbiesController = TextEditingController(text: widget.hobbies.join('\n'));
    profilePicture = widget.profilePicture;
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    hobbiesController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    ageController.dispose();
    super.dispose();
  }

  Future<void> chooseProfilePicture() async {
    final ImagePicker imagePicker = ImagePicker();
    final XFile? pickedFile = await imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile == null) return;

    final Uint8List imageBytes = await pickedFile.readAsBytes();
    setState(() {
      profilePicture = imageBytes;
    });
  }

  void saveProfile() {
    if (!formKey.currentState!.validate()) return;

    final List<String> updatedHobbies = hobbiesController.text
        .split('\n')
        .map((hobby) => hobby.trim())
        .where((hobby) => hobby.isNotEmpty)
        .toList();

    Navigator.pop(
      context,
      ProfileData(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        hobbies: updatedHobbies,
        profilePicture: profilePicture,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: chooseProfilePicture,
                      child: ProfileAvatar(
                        profilePicture: profilePicture,
                        radius: 55,
                        iconSize: 65,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: chooseProfilePicture,
                      icon: const Icon(Icons.photo_library_outlined),
                      label: const Text('Change picture'),
                    ),
                  ],
                ),
              ),
              TextFormField(
                key: const Key('nameField'),
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Name is required';
                  }
                  if (value.trim().length < 2) {
                    return 'Use at least 2 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                key: const Key('emailField'),
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) => value == null || !value.contains('@')
                    ? 'Enter a valid email containing @'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                key: const Key('hobbiesField'),
                controller: hobbiesController,
                minLines: 3,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Hobbies',
                  alignLabelWithHint: true,
                  helperText: 'Enter one hobby per line',
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Enter at least one hobby'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                key: const Key('passwordField'),
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Password is required'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                key: const Key('confirmPasswordField'),
                controller: confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirm password',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                key: const Key('ageField'),
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Age'),
                validator: (value) {
                  final age = int.tryParse(value ?? '');
                  return age == null || age < 1 ? 'Enter a valid age' : null;
                },
              ),
              const SizedBox(height: 24),
              FilledButton(onPressed: saveProfile, child: const Text('Save')),
            ],
          ),
        ),
      ),
    );
  }
}
