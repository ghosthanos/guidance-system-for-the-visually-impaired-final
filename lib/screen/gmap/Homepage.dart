import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
   HomePage({Key? key}) : super(key: key);



  @override
  _HomePageState createState() => _HomePageState();
}
BitmapDescriptor blueMarker = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
class _HomePageState extends State<HomePage> {
  Completer<GoogleMapController> _controller = Completer();
  static const CameraPosition _kGoogle = CameraPosition(
    target: LatLng(20.42796133580664, 80.885749655962),
    zoom: 14.4746,
  );

  final List<Marker> _markers = <Marker>[];
  late LatLng _startingPosition;

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR" + error.toString());
    });
    return await Geolocator.getCurrentPosition();
  }

  stt.SpeechToText _speechToText = stt.SpeechToText();
  FlutterTts _flutterTts = FlutterTts();

  String _destination = '';
  bool _isListening = false;

  void _listen() async {
    if (!_isListening) {
      bool available = await _speechToText.initialize(
        onStatus: (status) {},
        onError: (error) {},
      );

      if (available) {
        setState(() => _isListening = true);
        _speechToText.listen(
          onResult: (result) {
            setState(() {
              _destination = result.recognizedWords;
            });
          },
        );
      }
    } else {
      setState(() => _isListening = false);
      _speechToText.stop();
    }
  }

  void _speak(String text) async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.speak(text);
  }

  @override
  void initState() {
    super.initState();
    getUserCurrentLocation().then((Position position) {
      setState(() {
        _startingPosition = LatLng(position.latitude, position.longitude);
        _markers.add(
          Marker(
            markerId: MarkerId('1'),
            position: _startingPosition,
            infoWindow: InfoWindow(
              title: 'My Position',
            ),
          ),
        );
      });
    }).catchError((e) {
      print('Error: $e');
      // Handle error retrieving location
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Wrap( //will break to another line on overflow
          direction: Axis.horizontal, //use vertical to show  on vertical axis
          children: <Widget>[


            Container(

              height: 80,
                width: 80,
                margin:EdgeInsets.all(20),
                child:FloatingActionButton(
                  backgroundColor: Color.fromRGBO(6, 30, 69, 1),
                  foregroundColor: Color.fromRGBO(20, 188, 233, 1),

                  onPressed: _listen,
                  child: Icon(_isListening ? Icons.mic : Icons.mic_none,
                    size: 30,
                  ),

                ),


            ),

            //button first

            Container(
                height: 80,
                width: 80,
                margin:EdgeInsets.all(20),

                child: FloatingActionButton(
                  backgroundColor: Color.fromRGBO(6, 30, 69, 1),
                  foregroundColor: Color.fromRGBO(20, 188, 233, 1),

                  onPressed: () async {
                    final String url =
                        'https://www.google.com/maps/dir/?api=1&origin=${_startingPosition.latitude},${_startingPosition.longitude}&destination=$_destination';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },


                  child: Icon(Icons.directions,
                  size: 30),

                ),
            ), // button second



            // Add more buttons here
          ],
        ),
      appBar: AppBar(

        backgroundColor: Color.fromRGBO(6, 30, 69, 1),
        leading: IconButton(
          onPressed: () {
           Navigator.pop(context);

          },

          icon: const Icon(Icons.arrow_back_ios_new),
          color: Color.fromRGBO(67, 236, 227, 1),
          iconSize: 37,
padding: const EdgeInsets.only(right: 8.0),
        ),

        centerTitle: true,
        title: Text("Navigation",
          style: TextStyle(
            fontSize: 25.0,
            color: Color.fromRGBO(67, 236, 227, 1),


          ),),

      ),
      body: Container(

          child: Column(
            children: [
              TextField(
                onChanged: (value) {
                  setState(() {
                    _destination = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Destination',
                  

                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
              ),

             /* ElevatedButton(onPressed: _listen,
                  child: Text(_isListening ? 'Listening...' : 'Voice Input')),
*/
              Expanded(
                child: GoogleMap(
                  initialCameraPosition:
                      CameraPosition(target: _startingPosition, zoom: 14),
                  markers: Set<Marker>.of(_markers),
                  mapType: MapType.normal,
                  myLocationEnabled: true,
                  compassEnabled: true,

                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
              ),
            ],
          ),

      ),

     /*floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          width: 80,
          height: 80,
          child: FloatingActionButton(
            onPressed: () async {
              final String url =
                  'https://www.google.com/maps/dir/?api=1&origin=${_startingPosition.latitude},${_startingPosition.longitude}&destination=$_destination';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            },


            child: Icon(Icons.directions),
          ),
        ),
      ),*/
    );
  }
}