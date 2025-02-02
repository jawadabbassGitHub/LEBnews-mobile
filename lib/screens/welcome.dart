import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart'; // Import AdMob package
import 'package:final_news_app_senior/common/colors.dart';
import 'package:final_news_app_senior/common/widgets/no_connectivity.dart';
import 'package:final_news_app_senior/screens/home/home.dart';
import 'package:final_news_app_senior/services/api_service.dart';

import '../common/common.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ApiService apiService = ApiService();

  bool _isLoading = false;
  bool _isPasswordVisible = false;

  InterstitialAd? _interstitialAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadInterstitialAd();
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/1033173712', // Replace with your Ad Unit ID
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _isAdLoaded = true;
          showInterstitialAd();
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('Failed to load interstitial ad: $error');
          _isAdLoaded = false;
        },
      ),
    );
  }

  void showInterstitialAd() {
    if (_isAdLoaded && _interstitialAd != null) {
      _interstitialAd!.show();
      _interstitialAd = null; // Set to null to avoid reuse
    }
  }

  bool isValidEmail(String email) {
    String emailPattern = r'^[^@]+@[^@]+\.[^@]+';
    RegExp regExp = RegExp(emailPattern);
    return regExp.hasMatch(email);
  }

  void showAlertDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Future<void> checkConnectivityAndLogin() async {
    if (await getInternetStatus()) {
      login();
    } else {
      Navigator.of(context, rootNavigator: true)
          .push(MaterialPageRoute(
        builder: (context) => NoConnectivity(),
      ))
          .then((value) => checkConnectivityAndLogin());
    }
  }

  Future<void> login() async {
    if (!isValidEmail(emailController.text)) {
      showAlertDialog("Invalid Email", "Please enter a valid email address.");
      return;
    }

    if (passwordController.text.isEmpty) {
      showAlertDialog("Invalid Password", "Password cannot be empty.");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final response = await apiService.login(
      emailController.text,
      passwordController.text,
    );

    setState(() {
      _isLoading = false;
    });

    if (response != null && response['success'] == true) {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => Home(),
          ),
        );
      }
    } else {
      String errorMessage = response?['message'] ?? "Login failed. Please try again.";
      showAlertDialog("Login Failed", errorMessage);
    }
  }

  void continueAsGuest() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => Home(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "LEBnews",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primary,
        centerTitle: true,
      ),
      backgroundColor: AppColors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/197629.png",
                width: 130,
                height: 130,
              ),
              const SizedBox(height: 40),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _isLoading ? null : checkConnectivityAndLogin,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text("Login"),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: continueAsGuest,
                child: const Text(
                  "Continue as Guest",
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Copyright © 2024",
                style: GoogleFonts.poppins(
                  color: AppColors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
