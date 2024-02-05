import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TasksWidget extends StatelessWidget {
  const TasksWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Image(image: AssetImage('lib/assets/images/occumap.png'),),
        Table(
              //TODO columns should be fixed later.
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                  children: [
                    Container(
                      height: 50, 
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(width: 0.5, color: Colors.grey))
                      ),
                      child: Center(
                        child: Text('작업'),
                      ),
                    ),
                    Container(
                      height: 50, 
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(width: 0.5, color: Colors.grey))
                      ),
                      child: Center(
                        child: Text('목적지'),
                      ),
                    ),
                    Container(
                      height: 50, 
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(width: 0.5, color: Colors.grey))
                      ),
                      child: Center(
                        child: Text('할당 로봇'),
                      ),
                    ),
                    Container(
                      height: 50, 
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(width: 0.5, color: Colors.grey))
                      ),
                      child: Center(
                        child: Text('할당 로봇'),
                      ),
                    ),
                  ],
                ),
              ],
          ),
          Flexible(
            fit: FlexFit.tight,
            child: SingleChildScrollView(
              child: Table(
              children: [
                  TableRow(
                    children: [
                      Container(
                        height: 50, 
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(width: 0.5, color: Colors.grey))
                        ),
                        child: Center(
                          child: Text('A1'),
                        ),
                      ),
                      Container(
                        height: 50, 
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(width: 0.5, color: Colors.grey))
                        ),
                        child: Center(
                          child: Text('B1'),
                        ),
                      ),
                      Container(
                        height: 50, 
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(width: 0.5, color: Colors.grey))
                        ),
                        child: Center(
                          child: Text('Apollo_1'),
                        ),
                      ),
                      Container(
                        height: 50, 
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(width: 0.5, color: Colors.grey))
                        ),
                        child: Center(
                          child: Text('Apollo_1'),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Container(
                        height: 50, 
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(width: 0.5, color: Colors.grey))
                        ),
                        child: Center(
                          child: Text('A1'),
                        ),
                      ),
                      Container(
                        height: 50, 
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(width: 0.5, color: Colors.grey))
                        ),
                        child: Center(
                          child: Text('B1'),
                        ),
                      ),
                      Container(
                        height: 50, 
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(width: 0.5, color: Colors.grey))
                        ),
                        child: Center(
                          child: Text('Apollo_1'),
                        ),
                      ),
                      Container(
                        height: 50, 
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(width: 0.5, color: Colors.grey))
                        ),
                        child: Center(
                          child: Text('Apollo_1'),
                        ),
                      ),
                    ],
                  ),
              ],
              ),
            ),
          ),
      ],
    );
  }
}
