import 'package:flutter/material.dart';
import 'package:flutter_crise/components/button.component.dart';
import 'package:flutter_crise/components/text.component.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:quiz_enem/core/fonts/fonts.dart';
import 'package:quiz_enem/services/step_perguntas.service.dart';

import '../../../../core/colors.dart';

const double kHorizontalPadding = 32;
const double kVerticalPadding = 32;

class StepPageData {
  final String title;
  final Widget contentPage;
  const StepPageData({required this.title, required this.contentPage});
}

class StepsPerguntas extends StatefulWidget {
  const StepsPerguntas(
      {this.accentColor,
      required this.stepsPages,
      required this.onFinish,
      required this.onSkip,
      required this.onBack,
      this.initialPage = 0, // Adicionando parâmetro para página inicial
      Key? key})
      : super(key: key);
  final Color? accentColor;
  final List<StepPageData> stepsPages;
  final Function onFinish;
  final Function onSkip;
  final Function onBack;
  final int initialPage; // Adicionando parâmetro para página inicial

  @override
  State<StepsPerguntas> createState() => _StepsPerguntasState();
}

class _StepsPerguntasState extends State<StepsPerguntas> {
  Color? myDarkColor = Colors.grey[800];

  late PageController pageController;
  int? screenIndex;

  List<Widget> screens = [];

  @override
  void initState() {
    super.initState();
    for (var item in widget.stepsPages) {
      screens.add(_SingleScreen(contentPage: item.contentPage));
    }
    screenIndex = widget.initialPage;
    pageController = PageController(initialPage: widget.initialPage);
  }

  void setScreenIndex(int value) {
    setState(() {
      screenIndex = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData currentTheme = Theme.of(context);

    return Theme(
      data: currentTheme.copyWith(
        textTheme: currentTheme.textTheme
            .copyWith(bodyMedium: TextStyle(color: myDarkColor)),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: myDarkColor),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
            child: Stack(
              children: [
                PageViewWithIndicators(
                  type: IndicatorScreenType.dots,
                  dotColor:
                      widget.accentColor ?? Theme.of(context).primaryColor,
                  pageController: pageController,
                  onPageChanged: setScreenIndex,
                  children: screens,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 10),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: screenIndex != 0
                        ? Row(
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                      color: AppColor.primary,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(100)),
                                      border: Border.all(
                                          color: AppColor.light, width: 1)),
                                  child: IconButton(
                                      onPressed: () {
                                        pageController.previousPage(
                                            duration: const Duration(
                                                milliseconds: 500),
                                            curve: Curves.ease);
                                        widget.onBack(screenIndex! - 1);
                                      },
                                      icon: Icon(Icons.arrow_back,
                                          color: AppColor.light))),
                              const SizedBox(width: 5),
                              TextComponent(
                                  fontFamily: AppFont.Moonget,
                                  value: widget.stepsPages[screenIndex!].title
                                      .toString(),
                                  fontSize: 22)
                            ],
                          )
                        : Row(children: [
                            Container(
                                decoration: BoxDecoration(
                                    color: AppColor.primary,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(100)),
                                    border: Border.all(
                                        color: AppColor.light, width: 1)),
                                child: IconButton(
                                    onPressed: () {
                                      widget.onBack(screenIndex! - 1);
                                      Get.back();
                                    },
                                    icon: Icon(Icons.arrow_back,
                                        color: AppColor.light))),
                            const SizedBox(width: 5),
                            TextComponent(
                                fontFamily: AppFont.Moonget,
                                value: widget.stepsPages[screenIndex!].title
                                    .toString(),
                                fontSize: 22)
                          ]),
                  ),
                ),
                Container(
                    margin: const EdgeInsets.only(bottom: 30),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ValueListenableBuilder(
                              valueListenable:
                                  Get.find<StepPerguntasService>().showBtnStep,
                              builder: ((context, bool value, child) {
                                if (value == true) {
                                  return ButtonStylizedComponent(
                                      color: AppColor.button,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 100, vertical: 10),
                                      borderRadius: 32,
                                      onPressed: () {
                                        if (screenIndex == screens.length - 1) {
                                          widget.onFinish();
                                        } else {
                                          pageController.nextPage(
                                              duration: const Duration(
                                                  milliseconds: 500),
                                              curve: Curves.ease);
                                          widget.onSkip(screenIndex! + 1);
                                        }
                                      },
                                      label: TextComponent(
                                          fontFamily: AppFont.Moonget,
                                          fontSize: 18,
                                          value:
                                              screenIndex == screens.length - 1
                                                  ? 'Concluir'
                                                  : 'Próxima',
                                          color: Colors.white));
                                } else {
                                  return Container();
                                }
                              }))
                        ],
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SingleScreen extends StatelessWidget {
  const _SingleScreen({required this.contentPage});
  final Widget contentPage;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [contentPage],
    );
  }
}

