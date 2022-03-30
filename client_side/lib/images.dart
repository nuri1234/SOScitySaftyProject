
import 'dart:io';




class my_images{
  static int count=0;
  static List<String> _paths=[];

  static  File? imageFile1;
  static  File? imageFile2;
  static  File? imageFile3;

  static putPath(String path){
    _paths.add(path);
  }

  static List<String> getPaths(){
    return _paths;

  }
}