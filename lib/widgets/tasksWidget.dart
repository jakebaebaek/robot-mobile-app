import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lorobot_app/widgets/tasks/tasksTable.dart';


final List headersData = ['Task', 'Goal', 'Assigned'];
final List rowDatas = List.generate(10, (index) => ['A$index', 'B$index', 'Apollo_$index']);
final List<List> rowsData = 
    List.generate(10, (index) => ['A$index', 'B$index', 'Apollo_$index'])
  ;

class TasksWidget extends StatelessWidget {
  const TasksWidget({super.key});  
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FittedBox(
          child: const Image(image: AssetImage('lib/assets/images/occumap.png'),),
        ),
        Flexible(
          child: TasksTable(headersData: headersData, rowsData: rowsData),
        ),
      ],
    );
  }
}
