import 'dart:io';
import 'dart:convert';

void main() {
  var args = new List<String>();
  args.add("Hello");
  args.add("World");

  String output = RunJava(args);
}

String RunJava(List<String> args) {

  List<String> arguments = new List<String>();
  arguments.add('-jar');
  arguments.add('c:\\Users\\KadeB\\source\\flutter\\Projects\\boilermakeII\\BoilerMake\\lib\\JavaFile.jar');

  if(args != null) {
    for (int x = 0; x < args.length; x++) {
      arguments.add(args[x]);
    }
  }

  Process.start('java', arguments).then((Process process) {
    process.stdout
        .transform(utf8.decoder)
        .listen((data) { print(data); }); });
}