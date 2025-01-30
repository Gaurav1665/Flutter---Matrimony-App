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
  UserModel? user;
  AddUserScreen({super.key,this.user});

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  TextEditingController? _firstNameController;
  TextEditingController? _lastNameController;
  TextEditingController? _emailController;
  TextEditingController? _contactController;
  TextEditingController? _passwordController;
  TextEditingController? _confirmPasswordController;
  final _formKey = GlobalKey<FormState>();

  DateTime? _selectedDOB;
  
  XFile? _pickedImage;
  String? _savedImagePath;

  List<String> cities = ["Mumbai", "Delhi", "Bangalore", "Kolkata", "Chennai", "Hyderabad"];
  String? _selectedCity;

  String? _selectedGender;

  final List<String> hobbies = ["Reading", "Traveling", "Gaming", "Cooking", "Sports"];

  List<String> _selectedHobbies = [];

  bool passwordVisible = false;
  bool confirmPasswordVisible = false;

  //Function to save image
  Future<void> _saveImageToFolder(XFile imageFile) async {
    try {
      final Directory appDir = await getApplicationDocumentsDirectory();

      final Directory imageDir = Directory('${appDir.path}/SavedImages/User/');
      if (!await imageDir.exists()) {
        await imageDir.create(recursive: true);
        print('Created new directory at: ${imageDir.path}');
      }

      final String newImagePath = '${imageDir.path}${DateTime.now().millisecondsSinceEpoch}.jpg';

      final File savedImage = await File(imageFile.path).copy(newImagePath);

      setState(() {
        _savedImagePath = savedImage.path;
      });

      print('Image saved to: $newImagePath');
    } catch (e, stackTrace) {
      print('Error saving image: $e');
      print('Stack trace: $stackTrace');
    }
  }

  //Function to pick local device image
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
              _pickedImage = await imagePicker.pickImage(source: ImageSource.camera,imageQuality: 25,);
              if (_pickedImage != null) {
                print("Image picked: ${_pickedImage!.path}");
                await _saveImageToFolder(_pickedImage!);
              }
            },
            child: const Text("Camera"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              _pickedImage = await imagePicker.pickImage(source: ImageSource.gallery,imageQuality: 25,);
              if (_pickedImage != null) {
                print("Image picked: ${_pickedImage!.path}");
                await _saveImageToFolder(_pickedImage!);
              }
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

  //function for picking date
  Future<void> _showDatePicker() async {
    DateTime? pickedDate = await showBoardDateTimePicker(
      context: context,
      pickerType: DateTimePickerType.date,
      initialDate: _selectedDOB ?? DateTime.now(),
      maximumDate: DateTime(DateTime.now().year-18),
      minimumDate: DateTime(DateTime.now().year-80)
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDOB = pickedDate;
      });
      print("Saved image path: $_savedImagePath");
    }
  }

  //function for Hobbies
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
                        // Update both dialog and parent widget's state
                        setState(() {
                          if (isChecked == true) {
                            _selectedHobbies.add(hobby);
                          } else {
                            _selectedHobbies.remove(hobby);
                          }
                        });
                        setStateDialog(() {}); // Update dialog state
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(), // Close dialog
                  child: const Text("Done"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  //Custom widget for TextFormField
  Widget _CustomInputField({
    required String label, 
    required TextEditingController controller, 
    bool obscureText = false, 
    TextInputType? inputType, 
    Icon? icon, 
    VoidCallback? iconOnPress, 
    void Function(String)? onSubmitted,
    FormFieldValidator<String>? validator
  }){
    return TextFormField(
      obscureText: obscureText,
      controller: controller,
      textInputAction: TextInputAction.next,
      keyboardType: inputType,
      decoration: InputDecoration(
        suffixIcon: icon!=null ? IconButton(icon: icon,onPressed: iconOnPress):Icon(null),
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
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.user != null){
      _savedImagePath = widget.user!.userImage;
      _pickedImage = XFile(widget.user!.userImage);
      _firstNameController = TextEditingController(text: widget.user!.userFirstName);
      _lastNameController = TextEditingController(text: widget.user!.userLastName);
      _emailController = TextEditingController(text: widget.user!.userEmail);
      _contactController = TextEditingController(text: widget.user!.userContact);
      _passwordController = TextEditingController(text: widget.user!.password);
      _confirmPasswordController = TextEditingController(text: widget.user!.password);
      _selectedCity = widget.user!.userCity;
      _selectedGender = widget.user!.userGender;
      _selectedDOB = DateTime.parse(widget.user!.userDOB);
      _selectedHobbies = widget.user!.userHobbies.split(',');
    }
    else{
      _firstNameController = TextEditingController();
      _lastNameController = TextEditingController();
      _emailController = TextEditingController();
      _contactController = TextEditingController();
      _passwordController = TextEditingController();
      _confirmPasswordController = TextEditingController();
    }
  }
  
  @override
  Widget build(BuildContext context) {
  UserProvider userProvider = Provider.of<UserProvider>(context);
    Size size=MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: size.width*0.4,
                width: size.width*0.4,
                child: _savedImagePath != null
                ? GestureDetector(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Image.file(
                      File(_savedImagePath!),
                      fit: BoxFit.cover,
                    ),
                  ),
                  onTap: () {
                    localImagePicker();
                  },
                )
                : GestureDetector(
                  child: Container(
                    decoration: BoxDecoration(border: Border.all(color: Colors.black),borderRadius: BorderRadius.circular(20)),
                    child: Center(child: Text("Pick Image"),),
                  ),
                  onTap: () {
                    localImagePicker();
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _CustomInputField(
                        label: "First Name", 
                        controller: _firstNameController!, 
                        inputType: TextInputType.name,
                        validator: (value) => Validators.nameValidator(value),
                      ),
                      const SizedBox(height: 20),
                      _CustomInputField(
                        label: "Last Name", 
                        controller: _lastNameController!, 
                        inputType: TextInputType.name,
                        validator: (value) => Validators.nameValidator(value),
                      ),
                      const SizedBox(height: 20),
                      _CustomInputField(
                        label: "Email", 
                        controller: _emailController!, 
                        inputType: TextInputType.emailAddress,
                        validator: (value) => Validators.emailValidator(value),
                      ),
                      const SizedBox(height: 20),
                      _CustomInputField(
                        label: "Contact Number", 
                        controller: _contactController!, 
                        inputType: TextInputType.phone,
                        validator: (value) => Validators.mobileNumberValidator(value),
                        ),
                      const SizedBox(height: 20,),
                      GestureDetector(
                        onTap: _showDatePicker,
                        child: Container(
                          height: 56.0,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade600),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          alignment: Alignment.centerLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "DOB",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey.shade800
                                ),
                              ),
                              Text(
                                _selectedDOB != null
                                    ? "${_selectedDOB!.day}/${_selectedDOB!.month}/${_selectedDOB!.year}"
                                    : "Select Date",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: _selectedDOB != null ? Colors.black : Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20,),
                      Container(
                        height: 56.0,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade600),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "City",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade800,
                              ),
                            ),

                            Container(
                              width: size.width*0.4,
                              child: DropdownSearch<String>(
                                decoratorProps: DropDownDecoratorProps(
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                  textAlign: TextAlign.center,
                                  textAlignVertical: TextAlignVertical.center
                                ),
                                popupProps: PopupProps.menu(
                                  showSearchBox: true,
                                  searchFieldProps: const TextFieldProps(
                                    decoration: InputDecoration(
                                      labelText: 'Search city',
                                    ),
                                  ),
                                ),
                                items: (filter, loadProps) => cities,
                                selectedItem: _selectedCity??"Select City",
                                onChanged: (String? value) {
                                  setState(() {
                                    _selectedCity = value;
                                  });
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 20,),
                      Container(
                        height: 56.0,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade600),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Gender",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade800,
                              ),
                            ),
                            Row(
                              children: [
                                Radio<String>(
                                  value: "Male",
                                  groupValue: _selectedGender,
                                  onChanged: (String? value) {
                                    setState(() {
                                      _selectedGender = value;
                                    });
                                  },
                                ),
                                const Text("Male"),
                                const SizedBox(width: 10,),
                                Radio<String>(
                                  value: "Female",
                                  groupValue: _selectedGender,
                                  onChanged: (String? value) {
                                    setState(() {
                                      _selectedGender = value;
                                    });
                                  },
                                ),
                                const Text("Female"),
                              ],
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 20,),
                      Container(
                        height: 56.0,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade600),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Hobbies",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade800,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.grey),
                              onPressed: () {
                                _showHobbiesDialog();
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20,),
                      _CustomInputField(
                        label: "Password", 
                        controller: _passwordController!,
                        icon: Icon(passwordVisible ? Icons.visibility_off : Icons.visibility),
                        iconOnPress: () => setState(() {passwordVisible = !passwordVisible;}),
                        obscureText: passwordVisible,
                        validator: (value) => Validators.passwordValidator(value),
                      ),
                      const SizedBox(height: 20,),
                      _CustomInputField(
                        label: "Confirm Password", 
                        controller: _confirmPasswordController!,
                        icon: Icon(confirmPasswordVisible ? Icons.visibility_off : Icons.visibility),
                        iconOnPress: () => setState(() {confirmPasswordVisible = !confirmPasswordVisible;}),
                        obscureText: confirmPasswordVisible,
                        validator: (value) => Validators.passwordValidator(value),
                      ),
                      const SizedBox(height: 20,),
                      ElevatedButton(
                        child: widget.user!=null ? Text("Update User") : Text("Add User"),
                        onPressed: () {
                          if(_passwordController!.text != _confirmPasswordController!.text){
                            print("Password and Confirm Password does not match");
                          }
                          else if(_pickedImage == null){
                            print("Please Select a Profile Picture");
                          }
                          else if(_selectedCity == null){
                            print("Please select User's City");
                          }
                          else if(_selectedGender == null){
                            print("Please select User's Gender");
                          }
                          else if(_selectedHobbies.isEmpty){
                            print("Please select User's Hobbies");
                          }
                          else if(_formKey.currentState!.validate()){
                            if(widget.user == null){
                              UserModel user = UserModel(
                                userId: userProvider.index, 
                                userFirstName: _firstNameController!.text, 
                                userLastName: _lastNameController!.text, 
                                userImage: _savedImagePath!, 
                                userEmail: _emailController!.text, 
                                userContact: _contactController!.text, 
                                userCity: _selectedCity!, 
                                userGender: _selectedGender!, 
                                userDOB: _selectedDOB.toString(), 
                                userHobbies: _selectedHobbies.toString(), 
                                password: _passwordController!.text, 
                                isFavorite: 0
                              );
                              userProvider.addUser(user: user);
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => RootScreen(),));
                            }
                            else{
                               UserModel user = UserModel(
                                userId: widget.user!.userId, 
                                userFirstName: _firstNameController!.text, 
                                userLastName: _lastNameController!.text, 
                                userImage: _savedImagePath!, 
                                userEmail: _emailController!.text, 
                                userContact: _contactController!.text, 
                                userCity: _selectedCity!, 
                                userGender: _selectedGender!, 
                                userDOB: _selectedDOB.toString(), 
                                userHobbies: _selectedHobbies.toString(), 
                                password: _passwordController!.text, 
                                isFavorite: 0
                              );
                              userProvider.updateUser(index: widget.user!.userId, user: user);
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => RootScreen(),));
                            }
                          }
                        },
                      )
                    ],
                  )
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}