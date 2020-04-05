// ignore: avoid_web_libraries_in_flutter
//import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/rendering.dart';
import 'package:teddy/signin_button.dart';
import 'package:teddy/teddy_controller.dart';
import 'package:teddy/tracking_text_input.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: '登录页'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String platform;
  TeddyController _teddyController;

  @override
  initState() {
    _teddyController = TeddyController();
    super.initState();
  }

  void showAlert(BuildContext context) {
    showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            insetAnimationCurve: Curves.fastLinearToSlowEaseIn,
            title: Text('F&Q'),
            content: Text(
                '卡密？卡密就是一个类似于密码的东西，首先需要获取\n怎么获得？添加微信号cxxxxxxx\n还有问题？找找微信说去'),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text('了解'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    EdgeInsets devicePadding = MediaQuery.of(context).padding;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
          backgroundColor: Color.fromRGBO(93, 142, 155, 1.0),
          body: Builder(
            builder: (context) => Container(
                child: Stack(
              children: <Widget>[
                Positioned.fill(
                    child: Container(
                  decoration: BoxDecoration(
                    // Box decoration takes a gradient
                    gradient: LinearGradient(
                      // Where the linear gradient begins and ends
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      // Add one stop for each color. Stops should increase from 0 to 1
                      stops: [0.0, 1.0],
                      colors: [
                        Color.fromRGBO(170, 207, 211, 1.0),
                        Color.fromRGBO(93, 142, 155, 1.0),
                      ],
                    ),
                  ),
                )),
                Positioned.fill(
                  child: SingleChildScrollView(
                      padding: EdgeInsets.only(
                          left: 30.0,
                          right: 30.0,
                          top: devicePadding.top + 40.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                height: 200,
                                padding: const EdgeInsets.only(
                                    left: 30.0, right: 30.0),
                                child: FlareActor(
                                  "assets/Teddy.flr",
                                  shouldClip: false,
                                  alignment: Alignment.bottomCenter,
                                  fit: BoxFit.contain,
                                  controller: _teddyController,
                                )),
                            Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(25.0))),
                                child: Padding(
                                  padding: const EdgeInsets.all(30.0),
                                  child: Form(
                                      child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      ListTile(
                                        title: const Text('平台'),
                                        trailing: DropdownButton<String>(
                                          hint: const Text('选择刷课平台'),
                                          value: platform,
                                          onChanged: (String newValue) {
                                            _teddyController
                                                .setPlatform(newValue);
                                            setState(() {
                                              platform = newValue;
                                            });
                                          },
                                          items: <String>['超星', '智慧树']
                                              .map<DropdownMenuItem<String>>(
                                                  (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                      TrackingTextInput(
                                        label: "账号",
                                        hint: "平台账号——一般为手机号",
                                        onCaretMoved: (Offset caret) {
                                          _teddyController.lookAt(caret);
                                        },
                                        onTextChanged: (String value) {
                                          _teddyController.setID(value);
                                        },
                                      ),
                                      TrackingTextInput(
                                        label: "密码",
                                        hint: "输入密码",
                                        isObscured: true,
                                        onCaretMoved: (Offset caret) {
                                          _teddyController
                                              .coverEyes(caret != null);
                                          _teddyController.lookAt(null);
                                        },
                                        onTextChanged: (String value) {
                                          _teddyController.setPassword(value);
                                        },
                                      ),
                                      TrackingTextInput(
                                        label: "课程",
                                        hint: "输入你想刷的课程",
                                        onCaretMoved: (Offset caret) {
                                          _teddyController.lookAt(caret);
                                        },
                                        onTextChanged: (String value) {
                                          _teddyController.setClass(value);
                                        },
                                      ),
                                      TrackingTextInput(
                                        label: "卡密",
                                        hint: "输入卡密",
                                        onCaretMoved: (Offset caret) {
                                          _teddyController.lookAt(caret);
                                        },
                                        onTextChanged: (String value) {
                                          _teddyController.setSecret(value);
                                        },
                                      ),
                                      SigninButton(
                                          child: Text("下单",
                                              style: TextStyle(
                                                  fontFamily: "RobotoMedium",
                                                  fontSize: 16,
                                                  color: Colors.white)),
                                          onPressed: () {
                                            void show() {
                                              _teddyController
                                                  .submitPassword(context);
                                            }

                                            showDialog<void>(
                                                context: context,
                                                barrierDismissible: false,
                                                builder:
                                                    (BuildContext context) {
                                                  return CupertinoAlertDialog(
                                                    insetAnimationCurve: Curves
                                                        .fastLinearToSlowEaseIn,
                                                    title: Text('风险提示'),
                                                    content: Text(
                                                        '刷课有风险，脚本的设计已尽可能避免被检测，但仍有出现不良记录的可能性。\n默认操作，即单选、多选、判断题随机选择，填空、简答等文本类题目回答“不会”。\n题库的答案准确率较高，但无法保证自动答题功能始终可用，也无法保证答案全部正确。\n自动答题功能会采集部分非隐私数据上传，仅用于提高答案匹配度。\n每次脚本更新都会导致自定义参数重置为默认值，如有设置，请更新后及时修改。'),
                                                    actions: <Widget>[
                                                      CupertinoDialogAction(
                                                        isDestructiveAction:
                                                            true,
                                                        child: Text('已了解'),
                                                        onPressed: () {
                                                          Navigator.of(context).pop();
                                                          show();
                                                        },
                                                      ),
                                                      CupertinoDialogAction(
                                                        child: Text('不刷了'),
                                                        onPressed: () {
                                                          Navigator.of(context).pop();
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                });
                                          }),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          SigninButton(
                                              width: 100,
                                              child: Text("F&Q",
                                                  style: TextStyle(
                                                      fontFamily:
                                                          "RobotoMedium",
                                                      fontSize: 16,
                                                      color: Colors.white)),
                                              onPressed: () {
                                                showAlert(context);
                                              }),
                                          Text('         '),
                                          SigninButton(
                                              width: 100,
                                              child: Text("查询",
                                                  style: TextStyle(
                                                      fontFamily:
                                                          "RobotoMedium",
                                                      fontSize: 16,
                                                      color: Colors.white)),
                                              onPressed: () {
                                                void searchProgress() {
                                                  _teddyController
                                                      .searchProgress(context);
                                                }

                                                showDialog<void>(
                                                    context: context,
                                                    barrierDismissible: false,
                                                    builder:
                                                        (BuildContext context) {
                                                      return CupertinoAlertDialog(
                                                        insetAnimationCurve: Curves
                                                            .fastLinearToSlowEaseIn,
                                                        title: Text('输入账号'),
                                                        actions: <Widget>[
                                                          CupertinoTextField(
                                                            keyboardType:
                                                                TextInputType
                                                                    .phone,
                                                          ),
                                                          CupertinoDialogAction(
                                                            isDestructiveAction:
                                                                true,
                                                            child: Text('提交'),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              searchProgress();
                                                            },
                                                          ),
                                                          CupertinoDialogAction(
                                                            child: Text('取消'),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                          ),
                                                        ],
                                                      );
                                                    });
                                              })
                                        ],
                                      ),
                                    ],
                                  )),
                                )),
                          ])),
                ),
              ],
            )),
          )),
    );
  }
}
