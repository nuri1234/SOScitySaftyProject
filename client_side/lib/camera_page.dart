import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'texts.dart';
import 'colors.dart';
import 'sos_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'images.dart';


class camera_page extends StatefulWidget {
  const camera_page({Key? key}) : super(key: key);

  @override
  State<camera_page> createState() => _camera_pageState();
}

class _camera_pageState extends State<camera_page> {
  File? imageFile;
  bool _isButtonDisabled = false;
  final double button_h = 90;
  final double button_w = 90;
  final double button_fontSize = 15;
  List<File> _images = [];
  final int MAXIMAGES = 5;
  List<String> _paths=my_images.getPaths();

  ///////////////////////////////////////////////////////////////
  Widget nonImgContainer() =>Container(
    width: 450,
    height: 350,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: Colors.grey,
      border: Border.all(width: 8, color: Colors.black12),
      borderRadius: BorderRadius.circular(12.0),
    ),
    child: Center(child: Icon(
      Icons.add_box_outlined, color: Colors.black54, size: 50,)),
  );
  Widget bigImgContainer(File img) =>Container(
    width: 450,
    height: 350,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: Colors.grey,
      border: Border.all(width: 8, color: Colors.black12),
      borderRadius: BorderRadius.circular(12.0),
      image: DecorationImage(image: FileImage(img), fit: BoxFit.cover),
    ),

  );
  Widget imgBox(File img) => Container(
    height: 100,
    width: 80,
    padding: const EdgeInsets.all(0),
    //color: Colors.blue,
    alignment: Alignment.center,
    child: IconButton(
      onPressed: () {
        print("press");
      },
      icon: Image(image: FileImage(img)),
      iconSize: 90,

    ),

  );

  @override
  void initState(){
    super.initState();
    for(String p  in _paths){
      File newFile= File(p);

      _images.add(newFile);
    }

  }

  Widget imgFileContainer(File img) =>
      Container(
        height: 100,
        width: 100,
        padding: const EdgeInsets.all(10),
        //color: Colors.orange,
        child: Stack(children: [
          Align(alignment: Alignment.center, child: imgBox(img)),
          Align(alignment: const Alignment(-1, -1), child:
          SizedBox(
            height: 30,
            width: 30,
            // color: Colors.green,
            child: IconButton(
              padding: const EdgeInsets.all(0),
              iconSize: 80,
              onPressed: () {
                setState(() {
                  _images.remove(img);
                });
              },
              icon: const Icon(
                Icons.delete_forever_sharp, color: Colors.red, size: 30,
              ),
            ),
          ),)


        ],),

      );

  Widget buttonSelectText() =>
      Container(
        height: button_h,
        width: button_w,
        //color: Colors.black26,
        child: Center(child: Column(children: [
          const SizedBox(height: 25,),
          Text("select", style: TextStyle(color: app_colors.text_button,
              fontSize: button_fontSize,
              fontWeight: FontWeight.w500),),
          Text("image", style: TextStyle(color: app_colors.text_button,
              fontSize: button_fontSize,
              fontWeight: FontWeight.w500)),
        ],)),

      );

  Widget buttonCaptureText() =>
      Container(
        height: button_h,
        width: button_w,
        //color: Colors.black26,
        child: Center(child: Column(children: [
          const SizedBox(height: 25,),
          Text("capture", style: TextStyle(color: app_colors.text_button,
              fontSize: button_fontSize,
              fontWeight: FontWeight.w500),),
          Text("image", style: TextStyle(color: app_colors.text_button,
              fontSize: button_fontSize,
              fontWeight: FontWeight.w500)),
        ],)),

      );

  Widget selectImageButton() =>
      Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            boxShadow: [
              BoxShadow(
                  color: app_colors.buttom_shadow,
                  blurRadius: 20,
                  offset: const Offset(8, 5)

              ),
              BoxShadow(
                  color: app_colors.buttom_shadow,
                  blurRadius: 20,
                  offset: const Offset(-8, -5)

              ),
            ]
        ),
        child: SizedBox(
          height: button_h,
          width: button_w,
          child:
          FloatingActionButton(
            //child: Icon(Icons.ac_unit),
            child: buttonSelectText(),
            backgroundColor: app_colors.button,
            onPressed: () {
              _isButtonDisabled ? null :
              getImage(source: ImageSource.gallery);
              if (_images.length >= MAXIMAGES) {
                setState(() {
                  _isButtonDisabled = true;
                });
              }
            },
          ),
        ),
      );

  Widget captureImageButton() =>
      Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            boxShadow: [
              BoxShadow(
                  color: app_colors.buttom_shadow,
                  blurRadius: 20,
                  offset: const Offset(8, 5)

              ),
              BoxShadow(
                  color: app_colors.buttom_shadow,
                  blurRadius: 20,
                  offset: const Offset(-8, -5)

              ),
            ]
        ),
        child: SizedBox(
          height: button_h,
          width: button_w,
          child:
          ElevatedButton(
            //child: Icon(Icons.ac_unit),
            child: buttonCaptureText(),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100)
              ),
              primary: _isButtonDisabled ? app_colors.Disablebutton : app_colors
                  .button,
            ),
            onPressed: () {
              _isButtonDisabled ? null :
              getImage(source: ImageSource.camera);
              if (_images.length >= MAXIMAGES) {
                setState(() {
                  _isButtonDisabled = true;
                });
              }
            },
          ),
        ),
      );

  Widget imageListView() =>
      ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          for(File f in _images)
            imgFileContainer(f),

        ],


      );

  Widget imageContainer() =>
      Container(
        height: 100,
        width: 400,
        //color: Colors.pink,
        child: imageListView(),
      );

  Widget buttonContainer() =>
      Container(
        height: 100,
        width: 400,
        //color: Colors.green,
        child: Stack(children: [
          Align(
            alignment: const Alignment(-0.4, 0.0), child: selectImageButton(),),
          Align(
            alignment: const Alignment(0.4, 0.0), child: captureImageButton(),),

        ],),


      );

  void getImage({required ImageSource source}) async {
    final file = await ImagePicker().pickImage(source: source);

    if (file?.path != null) {
      setState(() {
        imageFile = File(file!.path);
        _images.add(File(file.path));
      });
    }
  }

  Widget cameraCancel() =>
      IconButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const Sos()));
        },
        icon: const Icon(Icons.cancel, color: Colors.red, size: 40,),
        tooltip: my_texts.cancel,
      );

  Widget cameraAccept() =>
      IconButton(
        onPressed: () async{

          int i=0;
          final directory = await getApplicationDocumentsDirectory();
          String path=directory.path;
          print(path);
          for(File f in _images){
             File newImage = await f.copy('$path/photo${i}.png');
             my_images.putPath(newImage.path);
             i++;

          }
          setState(() {

          });


          Navigator.push(context, MaterialPageRoute(builder: (context)=>const Sos()));

        },
        icon: const Icon(Icons.verified, color: Colors.green, size: 40,),
        tooltip: my_texts.continue_bot,
      );

  Widget cameraButtons() =>
      Container(
        height: 50,
        width: 100,
        //color: Colors.pink,
        child:
        Row(
          children: [
            cameraAccept(),
            cameraCancel(),
          ],
        )
        ,


      );


  Widget cameraPage() =>
      Padding(
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 1),
        child: Stack(
            children: [
              Column(
                children: [
                  if(imageFile == null)
                    nonImgContainer()
                  else
                    bigImgContainer(imageFile!),
                  if(_images.isNotEmpty)imageContainer(),
                  buttonContainer(),
                ],
              ),
            ]
        ),
      );

  //////////////////////////////////////////////////////////////////


  //////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: app_colors.background,
      appBar: AppBar(
        backgroundColor: app_colors.app_bar_background,
        title: Text(my_texts.capturing_Image, style: my_texts.buttonTextStyle,),
        centerTitle: true,
        actions: [
          cameraCancel(),
          cameraAccept(),

        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 5, 5, 1),
        child: Column(
          children: [
            if(imageFile == null)
              nonImgContainer()
            else
              bigImgContainer(imageFile!),
            if(_images.isNotEmpty)imageContainer(),
            buttonContainer(),
          ],
        ),
      ),
    );
  }
}


