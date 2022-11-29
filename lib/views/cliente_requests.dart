import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import 'package:get/get.dart';
import 'package:tg/views/get_request.dart';
import 'package:http/http.dart' as http;

import '../controllers/request_controller.dart';
import '../models/request_model.dart';
import 'package:tg/.env';

class ClienteRequests extends StatefulWidget {
  const ClienteRequests({Key? key}) : super(key: key);

  @override
  State<ClienteRequests> createState() => _ClienteRequestsState();
}

class _ClienteRequestsState extends State<ClienteRequests> {
  Map<String, dynamic>? paymentIntent;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RequestController>(
      init: RequestController(),
      initState: (_) {},
      builder: (requestController) {
        requestController.getRequests();
        return Scaffold(
          appBar: AppBar(
            title: const Text('Solicitações'),
          ),
          body: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Suas solicitações:",
                      style: TextStyle(fontSize: 20)),
                ),
                const SizedBox(height: 16),
                Flexible(
                  child: Center(
                    child: requestController.isLoading
                        ? const CircularProgressIndicator()
                        : requestController.requestList.isEmpty
                            ? const Text(
                                "Ops! Você ainda não solicitou nenhum serviço.\nVá para a página inicial e contrate um serviço!",
                              )
                            : ListView.separated(
                                itemCount: requestController.requestList.length,
                                itemBuilder: (BuildContext context, index) {
                                  RequestModel item =
                                      requestController.requestList[index];
                                  return Card(
                                    child: SizedBox(
                                      width: 300,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(children: [
                                          AutoSizeText(
                                            "Status: ${item.status}",
                                            maxLines: 1,
                                            minFontSize: 16,
                                            wrapWords: false,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500),
                                          ),
                                          if (item.statusPagamento != null)
                                            AutoSizeText(
                                              "${item.statusPagamento}",
                                              maxLines: 1,
                                              minFontSize: 16,
                                              wrapWords: false,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          const Divider(),
                                          AutoSizeText(
                                            requestController
                                                .requestList[index].descricao,
                                            maxLines: 4,
                                            overflow: TextOverflow.ellipsis,
                                            minFontSize: 16,
                                          ),
                                          const Divider(),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              item.statusPagamento ==
                                                      "aguardando pagamento"
                                                  ? ElevatedButton(
                                                      onPressed: () async {
                                                        await makePayment();
                                                      },
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: const [
                                                          Icon(Icons
                                                              .monetization_on),
                                                          Text("Pagar"),
                                                        ],
                                                      ),
                                                    )
                                                  : ElevatedButton(
                                                      onPressed: () async {
                                                        var res = await requestController
                                                            .getRequest(
                                                                requestController
                                                                    .requestList[
                                                                        index]
                                                                    .id as String);
                                                        print(res.descricao);
                                                        Get.to(() => GetRequest(
                                                              request: res,
                                                              title:
                                                                  "Atualizar Solicitação",
                                                            ));
                                                      },
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: const [
                                                          Icon(Icons.edit),
                                                          Text("Editar"),
                                                        ],
                                                      ),
                                                    ),
                                              ElevatedButton(
                                                onPressed: () => {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        title: const Text(
                                                            "Atenção!"),
                                                        content: const Text(
                                                            "Tem certeza que quer deletar sua solicitação?"),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: const Text(
                                                                "Cancelar"),
                                                          ),
                                                          TextButton(
                                                            onPressed:
                                                                () async {
                                                              await requestController
                                                                  .deleteRequest(
                                                                      requestController
                                                                          .requestList[
                                                                              index]
                                                                          .id);
                                                            },
                                                            child: const Text(
                                                                "Deletar"),
                                                          )
                                                        ],
                                                      );
                                                    },
                                                  ),
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: const [
                                                    Icon(Icons.delete),
                                                    Text('Deletar')
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ]),
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, index) {
                                  return const Divider(
                                    thickness: 2,
                                    color: Colors.black,
                                  );
                                },
                              ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> makePayment() async {
    try {
      paymentIntent = await createPaymentIntent('20', 'brl');
      //Payment Sheet
      await stripe.Stripe.instance.initPaymentSheet(
        paymentSheetParameters: stripe.SetupPaymentSheetParameters(
          // applePay: const PaymentSheetApplePay(merchantCountryCode: '+92',),
          // googlePay: const PaymentSheetGooglePay(testEnv: true, currencyCode: "US", merchantCountryCode: "+92"),
          paymentIntentClientSecret: paymentIntent!['client_secret'],
          style: ThemeMode.light,
          merchantDisplayName: 'Adnan',
        ),
      );

      ///now finally display payment sheeet
      displayPaymentSheet();
    } catch (e, s) {
      print('exception:$e$s');
    }
  }

  displayPaymentSheet() async {
    try {
      await stripe.Stripe.instance.presentPaymentSheet().then((value) {
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: const [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          ),
                          Text("Payment Successfull"),
                        ],
                      ),
                    ],
                  ),
                ));
        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("paid successfully")));

        paymentIntent = null;
      }).onError((error, stackTrace) {
        print('Error is:--->$error $stackTrace');
      });
    } on stripe.StripeException catch (e) {
      print('Error is:---> $e');
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
                content: Text("Cancelled "),
              ));
    } catch (e) {
      print('$e');
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $stripeSecretKey',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      // ignore: avoid_print
      print('Payment Intent Body->>> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (err) {
      // ignore: avoid_print
      print('err charging user: ${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    final calculatedAmout = (int.parse(amount)) * 100;
    return calculatedAmout.toString();
  }
}
