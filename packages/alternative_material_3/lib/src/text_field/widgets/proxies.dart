import 'dart:ui' as ui hide TextStyle;

import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../render/editable.dart';
import 'editable_text.dart';
import 'spell_check.dart';
import 'text_selection.dart';

class EditableTextStateProxy implements EditableTextState {
  EditableTextStateProxy(this.parent);

  final EditableTextM3State parent;

  @override
  SpellCheckResults? get spellCheckResults => parent.spellCheckResults;

  @override
  void activate() => parent.activate();

  @override
  void autofill(TextEditingValue value) => parent.autofill(value);

  @override
  String get autofillId => parent.autofillId;

  @override
  void beginBatchEdit() => parent.beginBatchEdit();

  @override
  void bringIntoView(ui.TextPosition position) =>
      parent.bringIntoView(position);

  @override
  Widget build(BuildContext context) => parent.build(context);

  @override
  TextSpan buildTextSpan() => parent.buildTextSpan();

  @override
  List<ContextMenuButtonItem>? buttonItemsForToolbarOptions(
          [TargetPlatform? targetPlatform]) =>
      parent.buttonItemsForToolbarOptions();

  @override
  ClipboardStatusNotifier get clipboardStatus => parent.clipboardStatus;

  @override
  void connectionClosed() => parent.connectionClosed();

  @override
  BuildContext get context => parent.context;

  @override
  TextSelectionToolbarAnchors get contextMenuAnchors =>
      parent.contextMenuAnchors;

  @override
  List<ContextMenuButtonItem> get contextMenuButtonItems =>
      parent.contextMenuButtonItems;

  @override
  bool get copyEnabled => parent.copyEnabled;

  @override
  void copySelection(SelectionChangedCause cause) =>
      parent.copySelection(cause);

  @override
  Ticker createTicker(TickerCallback onTick) => parent.createTicker(onTick);

  @override
  AutofillScope? get currentAutofillScope => parent.currentAutofillScope;

  @override
  TextEditingValue get currentTextEditingValue =>
      parent.currentTextEditingValue;

  @override
  Duration get cursorBlinkInterval => parent.cursorBlinkInterval;

  @override
  bool get cursorCurrentlyVisible => parent.cursorCurrentlyVisible;

  @override
  bool get cutEnabled => parent.cutEnabled;

  @override
  void cutSelection(SelectionChangedCause cause) => parent.cutSelection(cause);

