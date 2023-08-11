import 'dart:io';

import 'package:flutter/material.dart';

import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/src/audio_cache.dart';

class MusicDetailPage extends StatefulWidget {
  const MusicDetailPage(
      {super.key,
      required this.title,
      required this.description,
      required this.color,
      required this.img,
      required this.songUrl});
  final String title;
  final String description;
  final Color color;
  final String img;
  final String songUrl;

  @override
  State<MusicDetailPage> createState() => _MusicDetailPageState();
}

class _MusicDetailPageState extends State<MusicDetailPage> {
  double currentSliderValue = 20;

  //audio player
  AudioPlayer? advancedPlayer;
  AudioCache? audiocache;
  bool isplayer = true;

  @override
  void initState() {
    super.initState();
    initPlayer();
  }

  initPlayer() {
    advancedPlayer = AudioPlayer();
    audiocache = AudioCache(
        //fixedPlayer: advancedPlayer
        );
    playSound(widget.songUrl);
  }

  playSound(localPath) async {
    await audiocache!.load(localPath);
    //await advancedPlayer!.play(localPath);
  }

  stopsound(localPath) async {
    File audiofile = (await audiocache!.load(localPath)) as File;
    await advancedPlayer!.setSourceUrl(audiofile.path);
    advancedPlayer!.stop();
  }

  seeksong() async {
    File audiofile = (await audiocache?.load(widget.songUrl)) as File;
    await advancedPlayer!.setSourceUrl(audiofile.path);
    advancedPlayer!.seek(Duration(milliseconds: 2000));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    stopsound(widget.songUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert),
          )
        ],
      ),
      body: getBody(),
    );
  }

  getBody() {
    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
                child: Container(
                  width: size.width - 100,
                  height: size.width - 100,
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                        color: widget.color,
                        blurRadius: 50,
                        spreadRadius: 5,
                        offset: Offset(10, 40))
                  ], borderRadius: BorderRadius.circular(20)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
                child: Container(
                  width: size.width - 60,
                  height: size.width - 60,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(widget.img), fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(20)),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Container(
              width: size.width - 80,
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(
                    Icons.create_new_folder_outlined,
                    color: Colors.white,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      Container(
                        width: 150,
                        child: Text(
                          widget.description,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.more_vert,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Slider(
              // inactiveColor: Colors.transparent,
              activeColor: Color.fromARGB(255, 73, 158, 76),
              inactiveColor: Color.fromARGB(255, 132, 152, 133),
              value: currentSliderValue,
              min: 0,
              max: 200,
              onChanged: (value) {
                setState(() {
                  currentSliderValue = value;
                });
                seeksong();
              }),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "1:50",
                  style: TextStyle(color: Colors.white.withOpacity(0.5)),
                ),
                Text(
                  "3:00",
                  style: TextStyle(color: Colors.white.withOpacity(0.5)),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.shuffle_on_rounded,
                      size: 25,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.skip_previous_rounded,
                      size: 35,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                      iconSize: 45,
                      onPressed: () {
                        if (isplayer) {
                          stopsound(widget.songUrl);
                          setState(() {
                            isplayer = false;
                          });
                        } else {
                          playSound(widget.songUrl);
                          setState(() {
                            isplayer = true;
                          });
                        }
                      },
                      icon: Container(
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromARGB(255, 73, 158, 76)),
                        child: Center(
                          child: Icon(
                            isplayer ? Icons.stop : Icons.play_arrow,
                            size: 31,
                            color: Colors.white,
                          ),
                        ),
                      )),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.skip_next_rounded,
                      size: 35,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.restart_alt_outlined,
                      size: 25,
                      color: Colors.white,
                    ),
                  ),
                ]),
          ),
          const SizedBox(
            height: 25,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.tv,
                color: Color.fromARGB(255, 73, 158, 76),
              ),
              const SizedBox(
                width: 15,
              ),
              Text(
                'Taran\'s Airpods',
                style: TextStyle(color: Color.fromARGB(255, 73, 158, 76)),
              )
            ],
          )
        ],
      ),
    );
  }
}
