import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final LocalAuthentication localAuthentication;
  bool _supportState = false;

  @override
  void initState() {
    localAuthentication = LocalAuthentication();
    localAuthentication.isDeviceSupported().then(
          (isSupport) => setState(() {
            _supportState = isSupport;
          }),
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('Local Authenticate',
            style: TextStyle(
              color: Colors.white,
            )),
      ),
      body: Column(
        children: [
          if (_supportState)
            const Text("This device is supported")
          else
            const Text("This device is not supported"),
          const Divider(height: 10),
          ElevatedButton(
            onPressed: _getAvailbleBiometrics,
            child: const Text('Get Availble Biometrics'),
          ),
          const Divider(height: 10),
          ElevatedButton(
            onPressed: () async {
              var isAuth = await _authenticate();
              if (isAuth == true) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Authentication Successfully"),
                      content: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Okay'),
                      ),
                    );
                  },
                );
              } else {
                print("sadkjfadskfkg---------------------------------");
              }
            },
            child: const Text('Authenticate'),
          ),
        ],
      ),
    );
  }

  Future<bool> _authenticate() async {
    try {
      bool authenticated = await localAuthentication.authenticate(
        localizedReason: 'localizedReason',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
          sensitiveTransaction: true,
          useErrorDialogs: true,
        ),
      );
      print('authenticated$authenticated');
      return Future<bool>.value(true);
    } on PlatformException catch (e) {
      print('Error==>$e');
      return Future<bool>.value(false);
    }
  }

  Future<void> _getAvailbleBiometrics() async {
    List<BiometricType> availableBiometric =
        await localAuthentication.getAvailableBiometrics();
    print("gjasdgfasj$availableBiometric");

    if (!mounted) {
      return;
    }
  }
}
