import 'dart:io';

import 'package:altibbi/enum.dart';
import 'package:altibbi/service/api_service.dart';
import 'package:altibbi_example/waiting_room.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:open_filex/open_filex.dart';  // Commented out due to READ_MEDIA permissions requirement
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class Consultation extends StatefulWidget {
  const Consultation({Key? key}) : super(key: key);

  @override
  State<Consultation> createState() => _ConsultationState();
}

class _ConsultationState extends State<Consultation> {
  TextEditingController idController = TextEditingController();
  TextEditingController deleteIdController = TextEditingController();
  TextEditingController questionBody = TextEditingController();
  TextEditingController prescriptionID = TextEditingController();

  String? errorText = "";

  Medium selectedMedium = Medium.chat;
  ApiService apiService = ApiService();

  String? errorDeleteText = "";
  String? errorEmptyBody = "";

  String? path;

  Future<void> _selectImage() async {
    final ImageSource? source = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Image Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source == null) return;

    if (source == ImageSource.camera) {
      final cameraStatus = await Permission.camera.status;
      if (!cameraStatus.isGranted) {
        final status = await Permission.camera.request();
        if (!status.isGranted) return;
      }
    }

    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      setState(() {
        path = image.path;
      });
    }
  }

  Future<void> _selectDocument() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        final filePath = result.files.single.path!;
        setState(() {
          path = filePath;
        });
      }
    } catch (e) {
      setState(() {
        errorEmptyBody = "Error picking document: $e";
      });
    }
  }

  void getConsultation() async {
    if (idController.text.isEmpty) {
      setState(() {
        errorText = 'Please enter an ID';
      });
    } else {
      var consultation = await apiService.getConsultationInfo(int.parse(idController.text));
      print("Consultation question For The ID ${idController.text} \n ${consultation.question}");
      setState((){
        errorText = null ;
      });

    }
  }
  void getPrescription() async {
    if (prescriptionID.text.isEmpty) {
      setState(() {
        errorText = 'Please enter an ID';
      });
    } else {
      final fileName = 'prescription${prescriptionID.text}.pdf'; // Replace with the desired file name and extension
      final tempDir = "/storage/emulated/0/Download";
      final savePath = '${tempDir}/$fileName';
      var prescriptionPath = await apiService.getPrescription(int.parse(prescriptionID.text),savePath);
      // OpenFilex.open(prescriptionPath);  // Commented out - open_filex requires forbidden permissions
      // Use alternative method to open files without requiring media permissions
      print("Prescription saved to: $prescriptionPath");
    }
  }

  void deleteConsultation() async {
    if (deleteIdController.text.isEmpty) {
      setState(() {
        errorDeleteText = 'Please enter an ID';
      });
    } else {
      var value = await apiService.deleteConsultation(int.parse(deleteIdController.text));
      print("delete Consultation with the id  ${deleteIdController.text}  status =  $value");
      setState(() {
        errorDeleteText = '';
      });
    }
  }
  void createConsultation() async{
    if(questionBody.text.isEmpty || questionBody.text.length <15){
      setState(() {
        errorEmptyBody='Please enter your question';
      });
    }else{
      var media ;
      if(path != null){
         media = await apiService.uploadMedia(File(path!));
      }
      try{
        var consultation = await apiService.createConsultation(
          question: questionBody.text,
          medium: selectedMedium,
          userID: 1, //Assigning consultation to User ID
          mediaIDs: media != null ? [media.id] : [] ,
        );
        if(consultation  != null && consultation.pusherChannel != null){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>
                WaitingRoom(pusherID: consultation.pusherChannel!, id: consultation.id!, pusherApiKey: consultation.pusherApiKey!)
            ),
          );
        }
      } catch(error){
        if(error is http.Response){
          print(error.statusCode);
        }
      }
    }

  }
  void getLastConsultation() async{
    var consultation = await apiService.getLastConsultation();
    print("last Consultation question =${consultation.id} => ${consultation.question}");
    if(consultation  != null && consultation.pusherChannel != null && consultation.status != "closed"){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>
                  WaitingRoom(pusherID: consultation.pusherChannel!, id: consultation.id!, pusherApiKey: consultation.pusherApiKey!)
              ),
            );
          }

  }
  void getConsultationList () async {
    var consultationList = await apiService.getConsultationList(page: 1, perPage: 30);
    print("Consultation List Length = ${consultationList.length}");
  }

  void getAiSupport () async {
    var predictSummary = await apiService.getPredictSummary(148);
    var transcription = await apiService.getTranscription(146);
    var soap = await apiService.getSoapSummary(147);
    var predictSpecialty = await apiService.getPredictSpecialty(149);
    print("Consultation List Length predictSummary= ${predictSummary.summary}");
    print("Consultation List Length transcription= ${transcription.transcript}");
    print("Consultation List Length soap= ${soap.summary}");
    print("Consultation List Length predictSpecialty= ${predictSpecialty[0].specialtyId}");
  }

  void rateConsultation () async {
    var rated = await apiService.rateConsultation(226, 4);
    print("consultation rated : $rated");
  }

  Future<void> attachAsCSV(List<Map<String, String>> jsonData) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final fileName = 'attach-consultation-${DateTime.now().millisecondsSinceEpoch}.csv';
      final filePath = '${directory.path}/$fileName';

      List<List<String>> rows = [];
      if (jsonData.isNotEmpty) {
        rows.add(jsonData.first.keys.toList());
        for (var row in jsonData) {
          rows.add(row.values.toList());
        }
      }

      String csvContent = const ListToCsvConverter().convert(rows);
      final file = File(filePath);
      await file.writeAsString(csvContent, flush: true);
      await apiService.uploadMedia(file);

    } catch (e) {
      print("Failed to attach CSV: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F4),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0099D1),
        title: const Text('Consultation Page'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
                top: 20.0, left: 20, right: 20, bottom: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: questionBody,
                  style: const TextStyle(fontSize: 16), // Customize the text style within the TextField
                  decoration: InputDecoration(
                    errorText: errorEmptyBody,
                    hintText: " Enter Your question",
                    contentPadding: const EdgeInsets.all(20.0), // Adjust the vertical padding within the TextField
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    DropdownButton<Medium>(
                      value: selectedMedium,
                      onChanged: (newValue) {
                        setState(() {
                          selectedMedium = newValue!;
                        });
                      },
                      items:
                          Medium.values.map<DropdownMenuItem<Medium>>((item) {
                        return DropdownMenuItem<Medium>(
                          value: item,
                          child: Text(item.toString().split('.').last),
                        );
                      }).toList(),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      icon: const Icon(Icons.camera_alt),
                      onPressed: _selectImage,
                      tooltip: 'Pick Image',
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      icon: const Icon(Icons.insert_drive_file),
                      onPressed: _selectDocument,
                      tooltip: 'Pick Document',
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0099D1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextButton(
                          onPressed: createConsultation,
                          child: const Text(
                            "create consulttion",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        keyboardType:  TextInputType.number,
                        controller: prescriptionID,
                        decoration: InputDecoration(
                          labelText: 'id',
                          errorText: errorText,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 4,
                      child: ElevatedButton(
                        onPressed: getPrescription,
                        child: const Text('download prescription'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        keyboardType:  TextInputType.number,
                        controller: idController,
                        decoration: InputDecoration(
                          labelText: 'ID',
                          errorText: errorText,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 4,
                      child: ElevatedButton(
                        onPressed: getConsultation,
                        child: const Text('Get Consultation ID'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        keyboardType:  TextInputType.number,

                        controller: deleteIdController,
                        decoration: InputDecoration(
                          labelText: 'ID',
                          errorText: errorDeleteText,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 4,
                      child: ElevatedButton(
                        onPressed: deleteConsultation,
                        child: const Text('Delete Consultation'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0099D1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextButton(
                    onPressed: getLastConsultation,
                    child: const Text(
                      "get last consulttion",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0099D1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextButton(
                    onPressed: getConsultationList,
                    child: const Text(
                      "get consultation list",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0099D1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextButton(
                    onPressed: getAiSupport,
                    child: const Text(
                      "get ai support ",
                      style: TextStyle(color: Colors.white, fontSize: 20),
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
