// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:logger/logger.dart';
import 'package:questa/modules/c_navigate.dart';
import 'package:questa/modules/extensions_utils_packs.dart';
import 'package:questa/view/theme/configs/tc_buttons.dart';
import 'package:questa/view/widgets/c_modal_widget.dart';
import 'package:run_it/run_it.dart';

class CDropdownController extends TextEditingController {
  CDropdownController({String value = '', this.values = const []}) : super() {
    singleValue = value;
  }

  String singleValue = '';
  List<String> values;
}

// C DROP DOWN WIDGET. ///////////////////////////////////////////////////////////////////////////////////////////////////////
class CDropdownSelectWidget extends StatelessWidget {
  CDropdownSelectWidget({
    super.key,
    required this.options,
    this.isMultiSelector = false,
    this.controller,
    this.title,
    this.subtitle,
    this.separator = ' • ',
    this.showFilterField = false,
    // this.value,
    // this.values,
    this.placeholder,
    this.hint,
    this.leading,
    this.clear = false,
    this.trailing,
    this.onFinish,
    this.onCancel,
    this.onSelect,
    this.maxLength,
    this.maxLines = 1,
    this.minLines,
    this.filled = true,
    this.filledColor,
    this.border,
    this.onTap,
    this.enabled = true,
    this.readOnly = false,
    this.borderRadius,
    this.textAlign = TextAlign.start,
    this.expands = false,
    this.textAlignVertical = TextAlignVertical.center,
    this.onChanged,
    this.onTapOutside,
    this.style,
    this.isCollapsed,
    this.clipBehavior = Clip.hardEdge,
    this.placeholderAlignment,
    this.leadingAlignment,
    this.trailingAlignment,
    this.padding,
    this.isBottomSheet = true,
    this.showDragHandle = true,
  }) {
    initValues();
  }

  // PARAMETERS.
  final bool isMultiSelector;
  final Widget? title;
  final Widget? subtitle;
  // final String? value;
  // final List<String>? values;
  final List<CDropdownOption> options;
  final bool showFilterField;
  final Function()? onFinish;
  final Function()? onCancel;
  final Function()? onSelect;

  // SHADE PARAMS.
  final String? placeholder;
  final Widget? hint;
  final Icon? leading;
  final Widget? trailing;
  final bool clear;
  final String? separator;

  final CDropdownController? controller;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final bool filled;
  final Color? filledColor;
  final InputBorder? border;
  final EdgeInsetsGeometry? padding;
  final void Function()? onTap;
  final bool enabled;
  final bool readOnly;
  final BorderRadiusGeometry? borderRadius;
  final TextAlign textAlign;
  final bool expands;
  final TextAlignVertical? textAlignVertical;
  final void Function(String value, List<String> values)? onChanged;
  final void Function(PointerDownEvent)? onTapOutside;
  final TextStyle? style;
  final bool? isCollapsed;
  final Clip clipBehavior;
  final AlignmentGeometry? placeholderAlignment;
  final AlignmentGeometry? leadingAlignment;
  final AlignmentGeometry? trailingAlignment;
  final bool isBottomSheet;
  final bool showDragHandle;

  final List<CDropdownOption> _values = [];

