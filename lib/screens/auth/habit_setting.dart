import 'dart:io';
import 'package:flutter/material.dart';

class AppColors {
  static const cream = Color(0xFFFFF8E1);   // 배경
  static const green = Color(0xFFAFDBAE);   // 인증 버튼
  static const brown = Color(0xFFBF8D6A);   // 메인 포인트
  static const brick = Color(0xFFC32B2B);
  static const dark = Color(0xFF535353);    // 텍스트
  static const divider = Color(0xFFD8CBB6); // 라인
  static const danger = Color(0xFFE25B5B);  // 에러
  static const inputBg = Color(0xFFF6F1DC); // 인풋 배경
}
/// 제출 결과를 상위에서 바로 쓸 수 있게 DTO로 반환
class HabitSetupData {
  final String title;
  final DateTime  startDate; // 시작일
  final DateTime  endDate; // 종료일
  final List<int> weekdays; // 1=월, ... 7=일
  final String bet;         // 감자 내기
  final CertType certType;  // 사진/글
  final String deadline;    // "21:30" 등

  HabitSetupData({
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.weekdays,
    required this.bet,
    required this.certType,
    required this.deadline,
  });
}

enum CertType { photo, text }
const HabitSetupLogoPath = 'lib/assets/image2/habit_setting_icon.png';

class HabitSetupPage extends StatefulWidget {
  const HabitSetupPage({
    super.key,
    this.initialTitle = '습관을 설정해주세요',
    this.initialStartDate,
    this.initialEndDate,
    this.initialWeekdays,
    this.initialBet,
    this.initialCertType = CertType.photo,
    this.initialDeadline,
  });

  final String initialTitle;
  final DateTime?  initialStartDate; // 시작일
  final DateTime?  initialEndDate;
  final List<int>? initialWeekdays; // 1~7
  final String? initialBet;
  final CertType initialCertType;
  final String? initialDeadline;

  @override
  State<HabitSetupPage> createState() => _HabitSetupPageState();
}

