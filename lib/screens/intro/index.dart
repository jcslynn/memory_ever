import 'package:flutter/material.dart';

class IntroPage extends StatelessWidget {
  final int stepNum;

  const IntroPage(this.stepNum);

  String getStepNum() {
    return this.stepNum.toString() + ' / 4';
  }

  String getStepText() {
    switch (this.stepNum) {
      case 1:
        return '先申請我們的計劃';
      case 2:
        return '獲得專用暮誌銘並掃描二維碼';
      case 3:
        return '輸入密碼查看先人墓誌銘頁面';
      case 4:
        return '把先人事蹟傳承下去';
      default:
        return '';
    }
  }

  String getStepImageUrl() {
    switch (this.stepNum) {
      case 1:
        return 'assets/shutterstock138342692.png';
      case 2:
        return 'assets/shutterstock635558846.png';
      case 3:
        return 'assets/shutterstock261845771.png';
      case 4:
        return 'assets/shutterstock333702980.png';
      default:
        return 'assets/shutterstock635558846.png';
    }
  }

  List<Widget> getControlButtons(BuildContext context) {
    return <Widget>[
      this.stepNum == 1
          ? Icon(Icons.arrow_back, color: Colors.transparent, size: 40.0)
          : IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white, size: 40.0),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
      Expanded(
          flex: 1,
          child: Text(
            getStepNum(),
            textAlign: TextAlign.center,
            style: new TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 30.0,
            ),
          )),
      this.stepNum == 4
          ? Icon(Icons.arrow_forward, color: Colors.transparent, size: 40.0)
          : IconButton(
              icon: Icon(Icons.arrow_forward, color: Colors.white, size: 40.0),
              onPressed: () {
                Navigator.pushNamed(
                    context, '/intro' + (this.stepNum + 1).toString());
              },
            ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
                color: Colors.black,
                image: DecorationImage(
                  colorFilter: new ColorFilter.mode(
                      Colors.black.withOpacity(0.6), BlendMode.dstATop),
                  image: ExactAssetImage(getStepImageUrl()),
                  fit: BoxFit.cover,
                )),
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                    width: MediaQuery.of(context).size.width * 0.733,
                    height: MediaQuery.of(context).size.width * 0.733,
                    decoration: BoxDecoration(
                        border: Border.all(
                      color: Colors.white,
                      width: 3.0,
                    )),
                    alignment: Alignment.center,
                    child: ConstrainedBox(
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.5),
                        child: Text(
                          getStepText(),
                          textAlign: TextAlign.center,
                          style: new TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 24.0,
                          ),
//                    overflow: TextOverflow.clip,
                        ))),
                Padding(
                  padding: EdgeInsets.only(top: 32.0),
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.733,
                    child: Row(children: getControlButtons(context))),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: this.stepNum == 4
                      ? FlatButton(
                          color: Colors.blue,
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/scan',
                              ModalRoute.withName('/splash'),
                            );
                          },
                          child: Text(
                            '開始使用',
                            style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ))
                      : null,
                )
              ],
            )));
  }
}
