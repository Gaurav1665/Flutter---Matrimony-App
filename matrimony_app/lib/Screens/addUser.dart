import 'dart:io';
import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:matrimony_app/Model/userModel.dart';
import 'package:matrimony_app/Provider/userProvider.dart';
import 'package:matrimony_app/Screens/bottomNavigator.dart';
import 'package:matrimony_app/Services/validator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class AddUserScreen extends StatefulWidget {
  final UserModel? user;
  AddUserScreen({super.key, this.user});

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _contactController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDOB;
  XFile? _pickedImage;
  String? _savedImagePath;
  String? _selectedCity;
  String? _selectedGender;
  final List<String> cities = ["Mumbai", "Delhi", "Bangalore", "Kolkata", "Chennai", "Hyderabad"];
  final List<String> hobbies = ["Reading", "Traveling", "Gaming", "Cooking", "Sports"];
  List<String> _selectedHobbies = [];
  bool passwordVisible = false;
  bool confirmPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.user?.userFirstName);
    _lastNameController = TextEditingController(text: widget.user?.userLastName);
    _emailController = TextEditingController(text: widget.user?.userEmail);
    _contactController = TextEditingController(text: widget.user?.userContact);
    _passwordController = TextEditingController(text: widget.user?.password);
    _confirmPasswordController = TextEditingController(text: widget.user?.password);
    _selectedCity = widget.user?.userCity;
    _selectedGender = widget.user?.userGender;
    _selectedDOB = widget.user != null ? DateTime.parse(widget.user!.userDOB) : null;
    _selectedHobbies = widget.user?.userHobbies.split(" ") ?? [];
  }

  Future<void> localImagePicker() async {
    final ImagePicker imagePicker = ImagePicker();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Choose Image Source"),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              _pickedImage = await imagePicker.pickImage(source: ImageSource.camera, imageQuality: 25);
              if (_pickedImage != null) await _saveImageToFolder(_pickedImage!);
            },
            child: const Text("Camera"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              _pickedImage = await imagePicker.pickImage(source: ImageSource.gallery, imageQuality: 25);
              if (_pickedImage != null) await _saveImageToFolder(_pickedImage!);
            },
            child: const Text("Gallery"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _pickedImage = null;
                _savedImagePath = null;
              });
            },
            child: const Text("Remove"),
          ),
        ],
      ),
    );
  }

  Future<void> _saveImageToFolder(XFile imageFile) async {
    final Directory appDir = await getApplicationDocumentsDirectory();
    final Directory imageDir = Directory('${appDir.path}/SavedImages/User/');
    if (!await imageDir.exists()) await imageDir.create(recursive: true);
    final String newImagePath = '${imageDir.path}${DateTime.now().millisecondsSinceEpoch}.jpg';
    await File(imageFile.path).copy(newImagePath);
    setState(() {
      _savedImagePath = newImagePath;
    });
  }

  Future<void> _showDatePicker() async {
    DateTime? pickedDate = await showBoardDateTimePicker(
      context: context,
      pickerType: DateTimePickerType.date,
      initialDate: _selectedDOB ?? DateTime.now(),
      maximumDate: DateTime(DateTime.now().year - 18),
      minimumDate: DateTime(DateTime.now().year - 80),
    );
    if (pickedDate != null) setState(() => _selectedDOB = pickedDate);
  }

  void _showHobbiesDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStateDialog) {
            return AlertDialog(
              title: const Text("Select Hobbies"),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView(
                  shrinkWrap: true,
                  children: hobbies.map((hobby) {
                    return CheckboxListTile(
                      title: Text(hobby),
                      value: _selectedHobbies.contains(hobby),
                      onChanged: (bool? isChecked) {
                        setState(() {
                          if (isChecked == true) _selectedHobbies.add(hobby);
                          else _selectedHobbies.remove(hobby);
                        });
                        setStateDialog(() {});
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("Done")),
              ],
            );
          },
        );
      },
    );
  }

  Widget _CustomInputField({
    required String label,
    required TextEditingController controller,
    bool obscureText = false,
    TextInputType? inputType,
    Icon? icon,
    VoidCallback? iconOnPress,
    void Function(String)? onSubmitted,
    FormFieldValidator<String>? validator,
  }) {
    return TextFormField(
      obscureText: obscureText,
      controller: controller,
      textInputAction: TextInputAction.next,
      keyboardType: inputType,
      decoration: InputDecoration(
        suffixIcon: icon != null ? IconButton(icon: icon, onPressed: iconOnPress) : null,
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        labelText: label,
        hintText: label,
      ),
      onFieldSubmitted: onSubmitted,
      validator: validator,
    );
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: size.width * 0.4,
                width: size.width * 0.4,
                child: _savedImagePath != null
                    ? GestureDetector(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: Image.file(File(_savedImagePath!), fit: BoxFit.cover),
                        ),
                        onTap: localImagePicker,
                      )
                    : GestureDetector(
                        child: Container(
                          decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(20)),
                          child: Center(child: Text("Pick Image")),
                        ),
                        onTap: localImagePicker,
                      ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _CustomInputField(label: "First Name", controller: _firstNameController, inputType: TextInputType.name, validator: Validators.nameValidator),
                      const SizedBox(height: 20),
                      _CustomInputField(label: "Last Name", controller: _lastNameController, inputType: TextInputType.name, validator: Validators.nameValidator),
                      const SizedBox(height: 20),
                      _CustomInputField(label: "Email", controller: _emailController, inputType: TextInputType.emailAddress, validator: Validators.emailValidator),
                      const SizedBox(height: 20),
                      _CustomInputField(label: "Contact Number", controller: _contactController, inputType: TextInputType.phone, validator: Validators.mobileNumberValidator),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: _showDatePicker,
                        child: Container(
                          height: 56.0,
                          decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade600), borderRadius: BorderRadius.circular(20)),
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          alignment: Alignment.centerLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("DOB", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey.shade800)),
                              Text(
                                _selectedDOB != null ? "${_selectedDOB!.day}/${_selectedDOB!.month}/${_selectedDOB!.year}" : "Select Date",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: _selectedDOB != null ? Colors.black : Colors.grey.shade600),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        height: 56.0,
                        decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade600), borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("City", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey.shade800)),
                            DropdownSearch<String>(
                              items: (filter, loadProps) => cities,
                              selectedItem: _selectedCity ?? "Select City",
                              onChanged: (String? value) => setState(() => _selectedCity = value),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        height: 56.0,
                        decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade600), borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Gender", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey.shade800)),
                            Row(
                              children: [
                                Radio<String>(value: "Male", groupValue: _selectedGender, onChanged: (String? value) => setState(() => _selectedGender = value)),
                                const Text("Male"),
                                const SizedBox(width: 10),
                                Radio<String>(value: "Female", groupValue: _selectedGender, onChanged: (String? value) => setState(() => _selectedGender = value)),
                                const Text("Female"),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        height: 56.0,
                        decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade600), borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Hobbies", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey.shade800)),
                            IconButton(icon: const Icon(Icons.edit, color: Colors.grey), onPressed: _showHobbiesDialog),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      _CustomInputField(label: "Password", controller: _passwordController, obscureText: passwordVisible, icon: Icon(passwordVisible ? Icons.visibility_off : Icons.visibility), iconOnPress: () => setState(() => passwordVisible = !passwordVisible), validator: Validators.passwordValidator),
                      const SizedBox(height: 20),
                      _CustomInputField(label: "Confirm Password", controller: _confirmPasswordController, obscureText: confirmPasswordVisible, icon: Icon(confirmPasswordVisible ? Icons.visibility_off : Icons.visibility), iconOnPress: () => setState(() => confirmPasswordVisible = !confirmPasswordVisible), validator: Validators.passwordValidator),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        child: Text(widget.user != null ? "Update User" : "Add User"),
                        onPressed: () async {
                          if (_passwordController.text != _confirmPasswordController.text) {
                            print("Password and Confirm Password do not match");
                          } else if (_pickedImage == null) {
                            print("Please Select a Profile Picture");
                          } else if (_selectedCity == null) {
                            print("Please select User's City");
                          } else if (_selectedGender == null) {
                            print("Please select User's Gender");
                          } else if (_selectedHobbies.isEmpty) {
                            print("Please select User's Hobbies");
                          } else if (_formKey.currentState!.validate()) {
                            String hobbiesString = _selectedHobbies.join(" ");
                            if (widget.user == null) {
                              await userProvider.addUser (user: UserModel(
                                userFirstName: _firstNameController.text,
                                userLastName: _lastNameController.text,
                                userImage: _savedImagePath!,
                                userEmail: _emailController.text,
                                userContact: _contactController.text,
                                userCity: _selectedCity!,
                                userGender: _selectedGender!,
                                userDOB: _selectedDOB.toString(),
                                userHobbies: hobbiesString,
                                password: _passwordController.text,
                                isFavorite: false,
                              ));
                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => RootScreen()));
                            } else {
                              await userProvider.updateUser (user: UserModel(
                                userId: widget.user!.userId,
                                userFirstName: _firstNameController.text,
                                userLastName: _lastNameController.text,
                                userImage: _savedImagePath!,
                                userEmail: _emailController.text,
                                userContact: _contactController.text,
                                userCity: _selectedCity!,
                                userGender: _selectedGender!,
                                userDOB: _selectedDOB.toString(),
                                userHobbies: hobbiesString,
                                password: _passwordController.text,
                                isFavorite: false,
                              ));
                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => RootScreen()));
                            }
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}