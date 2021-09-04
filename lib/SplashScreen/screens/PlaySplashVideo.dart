import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PlaySplashVideo extends StatefulWidget {
  final position;
  const PlaySplashVideo(this.position);

  @override
  _PlaySplashVideoState createState() => _PlaySplashVideoState();
}

class _PlaySplashVideoState extends State<PlaySplashVideo> {
  VideoPlayerController _controller;
  VideoPlayerController _secondController;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(
      'assets/videos/introVideo1.mp4',
    );
    _secondController = VideoPlayerController.asset(
      'assets/videos/introVideo.mp4',
    );
    _controller.initialize().then((value) {
      _controller.seekTo(widget.position);
      _controller.play();
    });
    _secondController.initialize();
    _controller.addListener(() {
      if (_controller.value.position == _controller.value.duration) {
        _controller.pause();

        setState(() {
          _controller = _secondController;
        });
        _controller.setLooping(true);
        _controller.play();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _secondController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter, colors: [Colors.black, Colors.black87])),
            child: Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context, _controller.value.position);
                },
                child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: VideoPlayer(
                      _controller,
                    )),
              ),
            )),
      ),
    );
  }
}
