import 'package:dont_worry/theme/colors.dart';
import 'package:dont_worry/utils/enum.dart';
import 'package:flutter/material.dart';

class ListHeader extends StatefulWidget {
  final bool? isLending;
  final UnitType unitType;
  final Function(String)? onSortOptionSelected;
  const ListHeader(
      {this.isLending,
      this.onSortOptionSelected,
      required this.unitType,
      super.key});

  @override
  State<ListHeader> createState() => _ListHeaderState();
}

class _ListHeaderState extends State<ListHeader> {
  String selectedSortOption = '업데이트 순';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Offstage(
          offstage: widget.unitType == UnitType.person,
          child: Divider(height: 0, color: AppColor.divider.of(context)),
        ),
        Container(
          color: widget.unitType == UnitType.person
              ? Colors.transparent
              : widget.isLending != null // 상환여부 따라 글씨색상 변경
                  ? AppColor.containerWhite.of(context)
                  : AppColor.containerLightGray20.of(context),
          child: SizedBox(
            height: 60,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 14),
                Icon(
                  widget.isLending != null
                      ? widget.unitType == UnitType.person
                          ? Icons.person
                          : Icons.payments
                      : Icons.check,
                ),
                SizedBox(width: 8),
                Text(
                    widget.isLending != null
                        ? widget.isLending == true
                            ? widget.unitType == UnitType.person
                                ? '내가 빌려준 사람'
                                : '내가 빌려준 돈'
                            : widget.unitType == UnitType.person
                                ? '내가 빌린 사람'
                                : '내가 빌린 돈'
                        : '이미 다 갚았어요',
                    style: TextStyle(
                        fontSize: 16,
                        color: AppColor.defaultBlack.of(context),
                        fontWeight: FontWeight.w900)),
                Spacer(),
                Offstage(
                  offstage: widget.isLending == null,
                  child: PopupMenuButton(
                      icon: Row(
                        children: [
                          Text(
                            selectedSortOption,
                            style:
                                TextStyle(color: AppColor.gray20.of(context)),
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            color: AppColor.gray20.of(context),
                          )
                        ],
                      ),
                      itemBuilder: (BuildContext context) {
                        return [
                          PopupMenuItem(
                            value: '업데이트 순',
                            child: Text('업데이트 순'),
                          ),
                          PopupMenuItem(
                            value: '높은 가격 순',
                            child: Text('높은 가격 순'),
                          ),
                        ];
                      },
                      onSelected: (value) {
                        setState(() {
                          selectedSortOption = value; // 선택된 값으로 업데이트
                        });
                        if (widget.onSortOptionSelected != null) {
                          widget.onSortOptionSelected!(value);
                        }
                      }),
                ),
                SizedBox(width: 14),
              ],
            ),
          ),
        ),
        Offstage(
          offstage: widget.unitType == UnitType.person,
          child: Divider(height: 0, color: AppColor.divider.of(context)),
        )
      ],
    );
  }
}
