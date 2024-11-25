final RegExp emailRegExp = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
final RegExp passwordRegExp = RegExp(r"^(?=.*\d)(?=.*[a-z])(?=.*[a-zA-Z]).{8,}$");
final RegExp nameRegExp = RegExp(r"^[a-zA-Z\u0621-\u064A\u0660-\u0669]+(?: [a-zA-Z\u0621-\u064A\u0660-\u0669]+)*$");


const String placeholderPFP = "https://cdn-icons-png.flaticon.com/512/149/149071.png";
