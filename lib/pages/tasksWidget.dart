
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lorobot_app/pages/tasks/testDelete.dart';

Widget buildVerticalTextButton(String text, Color backgroundColor, double width) {
  return ElevatedButton(
    onPressed: () {},
    child: Text(
      text,
      style: TextStyle(fontSize: 30),
    ),
    style: ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      shape: const StadiumBorder(),
    ).copyWith(
      minimumSize: MaterialStateProperty.all(Size(width, 70)),
    ),
  );
}

class TasksWidget extends StatelessWidget {
  const TasksWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.878,
          child:FittedBox(
            child: const Image(image: AssetImage('lib/assets/images/occumap.png'),),
          ),
        ),
        Flexible(
          child:
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 280,
                height: 500,
                child:PointsTableWidget(),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildVerticalTextButton('GO', Colors.green, 120),
                  SizedBox(
                    height: MediaQuery.of(context).size.height*0.05,
                  ),
                  buildVerticalTextButton('STOP', Colors.pink, 120),
                ],
              )
            ],
          ),
        )

        // Flexible(
        //   child: TasksTable(headersData: headersData, rowsData: rowsData),
        // ),
      ],
    );
  }
}

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

