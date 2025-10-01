import 'package:flutter/material.dart';

/// =======================
///  공통 리소스 & 테마 정의
/// =======================
class AppImages {
  static const root = 'lib/assets/image1';
  static const smallHabitLogo = '$root/small_habit_logo.png';
  static const hbLogo         = '$root/HB_logo.png';
  static const cart           = '$root/cart.png';
}

class AppColors {
  static const page     = Color(0xFFFFFFFF);
  static const cream    = Color(0xFFFFF8E1);
  static const brown    = Color(0xFFBF8D6A);
  static const dark     = Color(0xFF535353);
  static const yellow   = Color(0xFFF3C34E);
  static const chip     = Color(0xFFF6E89E);
  static const danger   = Color(0xFFE25B5B);
  static const divider  = Color(0xFFE8E0D4);
  static const shadow   = Color(0x1F000000);
}

class Dimens {
  static const pad = 16.0;
  static const r20 = 20.0;
}

/// =======================
///  모델 정의
/// =======================
enum HabitStatus { pending, verified, skipped }

class HomeHabit {
  final String title;
  final String time;
  final String method;
  double progress;
  HabitStatus status;

  HomeHabit({
    required this.title,
    required this.time,
    required this.method,
    this.progress = 0.0,
    this.status = HabitStatus.pending,
  });
}

/// =======================
///  홈 화면
/// =======================
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tab = 1;

  final _today = <HomeHabit>[
    HomeHabit(title: '자기 전 스트레칭하기', time: '20:00 ~ 24:00', method: '사진', progress: .62),
    HomeHabit(title: '퇴근 후 빨래 바로 돌리기', time: '18:00 ~ 20:00', method: '사진', progress: .25),
  ];

  final _fighting = <HomeHabit>[
    HomeHabit(title: '아침에 물 한잔 마시기', time: '10:00 ~ 12:00', method: '사진', progress: .8),
    HomeHabit(title: '나갈 때 키 챙기기',   time: '09:00 ~ 10:00', method: '사진', progress: .3),
  ];

  void _rebuild() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.page,
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: _TopBar()),

          // 상단 크림색 박스(프로필 + 해시브라운 카드)
          SliverToBoxAdapter(
            child: Container(
              color: AppColors.cream,
              padding: const EdgeInsets.only(bottom: 16),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: Dimens.pad),
                    child: _HeaderProfile(),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(Dimens.pad, 12, Dimens.pad, 0),
                    child: _TodayProgressCard(progress: .65),
                  ),
                ],
              ),
            ),
          ),

          const _SectionTitle('튀기기를 기다리고 있는 감자', action: _SectionActions()),
          _HabitList(habits: _today, onChange: _rebuild),

          const _SectionTitle('싸우고 있는 감자', icon: Icons.gavel),
          _HabitList(habits: _fighting, onChange: _rebuild),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      bottomNavigationBar: _BottomBar(index: _tab, onChanged: (i) => setState(() => _tab = i)),
    );
  }
}

/// =======================
///  상단바
/// =======================
class _TopBar extends StatelessWidget implements PreferredSizeWidget {
  const _TopBar();
  @override
  Size get preferredSize => const Size.fromHeight(96);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.cream,
      elevation: 0,
      toolbarHeight: 88,
      leadingWidth: 140,
      leading: Padding(
        padding: const EdgeInsets.only(left: 6, top: 12),
        child: Image.asset(
          AppImages.smallHabitLogo,
          width: 94, height: 18,
          fit: BoxFit.contain,
        ),
      ),
      actions: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.chip,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Image.asset(AppImages.hbLogo, width: 18, height: 18),
              const SizedBox(width: 6),
              const Text('53', style: TextStyle(color: AppColors.dark)),
            ],
          ),
        ),
        const SizedBox(width: 12),
        IconButton(
          icon: Image.asset(AppImages.cart, width: 24, height: 24),
          onPressed: () {},
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}

/// =======================
///  프로필 & 인사말
/// =======================
class _HeaderProfile extends StatelessWidget {
  const _HeaderProfile();
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 64, height: 64,
          decoration: BoxDecoration(
            color: AppColors.page,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.brown),
            boxShadow: const [BoxShadow(color: AppColors.shadow, blurRadius: 6, offset: Offset(0, 2))],
          ),
          child: const Icon(Icons.camera_alt_outlined, color: AppColors.dark),
        ),
        const SizedBox(width: 14),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('안녕하세요,', style: TextStyle(color: AppColors.dark)),
            SizedBox(height: 4),
            Text('망설이는 감자  농부님!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          ],
        ),
      ],
    );
  }
}

