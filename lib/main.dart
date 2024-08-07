import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  String text = "",s='';
  double result = 0.0;
  int demkq=0;
  List<String> bieuthuc=[];

  void btnClicked(String btnText) {
    if(text.isNotEmpty){
      s =text[text.length-1];
    }
    if (btnText == "=" ) {
      setState(() {
        text = text;
        result = ketqua(text);
        demkq=1;
      });
    }
    else if(_laToanTu(btnText)  && demkq==1){
      setState(() {
        text = result.toString();
        text = text + btnText;
        demkq=0;
      });
    }
    else if(ktraSo(btnText) && demkq==1 ){
      setState(() {
        text="";
        text = text + btnText;
        result=double.parse(text+btnText);
        demkq=0;
      });
    }
    else if(btnText=='xoa'){
      setState(() {
        text= text.substring(0, text.length-1);
      });
    }
    else if(_laToanTu(btnText) && _laToanTu(s)){
      setState(() {
        text=text;
      });
    }
    else {
      setState(() {
        text = text + btnText;
      });
    }
    if (btnText == 'C' ) {
      text = "";
      result = 0.0;
    }


  }

  double ketqua(String list) {
    List<String> stack = [];
    List<String> output = [];
    List<String> op = [];
    // tach cac ki tu trong chuoi
    String so = '';
    for (int i = 0; i < list.length; i++) {
      String s = list[i];
      if (_laToanTu(s) || laDauNgoac(s)) {
        if (so.isNotEmpty) {
          output.add(so);
          so = '';
        }
        output.add(s);
      } else {
        so += s;
      }
    }
    if (so.isNotEmpty) {
      output.add(so);
    }
    for (int i = 0; i < output.length; i++) {
      bieuthuc.add(output[i]);
    }
    //
// chuyen trung to sang hau to
    for (int i = 0; i < output.length; i++) {
      String token = output[i];
      if (ktraSo(token)) {
        op.add(token);
      } else if (_laToanTu(token)) {
        while (stack.isNotEmpty &&
            _laToanTu(stack.last) &&
            soSanhDoUuTien(stack.last, token) >= 0) {
          op.add(stack.removeLast());
        }
        stack.add(token);
      } else if (laDauMoNgoac(token)) {
        stack.add(token);
      } else if (laDauDongNgoac(token)) {
        while (stack.isNotEmpty && !laDauMoNgoac(stack.last)) {
          op.add(stack.removeLast());
        }
        stack.removeLast();
      }
    }
    while (stack.isNotEmpty) {
      op.add(stack.removeLast());
    }
    double result1 = evaluatePostfix(op);
    return result1;
  }

  bool ktraSo(String input) {
    if (input == "" || input.isEmpty) {
      return false;
    }
    // Attempt to parse input as a double
    return double.tryParse(input) != null;
  }

  bool laDauNgoac(String s) {
    return s == '(' || s == ')';
  }

  bool laDauDongNgoac(String s) {
    return s == ')';
  }

  bool laDauMoNgoac(String s) {
    return s == '(';
  }

  bool _laToanTu(String s) {
    return s == '+' || s == '-' || s == '*' || s == '/';
  }

  int doUuTien(String key) {
    if (key == '*' || key == '/') return 2;
    if (key == '+' || key == '-') return 1;
    return 0;
  }

  int soSanhDoUuTien(String op1, String op2) {
    Map<String, int> precedence = {
      '+': 1,
      '-': 1,
      '*': 2,
      '/': 2,
    };
    return precedence[op1]! - precedence[op2]!;
  }

  double evaluatePostfix(List<String> postfixExpression) {
    List<double> stack = [];

    for (String token in postfixExpression) {
      if (ktraSo(token)) {
        stack.add(double.parse(token));
      } else if (_laToanTu(token)) {
        double operand2 = stack.removeLast();
        double operand1 = stack.removeLast();
        double result = performOperation(operand1, operand2, token);
        stack.add(result);
      }
    }

    return stack.isNotEmpty ? stack.removeLast() : 0;
  }

  double performOperation(double operand1, double operand2, String operator) {
    switch (operator) {
      case '+':
        return operand1 + operand2;
      case '-':
        return operand1 - operand2;
      case '*':
        return operand1 * operand2;
      case '/':
        if (operand2 != 0) {
          return operand1 / operand2;
        } else {
          throw Exception('Division by zero');
        }
      default:
        throw Exception('Invalid operator: $operator');
    }
  }

  Widget customOutlineButton(String value) {
    return Expanded(
      child: OutlinedButton(
          onPressed: () => btnClicked(value),
          //padding: EdgeInsets.all(25),
          child: Text(
            value,
            style: const TextStyle(fontSize: 25),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('calculator')),
      body: Column(
        children: [
          Expanded(
              child: Container(
                color: Colors.blue,
                alignment: Alignment.bottomRight,
                padding: EdgeInsets.all(10),
                child: Text(
                  text,
                  style: const TextStyle(
                      fontSize: 50, fontWeight: FontWeight.w700, color: Colors.red),
                ),
              )),
          Expanded(
              child: Container(
                color: Colors.green,
                alignment: Alignment.bottomRight,
                padding: EdgeInsets.all(10),
                child: Text(
                  result.toString(),
                  style: const TextStyle(
                      fontSize: 50, fontWeight: FontWeight.w700, color: Colors.red),
                ),
              )),
          // tao phim so
          Row(
            children: [
              customOutlineButton("("),
              customOutlineButton(")"),
              customOutlineButton(""),
              customOutlineButton("xoa"),
            ],
          ),
          Row(
            children: [
              customOutlineButton("9"),
              customOutlineButton("8"),
              customOutlineButton("7"),
              customOutlineButton("+"),
            ],
          ),
          Row(
            children: [
              customOutlineButton("6"),
              customOutlineButton("5"),
              customOutlineButton("4"),
              customOutlineButton("-"),
            ],
          ),
          Row(
            children: [
              customOutlineButton("3"),
              customOutlineButton("2"),
              customOutlineButton("1"),
              customOutlineButton("*"),
            ],
          ),
          Row(
            children: [
              customOutlineButton("C"),
              customOutlineButton("0"),
              customOutlineButton("="),
              customOutlineButton("/"),
            ],
          )
        ],
      ),
    );
  }
}
