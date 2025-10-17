import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

const Color myCustomColor = Color(0x2B2C3AFF);

class FinancialData extends ChangeNotifier {
  double _balance;
  String? _username;
  FinancialData({double initialBalance = 0.0, String? initialUsername})
      : _balance = initialBalance,
        _username = initialUsername;
  double get balance => _balance;
  String? get username => _username;
  void setUsername(String name) {
    _username = name;
    notifyListeners();
  }
  void deposit(double amount) {
    if (amount <= 0) {
      throw ArgumentError('Deposit amount must be positive.');
    }
    _balance += amount;
    notifyListeners();
  }
  bool withdraw(double amount) {
    if (amount <= 0) {
      throw ArgumentError('Withdrawal amount must be positive.');
    }
    if (amount > _balance) {
      return false;
    }
    _balance -= amount;
    notifyListeners();
    return true;
  }
}

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
            return const MainDashboardScreen();
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
    return ChangeNotifierProvider<FinancialData>(
      create: (BuildContext context) => FinancialData(),
      builder: (BuildContext context, Widget? child) {
        return MaterialApp.router(
          routerConfig: _router,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: myCustomColor),
            useMaterial3: true,
            appBarTheme: AppBarTheme(
              backgroundColor: Theme.of(context).primaryColor,
              titleTextStyle: const TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
              centerTitle: true,
            ),
          ),
          debugShowCheckedModeBanner: false,
        );
      },
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
      // Store the username in the FinancialData model
      context.read<FinancialData>().setUsername(_usernameController.text);
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome!'),
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

class MainDashboardScreen extends StatelessWidget {
  const MainDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FinancialData financialData = context.watch<FinancialData>();
    final String displayUsername = financialData.username ?? 'User';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Dashboard'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Hello, $displayUsername!',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
              Text(
                'Current Balance: \$${financialData.balance.toStringAsFixed(2)}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
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
                onPressed: () {
                  financialData.setUsername('');
                  context.go('/');
                },
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

class DepositScreen extends StatefulWidget {
  const DepositScreen({super.key});

  @override
  State<DepositScreen> createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onDeposit() {
    if (_formKey.currentState!.validate()) {
      final double? amount = double.tryParse(_amountController.text);
      if (amount != null && amount > 0) {
        try {
          context.read<FinancialData>().deposit(amount);
          _showSnackBar('Deposit of \$${amount.toStringAsFixed(2)} successful!');
          _amountController.clear();
          context.go('/home'); 
        } on ArgumentError catch (e) {
          _showSnackBar(e.message, isError: true);
        }
      }
    }
  }

  String? _validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an amount.';
    }
    final double? amount = double.tryParse(value);
    if (amount == null) {
      return 'Please enter a valid number.';
    }
    if (amount <= 0) {
      return 'Amount must be positive.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final FinancialData financialData = context.watch<FinancialData>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Deposit Funds'),
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
                const Icon(
                  Icons.attach_money,
                  size: 80,
                  color: Colors.green,
                ),
                const SizedBox(height: 24.0),
                Text(
                  'Current Balance: \$${financialData.balance.toStringAsFixed(2)}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 24.0),
                TextFormField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Deposit Amount',
                    hintText: 'Enter amount to deposit',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.money),
                  ),
                  validator: _validateAmount,
                ),
                const SizedBox(height: 24.0),
                FilledButton.icon(
                  onPressed: _onDeposit,
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('Confirm Deposit'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                    textStyle: const TextStyle(fontSize: 18.0),
                  ),
                ),
                const SizedBox(height: 16.0),
                FilledButton.icon(
                  onPressed: () => context.go('/home'),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Back to Dashboard'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                    textStyle: const TextStyle(fontSize: 18.0),
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A screen for withdrawing funds.
class WithdrawScreen extends StatefulWidget {
  const WithdrawScreen({super.key});

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onWithdraw() {
    if (_formKey.currentState!.validate()) {
      final double? amount = double.tryParse(_amountController.text);
      if (amount != null && amount > 0) {
        final FinancialData financialData = context.read<FinancialData>();
        try {
          if (financialData.withdraw(amount)) {
            _showSnackBar('Withdrawal of \$${amount.toStringAsFixed(2)} successful!');
            _amountController.clear();
            context.go('/home');
          } else {
            _showSnackBar('Insufficient funds!', isError: true);
          }
        } on ArgumentError catch (e) {
          _showSnackBar(e.message, isError: true);
        }
      }
    }
  }

  String? _validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an amount.';
    }
    final double? amount = double.tryParse(value);
    if (amount == null) {
      return 'Please enter a valid number.';
    }
    if (amount <= 0) {
      return 'Amount must be positive.';
    }
    final double currentBalance = context.read<FinancialData>().balance;
    if (amount > currentBalance) {
      return 'Insufficient funds. Available: \$${currentBalance.toStringAsFixed(2)}';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final FinancialData financialData = context.watch<FinancialData>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Withdraw Funds'),
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
                const Icon(
                  Icons.money_off_csred,
                  size: 80,
                  color: Colors.red,
                ),
                const SizedBox(height: 24.0),
                Text(
                  'Current Balance: \$${financialData.balance.toStringAsFixed(2)}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 24.0),
                TextFormField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Withdrawal Amount',
                    hintText: 'Enter amount to withdraw',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.money),
                  ),
                  validator: _validateAmount,
                ),
                const SizedBox(height: 24.0),
                FilledButton.icon(
                  onPressed: _onWithdraw,
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('Confirm Withdrawal'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                    textStyle: const TextStyle(fontSize: 18.0),
                  ),
                ),
                const SizedBox(height: 16.0),
                FilledButton.icon(
                  onPressed: () => context.go('/home'),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Back to Dashboard'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                    textStyle: const TextStyle(fontSize: 18.0),
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
