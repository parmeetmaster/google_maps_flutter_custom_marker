


import 'package:uuid/uuid.dart';

class UuidGenerator {

  getV4Uuid(){
    var uuid = Uuid();
    return uuid.v4();
  }
}