  @override
  void deactivate() => parent.deactivate();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) =>
      parent.debugFillProperties(properties);

  @override
  void didChangeAccessibilityFeatures() =>
      parent.didChangeAccessibilityFeatures();

  @override
  void didChangeAppLifecycleState(ui.AppLifecycleState state) =>
      parent.didChangeAppLifecycleState(state);

  @override
  void didChangeDependencies() => parent.didChangeDependencies();

  @override
  void didChangeInputControl(
          TextInputControl? oldControl, TextInputControl? newControl) =>
      parent.didChangeInputControl(oldControl, newControl);

  @override
  void didChangeLocales(List<ui.Locale>? locales) =>
      parent.didChangeLocales(locales);

  @override
  void didChangeMetrics() => parent.didChangeMetrics();

  @override
  void didChangePlatformBrightness() => parent.didChangePlatformBrightness();

  @override
  void didChangeTextScaleFactor() => parent.didChangeTextScaleFactor();

  @override
  void didHaveMemoryPressure() => parent.didHaveMemoryPressure();

  @override
  Future<bool> didPopRoute() => parent.didPopRoute();

  @override
  Future<bool> didPushRoute(String route) => parent.didPushRoute(route);

  @override
  Future<bool> didPushRouteInformation(RouteInformation routeInformation) =>
      parent.didPushRouteInformation(routeInformation);

  @override
  Future<ui.AppExitResponse> didRequestAppExit() => parent.didRequestAppExit();

  @override
  void didUpdateWidget(covariant EditableText oldWidget) {
    // can't support this
  }

  @override
  void dispose() => parent.dispose();

  @override
  void endBatchEdit() => parent.endBatchEdit();

  @override
  SuggestionSpan? findSuggestionSpanAtCursorIndex(int cursorIndex) =>
      parent.findSuggestionSpanAtCursorIndex(cursorIndex);

  @override
  void hideMagnifier() => parent.hideMagnifier();

  @override
  void hideToolbar([bool hideHandles = true]) =>
      parent.hideToolbar(hideHandles);

  @override
  void initState() => parent.initState();

  @override
  void insertContent(KeyboardInsertedContent content) =>
      parent.insertContent(content);

  @override
  void insertTextPlaceholder(ui.Size size) =>
      parent.insertTextPlaceholder(size);

  @override
  bool get mounted => parent.mounted;

  @override
  bool get pasteEnabled => parent.pasteEnabled;

  @override
  Future<void> pasteText(SelectionChangedCause cause) =>
      parent.pasteText(cause);

  @override
  void performAction(TextInputAction action) => parent.performAction(action);

  @override
  void performPrivateCommand(String action, Map<String, dynamic> data) =>
      parent.performPrivateCommand(action, data);

  @override
  void performSelector(String selectorName) =>
      parent.performSelector(selectorName);

  @override
  void reassemble() => parent.reassemble();

  @override
  void removeTextPlaceholder() => parent.removeTextPlaceholder();

  @override
  RenderEditable get renderEditable => throw UnimplementedError();

  @override
  void requestKeyboard() => parent.requestKeyboard();

  @override
  void selectAll(SelectionChangedCause cause) => parent.selectAll(cause);

  @override
  bool get selectAllEnabled => parent.selectAllEnabled;

  @override
  TextSelectionOverlay? get selectionOverlay => null;

  @override
  void setState(ui.VoidCallback fn) => parent.setState(fn);

  @override
  void showAutocorrectionPromptRect(int start, int end) =>
      parent.showAutocorrectionPromptRect(start, end);

  @override
  void showMagnifier(ui.Offset positionToShow) =>
      parent.showMagnifier(positionToShow);

  @override
  bool showSpellCheckSuggestionsToolbar() =>
      parent.showSpellCheckSuggestionsToolbar();

  @override
  bool showToolbar() => parent.showToolbar();

  @override
  SpellCheckConfiguration get spellCheckConfiguration =>
      throw UnimplementedError();

  @override
  bool get spellCheckEnabled => parent.spellCheckEnabled;

  @override
  TextEditingValue get textEditingValue => parent.textEditingValue;

  @override
  TextInputConfiguration get textInputConfiguration =>
      parent.textInputConfiguration;

  @override
  DiagnosticsNode toDiagnosticsNode(
          {String? name, DiagnosticsTreeStyle? style}) =>
      parent.toDiagnosticsNode(name: name, style: style);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) =>
      parent.toString(minLevel: minLevel);

  @override
  String toStringShort() => parent.toStringShort();

  @override
  void toggleToolbar([bool hideHandles = true]) =>
      parent.toggleToolbar(hideHandles);

  @override
  void updateEditingValue(TextEditingValue value) => updateEditingValue(value);

  @override
  void updateFloatingCursor(RawFloatingCursorPoint point) =>
      parent.updateFloatingCursor(point);

  @override
  void updateKeepAlive() => parent.updateKeepAlive();

  @override
  void userUpdateTextEditingValue(
          TextEditingValue value, SelectionChangedCause? cause) =>
      parent.userUpdateTextEditingValue(value, cause);

  @override
  bool get wantKeepAlive => parent.wantKeepAlive;

  @override
  EditableText get widget => throw UnimplementedError();

  @override
  set spellCheckResults(SpellCheckResults? _spellCheckResults) =>
      parent.spellCheckResults = _spellCheckResults;
}

class EditableTextM3StateProxy implements EditableTextM3State {
  EditableTextM3StateProxy(this.parent);

  final EditableTextState parent;

  @override
  SpellCheckResults? get spellCheckResults => parent.spellCheckResults;

  @override
  void activate() => parent.activate();

  @override
  void autofill(TextEditingValue value) => parent.autofill(value);

  @override
  String get autofillId => parent.autofillId;

  @override
  void beginBatchEdit() => parent.beginBatchEdit();

  @override
  void bringIntoView(ui.TextPosition position) =>
      parent.bringIntoView(position);

  @override
  Widget build(BuildContext context) => parent.build(context);

  @override
  TextSpan buildTextSpan() => parent.buildTextSpan();

  @override
  List<ContextMenuButtonItem>? buttonItemsForToolbarOptions(
          [TargetPlatform? targetPlatform]) =>
      parent.buttonItemsForToolbarOptions();

  @override
  ClipboardStatusNotifier get clipboardStatus => parent.clipboardStatus;

  @override
  void connectionClosed() => parent.connectionClosed();

  @override
  BuildContext get context => parent.context;

  @override
  TextSelectionToolbarAnchors get contextMenuAnchors =>
      parent.contextMenuAnchors;

  @override
  List<ContextMenuButtonItem> get contextMenuButtonItems =>
      parent.contextMenuButtonItems;

  @override
  bool get copyEnabled => parent.copyEnabled;

  @override
  void copySelection(SelectionChangedCause cause) =>
      parent.copySelection(cause);

  @override
  Ticker createTicker(TickerCallback onTick) => parent.createTicker(onTick);

