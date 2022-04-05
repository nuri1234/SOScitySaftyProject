class my_images{
  static int count=0;
  static List<String> _paths=[];
   static List<String> base64EncodeImages=[];
  static putPath(String path){
    _paths.add(path);
  }

  static putbase64EncodeImages(String img){
    print("here");
    base64EncodeImages.insert(count,img);
    count++;
  }
  static restart(){
    int count=0;
    _paths.clear();
   base64EncodeImages.clear();

  }

  static List<String> getputbase64EncodeImagess(){
    return base64EncodeImages;

  }
  static List<String> getPaths(){
    return _paths;

  }
}