/// =======================
///  오늘의 해시브라운 카드
/// =======================
class _TodayProgressCard extends StatelessWidget {
  final double progress;
  const _TodayProgressCard({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        // #A26C1B @ 70% = 0xB3A26C1B
        color: const Color(0xB3A26C1B),
        borderRadius: BorderRadius.circular(40),
        boxShadow: const [BoxShadow(color: AppColors.shadow, blurRadius: 8, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            '오늘의 따끈따끈 해시브라운',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          _ProgressPill(value: progress),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('1개', style: TextStyle(color: Colors.white70)),
              Text('2개', style: TextStyle(color: Colors.white70)),
              Text('3개', style: TextStyle(color: Colors.white70)),
              Text('4개', style: TextStyle(color: Colors.white70)),
              Text('5개', style: TextStyle(color: Colors.white70)),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProgressPill extends StatelessWidget {
  final double value;
  const _ProgressPill({required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 14,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: LayoutBuilder(
        builder: (_, c) => Align(
          alignment: Alignment.centerLeft,
          child: Container(
            width: c.maxWidth * value.clamp(0, 1),
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(color: AppColors.danger, borderRadius: BorderRadius.circular(20)),
          ),
        ),
      ),
    );
  }
}

/// =======================
///  섹션 타이틀
/// =======================
class _SectionTitle extends StatelessWidget {
  final String title;
  final IconData? icon;
  final Widget? action;
  const _SectionTitle(this.title, {this.icon, this.action});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(Dimens.pad, 12, Dimens.pad, 6),
        child: Row(
          children: [
            Text('· $title', style: const TextStyle(color: AppColors.dark, fontWeight: FontWeight.w700)),
            if (icon != null) ...[
              const SizedBox(width: 6),
              Icon(icon, size: 18, color: AppColors.dark),
            ],
            const Spacer(),
            if (action != null) action!,
          ],
        ),
      ),
    );
  }
}

class _SectionActions extends StatelessWidget {
  const _SectionActions();
  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        _RoundIcon(icon: Icons.add),
        SizedBox(width: 8),
        _RoundIcon(icon: Icons.edit),
      ],
    );
  }
}

class _RoundIcon extends StatelessWidget {
  final IconData icon;
  const _RoundIcon({required this.icon});
  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.cream,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () {},
        child: SizedBox(width: 34, height: 34, child: Icon(icon, size: 18, color: AppColors.brown)),
      ),
    );
  }
}

/// =======================
///  습관 카드 목록 & 카드
/// =======================
typedef HabitChange = void Function();

class _HabitList extends StatelessWidget {
  final List<HomeHabit> habits;
  final HabitChange onChange;
  const _HabitList({required this.habits, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: Dimens.pad, vertical: 8),
      sliver: SliverList.separated(
        itemCount: habits.length,
        itemBuilder: (_, i) => _HabitCard(h: habits[i], onChange: onChange),
        separatorBuilder: (_, __) => const SizedBox(height: 12),
      ),
    );
  }
}

class _HabitCard extends StatelessWidget {
  final HomeHabit h;
  final HabitChange onChange;
  const _HabitCard({required this.h, required this.onChange});

  @override
  Widget build(BuildContext context) {
    final isVerified = h.status == HabitStatus.verified;
    final isSkipped  = h.status == HabitStatus.skipped;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.divider),
        boxShadow: const [BoxShadow(color: AppColors.shadow, blurRadius: 6, offset: Offset(0, 2))],
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 8, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(h.title, style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.dark)),
                  const SizedBox(height: 6),
                  Text('· 시간: ${h.time}'),
                  Text('· 방법: ${h.method}'),
                  const SizedBox(height: 10),
                  _ProgressPill(value: h.progress),
                ],
              ),
            ),
          ),
          Container(
            width: 130,
            margin: const EdgeInsets.fromLTRB(6, 12, 12, 12),
            child: Column(
              children: [
                _FilledButton(
                  text: isVerified ? '인증완료' : '인증하기',
                  bg: isVerified ? Colors.green.shade400 : AppColors.yellow,
                  onTap: isVerified
                      ? null
                      : () {
                    h.status = HabitStatus.verified;
                    onChange();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('인증 완료!')),
                    );
                  },
                ),
                const SizedBox(height: 10),
                _TextLink(
                  text: isSkipped ? '오늘은 스킵' : '오늘은 안할래',
                  color: AppColors.danger,
                  onTap: isSkipped
                      ? null
                      : () {
                    h.status = HabitStatus.skipped;
                    onChange();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('오늘은 스킵했어요')),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FilledButton extends StatelessWidget {
  final String text;
  final Color bg;
  final VoidCallback? onTap;
  const _FilledButton({required this.text, required this.bg, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: bg.withValues(alpha: onTap == null ? 0.6 : 1), // ← 변경
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: SizedBox(
          height: 48,
          child: Center(
            child: Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.dark),
            ),
          ),
        ),
      ),
    );
  }
}

class _TextLink extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback? onTap;
  const _TextLink({required this.text, required this.color, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(
        text,
        style: TextStyle(
          color: color.withValues(alpha: onTap == null ? 0.5 : 1), // ← 변경
          decoration: TextDecoration.underline,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

/// =======================
///  하단 네비게이션 바
/// =======================
class _BottomBar extends StatelessWidget {
  final int index;
  final ValueChanged<int> onChanged;
  const _BottomBar({required this.index, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: index,
      onTap: onChanged,
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.page,
      selectedItemColor: AppColors.dark,
      unselectedItemColor: AppColors.dark.withValues(alpha: 0.5), // ← 변경
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.local_florist_outlined), label: '감자캐기'),
        BottomNavigationBarItem(icon: Icon(Icons.build_outlined),          label: '해시내기'),
        BottomNavigationBarItem(icon: Icon(Icons.notifications_none),      label: '알림'),
        BottomNavigationBarItem(icon: Icon(Icons.groups_outlined),         label: '커뮤니티'),
        BottomNavigationBarItem(icon: Icon(Icons.emoji_emotions_outlined), label: '마이페이지'),
      ],
    );
  }
}
