import 'package:agrotech_app/forgotpass/changepass.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class otp extends StatefulWidget {
  const otp({super.key});

  @override
  State<otp> createState() => _otpState();
}

class _otpState extends State<otp> {
  TextEditingController otpDigit1Controller = TextEditingController();
  TextEditingController otpDigit2Controller = TextEditingController();
  TextEditingController otpDigit3Controller = TextEditingController();
  TextEditingController otpDigit4Controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final _orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      appBar: AppBar(
        title: Text("OTP Verification"),
        backgroundColor: const Color.fromARGB(255, 91, 172, 10),
      ),
      body: _orientation == Orientation.portrait
          ?
          //code for portrait
          SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: height * 0.03,
                    width: width * 0.03,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Verify Your OTP",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        )),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: height * 0.1,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SizedBox(
                          height: height * 0.07,
                          width: width * 0.15,
                          child: TextFormField(
                            controller: otpDigit1Controller,
                            onChanged: (value) {
                              FocusScope.of(context).nextFocus();
                            },
                            style: Theme.of(context).textTheme.headlineSmall,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(1),
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SizedBox(
                          height: height * 0.07,
                          width: width * 0.15,
                          child: TextFormField(
                            controller: otpDigit2Controller,
                            onChanged: (value) {
                              FocusScope.of(context).nextFocus();
                            },
                            style: Theme.of(context).textTheme.headlineSmall,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(1),
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SizedBox(
                          height: height * 0.07,
                          width: width * 0.15,
                          child: TextFormField(
                            controller: otpDigit3Controller,
                            onChanged: (value) {
                              FocusScope.of(context).nextFocus();
                            },
                            style: Theme.of(context).textTheme.headlineSmall,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(1),
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SizedBox(
                          height: height * 0.07,
                          width: width * 0.15,
                          child: TextFormField(
                            controller: otpDigit4Controller,
                            onChanged: (value) {
                              FocusScope.of(context).nextFocus();
                            },
                            style: Theme.of(context).textTheme.headlineSmall,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(1),
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 91, 172, 10),
                      elevation: 0,
                    ),
                    onPressed: () async {},
                    child: const Text(
                      "Verify",
                      style: TextStyle(fontSize: 15, color: Colors.black),
                    ),
                  ),
                ],
              ),
            )
          :
          //code for landscape
          Column(
              children: [
                SizedBox(
                  height: height * 0.03,
                  width: width * 0.03,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Verify Your OTP",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      )),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      height: height * 0.1,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: SizedBox(
                        height: height * 0.17,
                        width: width * 0.09,
                        child: TextFormField(
                          controller: otpDigit1Controller,
                          onChanged: (value) {
                            FocusScope.of(context).nextFocus();
                          },
                          style: Theme.of(context).textTheme.headlineSmall,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(1),
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: SizedBox(
                        height: height * 0.17,
                        width: width * 0.09,
                        child: TextFormField(
                          controller: otpDigit2Controller,
                          onChanged: (value) {
                            FocusScope.of(context).nextFocus();
                          },
                          style: Theme.of(context).textTheme.headlineSmall,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(1),
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: SizedBox(
                        height: height * 0.17,
                        width: width * 0.09,
                        child: TextFormField(
                          controller: otpDigit3Controller,
                          onChanged: (value) {
                            FocusScope.of(context).nextFocus();
                          },
                          style: Theme.of(context).textTheme.headlineSmall,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(1),
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: SizedBox(
                        height: height * 0.17,
                        width: width * 0.09,
                        child: TextFormField(
                          controller: otpDigit4Controller,
                          onChanged: (value) {
                            FocusScope.of(context).nextFocus();
                          },
                          style: Theme.of(context).textTheme.headlineSmall,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(1),
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 91, 172, 10),
                    elevation: 0,
                  ),
                  onPressed: () async {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => changepass()));
                  },
                  child: const Text(
                    "Verify",
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),
                ),
              ],
            ),
    );
  }
}
