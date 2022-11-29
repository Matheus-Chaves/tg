import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class PaymentScreen extends StatelessWidget {
  PaymentScreen({super.key});
  final _controller = CardFormEditController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Insira seu cartão",
              style: Theme.of(context).textTheme.headline5,
            ),
            const SizedBox(height: 16),
            CardFormField(
              controller: _controller,
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                if (_controller.details.complete == true) {
                  print("true");
                }
              },
              child: const Text("Pagar"),
            ),
          ],
        ),
      ),
    );
  }
}
