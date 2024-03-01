import 'package:altibbi/model/user.dart';
import 'package:altibbi/service/api_service.dart';
import 'package:flutter/material.dart';

class PhrPage extends StatefulWidget {
  const PhrPage({Key? key}) : super(key: key);

  @override
  State<PhrPage> createState() => _PhrPageState();
}

class _PhrPageState extends State<PhrPage> {
  TextEditingController idController = TextEditingController();
  TextEditingController deleteIdController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController insuranceIdController = TextEditingController();
  TextEditingController policyNumberController = TextEditingController();
  TextEditingController nationalityNumberController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController bloodTypeController = TextEditingController();
  TextEditingController smokerController = TextEditingController();
  TextEditingController alcoholicController = TextEditingController();
  TextEditingController maritalStatusController = TextEditingController();
  String errorText = '';
  String errorDeleteText = '';
  ApiService apiService = ApiService();
  @override
  void dispose() {
    idController.dispose();
    deleteIdController.dispose();
    nameController.dispose();
    emailController.dispose();
    dateOfBirthController.dispose();
    genderController.dispose();
    insuranceIdController.dispose();
    policyNumberController.dispose();
    nationalityNumberController.dispose();
    heightController.dispose();
    weightController.dispose();
    bloodTypeController.dispose();
    smokerController.dispose();
    alcoholicController.dispose();
    maritalStatusController.dispose();
    super.dispose();
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        dateOfBirthController.text = pickedDate.toString().split(' ')[0];
      });
    }
  }

  void getPHRById()  async {
    if (idController.text.isEmpty) {
      setState(() {
        errorText = 'Please enter an ID';
      });
    } else {
      setState(() {
        errorText = '';
      });
      var user = await apiService.getUser(int.parse(idController.text));
      print("user email  = ${user.nationalityNumber}");
    }
  }
  void deletePhr() async{
    if (deleteIdController.text.isEmpty) {
      setState(() {
        errorText = 'Please enter an ID';
      });
    } else {
      setState(() {
        errorText = '';
      });
      var value = await apiService.deleteUser(int.parse(deleteIdController.text));
      print("user deleted status = ${value}");
    }
  }

  void createUser (Map user) async {
    var createUser = await apiService.createUser(User(name: user['name'] , nationalityNumber: user['nationality_number'] ));
    print ('user created with the id ${createUser.nationalityNumber}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F4),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0099D1),
        title: const Text('Phr Page'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
                top: 20.0, left: 20, right: 20, bottom: 40
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('create phr'),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(labelText: 'Name'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: nationalityNumberController,
                        decoration: InputDecoration(labelText: 'Nationality Number'),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(labelText: 'Email'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => selectDate(context),
                        child: AbsorbPointer(
                          child: TextFormField(
                            controller: dateOfBirthController,
                            decoration: InputDecoration(
                              labelText: 'Date of Birth',
                              suffixIcon: Icon(Icons.calendar_today),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: genderController,
                        decoration: InputDecoration(labelText: 'Gender'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: insuranceIdController,
                        decoration: InputDecoration(labelText: 'Insurance ID'),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: policyNumberController,
                        decoration: InputDecoration(labelText: 'Policy Number'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: heightController,
                        decoration: InputDecoration(labelText: 'Height'),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: weightController,
                        decoration: InputDecoration(labelText: 'Weight'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: bloodTypeController,
                        decoration: InputDecoration(labelText: 'Blood Type'),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: smokerController,
                        decoration: InputDecoration(labelText: 'Smoker'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: alcoholicController,
                        decoration: InputDecoration(labelText: 'Alcoholic'),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: maritalStatusController,
                        decoration:
                        InputDecoration(labelText: 'Marital Status'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    final  userData = {
                      'name': nameController.text.toString(),
                      'email': emailController.text.toString(),
                      'date_of_birth': dateOfBirthController.text.toString(),
                      'gender': genderController.text.toString(),
                      'insurance_id': insuranceIdController.text.toString(),
                      'policy_number': policyNumberController.text.toString(),
                      'nationality_number': nationalityNumberController.text.toString(),
                      'height': heightController.text.toString(),
                      'weight': weightController.text.toString(),
                      'blood_type': bloodTypeController.text.toString(),
                      'smoker': smokerController.text.toString(),
                      'alcoholic': alcoholicController.text.toString(),
                      'marital_status': maritalStatusController.text.toString(),
                    };
                    createUser(userData);
                  },
                  child: Text('create'),
                ),
                SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: idController,
                        decoration: InputDecoration(
                          labelText: 'ID',
                          errorText: errorText.isNotEmpty ? errorText : null,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      flex: 4,
                      child: ElevatedButton(
                        onPressed: getPHRById,
                        child: Text('Get PHR by ID'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: deleteIdController,
                        decoration: InputDecoration(
                          labelText: 'ID',
                          errorText: errorDeleteText.isNotEmpty ? errorDeleteText : null,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      flex: 4,
                      child: ElevatedButton(
                        onPressed: deletePhr,
                        child: Text('Delete phr'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