  // COMPONENT. //////////////////////////////////////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 9 * 5,
      child: TextField(
        controller: controller,
        readOnly: true,
        enabled: enabled,
        onTap: () {
          if (!readOnly) {
            onTap?.call();

            openSelector(context);
          }
        },
        decoration: InputDecoration(
          helper: hint,
          hintText: placeholder,
          prefixIcon: leading,
          suffixIconConstraints: const BoxConstraints(maxWidth: 27),
          suffixIcon: IconButton(
            icon: Icon(IconsaxPlusLinear.arrow_down),
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            onPressed: () {
              onTap?.call();
              if (!readOnly) openSelector(context);
            },
          ).withPadding(right: 9),
          filled: filled,
          fillColor: filledColor,
          border: border,
          contentPadding: padding,
        ),
        maxLength: maxLength,
        maxLines: maxLength ?? 1,
        minLines: minLines ?? 1,
        textAlign: textAlign,
        expands: expands,
        textAlignVertical: textAlignVertical,
        onTapOutside: onTapOutside,
        style: style,
        clipBehavior: clipBehavior,
      ),
    );
  }

  // METHODS. ----------------------------------------------------------------------------------------------------------------
  void initValues() {
    _values.clear();

    if (controller != null) {
      List<String> values = [if (controller?.singleValue != null) controller!.singleValue];

      if (isMultiSelector) values = (controller?.values ?? <String>[]).toSet().toList();

      for (String value in values) {
        for (CDropdownOption option in options) {
          if (option.value == value) _values.add(option);
        }
      }

      _displaySelecteds(_values);
    }
    _convertOptionToValueListAndPut(_values);
  }

  void _convertOptionToValueListAndPut(List<CDropdownOption> options) {
    List<String> opts = [];

    for (CDropdownOption option in options) {
      opts.add(option.value);
    }

    if (isMultiSelector) {
      controller?.values = opts;
    } else {
      controller?.singleValue = opts.isNotEmpty ? opts.first : (controller?.singleValue ?? '');
    }
  }

  void _convertOptionToValueList(List<CDropdownOption> options) {
    List<String> opts = [];
    List<CDropdownOption> innerValues = [];

    for (CDropdownOption option in options) {
      opts.add(option.value);
      innerValues.add(option);
    }
    _values.clear();
    _values.addAll(innerValues);

    if (isMultiSelector) {
      controller?.values = opts;
      onChanged?.call('', opts);
    } else {
      controller?.singleValue = opts.isNotEmpty ? opts.first : (controller?.singleValue ?? '');
      onChanged?.call(opts.isNotEmpty ? opts.first : '', []);
    }
  }

  void _displaySelecteds(List<CDropdownOption> options) {
    List<String> textValue = [];

    for (CDropdownOption option in options) {
      textValue.add(option.label);
    }

    var joineds = textValue.join(separator ?? ', ');
    controller?.text = joineds;
  }

  void openSelector(BuildContext context) {
    Widget container = CInnerDropdownSelector(
      options: options,
      selecteds: _values,
      title: title,
      subtitle: subtitle,
      isMultiSelector: isMultiSelector,
      showFilterField: showFilterField,
      onFinish: (selecteds) {
        _convertOptionToValueList(selecteds);
        _displaySelecteds(selecteds);
      },
    );

    if (isBottomSheet) {
      showModalBottomSheet(
        isScrollControlled: true,
        showDragHandle: showDragHandle,
        context: context,
        builder: (context) => container.withPadding(left: 14, right: 14, bottom: 14, top: showDragHandle ? null : 14),
      );
    } else {
      CModalWidget(context, child: container).show();
    }
  }
}

// C DROP DOWN OPTION. ///////////////////////////////////////////////////////////////////////////////////////////////////////
class CDropdownOption {
  const CDropdownOption({required this.value, required this.label, this.trailing, this.subtitle});

  final String value;
  final String label;
  final Widget? trailing;
  final String? subtitle;
}

// C DROP DOWN SELECTOR. /////////////////////////////////////////////////////////////////////////////////////////////////////
class CInnerDropdownSelector extends StatefulWidget {
  const CInnerDropdownSelector({
    super.key,
    this.title,
    this.subtitle,
    this.isMultiSelector = false,
    this.showFilterField = true,
    this.expandIt = false,
    this.selecteds,
    required this.options,
    this.onFinish,
    this.onCancel,
    this.onClose,
  });

  final bool showFilterField;
  final bool isMultiSelector;
  final bool expandIt;
  final List<CDropdownOption>? selecteds;
  final List<CDropdownOption> options;
  final Widget? title;
  final Widget? subtitle;
  final Function(List<CDropdownOption>)? onFinish;
  final Function()? onClose;
  final Function()? onCancel;

  @override
  State<CInnerDropdownSelector> createState() => _CInnerDropdownSelectorState();
}

class _CInnerDropdownSelectorState extends State<CInnerDropdownSelector> {
  // DATA'S. -----------------------------------------------------------------------------------------------------------------
  List<CDropdownOption> selecteds = [];
  List<CDropdownOption> optionsList = [];
  TextEditingController textEditingController = TextEditingController();

  // INITIALIZER. ------------------------------------------------------------------------------------------------------------
  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void initState() {
    optionsList = widget.options;
    selecteds = widget.selecteds ?? [];

    super.initState();
  }

  @override
  void dispose() {
    widget.onClose?.call();
    super.dispose();
  }

  // COMPONENTS. /////////////////////////////////////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    Widget? title = widget.title;
    Widget? subtitle = widget.subtitle;

