import 'package:flutter/material.dart';
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';
import 'package:color_type_converter/color_type_converter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: FadingTextAnimation());
  }
}

class FadingTextAnimation extends StatefulWidget {
  const FadingTextAnimation({super.key});

  @override
  FadingTextAnimationState createState() => FadingTextAnimationState();
}

class FadingTextAnimationState extends State<FadingTextAnimation> {
  bool _isVisible = true;
  bool _mode = true;
  bool _picker = false;
  Color textColor = Colors.black;
  late final _colorNotifier = ValueNotifier(textColor);
  void toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  void cycle() {
    setState(() {
      _mode = !_mode;
    });
  }

  void colorPick() {
    setState(() {
      _picker = !_picker;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fading Text Animation'),
        actions: [
          IconButton(onPressed: cycle, icon: Icon(Icons.square)),
          IconButton(
            onPressed: () {
              // Navigate to the second screen when the icon button is pressed
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SecondScreen()),
              );
            },
            icon: Icon(Icons.circle),
          ),
          IconButton(onPressed: colorPick, icon: Icon(Icons.pentagon)),
        ],
      ),
      body: SizedBox.expand(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeInOut,
          color: _mode ? Colors.grey : Colors.lightBlue,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedOpacity(
                opacity: _isVisible ? 1.0 : 0.0,
                duration: const Duration(seconds: 1),
                child: Text(
                  'Hello, Flutter!',
                  style: TextStyle(fontSize: 24, color: textColor),
                ),
              ),
              if (_picker)
                Padding(
                  padding: EdgeInsets.all(20),
                  child: ValueListenableBuilder<Color>(
                    valueListenable: _colorNotifier,
                    builder: (_, color, __) {
                      return ColorPicker(
                        color: color,
                        onChanged: (value) {
                          setState(() {
                            color = value;
                            textColor = value;
                          });
                        },
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: toggleVisibility,
        child: Icon(Icons.play_arrow),
      ),
    );
  }
}

// Second Screen with FadeTransition
class SecondScreen extends StatefulWidget {
  const SecondScreen({super.key});

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Second Screen with FadeTransition")),
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Text(
            'This is the second screen with FadeTransition!',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