  @override
  AutofillScope? get currentAutofillScope => parent.currentAutofillScope;

  @override
  TextEditingValue get currentTextEditingValue =>
      parent.currentTextEditingValue;

  @override
  Duration get cursorBlinkInterval => parent.cursorBlinkInterval;

  @override
  bool get cursorCurrentlyVisible => parent.cursorCurrentlyVisible;

  @override
  bool get cutEnabled => parent.cutEnabled;

  @override
  void cutSelection(SelectionChangedCause cause) => parent.cutSelection(cause);

  @override
  void deactivate() => parent.deactivate();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) =>
      parent.debugFillProperties(properties);

  @override
  void didChangeAccessibilityFeatures() =>
      parent.didChangeAccessibilityFeatures();

  @override
  void didChangeAppLifecycleState(ui.AppLifecycleState state) =>
      parent.didChangeAppLifecycleState(state);

  @override
  void didChangeDependencies() => parent.didChangeDependencies();

  @override
  void didChangeInputControl(
          TextInputControl? oldControl, TextInputControl? newControl) =>
      parent.didChangeInputControl(oldControl, newControl);

  @override
  void didChangeLocales(List<ui.Locale>? locales) =>
      parent.didChangeLocales(locales);

  @override
  void didChangeMetrics() => parent.didChangeMetrics();

  @override
  void didChangePlatformBrightness() => parent.didChangePlatformBrightness();

  @override
  void didChangeTextScaleFactor() => parent.didChangeTextScaleFactor();

  @override
  void didHaveMemoryPressure() => parent.didHaveMemoryPressure();

  @override
  Future<bool> didPopRoute() => parent.didPopRoute();

  @override
  Future<bool> didPushRoute(String route) => parent.didPushRoute(route);

  @override
  Future<bool> didPushRouteInformation(RouteInformation routeInformation) =>
      parent.didPushRouteInformation(routeInformation);

  @override
  Future<ui.AppExitResponse> didRequestAppExit() => parent.didRequestAppExit();

  @override
  void didUpdateWidget(covariant EditableTextM3 oldWidget) {
    // can't support this
  }

  @override
  void dispose() => parent.dispose();

  @override
  void endBatchEdit() => parent.endBatchEdit();

  @override
  SuggestionSpan? findSuggestionSpanAtCursorIndex(int cursorIndex) =>
      parent.findSuggestionSpanAtCursorIndex(cursorIndex);

  @override
  void hideMagnifier() => parent.hideMagnifier();

  @override
  void hideToolbar([bool hideHandles = true]) =>
      parent.hideToolbar(hideHandles);

  @override
  void initState() => parent.initState();

  @override
  void insertContent(KeyboardInsertedContent content) =>
      parent.insertContent(content);

  @override
  void insertTextPlaceholder(ui.Size size) =>
      parent.insertTextPlaceholder(size);

  @override
  bool get mounted => parent.mounted;

  @override
  bool get pasteEnabled => parent.pasteEnabled;

  @override
  Future<void> pasteText(SelectionChangedCause cause) =>
      parent.pasteText(cause);

  @override
  void performAction(TextInputAction action) => parent.performAction(action);

  @override
  void performPrivateCommand(String action, Map<String, dynamic> data) =>
      parent.performPrivateCommand(action, data);

  @override
  void performSelector(String selectorName) =>
      parent.performSelector(selectorName);

  @override
  void reassemble() => parent.reassemble();

  @override
  void removeTextPlaceholder() => parent.removeTextPlaceholder();

  @override
  RenderEditableM3 get renderEditable => throw UnimplementedError();

  @override
  void requestKeyboard() => parent.requestKeyboard();

  @override
  void selectAll(SelectionChangedCause cause) => parent.selectAll(cause);

  @override
  bool get selectAllEnabled => parent.selectAllEnabled;

  @override
  TextSelectionOverlayM3? get selectionOverlay => null;

  @override
  void setState(ui.VoidCallback fn) => parent.setState(fn);

  @override
  void showAutocorrectionPromptRect(int start, int end) =>
      parent.showAutocorrectionPromptRect(start, end);

  @override
  void showMagnifier(ui.Offset positionToShow) =>
      parent.showMagnifier(positionToShow);

  @override
  bool showSpellCheckSuggestionsToolbar() =>
      parent.showSpellCheckSuggestionsToolbar();

  @override
  bool showToolbar() => parent.showToolbar();

  @override
  SpellCheckConfigurationM3 get spellCheckConfiguration =>
      throw UnimplementedError();

  @override
  bool get spellCheckEnabled => parent.spellCheckEnabled;

  @override
  TextEditingValue get textEditingValue => parent.textEditingValue;

  @override
  TextInputConfiguration get textInputConfiguration =>
      parent.textInputConfiguration;

  @override
  DiagnosticsNode toDiagnosticsNode(
          {String? name, DiagnosticsTreeStyle? style}) =>
      parent.toDiagnosticsNode(name: name, style: style);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) =>
      parent.toString(minLevel: minLevel);

  @override
  String toStringShort() => parent.toStringShort();

  @override
  void toggleToolbar([bool hideHandles = true]) =>
      parent.toggleToolbar(hideHandles);

  @override
  void updateEditingValue(TextEditingValue value) => updateEditingValue(value);

  @override
  void updateFloatingCursor(RawFloatingCursorPoint point) =>
      parent.updateFloatingCursor(point);

  @override
  void updateKeepAlive() => parent.updateKeepAlive();

  @override
  void userUpdateTextEditingValue(
          TextEditingValue value, SelectionChangedCause? cause) =>
      parent.userUpdateTextEditingValue(value, cause);

  @override
  bool get wantKeepAlive => parent.wantKeepAlive;

  @override
  EditableTextM3 get widget => throw UnimplementedError();

  @override
  set spellCheckResults(SpellCheckResults? _spellCheckResults) =>
      parent.spellCheckResults = _spellCheckResults;
}

