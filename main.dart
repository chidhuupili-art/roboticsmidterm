import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

const Color myCustomColor = Color(0x2B2C3AFF);

void main() {
  runApp(const MyApp());
}
final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const WelcomeScreen();
      },
      routes: [
        GoRoute(
          path: 'home',
          builder: (BuildContext context, GoRouterState state) {
            return const MainDashboardScreen(); // Main application screen after login
          },
        ),
        GoRoute(
          path: 'deposit',
          builder: (BuildContext context, GoRouterState state) {
            return const DepositScreen(); 
          },
        ),
        GoRoute(
          path: 'withdraw',
          builder: (BuildContext context, GoRouterState state) {
            return const WithdrawScreen(); 
          },
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: myCustomColor),
        useMaterial3: true, 
      ),
      debugShowCheckedModeBanner: false, 
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  void _onContinue() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Welcome',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor, 
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView( 
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch, 
              children: <Widget>[
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    hintText: 'Enter your username',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a username';
                    }
                    return null;
                  },
                  onSaved: (String? value) {
                    debugPrint('Username saved: $value'); 
                  },
                ),
                const SizedBox(height: 24.0),
                FilledButton(
                  onPressed: _onContinue,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    textStyle: const TextStyle(fontSize: 18.0),
                  ),
                  child: const Text('Continue'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MainDashboardScreen extends StatefulWidget {
  const MainDashboardScreen({super.key});

  @override
  State<MainDashboardScreen> createState() => _MainDashboardScreenState();
}

class _MainDashboardScreenState extends State<MainDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Main Dashboard',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                'Welcome to your financial hub!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 48.0),
              FilledButton.icon(
                onPressed: () => context.go('/deposit'),
                icon: const Icon(Icons.account_balance_wallet),
                label: const Text('Deposit Funds'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  textStyle: const TextStyle(fontSize: 18.0),
                ),
              ),
              const SizedBox(height: 16.0),
              FilledButton.icon(
                onPressed: () => context.go('/withdraw'),
                icon: const Icon(Icons.money_off),
                label: const Text('Withdraw Funds'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  textStyle: const TextStyle(fontSize: 18.0),
                ),
              ),
              const SizedBox(height: 16.0),
              FilledButton.icon(
                onPressed: () => context.go('/'), 
                icon: const Icon(Icons.logout),
                label: const Text('Sign Out'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  textStyle: const TextStyle(fontSize: 18.0),
                  backgroundColor: Colors.redAccent, 
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DepositScreen extends StatelessWidget {
  const DepositScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Deposit Funds',
          style: TextStyle(color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.attach_money,
              size: 80,
              color: Colors.green,
            ),
            const SizedBox(height: 24.0),
            const Text(
              'This is the Deposit Screen. Implement deposit logic here.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 24.0),
            FilledButton.icon(
              onPressed: () => context.go('/home'),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Back to Dashboard'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                textStyle: const TextStyle(fontSize: 18.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A screen for withdrawing funds.
class WithdrawScreen extends StatelessWidget {
  const WithdrawScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Withdraw Funds',
          style: TextStyle(color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.money_off_csred,
              size: 80,
              color: Colors.red,
            ),
            const SizedBox(height: 24.0),
            const Text(
              'This is the Withdraw Screen. Implement withdraw logic here.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 24.0),
            FilledButton.icon(
              onPressed: () => context.go('/home'), 
              icon: const Icon(Icons.arrow_back),
              label: const Text('Back to Dashboard'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                textStyle: const TextStyle(fontSize: 18.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
