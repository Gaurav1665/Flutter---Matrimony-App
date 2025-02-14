import 'dart:io';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/src/material/date_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:matrimony_app/Model/userModel.dart';
import 'package:matrimony_app/Provider/userProvider.dart';
import 'package:matrimony_app/Screens/bottomNavigator.dart';
import 'package:matrimony_app/Services/validator.dart';
import 'package:matrimony_app/Widgets/customWidgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class AddUserScreen extends StatefulWidget {
  final int? userId;
  AddUserScreen({super.key, this.userId});

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  TextEditingController? _fullNameController;
  TextEditingController? _emailController;
  TextEditingController? _contactController;
  TextEditingController? _passwordController;
  TextEditingController? _confirmPasswordController;
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDOB;
  XFile? _pickedImage;
  String? _savedImagePath;
  String? _selectedCity;
  String? _selectedGender;
  final List<String> cities = ["Mumbai", "Delhi", "Bangalore", "Kolkata", "Chennai", "Hyderabad"];
  final List<String> hobbies = ["Reading", "Traveling", "Gaming", "Cooking", "Sports"];
  List<String> _selectedHobbies = [];
  bool passwordVisible = true;
  bool confirmPasswordVisible = true;
  bool? _isFavorite;

  @override
  void initState() {
    super.initState();
    _initializeEmptyFields();
    if (widget.userId != null) {
      _loadUserData();
    }
  }

  void _loadUserData() async {
    try {
      UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
      UserModel user = await userProvider.fetchUserById(widget.userId!);
      setState(() {
        _savedImagePath = user.userImage;
        _pickedImage = XFile(user.userImage);
        _fullNameController = TextEditingController(text: user.userFullName);
        _emailController = TextEditingController(text: user.userEmail);
        _contactController = TextEditingController(text: user.userContact);
        _passwordController = TextEditingController(text: user.password);
        _confirmPasswordController = TextEditingController(text: user.password);
        _selectedCity = user.userCity;
        _selectedGender = user.userGender;
        _selectedDOB = DateTime.parse(user.userDOB);
        _selectedHobbies = user.userHobbies.split(" ");
        _isFavorite = user.isFavorite;
      });
    } catch (e) {
      Fluttertoast.showToast(msg: "Error loading user data: $e", backgroundColor: Colors.redAccent);
    }
  }

  void _initializeEmptyFields() {
    _fullNameController = TextEditingController();
    _emailController = TextEditingController();
    _contactController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  void _clearFields(){
    _savedImagePath = null;
    _pickedImage = null;
    _fullNameController!.clear();
    _emailController!.clear();
    _contactController!.clear();
    _passwordController!.clear();
    _confirmPasswordController!.clear();
    _selectedCity = null;
    _selectedGender = null;
    _selectedDOB = null;
    _selectedHobbies = [];
  }


  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    _clearFields();
  }

  @override
  void dispose(){
    // TODO: implement dispose
    super.dispose();
    _clearFields();
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
  DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: _selectedDOB ?? DateTime(DateTime.now().year - 18),
    firstDate: DateTime(DateTime.now().year - 80),
    lastDate: DateTime(DateTime.now().year - 18)
  );

  if (pickedDate != null) {
    setState(() {
      _selectedDOB = pickedDate;
    });
  }
}

  void _showCustomHobbiesDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
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
                          if (isChecked == true) {
                            _selectedHobbies.add(hobby);
                          } else {
                            _selectedHobbies.remove(hobby);
                          }
                        });
                        setState(() {});
                        print(_selectedHobbies);
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

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    CustomWidgets cw = CustomWidgets();
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
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
                          onTap: localImagePicker,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: Image.file(File(_savedImagePath!), fit: BoxFit.cover),
                          ),
                        )
                      : GestureDetector(
                          onTap: localImagePicker,
                          child: Container(
                            decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(20)),
                            child: Center(child: Text("Pick Image")),
                          ),
                        ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        cw.CustomInputField(label: "Full Name", controller: _fullNameController!,prefixIcon: Icon(Icons.person), inputType: TextInputType.text, textCapitalization: TextCapitalization.words, validator: Validators.nameValidator),
                        const SizedBox(height: 20),
                        cw.CustomInputField(label: "Email", controller: _emailController!,prefixIcon: Icon(Icons.email), inputType: TextInputType.emailAddress, validator: Validators.emailValidator),
                        const SizedBox(height: 20),
                        cw.CustomInputField(label: "Contact Number", controller: _contactController!,prefixIcon: Icon(Icons.call), inputType: TextInputType.phone, validator: Validators.mobileNumberValidator),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: _showDatePicker,
                          child: Container(
                            height: size.height*0.08,
                            decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade600), borderRadius: BorderRadius.circular(20)),
                            padding: const EdgeInsets.symmetric(horizontal: 15.0),
                            alignment: Alignment.centerLeft,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.date_range),
                                    SizedBox(width: size.width*0.02),
                                    Text("DOB", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey.shade800)),
                                  ],
                                ),
                                Text(
                                  _selectedDOB != null ? DateFormat('dd/MM/yyyy').format(_selectedDOB!) : "Select Date",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: _selectedDOB != null ? Colors.black : Colors.grey.shade600),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          height: size.height*0.08,
                          decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade600), borderRadius: BorderRadius.circular(20)),
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          alignment: Alignment.centerLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.location_city ),
                                    SizedBox(width: size.width*0.02),
                                  Text("City", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey.shade800)),
                                ],
                              ),
                              Container(
                                width: size.width*0.6,
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
                        const SizedBox(height: 20),
                        Container(
                          height: size.height*0.08,
                          decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade600), borderRadius: BorderRadius.circular(20)),
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          alignment: Alignment.centerLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image.asset("asset/images/gender-dark.png",width: 24, height: 24,),
                                  SizedBox(width: size.width*0.02),
                                  Text("Gender", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey.shade800)),
                                ],
                              ),
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
                          height: size.height*0.08,
                          decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade600), borderRadius: BorderRadius.circular(20)),
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          alignment: Alignment.centerLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.check_box_outlined),
                                  SizedBox(width: size.width*0.02),
                                  Text("Hobbies", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey.shade800)),
                                ],
                              ),
                              IconButton(icon: const Icon(Icons.edit, color: Colors.grey), onPressed: _showCustomHobbiesDialog),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        cw.CustomInputField(label: "Password", controller: _passwordController!, obscureText: passwordVisible, prefixIcon: Icon(Icons.lock), suffixIcon: Icon(passwordVisible ? Icons.visibility_off : Icons.visibility), iconOnPress: () => setState(() => passwordVisible = !passwordVisible), validator: Validators.passwordValidator),
                        const SizedBox(height: 20),
                        cw.CustomInputField(label: "Confirm Password", controller: _confirmPasswordController!, obscureText: confirmPasswordVisible, prefixIcon: Icon(Icons.lock), suffixIcon: Icon(confirmPasswordVisible ? Icons.visibility_off : Icons.visibility), iconOnPress: () => setState(() => confirmPasswordVisible = !confirmPasswordVisible), validator: Validators.passwordValidator),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          child: Text(widget.userId != null ? "Update User" : "Add User"),
                          onPressed: () async {
                            if (_passwordController!.text != _confirmPasswordController!.text) {
                              Fluttertoast.showToast(msg: "Password and Confirm Password do not match", backgroundColor: Colors.redAccent);
                            } else if (_pickedImage == null) {
                              Fluttertoast.showToast(msg: "Please Select a Profile Picture", backgroundColor: Colors.redAccent);
                            } else if (_selectedCity == null) {
                              Fluttertoast.showToast(msg: "Please select User's City", backgroundColor: Colors.redAccent);
                            } else if (_selectedGender == null) {
                              Fluttertoast.showToast(msg: "Please select User's Gender", backgroundColor: Colors.redAccent);
                            } else if (_selectedHobbies.isEmpty) {
                              Fluttertoast.showToast(msg: "Please select User's Hobbies", backgroundColor: Colors.redAccent);
                            } else if (_formKey.currentState!.validate()) {
                              String hobbiesString = _selectedHobbies.join(" ");
                              if (widget.userId == null) {
                                await userProvider.addUser (user: UserModel(
                                  userFullName: _fullNameController!.text,
                                  userImage: _savedImagePath!,
                                  userEmail: _emailController!.text,
                                  userContact: _contactController!.text,
                                  userCity: _selectedCity!,
                                  userGender: _selectedGender!,
                                  userDOB: _selectedDOB.toString(),
                                  userHobbies: hobbiesString,
                                  password: _passwordController!.text,
                                  isFavorite: false,
                                ));
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => RootScreen()));
                              } else {
                                await userProvider.updateUser (user: UserModel(
                                  userId: widget.userId!,
                                  userFullName: _fullNameController!.text,
                                  userImage: _savedImagePath!,
                                  userEmail: _emailController!.text,
                                  userContact: _contactController!.text,
                                  userCity: _selectedCity!,
                                  userGender: _selectedGender!,
                                  userDOB: _selectedDOB.toString(),
                                  userHobbies: hobbiesString,
                                  password: _passwordController!.text,
                                  isFavorite: _isFavorite!,
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
      ),
    );
  }
}