import 'dart:async';
import 'package:flutter/material.dart';

class CountdownPage extends StatefulWidget {
  @override
  _CountdownPageState createState() => _CountdownPageState();
}

class _CountdownPageState extends State<CountdownPage> {
  static const initialCountdownDuration = Duration(minutes: 0); // Durata iniziale per il countdown
  Duration duration = Duration(); // Durata attuale del timer
  late StreamController<int> _streamController; // StreamController per generare eventi ogni secondo
  StreamSubscription<int>? _streamSubscription; // Gestisce la sottoscrizione agli eventi dello stream
  Timer? periodicTimer; // Gestisce il Timer.periodic
  bool isRunning = false; // Indica se il timer è in esecuzione
  bool isCountdown = true; // Indica se siamo in modalità countdown o stopwatch

  @override
  void initState() {
    super.initState();
    _streamController = StreamController<int>.broadcast();
    reset(); // Imposta la durata iniziale
  }

  @override
  void dispose() {
    _streamSubscription?.cancel(); // Cancella la sottoscrizione allo stream
    periodicTimer?.cancel(); // Cancella il timer periodico
    _streamController.close(); // Chiude il controller dello stream
    super.dispose();
  }

  // Reimposta il timer alla durata iniziale o a zero, a seconda della modalità
  void reset() {
    _streamSubscription?.cancel();
    periodicTimer?.cancel();
    setState(() => duration = isCountdown ? initialCountdownDuration : Duration());
    isRunning = false;
  }

  // Inizia a generare eventi dallo stream
  void startStream() {
    _streamSubscription = _streamController.stream.listen((event) {
      setState(() {
        if (isCountdown) {
          // Riduce il countdown ogni secondo
          if (duration.inSeconds > 0) {
            duration -= const Duration(seconds: 1);
          } else {
            _streamSubscription?.cancel(); // Ferma lo stream quando raggiunge zero
            periodicTimer?.cancel();
            reset(); // Reset automatico al termine del countdown
          }
        } else {
          // Incrementa la durata nello stopwatch
          duration += const Duration(seconds: 1);
        }
      });
    });
  }

  // Avvia il timer utilizzando lo stream
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

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildTime(), // Mostra il tempo formattato
              const SizedBox(height: 24),
              if (isCountdown) buildDurationAdjuster(), // Regola ore, minuti e secondi
              const SizedBox(height: 24),
              buildButtons(), // Pulsanti di controllo
              const SizedBox(height: 24),
              buildModeSwitch(), // Switch tra countdown e stopwatch
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
        padding: EdgeInsets.all(8),
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
                child: Text(
                  'STOP',
                  style: const TextStyle(fontFamily: 'Roboto'),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: reset,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black, backgroundColor: Colors.white,
                ),
                child: Text(
                  'RESET',
                  style: const TextStyle(fontFamily: 'Roboto'),
                ),
              ),
            ],
          )
        : ElevatedButton(
            onPressed: startTimer,
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black, backgroundColor: Colors.white,
            ),
            child: Text(
              'START',
              style: const TextStyle(fontFamily: 'Roboto'),
            ),
          );
  }

  // Switch tra le modalità countdown e stopwatch
  Widget buildModeSwitch() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Countdown',
            style: const TextStyle(fontFamily: 'Roboto'),
          ),
          Switch(
            value: !isCountdown,
            onChanged: (_) => toggleMode(),
          ),
          Text(
            'Stopwatch',
            style: const TextStyle(fontFamily: 'Roboto'),
          ),
        ],
      );

  // Widget per regolare ore, minuti e secondi
  Widget buildDurationAdjuster() => Visibility(
        visible: isCountdown,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Hours:', style: TextStyle(fontFamily: 'Roboto', fontSize: 16)),
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      if (duration.inHours > 0) {
                        duration -= Duration(hours: 1);
                      }
                    });
                  },
                ),
                Text('${duration.inHours}', style: TextStyle(fontSize: 16)),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      duration += Duration(hours: 1);
                    });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Minutes:', style: TextStyle(fontFamily: 'Roboto', fontSize: 16)),
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      if (duration.inMinutes.remainder(60) > 0) {
                        duration -= Duration(minutes: 1);
                      }
                    });
                  },
                ),
                Text('${duration.inMinutes.remainder(60)}', style: TextStyle(fontSize: 16)),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      duration += Duration(minutes: 1);
                    });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Seconds:', style: TextStyle(fontFamily: 'Roboto', fontSize: 16)),
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      if (duration.inSeconds.remainder(60) > 0) {
                        duration -= Duration(seconds: 1);
                      }
                    });
                  },
                ),
                Text('${duration.inSeconds.remainder(60)}', style: TextStyle(fontSize: 16)),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      duration += Duration(seconds: 1);
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      );
}