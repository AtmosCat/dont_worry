import 'package:dont_worry/theme/colors.dart';
import 'package:flutter/material.dart';

Future<void> showDeleteBottomSheet(
    {required BuildContext context, required VoidCallback onConfirm, String text = '정말 삭제하시겠습니까?'}) async {
  await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return _DeleteBottomSheet(onConfirm: onConfirm, text:text);
      });
}

class _DeleteBottomSheet extends StatelessWidget {
  const _DeleteBottomSheet({required this.onConfirm, required this.text});

  final VoidCallback onConfirm;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(14.0),
        child: SizedBox(
          height: 200,
          child: Column(
            children: [
              Text(text),
              ListTile(
                leading: Icon(
                  Icons.task_alt,
                  color: AppColor.negative.of(context),
                ),
                title: Text(
                  '삭제',
                  style: TextStyle(
                      color: AppColor.negative.of(context),
                      fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  onConfirm();   
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.edit),
                title: Text('취소'),
                onTap: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ));
  }
}
