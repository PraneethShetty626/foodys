import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodyrest/domain/HttpClient/http_client.dart';
import 'package:foodyrest/widgets/custom_text_button.dart';
import 'package:google_fonts/google_fonts.dart';

class AddFood extends StatefulWidget {
  final Function function;
  const AddFood(this.function, {super.key});

  @override
  State<AddFood> createState() => _AddFoodState();
}

class _AddFoodState extends State<AddFood> {
  int selectedOption = 0;
  String name = '';
  int amount = 0;
  List<String> urls = [
    'https://img.freepik.com/free-photo/flat-lay-batch-cooking-composition_23-2148765597.jpg',
    'https://t3.ftcdn.net/jpg/04/09/16/58/360_F_409165817_Gqjkeb3I5aGf08SLAlNjUtP1tMN9mE4s.jpg',
    'https://assets.cntraveller.in/photos/627a4112cbc04ca509426501/4:3/w_2932,h_2199,c_limit/Vegetarian%20South%20Indian%20breakfast%20thali%20-%20Idli%20vada%20sambar%20chutney%20-%20Image%20ID%202H3783R%20(RF).jpg',
    'https://d2jx2rerrg6sh3.cloudfront.net/image-handler/picture/2018/4/shutterstock_1By_stockcreations.jpg',
    'https://img.freepik.com/free-photo/fresh-orange-juice-glass-dark-background_1150-45560.jpg',
    'https://media-cdn.tripadvisor.com/media/photo-s/0e/6f/8d/cf/veg-meals.jpg'
  ];
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        // width: 600,
        // height: 600,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Let's create new Recipe",
                            style: GoogleFonts.aclonica(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 300,
                    width: 300,
                    child: Image.network(
                        "https://img.freepik.com/free-photo/flat-lay-batch-cooking-composition_23-2148765597.jpg"),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(8),
              width: 500,
              // height: 400,
              child: Form(
                key: _formkey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      height:
                          50, // Provide a specific height for the TextField widgets
                      child: _textField("Name of Food Item", TextInputType.text,
                          FontAwesomeIcons.bowlFood, (val) {
                        return val.toString().isEmpty ? "Enter name" : null;
                      }, (val) {
                        name = val;
                      }),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      height:
                          50, // Provide a specific height for the TextField widgets
                      child: _textField(
                        "Price of food per serve",
                        TextInputType.number,
                        FontAwesomeIcons.moneyBill,
                        (val) {
                          return val.toString().isEmpty ? "Enter amount" : null;
                        },
                        (val) {
                          amount = int.parse(val);
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    DropdownButtonFormField<int>(
                      value: selectedOption,
                      items: const [
                        DropdownMenuItem(
                            value: 0, child: Text('Default food image')),
                        DropdownMenuItem(value: 1, child: Text('Dosa image')),
                        DropdownMenuItem(value: 2, child: Text('idli image')),
                        DropdownMenuItem(
                            value: 3, child: Text('Juice image 1')),
                        DropdownMenuItem(
                            value: 4, child: Text('Juice image 2')),
                        DropdownMenuItem(value: 5, child: Text('Meals')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedOption = value!;
                        });
                      },
                      decoration:
                          inputdecoration("Image Type", FontAwesomeIcons.image),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: (() => Navigator.of(context).pop()),
            child: Text('Cancel')),
        CustomTextButton(
          text: "Save",
          onTap: () {
            if (_formkey.currentState!.validate()) {
              _formkey.currentState!.save();
              HttpClient()
                  .addFoodItem(name, urls[selectedOption], amount)
                  .then((value) =>
                      widget.function(name, urls[selectedOption], amount))
                  .then((value) => Navigator.of(context).pop())
                  .then((value) => showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            content: Text("New Item successfully added"),
                            actions: [
                              CustomTextButton(
                                text: "Close",
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                              )
                            ],
                          )))
                  .onError((error, stackTrace) => print(error));
            }
          },
        )
      ],
    );
  }
}

TextFormField _textField(String text, TextInputType inputType,
        IconData iconData, Function validator, Function onsave) =>
    TextFormField(
      style: const TextStyle(fontSize: 12),
      inputFormatters: [
        if (inputType == TextInputType.number)
          FilteringTextInputFormatter.digitsOnly,
      ],
      keyboardType: inputType,
      validator: (value) => validator(value),
      onSaved: (newValue) => onsave(newValue),
      decoration: inputdecoration(text, iconData),
    );

InputDecoration inputdecoration(String text, IconData iconData) =>
    InputDecoration(
      hintText: text,
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(width: 3, color: Color.fromARGB(255, 5, 47, 27)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(width: 3, color: Color.fromARGB(255, 3, 26, 15)),
      ),
      prefixIcon: Container(
        padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
        child: FaIcon(
          iconData,
          size: 16,
        ),
      ),
    );