class SpellCheckConfigutationProxy implements SpellCheckConfiguration {
  SpellCheckConfigutationProxy(this.parent);

  final SpellCheckConfigurationM3 parent;

  @override
  SpellCheckConfiguration copyWith(
      {SpellCheckService? spellCheckService,
      Color? misspelledSelectionColor,
      TextStyle? misspelledTextStyle,
      EditableTextContextMenuBuilder? spellCheckSuggestionsToolbarBuilder}) {
    return SpellCheckConfigutationProxy(
      parent.copyWith(
        spellCheckService: spellCheckService,
        misspelledSelectionColor: misspelledSelectionColor,
        misspelledTextStyle: misspelledTextStyle,
        spellCheckSuggestionsToolbarBuilder:
        spellCheckSuggestionsToolbarBuilder == null
            ? null
            : (context, editableTextState) =>
            spellCheckSuggestionsToolbarBuilder(
                context, EditableTextStateProxy(editableTextState)),
      ),
    );
  }

  @override
  Color? get misspelledSelectionColor => parent.misspelledSelectionColor;

  @override
  TextStyle? get misspelledTextStyle => parent.misspelledTextStyle;

  @override
  bool get spellCheckEnabled => parent.spellCheckEnabled;

  @override
  SpellCheckService? get spellCheckService => parent.spellCheckService;

  @override
  EditableTextContextMenuBuilder? get spellCheckSuggestionsToolbarBuilder =>
      parent.spellCheckSuggestionsToolbarBuilder != null
          ? (context, editableTextState) =>
              parent.spellCheckSuggestionsToolbarBuilder!(
                  context, EditableTextM3StateProxy(editableTextState))
          : null;

  @override
  String toString() => parent.toString();
}

class SpellCheckConfigutationM3Proxy implements SpellCheckConfigurationM3 {
  SpellCheckConfigutationM3Proxy(this.parent);

  final SpellCheckConfiguration parent;

  @override
  SpellCheckConfigurationM3 copyWith(
      {SpellCheckService? spellCheckService,
      Color? misspelledSelectionColor,
      TextStyle? misspelledTextStyle,
      EditableTextContextMenuBuilderM3? spellCheckSuggestionsToolbarBuilder}) {
    return SpellCheckConfigutationM3Proxy(
      parent.copyWith(
        spellCheckService: spellCheckService,
        misspelledSelectionColor: misspelledSelectionColor,
        misspelledTextStyle: misspelledTextStyle,
        spellCheckSuggestionsToolbarBuilder:
            spellCheckSuggestionsToolbarBuilder == null
                ? null
                : (context, editableTextState) =>
                    spellCheckSuggestionsToolbarBuilder(
                        context, EditableTextM3StateProxy(editableTextState)),
      ),
    );
  }

  @override
  Color? get misspelledSelectionColor => parent.misspelledSelectionColor;

  @override
  TextStyle? get misspelledTextStyle => parent.misspelledTextStyle;

  @override
  bool get spellCheckEnabled => parent.spellCheckEnabled;

  @override
  SpellCheckService? get spellCheckService => parent.spellCheckService;

  @override
  EditableTextContextMenuBuilderM3? get spellCheckSuggestionsToolbarBuilder =>
      parent.spellCheckSuggestionsToolbarBuilder != null
          ? (context, editableTextState) =>
              parent.spellCheckSuggestionsToolbarBuilder!(
                  context, EditableTextStateProxy(editableTextState))
          : null;

  @override
  String toString() => parent.toString();
}