enum IndicatorScreenType { dots, numbered, dotsAndNumbered }

class PageViewWithIndicators extends StatefulWidget {
  const PageViewWithIndicators(
      {required this.children,
      this.dotColor = Colors.white,
      this.type = IndicatorScreenType.dots,
      this.pageController,
      required this.onPageChanged,
      Key? key})
      : super(key: key);
  final List<Widget> children;
  final Color dotColor;
  final IndicatorScreenType type;
  final Function(int) onPageChanged;
  final PageController? pageController;

  @override
  State<PageViewWithIndicators> createState() => _PageViewWithIndicatorsState();
}

class _PageViewWithIndicatorsState extends State<PageViewWithIndicators> {
  late int activeIndex;

  @override
  void initState() {
    activeIndex = widget.pageController?.initialPage ?? 0;
    super.initState();
  }

  setActiveIndex(int index) {
    setState(() {
      activeIndex = index;
    });
  }

  Widget validIndicators(IndicatorScreenType type) {
    late Widget indicator;
    switch (type) {
      case IndicatorScreenType.dots:
        indicator = buildDottedIndicators();
        break;
      case IndicatorScreenType.numbered:
        indicator = buildNumberedIndicators();
        break;
      case IndicatorScreenType.dotsAndNumbered:
        indicator = buildDottedAndPageIndicators();
        break;
    }
    return indicator;
  }

  // -> TIPOS DE DOTS
  buildDottedAndPageIndicators() {
    List<Widget> dots = [];
    const double radius = 8;

    for (int i = 0; i < widget.children.length; i++) {
      dots.add(
        Container(
          height: radius,
          width: radius,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: i == activeIndex
                ? widget.dotColor
                : widget.dotColor.withOpacity(.6),
          ),
        ),
      );
    }
    dots = intersperse(const SizedBox(width: 6), dots).toList();

    // Construindo o número da página atual + total de páginas
    String pageIndicatorText = '${activeIndex + 1}/${widget.children.length}';

    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: dots,
            ),
            SizedBox(
                width:
                    8), // Adicionando um espaço entre os pontos e o número da página
            Text(
              pageIndicatorText,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildDottedIndicators() {
    List<Widget> dots = [];
    const double radius = 8;

    for (int i = 0; i < widget.children.length; i++) {
      dots.add(
        Container(
          height: radius,
          width: radius,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: i == activeIndex
                ? widget.dotColor
                : widget.dotColor.withOpacity(.6),
          ),
        ),
      );
    }
    dots = intersperse(const SizedBox(width: 6), dots).toList();

    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: dots,
        ),
      ),
    );
  }

  buildNumberedIndicators() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(.33),
            borderRadius: BorderRadius.circular(4),
          ),
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
          child: Text(
            '${(activeIndex + 1).toString()} / ${widget.children.length.toString()}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView(
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (value) {
            setActiveIndex(value);
            widget.onPageChanged(value);
          },
          controller: widget.pageController,
          children: widget.children,
        ),
        validIndicators(IndicatorScreenType.numbered)
      ],
    );
  }
}

Iterable<T> intersperse<T>(T element, Iterable<T> iterable) sync* {
  final iterator = iterable.iterator;
  if (iterator.moveNext()) {
    yield iterator.current;
    while (iterator.moveNext()) {
      yield element;
      yield iterator.current;
    }
  }
}
