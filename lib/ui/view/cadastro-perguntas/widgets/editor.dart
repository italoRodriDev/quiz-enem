import 'package:flutter/material.dart';
import 'package:quill_html_editor/quill_html_editor.dart';

class EditorTexto extends StatefulWidget {
  const EditorTexto({super.key});

  @override
  State<EditorTexto> createState() => _EditorTextoState();
}

class _EditorTextoState extends State<EditorTexto> {
  ///[controller] create a QuillEditorController to access the editor methods
  late QuillEditorController controller;

  ///[customToolBarList] pass the custom toolbarList to show only selected styles in the editor

  final customToolBarList = [
    ToolBarStyle.bold,
    ToolBarStyle.italic,
    ToolBarStyle.align,
    ToolBarStyle.color,
    ToolBarStyle.background,
    ToolBarStyle.listBullet,
    ToolBarStyle.listOrdered,
    ToolBarStyle.clean,
    ToolBarStyle.addTable,
    ToolBarStyle.editTable,
  ];

  final _toolbarColor = Colors.grey.shade200;
  final _backgroundColor = Colors.white70;
  final _toolbarIconColor = Colors.black87;
  final _editorTextStyle = const TextStyle(
      fontSize: 18,
      color: Colors.black,
      fontWeight: FontWeight.normal,
      fontFamily: 'Roboto');
  final _hintTextStyle = const TextStyle(
      fontSize: 18, color: Colors.black38, fontWeight: FontWeight.normal);

  bool _hasFocus = false;
  @override
  void initState() {
    controller = QuillEditorController();
    controller.onTextChanged((text) {
      debugPrint('listening to $text');
    });
    controller.onEditorLoaded(() {
      debugPrint('Editor Loaded :)');
    });
    super.initState();
  }

  @override
  void dispose() {
    /// please do not forget to dispose the controller
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 500,
        child: Column(
          children: [
            ToolBar(
              toolBarColor: _toolbarColor,
              padding: const EdgeInsets.all(8),
              iconSize: 25,
              iconColor: _toolbarIconColor,
              activeIconColor: Colors.greenAccent.shade400,
              controller: controller,
              crossAxisAlignment: WrapCrossAlignment.start,
              direction: Axis.horizontal,
              customButtons: [
                Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                      color: _hasFocus ? Colors.green : Colors.grey,
                      borderRadius: BorderRadius.circular(15)),
                ),
                InkWell(
                    onTap: () => unFocusEditor(),
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.black,
                    )),
                InkWell(
                    onTap: () async {
                      var selectedText = await controller.getSelectedText();
                      debugPrint('selectedText $selectedText');
                      var selectedHtmlText =
                          await controller.getSelectedHtmlText();
                      debugPrint('selectedHtmlText $selectedHtmlText');
                    },
                    child: const Icon(
                      Icons.add_circle,
                      color: Colors.black,
                    )),
              ],
            ),
            Expanded(
              child: QuillHtmlEditor(
                hintText: 'Dados da pergunta',
                controller: controller,
                isEnabled: true,
                ensureVisible: false,
                minHeight: 500,
                autoFocus: false,
                textStyle: _editorTextStyle,
                hintTextStyle: _hintTextStyle,
                hintTextAlign: TextAlign.start,
                padding: const EdgeInsets.only(left: 10, top: 10),
                hintTextPadding: const EdgeInsets.only(left: 20),
                backgroundColor: _backgroundColor,
                inputAction: InputAction.newline,
                onEditingComplete: (s) => debugPrint('Editing completed $s'),
                loadingBuilder: (context) {
                  return const Center(
                      child: CircularProgressIndicator(
                    strokeWidth: 1,
                    color: Colors.red,
                  ));
                },
                onFocusChanged: (focus) {
                  debugPrint('has focus $focus');
                  setState(() {
                    _hasFocus = focus;
                  });
                },
                onTextChanged: (text) => debugPrint('widget text change $text'),
                onEditorCreated: () {
                  debugPrint('Editor has been loaded');
                },
                onEditorResized: (height) =>
                    debugPrint('Editor resized $height'),
                onSelectionChanged: (sel) =>
                    debugPrint('index ${sel.index}, range ${sel.length}'),
              ),
            )
          ],
        ));
  }

  ///[getHtmlText] to get the html text from editor
  void getHtmlText() async {
    String? htmlText = await controller.getText();
    debugPrint(htmlText);
  }

  ///[setHtmlText] to set the html text to editor
  void setHtmlText(String text) async {
    await controller.setText(text);
  }

  ///[insertNetworkImage] to set the html text to editor
  void insertNetworkImage(String url) async {
    await controller.embedImage(url);
  }

  ///[insertVideoURL] to set the video url to editor
  ///this method recognises the inserted url and sanitize to make it embeddable url
  ///eg: converts youtube video to embed video, same for vimeo
  void insertVideoURL(String url) async {
    await controller.embedVideo(url);
  }

  /// to set the html text to editor
  /// if index is not set, it will be inserted at the cursor postion
  void insertHtmlText(String text, {int? index}) async {
    await controller.insertText(text, index: index);
  }

  /// to clear the editor
  void clearEditor() => controller.clear();

  /// to enable/disable the editor
  void enableEditor(bool enable) => controller.enableEditor(enable);

  /// method to un focus editor
  void unFocusEditor() => controller.unFocus();
}
