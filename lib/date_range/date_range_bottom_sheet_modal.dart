import 'package:flutter/material.dart';

import '../widget/date_field_widget/date_filed_widget.dart';

class DateRangeBottomSheetModal extends StatefulWidget {
  final BuildContext ctx;
  final Function(bool,Map<String,String>)? dateRangePost;
  final Function(bool)? onDateReset;
  final String? folderId;
  final String? id;
  final String? searchSourceType;
  const DateRangeBottomSheetModal({Key? key,this.id,this.folderId,this.dateRangePost,this.onDateReset,required this.searchSourceType, required this.ctx}) : super(key: key);

  @override
  State<DateRangeBottomSheetModal> createState() => _DateRangeBottomSheetModalState();
}

class _DateRangeBottomSheetModalState extends State<DateRangeBottomSheetModal> {
  String? _startDate;
  String? _endDate;


  @override
  void initState() {

    super.initState();
  }

  bool _postDateRangeData({String? startDate, String? searchSourceType}){
    Navigator.of(context).pop();
    bool isTrue=false;

    if(startDate!=null){
      switch (searchSourceType) {
        case 'project_history_date':isTrue = true;

        break;


      }

    }
    return isTrue;

  }
  // void _onDateReset(){
  //   Navigator.of(context).pop();
  //
  //
  // }
  @override
  Widget build(BuildContext context) {
    return

      Stack(
          children:[ Container(
              height: 130,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 0.0,right: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.close)),
                        const Text('Select date range', style: TextStyle(fontFamily: 'Roboto', fontSize: 20.0, fontWeight: FontWeight.w500),),
                        const Spacer(),
                        TextButton(
                            onPressed:(){
                              Navigator.of(context).pop();
                              widget.onDateReset!(false);
                            }
                            , child: Text('Reset',style: TextStyle(color:Colors.grey.shade700 ),)),
                        TextButton(
                            onPressed: _startDate !=null ? (){

                              bool isTrue = _postDateRangeData(startDate:_startDate,searchSourceType: widget.searchSourceType);
                              widget.dateRangePost!(isTrue,{
                                'startDate':'$_startDate',
                                'endDate': '$_endDate'
                              });
                            }:null
                            , child: Text('Apply',style: TextStyle(color: _startDate !=null ? Colors.blue:Colors.blue.shade200 ),))

                      ],),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0,right: 16.0),
                      child: DateFieldWidget(
                        hasIcon: true,
                        name: 'Select date',
                        subName: 'Date',
                        maximumDate: _startDate != null ? DateTime.parse(DateTime.now().toString()).subtract(const Duration(days: 1)) : null,
                        onChange: (val) {
                          setState(() {
                            _startDate = val;
                          });
                        },
                      ),
                    ),
                  ),
                ],

              )),]
      );
  }
}