import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class CountdownPage extends StatefulWidget {
  @override
  _CountdownPageState createState() => _CountdownPageState();
}

class _CountdownPageState extends State<CountdownPage> {
  static const initialCountdownDuration = Duration(minutes: 0); // Durata iniziale del countdown
  Duration duration = Duration(); // Durata attuale del timer
  late StreamController<int> _streamController; // StreamController per eventi ogni secondo
  StreamSubscription<int>? _streamSubscription; // Sottoscrizione agli eventi dello stream
  Timer? periodicTimer; // Gestisce il timer periodico
  bool isRunning = false; // Indica se il timer è in esecuzione
  bool isCountdown = true; // Modalità countdown o stopwatch
  final player = AudioPlayer(); // Istanza del player audio

  @override
  void initState() {
    super.initState();
    _streamController = StreamController<int>.broadcast();
    reset();
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    periodicTimer?.cancel();
    _streamController.close();
    player.dispose(); // Libera le risorse del player audio
    super.dispose();
  }


  // Reimposta il timer alla durata iniziale o a zero
  void reset() {
    _streamSubscription?.cancel();
    periodicTimer?.cancel();
    setState(() => duration = isCountdown ? initialCountdownDuration : Duration());
    isRunning = false;
  }

  // Inizia il flusso del timer
  void startStream() {
    _streamSubscription = _streamController.stream.listen((event) {
      setState(() {
        if (isCountdown) {
          // Countdown: riduce la durata
          if (duration.inSeconds > 0) {
            duration -= const Duration(seconds: 1);
          } else {
            playAudio(); // Riproduce l'audio alla fine del countdown
            _streamSubscription?.cancel();
            periodicTimer?.cancel();
            reset();
          }
        } else {
          // Stopwatch: aumenta la durata
          duration += const Duration(seconds: 1);
        }
      });
    });
  }

  // Avvia il timer
  void startTimer() {
    if (!isRunning) {
      isRunning = true;
      startStream();
      periodicTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _streamController.add(1); // Genera un evento ogni secondo
      });
    }
  }

  // Ferma il timer
  void stopTimer() {
    setState(() {
      isRunning = false;
      periodicTimer?.cancel();
    });
  }

  // Cambia modalità tra countdown e stopwatch
  void toggleMode() {
    reset();
    setState(() => isCountdown = !isCountdown);
  }

  // Riproduce l'audio "Lobotomy"
  void playAudio() async {
    await player.play(AssetSource('lobotomy sound effect.mp3'));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildTime(),
              const SizedBox(height: 24),
              if (isCountdown) buildDurationAdjuster(),
              const SizedBox(height: 24),
              buildButtons(),
              const SizedBox(height: 24),
              buildModeSwitch(),
            ],
          ),
        ),
      );

  // Formatta il tempo in ore, minuti e secondi
  Widget buildTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildTimeCard(time: hours, header: 'HOURS'),
        const SizedBox(width: 8),
        buildTimeCard(time: minutes, header: 'MINUTES'),
        const SizedBox(width: 8),
        buildTimeCard(time: seconds, header: 'SECONDS'),
      ],
    );
  }

  // Crea una card per mostrare ore, minuti o secondi
  Widget buildTimeCard({required String time, required String header}) => Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              time,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 72,
                fontFamily: 'Roboto',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              header,
              style: const TextStyle(fontFamily: 'Roboto'),
            ),
          ],
        ),
      );

  // Pulsanti per avviare, fermare e resettare il timer
  Widget buildButtons() {
    return isRunning
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: stopTimer,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black, backgroundColor: Colors.white,
                ),
                child: const Text('STOP'),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: reset,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black, backgroundColor: Colors.white,
                ),
                child: const Text('RESET'),
              ),
            ],
          )
        : ElevatedButton(
            onPressed: startTimer,
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black, backgroundColor: Colors.white,
            ),
            child: const Text('START'),
          );
  }

  // Switch tra countdown e stopwatch
  Widget buildModeSwitch() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Countdown'),
          Switch(
            value: !isCountdown,
            onChanged: (_) => toggleMode(),
          ),
          const Text('Stopwatch'),
        ],
      );

  // Regola ore, minuti e secondi
  Widget buildDurationAdjuster() => Column(
        children: [
          buildAdjusterRow('Hours', (value) {
            setState(() => duration += Duration(hours: value));
          }, duration.inHours),
          buildAdjusterRow('Minutes', (value) {
            setState(() => duration += Duration(minutes: value));
          }, duration.inMinutes.remainder(60)),
          buildAdjusterRow('Seconds', (value) {
            setState(() => duration += Duration(seconds: value));
          }, duration.inSeconds.remainder(60)),
        ],
      );

  Widget buildAdjusterRow(String label, Function(int) onChange, int value) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('$label:', style: const TextStyle(fontSize: 16)),
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: () => onChange(-1),
          ),
          Text('$value', style: const TextStyle(fontSize: 16)),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => onChange(1),
          ),
        ],
      );
}
