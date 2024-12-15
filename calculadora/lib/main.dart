import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  dynamic displaytxt = 20;
  dynamic text = '0';
  double numOne = 0;
  double numTwo = 0;
  dynamic result = '';
  dynamic finalResult = '';
  dynamic opr = '';
  dynamic preOpr = '';
  bool isOperatorPressed = false;

  // Button Widget
  Widget calcButton(String btntxt, Color btncolor, Color txtcolor) {
    return Container(
      child: ElevatedButton(
        onPressed: () => calculation(btntxt),
        style: ElevatedButton.styleFrom(
          shape: CircleBorder(),
          padding: EdgeInsets.all(20),
          backgroundColor: btncolor,
        ),
        child: Text(
          btntxt,
          style: TextStyle(fontSize: 35, color: txtcolor),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Calculator'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            // Calculator display
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      text,
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.white, fontSize: 50),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 10),
            buildButtonRow(['AC', 'Del', '%', '/'], Colors.grey, Colors.amber[700]!),
            SizedBox(height: 10),
            buildButtonRow(['7', '8', '9', 'x'], Colors.grey[850]!, Colors.amber[700]!),
            SizedBox(height: 10),
            buildButtonRow(['4', '5', '6', '-'], Colors.grey[850]!, Colors.amber[700]!),
            SizedBox(height: 10),
            buildButtonRow(['1', '2', '3', '+'], Colors.grey[850]!, Colors.amber[700]!),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () => calculation('0'),
                  style: ElevatedButton.styleFrom(
                    shape: StadiumBorder(),
                    padding: EdgeInsets.fromLTRB(34, 20, 128, 20),
                    backgroundColor: Colors.grey[850],
                  ),
                  child: Text(
                    '0',
                    style: TextStyle(fontSize: 35, color: Colors.white),
                  ),
                ),
                calcButton('.', Colors.grey[850]!, Colors.white),
                calcButton('=', Colors.amber[700]!, Colors.white),
              ],
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  // Utility to build button rows
  Row buildButtonRow(List<String> texts, Color btnColor, Color operatorColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: texts.map((txt) {
        Color color = (['/', 'x', '-', '+', '='].contains(txt)) ? operatorColor : btnColor;
        Color textColor = (['/', 'x', '-', '+', '='].contains(txt)) ? Colors.white : Colors.black;
        return calcButton(txt, color, textColor);
      }).toList(),
    );
  }

  // Calculator logic
  void calculation(String btnText) {
    try {
      if (btnText == 'AC') {
        text = '0';
        numOne = 0;
        numTwo = 0;
        result = '';
        finalResult = '0';
        opr = '';
        preOpr = '';
      } else if (btnText == 'Del') {
        // Delete the last character from the current input
        if (result.isNotEmpty) {
          result = result.substring(0, result.length - 1);
          finalResult = result.isEmpty ? '0' : result;
          setState(() {
            text = finalResult;
          });
        }
      } else if (opr == '=' && btnText == '=') {
        if (preOpr == '+') {
          finalResult = add();
        } else if (preOpr == '-') {
          finalResult = sub();
        } else if (preOpr == 'x') {
          finalResult = mul();
        } else if (preOpr == '/') {
          finalResult = div();
        }
      } else if (['+', '-', 'x', '/', '='].contains(btnText)) {
        if (result.isNotEmpty) {
          if (numOne == 0) {
            numOne = double.tryParse(result) ?? 0;
          } else {
            numTwo = double.tryParse(result) ?? 0;
          }

          if (opr == '+') {
            finalResult = add();
          } else if (opr == '-') {
            finalResult = sub();
          } else if (opr == 'x') {
            finalResult = mul();
          } else if (opr == '/') {
            finalResult = div();
          }
        }

        preOpr = opr;
        opr = btnText;

        // Si el operador ha sido presionado, mantener el primer número y mostrar el operador
        setState(() {
          text = result.isEmpty
              ? (numOne == 0 ? '' : numOne.toString()) + ' $opr'
              : result + ' $opr';
        });

        result = ''; // Preparar para el siguiente número
      } else if (btnText == '%') {
        result = (numOne / 100).toString();
        finalResult = formatResult(numOne / 100);
      } else if (btnText == '.') {
        if (!result.toString().contains('.')) {
          result = '$result.';
        }
        finalResult = result;
      } else {
        // Si el resultado es '0.0' o '0', lo reemplazamos por vacío
        if (result == '0' || result == '0.0') {
          result = '';
        }
        result = result + btnText;
        finalResult = result;
        setState(() {
          text = result;
        });
      }

      setState(() {
        if (btnText == '=' && opr.isNotEmpty) {
          text = finalResult;
        }
      });
    } catch (e) {
      setState(() {
        text = 'Error';
      });
    }
  }

  String add() {
    result = (numOne + numTwo).toString();
    numOne = double.tryParse(result) ?? 0;
    return formatResult(numOne);
  }

  String sub() {
    result = (numOne - numTwo).toString();
    numOne = double.tryParse(result) ?? 0;
    return formatResult(numOne);
  }

  String mul() {
    result = (numOne * numTwo).toString();
    numOne = double.tryParse(result) ?? 0;
    return formatResult(numOne);
  }

  String div() {
    if (numTwo == 0) return 'Error';
    result = (numOne / numTwo).toString();
    numOne = double.tryParse(result) ?? 0;
    return formatResult(numOne);
  }

  // Formato sin decimales
  String formatResult(double value) {
    if (value == value.toInt()) {
      return value.toInt().toString();
    }
    return value.toString();
  }
}
