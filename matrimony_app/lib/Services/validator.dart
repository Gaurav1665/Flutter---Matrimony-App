class Validators {
  static String? nameValidator(String? name) {
    if (name == null || name.trim().isEmpty) return 'Please enter your full name';
    if (name.length < 3 || name.length > 50) return 'Full Name must be between 3 and 50 characters';
    if (!RegExp(r"^[a-zA-Z\s'-]{3,50}$").hasMatch(name)) return 'Enter a valid full name (3-50 characters, alphabets only)';
    return null;
  }

  static String? passwordValidator(String? password) {
    if (password == null || password.trim().isEmpty) return 'Please enter your password';
    if (password.length < 6) return 'Password must be at least 6 characters long';
    return null;
  }

  static String? emailValidator(String? email) {
    if (email == null || email.trim().isEmpty) return 'Please enter your email address';
    if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(email)) return 'Enter a valid email address';
    return null;
  }

  static String? mobileNumberValidator(String? number) {
    if (number == null || number.trim().isEmpty) return 'Please enter your mobile number';
    if (!RegExp(r"^\+?[0-9]{10,15}$").hasMatch(number)) return 'Enter a valid 10-digit mobile number';
    return null;
  }
}