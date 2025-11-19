import 'package:flutter/material.dart';

class InvoicePage extends StatelessWidget {
  const InvoicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 378,
          height: 491,
          decoration: const BoxDecoration(
              color: Colors.white,
              border: Border.fromBorderSide(
                  BorderSide(color: Colors.black, width: .5))),
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 25,
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: Text(
                          "[Company Name]",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontFamily: "Roboto",
                              fontSize: 13),
                        ),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        "[Street Address]\n[City: ST ZP]\nPhone : (000)000-00000",
                        style: TextStyle(
                            fontSize: 8,
                            fontFamily: "Roboto",
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 50,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "INVOICE",
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontFamily: "Roboto",
                            color: Colors.grey.shade600,
                            fontSize: 19),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: SizedBox(
                          height: 50,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 70,
                                    height: 17,
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.only(left: 10),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black, width: .5),
                                        color: Colors.grey.shade200),
                                    child: const Text(
                                      "#INVOICE",
                                      style: TextStyle(
                                          fontFamily: "Roboto",
                                          fontSize: 8,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  Container(
                                    width: 70,
                                    height: 17,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black, width: .5),
                                        color: Colors.grey.shade200),
                                    child: const Text(
                                      "DATE",
                                      style: TextStyle(
                                          fontFamily: "Roboto",
                                          fontSize: 8,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 70,
                                    height: 17,
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.only(left: 10),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black, width: .5),
                                        color: Colors.white),
                                    child: const Text(
                                      "[123456]",
                                      style: TextStyle(
                                          fontFamily: "Roboto",
                                          fontSize: 8,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  Container(
                                    width: 70,
                                    height: 17,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black, width: .5),
                                        color: Colors.white),
                                    child: const Text(
                                      "[5/1/2014]",
                                      style: TextStyle(
                                          fontFamily: "Roboto",
                                          fontSize: 8,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 25,
                  ),
                  Container(
                    width: 150,
                    padding: const EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      border: Border.all(color: Colors.black, width: 1),
                    ),
                    child: const Text(
                      "BILL TO",
                      style: TextStyle(
                          fontFamily: "Roboto",
                          fontSize: 10,
                          fontWeight: FontWeight.w800),
                    ),
                  ),
                ],
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 25,
                  ),
                  Text(
                    '[Name]\n[Company] [Name]\n[Street Address]\n[City: ST ZP]\n[Phone]\n[Email Address]',
                    style: TextStyle(
                        fontSize: 8,
                        fontFamily: "Roboto",
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  height: 150,
                  width: 330,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 240,
                            height: 17,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black, width: .2),
                                color: Colors.grey.shade200),
                            child: const Text(
                              "DESCRIPTION",
                              style: TextStyle(
                                  fontFamily: "Roboto",
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          Container(
                            width: 88,
                            height: 17,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black, width: .5),
                                color: Colors.grey.shade200),
                            child: const Text(
                              "Amount",
                              style: TextStyle(
                                  fontFamily: "Roboto",
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            width: 240,
                            height: 115,
                            padding: const EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black, width: .5),
                                color: Colors.white),
                            child: const Text(
                              "Service fee \nLabor :5 hours at \$75\nNew client discount \nTax (4.5% after discount)",
                              style: TextStyle(
                                  fontFamily: "Roboto",
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          Container(
                            width: 88,
                            height: 115,
                            alignment: Alignment.topRight,
                            padding: const EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black, width: .5),
                                color: Colors.white),
                            child: const Text(
                              "200.00 \n375.00\n(50.00)\n26.56",
                              style: TextStyle(
                                  fontFamily: "Roboto",
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            width: 180,
                            height: 16,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black, width: .5),
                                color: Colors.white),
                            child: const Text(
                              "Thank you for the business!",
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontFamily: "Roboto",
                                  fontSize: 8,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          Container(
                            width: 148,
                            height: 16,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black, width: .5),
                                color: Colors.white),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "TOTAL ",
                                  style: TextStyle(
                                      fontFamily: "Roboto",
                                      fontSize: 9,
                                      fontWeight: FontWeight.w800),
                                ),
                                Text(
                                  "\$ ",
                                  style: TextStyle(
                                      fontFamily: "Roboto",
                                      fontSize: 9,
                                      fontWeight: FontWeight.w800),
                                ),
                                Text(
                                  "551.56 ",
                                  style: TextStyle(
                                      fontFamily: "Roboto",
                                      fontSize: 9,
                                      fontWeight: FontWeight.w800),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  )),
              const SizedBox(
                height: 30,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "If you have any question about this invoice, please contact\n[Name,Phone,email@address.com] ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: "Roboto",
                        fontSize: 7,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  )
                ],
              )
            ],
          ),
        ),

//------------------------------------
      ],
    );
  }
}
