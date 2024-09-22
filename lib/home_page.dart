import "package:animate_do/animate_do.dart";
import "package:flutter/material.dart";
import "package:flutter_tts/flutter_tts.dart";
import "package:jarvis/feature_box.dart";
import "package:jarvis/openAi_service.dart";
import "package:jarvis/pallete.dart";
import "package:speech_to_text/speech_to_text.dart";
import 'package:speech_to_text/speech_recognition_result.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final speechToText = SpeechToText();
  String lastWords = "";
  final OpenAIService openAIService = OpenAIService();
  final flutterTts = FlutterTts();
  String? generatedContent;
  String? generatedImgURL;
  int start = 200, delay = 200;
  
  @override
  void initState() {
    super.initState();
    initSpeechToText();
    initTextToSpeech();
  }

  Future<void>initTextToSpeech()async{
    await flutterTts.setSharedInstance(true);
    setState(() {

    });
  }

  Future<void>initSpeechToText() async{
    await speechToText.initialize();
    setState(() {
       
    });
  }
  //Each time to start a speech recognition session
  Future<void> startListening() async{
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {

    });
  }

  Future<void> stopListening() async{
    await speechToText.stop();
    setState(() {

    });
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
    });
  }

  Future<void>systemSpeak(String content)async{
    await flutterTts.speak(content);
  }
  @override
  void dispose() {
    super.dispose();
    speechToText.stop();
    flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BounceInDown(
          child: const Text("Jarvis-AI"),
        ),
        centerTitle: true,
        leading: const Icon(Icons.menu),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //Virtual Assistant (Jarvis) Picture
            ZoomIn(
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      height: 120,
                      width: 120,
                      margin: const EdgeInsets.only(top: 4),
                      decoration: const BoxDecoration(
                        color: Pallete.assistantCircleColor,
                        shape: BoxShape.circle
                      ),
                    ),
                  ),
                  Container(
                    height: 123,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('assets/image/arc_reactor.png'),
                      ),
                    ),
                  )
                ],
              ),
            ),
            //Chat bubble
            FadeInRight(
              child: Visibility(
                visible: generatedImgURL == null,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                  margin: const EdgeInsets.symmetric(horizontal: 20).copyWith(top:15),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Pallete.borderColor
                    ), 
                    borderRadius: BorderRadius.circular(20).copyWith(topLeft: Radius.zero)
                  ),
                  child:Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      generatedContent == null ? "Good Morning, what task can I do for you??":generatedContent!,
                      style: TextStyle(
                        fontFamily: 'Cera Pro',
                        color: Pallete.mainFontColor,
                        fontSize: generatedContent == null ? 20:15
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if(generatedImgURL != null)
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ClipRRect(
                  child: Image.network(generatedImgURL!),
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            SlideInLeft(
              child: Visibility(
                visible: generatedContent == null && generatedImgURL == null,
                child: Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(top: 10,left: 32),
                  child: const Text(
                      'Here are a few features',
                    style: TextStyle(
                      fontFamily: 'Cera Pro',
                      color: Pallete.mainFontColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
            ),
            //Features list
            Visibility(
              visible: generatedContent == null && generatedImgURL == null,
              child: Column(
                children: [
                  SlideInLeft(
                    delay: Duration(milliseconds: start),
                    child: const   FeatureBox(
                      color: Pallete.firstSuggestionBoxColor,
                      headerText: 'ChatGPT',
                      descriptionText: 'A smarter way to stay organized and informed with ChatGPT',
                    ),
                  ),
                  SlideInLeft(
                    delay: Duration(milliseconds: start+ delay),
                    child: const FeatureBox(
                        color: Pallete.secondSuggestionBoxColor,
                        headerText: 'Dall-E',
                        descriptionText: 'Get inspired and stay creative with your personal assistant powered by Dall-E',
                    ),
                  ),
                  SlideInLeft(
                    delay: Duration(milliseconds: start+ 2 * delay),
                    child: const FeatureBox(
                        color: Pallete.thirdSuggestionBoxColor,
                        headerText: 'Smart Voice Assistant',
                        descriptionText: 'Get the best of both worlds with a voice assistant powered by Dall-E and ChatGPT',
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: ZoomIn(
        delay: Duration(milliseconds: start+ 3 * delay),
        child: FloatingActionButton(
          onPressed: () async{
            if(await speechToText.hasPermission && speechToText.isNotListening){
              await startListening();
            }else if(speechToText.isListening){
              final speech = await openAIService.isArtPrompt(lastWords);
              if(speech.contains('https')){
                generatedImgURL = speech;
                generatedContent = null;
                setState(() { });
              }else {
                generatedImgURL = null;
                generatedContent = speech;
                await systemSpeak(speech);
                setState(() { });
              }
              await stopListening();
            }else{
              initSpeechToText();
            }
          },
          child: Icon(speechToText.isListening?Icons.stop:Icons.mic),
          backgroundColor: Pallete.firstSuggestionBoxColor,
        ),
      ), 
    );
  }
}
