import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:url_launcher/url_launcher.dart';

class WebReferenceLinkButton extends StatelessWidget {
  const WebReferenceLinkButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadTooltip(
      reverseDuration: Duration(milliseconds: 80),
      builder: (_) => Text('$url'),
      child: ShadButton.ghost(
        expands: true,
        leading: const Icon(LucideIcons.externalLink),
        onPressed: () async {
          if (!await launchUrl(url) && context.mounted) {
            ShadToaster.of(context).show(
              ShadToast(
                title: const Text('Uh oh! Something went wrong.'),
                description: Text('Could not launch "$url".'),
                action: const CopyUrlToClipboard(),
              ),
            );
          }
        },
        child: const Text(
          'What is the 20/3/8 Rule?',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

class CopyUrlToClipboard extends StatefulWidget {
  const CopyUrlToClipboard({super.key});

  @override
  State<CopyUrlToClipboard> createState() => _CopyUrlToClipboardState();
}

class _CopyUrlToClipboardState extends State<CopyUrlToClipboard> {
  var copied = false;

  @override
  Widget build(BuildContext context) {
    return ShadButton(onPressed: onPressed, leading: icon());
  }

  Widget icon() {
    if (copied) return const Icon(LucideIcons.clipboardCheck);
    return const Icon(LucideIcons.clipboardCopy);
  }

  void onPressed() async {
    try {
      await Clipboard.setData(ClipboardData(text: '$url'));
    } finally {
      setState(() => copied = true);
    }
  }
}

final url = Uri.parse('https://moneyguy.com/article/20-3-8-rule/');
