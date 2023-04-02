import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';

//this doesn't work yet
//this doesn't work yet
//this doesn't work yet


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'law1',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {


  AudioPlayer player = AudioPlayer();
  AudioPlayer cache = AudioPlayer();
  AudioPlayer player_bell = AudioPlayer();
  final cache_bell = AudioPlayer();

  Color color = Colors.white;
  String audioPath = "law1.mp3";
  String bellPath = "single_bell.mp3";
  bool isPlaying = false;
  bool isPlayedOnce = false;
  double volume = 0.5;
  double volume_interval = 0.01;
  double speed_interval = 0.01;
  double gesture_interval = 0.5;
  int delay_time = 500;
  double speed = 1;


  @override
  void initState()  {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
     cache_bell.play(AssetSource('assets/audio/single_bell.mp3'));
  }

  /*_playBell() async {
    player_bell = await cache_bell.play(AssetSource('sounds/note1.wave');
  }*/

  _setFile(String filePath) async {
    this.audioPath = filePath;
  }

  void _playFile() async {

    if (!isPlayedOnce) {
      _changeVolume(this.volume);
      _changeSpeed(this.speed);

      isPlayedOnce = true;
      isPlaying = true;
    } else {
      player.resume();
      isPlaying = true;
    }
  }

  void _stopFile() {

    player.stop();
    isPlaying = false;
  }

  void _pauseFile() {

    player.pause();
    isPlaying = false;
  }

  void _changeVolume(double volume) {
    player.setVolume(volume);
  }

  void _changeSpeed(double speed) {
    player.setPlaybackRate(speed);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.inactive:
        _stopFile();
        break;
      case AppLifecycleState.resumed:
         cache_bell.play(AssetSource('assets/audio/single_bell.mp3'));
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () {
            setState(() {
              color = Colors.redAccent;
              if (isPlaying == false)
                _playFile();
              else
                _pauseFile();
            });
          },
          onDoubleTap: () {
            setState(() {
              volume = 0.5;
              _changeVolume(volume);
              speed = 1;
              _changeSpeed(speed);
            });
          },
          onLongPress: () {
            setState(() {
              _stopFile();
            });
          },
          onPanUpdate: (details) {
            if (details.delta.dy > gesture_interval)
              setState(() {
                volume > 0 ? volume -= volume_interval : volume = 0;
                _changeVolume(volume);
              });
            else if (details.delta.dy < -gesture_interval)
              setState(() {
                volume < 1 ? volume += volume_interval : volume = 1;
                _changeVolume(volume);
              });
            if (details.delta.dx > gesture_interval)
              setState(() {
                speed < 2 ? speed += speed_interval : speed = 2;
                _changeSpeed(speed);
              });
            else if (details.delta.dx < -gesture_interval)
              setState(() {
                speed > 0.5 ? speed -= speed_interval : speed = 0.5;
                _changeSpeed(speed);
              });
          },
          child: Container(
              color: color,
              height: 1920,
              width: 1080,
              child: Column(children: [
                Text("volume = " + volume.toString()),
                Text("speed = " + speed.toString()),
                Text("law1"),
              ])),
        ),
      ),
    );
  }
}