class _HabitSetupPageState extends State<HabitSetupPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleCtrl;
  DateTimeRange? _selectedRange;

  final List<bool> _weekdaySelected = List<bool>.filled(7, false);
  String? _betValue;
  CertType _certType = CertType.photo;
  String? _deadlineValue;

  static const _betOptions = ['감자 1개', '감자 3개', '감자 5개', '감자 10개'];
  static const _timeOptions = [
    '20:00','20:30','21:00','21:30','22:00','22:30','23:00'
  ];
  static const _labels = ['월','화','수','목','금','토','일'];

  @override
  void initState() {
    super.initState();
    _titleCtrl  = TextEditingController(text: widget.initialTitle);
    final now = DateTime.now();
    final start = widget.initialStartDate ?? DateTime(now.year, now.month, now.day);
    final end = widget.initialEndDate ?? start.add(const Duration(days: 27)); // 기본 4주
    _selectedRange = DateTimeRange(start: start, end: end);


    // 초기값 주입
    if (widget.initialWeekdays != null) {
      for (final d in widget.initialWeekdays!) {
        if (d >= 1 && d <= 7) _weekdaySelected[d - 1] = true;
      }
    }
    _betValue = widget.initialBet;
    _certType = widget.initialCertType;
    _deadlineValue = widget.initialDeadline;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    super.dispose();
  }

  void _toggleDay(int i) => setState(() => _weekdaySelected[i] = !_weekdaySelected[i]);

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final selectedDays = <int>[];
    for (int i = 0; i < 7; i++) {
      if (_weekdaySelected[i]) selectedDays.add(i + 1);
    }
    if (selectedDays.isEmpty) {
      _showSnack('요일을 한 개 이상 선택해 주세요.');
      return;
    }
    if (_betValue == null) {
      _showSnack('감자 내기를 선택해 주세요.');
      return;
    }
    if (_deadlineValue == null) {
      _showSnack('인증 마감 시간을 선택해 주세요.');
      return;
    }

    final result = HabitSetupData(
      title: _titleCtrl.text.trim(),
      startDate: _selectedRange!.start,
      endDate: _selectedRange!.end,
      weekdays: selectedDays,
      bet: _betValue!,
      certType: _certType,
      deadline: _deadlineValue!,
    );
    Navigator.of(context).pop(result);
  }

  void _showSnack(String m) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF8EEDD),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 상단
                    Row(
                      children: [
                        const SizedBox(height: 120,width: 15,),
                        Container(
                          width: 130,
                          child:
                          Image.asset(
                          HabitSetupLogoPath,
                          fit: BoxFit.contain,
                        ),
                        ),
                        const SizedBox(width: 50, height: 30,),
                        Column(
                          children: [
                            const SizedBox(height: 20,),
                            Text(
                              '습관 설정 하기',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: AppColors.brick,
                              ),
                            ),

                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 36),

                    // 제목 + 부제
                    Row(children: [
                      const SizedBox(width: 30,),
                      Container(
                        width: 250,
                        child:
                        TextFormField(
                          controller: _titleCtrl,
                          decoration: InputDecoration(
                            hintText: '예) 아침에 물 마시기',
                            labelStyle: const TextStyle(color: Colors.grey),
                            hintStyle: const TextStyle(color: Colors.black38),
                            // ✅ 배경 제거
                            filled: false,
                            // ✅ 밑줄 스타일 지정
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: AppColors.brick),
                              // 연한 베이지 밑줄
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFDB6D6D), width: 1.5), // 포커스 시 포인트 컬러
                            ),
                          ),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                          validator: (v) =>
                          (v == null || v.trim().isEmpty) ? '제목을 입력해 주세요.' : null,
                        ),

                      ),
                    ],),
                    const SizedBox(height: 15),
                    Row(children: [
                      const SizedBox(width: 200,),
                      const Text('습관을 설정해 볼까요?',
                          style: TextStyle(fontSize: 16, color: AppColors.brick ),
                          textAlign: TextAlign.center,
                      ),


                    ],),
                    const SizedBox(height: 24),
                    _SectionLabel('기간'),
                    _DateRangeField(
                      range: _selectedRange,
                      onPick: () async {
                        final now = DateTime.now();
                        final firstDay = DateTime(now.year - 1, 1, 1);
                        final lastDay  = DateTime(now.year + 2, 12, 31);

                        final picked = await showDateRangePicker(
                          context: context,
                          firstDate: firstDay,
                          lastDate: lastDay,
                          initialDateRange: _selectedRange,
                          helpText: '기간 선택',
                          builder: (context, child) {
                            // 🔹 여기서 전체화면 대신 화면 중앙에 조그맣게 띄우게 함
                            return Center(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: 340),
                                child: Material(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  clipBehavior: Clip.antiAlias,
                                  child: child,
                                ),
                              ),
                            );
                          },
                        );

                        if (picked != null) {
                          setState(() {
                            _selectedRange = DateTimeRange(
                              start: DateTime(picked.start.year, picked.start.month, picked.start.day),
                              end: DateTime(picked.end.year, picked.end.month, picked.end.day),
                            );
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 12),




                    Wrap(
                      spacing: 8, runSpacing: 8,
                      children: List.generate(7, (i) => _DayChip(
                        label: _labels[i],
                        selected: _weekdaySelected[i],
                        onTap: () => _toggleDay(i),
                      )),
                    ),
                    const SizedBox(height: 24),

                    _SectionLabel('감자 내기'),
                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      value: _betValue,
                      items: _betOptions
                          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (v) => setState(() => _betValue = v),
                      decoration: const InputDecoration(
                        hintText: '선택하세요',
                        filled: true, fillColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 24),

                    _SectionLabel('인증 방식'),
                    const SizedBox(height: 8),
                    ToggleButtons(
                      isSelected: [
                        _certType == CertType.photo,
                        _certType == CertType.text,
                      ],
                      onPressed: (i) =>
                          setState(() => _certType = i == 0 ? CertType.photo : CertType.text),
                      borderRadius: BorderRadius.circular(10),
                      constraints: const BoxConstraints(minHeight: 44, minWidth: 72),
                      children: const [Text('사진'), Text('글')],
                    ),
                    const SizedBox(height: 24),

                    _SectionLabel('인증마감 시간'),
                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      value: _deadlineValue,
                      items: _timeOptions
                          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (v) => setState(() => _deadlineValue = v),
                      decoration: const InputDecoration(
                        hintText: '선택하세요',
                        filled: true, fillColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 36),

                    SizedBox(
                      width: double.infinity, height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFDB6D6D),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                        onPressed: _submit,
                        child: const Text('도전하기!', style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// --- UI Subcomponents -------------------------------------------------------

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.title);
  final String title;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 8, bottom: 6),
    child: Row(children: [
      const Text('· ', style: TextStyle(fontSize: 16)),
      Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
    ]),
  );
}

class _DayChip extends StatelessWidget {
  const _DayChip({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.green : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppColors.brick  : const Color(0xFFE7C7B0),
          ),
          boxShadow: selected
              ? [BoxShadow(color: AppColors.brick.withOpacity(0.18), blurRadius: 10)]
              : const [],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : const Color(0xFF7D6B60),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _DateRangeField extends StatelessWidget {
  const _DateRangeField({required this.range, required this.onPick});
  final DateTimeRange? range;
  final VoidCallback onPick;

  @override
  Widget build(BuildContext context) {
    final hasValue = range != null;
    final text = hasValue
        ? '${_fmt(range!.start)}  ~  ${_fmt(range!.end)}'
        : '달력에서 기간을 선택하세요';

    return InkWell(
      onTap: onPick,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE7C7B0)),
        ),
        child: Row(
          children: [
            const Icon(Icons.date_range),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: hasValue ? Colors.black87 : Colors.black45,
                  fontSize: 16,
                  fontWeight: hasValue ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
            const Icon(Icons.keyboard_arrow_down),
          ],
        ),
      ),
    );
  }

  String _fmt(DateTime d) =>
      '${d.year.toString().padLeft(4,'0')}.${d.month.toString().padLeft(2,'0')}.${d.day.toString().padLeft(2,'0')}';
}
