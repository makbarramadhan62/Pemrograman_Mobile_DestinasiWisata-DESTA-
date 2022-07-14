import 'package:flutter/material.dart';
import 'package:tubes_1/model/place_model.dart';
import 'package:tubes_1/utilities/colors.dart';
import 'package:tubes_1/screens/home/home_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DetailScreen extends StatefulWidget {
  final PlaceInfo placeInfo;
  const DetailScreen({Key? key, required this.placeInfo}) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final _formKey = GlobalKey<FormState>();

  //inisialize field
  var title = TextEditingController();
  var content = TextEditingController();

  List _get = [];

  @override
  void initState() {
    super.initState();
    //in first time, this method will be executed
    _getData();
  }

  Future _getData() async {
    try {
      final response = await http.get(Uri.parse(
          //you have to take the ip address of your computer.
          //because using localhost will cause an error
          "http://192.168.43.3:8080/latihan/list.php"));

      // if response successful
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // entry data to variabel list _get
        setState(() {
          _get = data;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future _onSubmit() async {
    try {
      return await http.post(
        Uri.parse("http://192.168.43.3:8080/latihan/create.php"),
        body: {
          "title": title.text,
          "content": content.text,
        },
      ).then((value) {
        //print message after insert to database
        //you can improve this message with alert dialog
        var data = jsonDecode(value.body);
        print(data["message"]);

        Navigator.of(context).pushNamedAndRemoveUntil(
            '../detailscreen/detail_screen.dart',
            (Route<dynamic> route) => false);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteClr,
      body: Stack(
        children: [
          Image.asset(
            widget.placeInfo.image,
            width: double.infinity,
            fit: BoxFit.cover,
            height: MediaQuery.of(context).size.height * 0.45,
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Material(
                          elevation: 5,
                          borderRadius: BorderRadius.circular(100),
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Container(
                              height: 25,
                              width: 25,
                              decoration: const BoxDecoration(
                                  color: kPrimaryClr, shape: BoxShape.circle),
                              child: const Center(
                                child: Icon(
                                  Icons.arrow_back,
                                  color: kWhiteClr,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Material(
                        elevation: 5,
                        borderRadius: BorderRadius.circular(100),
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Container(
                            height: 25,
                            width: 25,
                            decoration: BoxDecoration(
                                color: kWhiteClr, shape: BoxShape.circle),
                            child: Center(
                              child: Icon(
                                Icons.bookmark_rounded,
                                color: kPrimaryClr,
                                size: 25,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                ///
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: kWhiteClr,
                        borderRadius: BorderRadius.circular(30)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 20),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.placeInfo.name,
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ), //textstye
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              widget.placeInfo.name,
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: kGreyClr),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: kPrimaryClr,
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                Text(
                                  widget.placeInfo.location,
                                  style: const TextStyle(
                                    color: kGreyClr,
                                    fontSize: 20,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 15),
                            const Text(
                              "Candi Detail",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              widget.placeInfo.desc,
                              style: const TextStyle(
                                color: kGreyClr,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Divider(
                              height: 5,
                              color: Colors.black,
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Text(
                                  "Harga Tiket",
                                  style: const TextStyle(
                                    color: kGreyClr,
                                    fontSize: 20,
                                  ),
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                Expanded(
                                  child: Text(
                                    "Rp. ${widget.placeInfo.price}",
                                    style: const TextStyle(
                                      color: kGreyClr,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(children: [
                              Text(
                                "Link",
                                style: const TextStyle(
                                  color: kGreyClr,
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Expanded(
                                  child: new InkWell(
                                      child: new Text('Open Maps'),
                                      onTap: () =>
                                          launch('${widget.placeInfo.maps}')))
                            ]),
                            const SizedBox(height: 20),
                            const Text(
                              "Review's",
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              widget.placeInfo.review,
                              style: const TextStyle(
                                color: kGreyClr,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                //Review Tab

                //Insert Review Box
                Material(
                  child: Container(
                    decoration: BoxDecoration(color: kWhiteClr, boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(255, 170, 170, 170),
                        spreadRadius: 5,
                        blurRadius: 15,
                        offset: Offset(0, 3), // changes position of shadow
                      )
                    ]),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: content,
                              keyboardType: TextInputType.multiline,
                              // minLines: 5,
                              maxLines: null,
                              decoration: const InputDecoration(
                                  hintText: "Insert Your Review",
                                  prefixIcon:
                                      Icon(Icons.comment, color: kPrimaryClr),
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  filled: false),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Note Content is Required!';
                                }
                                return null;
                              },
                            ),
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: kPrimaryClr, onPrimary: kWhiteClr),
                              child: const Text(
                                'SUBMIT',
                              ),
                              onPressed: () {
                                _onSubmit();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomeScreen(),
                                  ),
                                );
                              })
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
