
import 'package:flutter/material.dart';
import "package:mobile_yp/color_schemes.g.dart";
import "package:mobile_yp/public_cc.dart";
import "package:mobile_yp/custom_color.g.dart";



class View extends StatelessWidget {
  const View({
    Key? key, required this.title,required this.agency,required this.date,
  }) : super(key: key);
  final String title;
  final String agency;
  final String date;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightColorScheme.background,
      appBar: AppBar(
        backgroundColor: lightColorScheme.background,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20),
              child: Text(title,
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 30,
                    color: lightColorScheme.onPrimaryContainer
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left:20,bottom: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Icon(Icons.apartment,size: 30,color: lightColorScheme.onSecondaryContainer),
                  Padding(padding: EdgeInsets.only(left: 15),
                      child: Text(agency,
                        style: TextStyle(
                            fontSize: 22,
                            color: lightColorScheme.onSecondaryContainer
                        ),
                      ),
                  )
                ],
              )
            ),
            Padding(
                padding: EdgeInsets.only(left:20,bottom: 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Icon(Icons.calendar_month_outlined,size: 30),
                    Padding(padding: EdgeInsets.only(left: 15),
                      child: Text(date,
                        style: TextStyle(
                            fontSize: 22,
                            color: lightColorScheme.onSecondaryContainer
                        ),
                      ),
                    )
                  ],
                )
            ),
            Padding(
                padding: EdgeInsets.only(left:20,bottom: 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Icon(Icons.person_outlined,size: 30),
                    Padding(padding: EdgeInsets.only(left: 15),
                      child: Text("蘇明慧",
                        style: TextStyle(
                            fontSize: 22,
                            color: lightColorScheme.onSecondaryContainer
                        ),
                      ),
                    )
                  ],
                )
            ),
            Padding(
                padding: EdgeInsets.only(left:20,bottom: 15),
                child: Padding(padding: EdgeInsets.only(top: 15),
                  child: Text("""Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam nec facilisis diam. Sed interdum magna vitae elit pellentesque, sit amet euismod nunc consectetur. Sed pretium varius nibh, et vehicula lectus scelerisque vitae. Vivamus vestibulum odio vel nisl luctus, non lacinia sem sollicitudin. In molestie mollis nibh quis condimentum. Aliquam iaculis tincidunt rutrum. Praesent bibendum mattis nisl a consequat. Mauris eu turpis ex. Donec semper fermentum nisi eget efficitur. Fusce nec feugiat turpis.

                      Integer lectus ante, dapibus sed sem eu, dapibus venenatis sapien. Phasellus quis ultrices enim. Nulla aliquet dolor at enim rutrum, vitae sagittis ligula bibendum. Aliquam id ullamcorper lectus. Sed interdum maximus fringilla. Sed pharetra vel ex varius placerat. Maecenas maximus viverra mauris, vitae scelerisque diam vehicula ut. Etiam consectetur risus vel erat viverra, id elementum odio rhoncus.

                      Nunc dolor ligula, blandit id risus eu, congue aliquet mi. Morbi diam diam, molestie et lectus ut, sollicitudin iaculis neque. Etiam vitae leo rhoncus, dictum nunc tristique, blandit tellus. Mauris lacus odio, consequat quis mi sit amet, molestie scelerisque velit. Fusce orci enim, interdum quis consectetur fringilla, commodo id nisl. Donec vel tortor ut ante aliquam dignissim quis eget lectus. Suspendisse varius cursus dictum. Nunc porta lorem lectus, et dictum ex pharetra ac. Integer aliquam viverra ante, id condimentum tortor imperdiet sit amet. Curabitur gravida diam non sem pretium, sit amet fringilla mi aliquet. Praesent sit amet justo hendrerit, fermentum ex ac, egestas ligula. Sed porta odio at massa pharetra pulvinar.

                      Quisque ac dapibus libero. Mauris eget eros et urna efficitur congue. Suspendisse quis ante efficitur, suscipit dui quis, ornare urna. Sed commodo nec libero et faucibus. Sed bibendum eu sapien et cursus. Curabitur sollicitudin consequat nisi, eu tincidunt purus condimentum eget. Nam ornare et ipsum sed venenatis. Etiam velit nunc, porttitor in dolor eget, gravida tincidunt ex. Nullam sollicitudin euismod sem, eget pretium felis sagittis non. Etiam tincidunt orci urna, ut accumsan justo vulputate id. Fusce tempus augue eu nisl vehicula, eget fermentum tortor iaculis. Vivamus blandit luctus felis hendrerit placerat. Donec nec scelerisque sem. Nam at felis bibendum, aliquet est at, iaculis mi.`

                      Fusce vitae mattis lectus. Integer vitae risus pulvinar, pulvinar odio vitae, bibendum metus. Curabitur ornare leo non massa sodales, pharetra ornare metus porttitor. Nullam ligula ipsum, pulvinar ut justo ac, cursus porttitor libero. Sed ultricies lacinia posuere. Nunc congue felis at diam pretium fermentum. Nunc nisl ante, venenatis sed fringilla vel, tempus in sapien.""",
                    style: TextStyle(
                        fontSize: 20,
                        color: lightColorScheme.onSecondaryContainer
                    ),
                  ),
                )
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 10)),
            Padding(
                padding: EdgeInsets.only(left:20,bottom: 15,right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("連結",
                      style: TextStyle(
                          fontSize: 22,
                          color: lightColorScheme.primary,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 15),
                      child: ElevatedButton(
                        onPressed: () {  },
                        child: Row(
                          children: [
                            Icon(Icons.language_outlined),
                            Padding(padding: EdgeInsets.only(left: 10),
                            child: Text("Hi",
                              style: TextStyle(
                                  fontSize: 20
                              ),
                            ),
                            )
                          ],
                        )
                      )
                    )
                  ],
                )
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 50)),
          ],
        ),
      ),
    );
  }
}