    if (title is Text) {
      TextStyle textStyle = title.style ?? const TextStyle();
      title = Text(title.data ?? '', style: textStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 21.6));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null) ...[title, const Gap(4.5)],

        if (subtitle != null) ...[subtitle, const Gap(4.5)],

        if (widget.showFilterField)
          SizedBox(
            height: 9 * 4,
            child: TextField(
              controller: textEditingController,
              decoration: InputDecoration(
                filled: true,
                border: const OutlineInputBorder(borderSide: BorderSide.none),
                hintText: "Filtrer par mot clé",
                prefixIcon: const Icon(IconsaxPlusLinear.search_normal),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () {
                    setState(() {
                      textEditingController.clear();
                      optionsList = widget.options;
                    });
                  },
                ),
              ),
              onChanged: (value) => filterItems(),
            ),
          ),

        // )
        const Gap(9),
        SingleChildScrollView(
          child: Column(
            children: [
              ...List.generate(optionsList.length, (index) {
                if (widget.isMultiSelector) {
                  return Padding(
                    padding: EdgeInsets.zero,
                    child: Card.filled(
                      child: CheckboxListTile(
                        title: Text(
                          optionsList[index].label,
                          style: context.theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        subtitle: (optionsList[index].subtitle != null) ? Text(optionsList[index].subtitle!) : null,
                        value: isChecked(optionsList[index]) ? true : false,
                        secondary: (optionsList[index].trailing != null) ? optionsList[index].trailing! : null,
                        onChanged: (value) => toggleSelect(optionsList[index]),
                      ),
                    ).onTap(() => toggleSelect(optionsList[index])),
                  );
                }

                return Card.filled(
                  child: Row(
                    children: [
                      const Icon(Icons.circle_outlined, size: 14),
                      const Gap(9),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            optionsList[index].label,
                            style: context.theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (optionsList[index].subtitle != null)
                            Text(
                              optionsList[index].subtitle!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                        ],
                      ).expanded(),
                      if (optionsList[index].trailing != null) ...[const SizedBox(width: 9), optionsList[index].trailing!],
                    ],
                  ).withPadding(all: 9),
                ).withPadding(bottom: 9 / 2).onTap(() {
                  // CRouter(context).goBack(userNavigator: true);
                  Navigator.pop(context);
                  widget.onFinish?.call([optionsList[index]]);
                });
              }),
              27.gap,
            ],
          ),
        ).run((it) {
          if (widget.expandIt) return it.expanded();

          return it.constrained(maxHeight: 405, minHeight: 108);
        }),

        const Divider(height: 0, thickness: 0).withPadding(bottom: 4.5),
        Row(
          children: [
            OutlinedButton.icon(
              icon: const Icon(Icons.close),
              label: const Text("Fermer"),
              onPressed: () {
                // closeOverlay(context);
                Navigator.pop(context);
                widget.onCancel?.call();
              },
            ),
            const Spacer(),
            FilledButton.tonalIcon(
              onPressed: () {
                Navigator.pop(context);
                if (selecteds.isNotEmpty) widget.onFinish?.call(selecteds);
              },
              label: "OK".t,
              icon: Icon(Icons.check),
              style: TcButtonsLight.blackButtonTheme,
            ),
            // ButtonWidget(
            //   leading: Icon(Icons.check, color: context.theme.colorScheme.onSecondary),
            //   text: "OK",
            //   onPressed: () {
            //     Navigator.pop(context);
            //     // CRouter(context).goBack();
            //     if (selecteds.isNotEmpty) widget.onFinish?.call(selecteds);
            //   },
            // ),
          ],
        ),
      ],
    );
  }

  // METHODS. ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  void toggleSelect(CDropdownOption option) {
    List<CDropdownOption> list = [];

    bool addIt = true;
    for (CDropdownOption item in selecteds) {
      // if (option.value != widget.options[index].value) list.add(option);
      if (option.value == item.value) {
        addIt = false;
      } else {
        list.add(item);
      }
    }

    if (addIt) list.add(option);

    setState(() => selecteds = list);
  }

  void filterItems() {
    if (textEditingController.text.isNotEmpty) setState(() => optionsList = widget.options);

    List<CDropdownOption> list = [];

    for (CDropdownOption option in widget.options) {
      if (option.label.toLowerCase().contains(textEditingController.text.toLowerCase())) {
        list.add(option);
      }
    }

    setState(() => optionsList = list);
  }

  bool isChecked(CDropdownOption option) {
    for (CDropdownOption opt in selecteds) {
      if (opt.value == option.value) return true;
    }

    return false;
  }
}
