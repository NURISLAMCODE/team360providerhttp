final validator = _Validators();

class _Validators {

  String? nameValidator(val) {
    return val.isEmpty ? 'The field is empty' : null;
  }

  String? phoneNoValidator(val) {
    return RegExp(r"(01[0-9][0-9]{8})$").hasMatch(val) ? null : "Please enter valid number";
  }

  String? passwordValidator(val) {
    return val.length < 4 ? "Needs at least 4 characters" : null;
  }

  String? emailValidator(val) {

    return RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$").hasMatch(val) ? null : "Please enter valid email";
  }
}