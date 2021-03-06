import 'dart:convert';

import 'package:logger/logger.dart';

class ApplicationLogger {
  static Logger getLogger(String className, {bool colors = true}) =>
      Logger(
          printer: PrefixPrinter(
              SimpleLogPrinter(
                  className,
                  colors: colors,
              ),
          ),
      );
}

class SimpleLogPrinter extends LogPrinter {
  final String _className;
  final bool colors;
  static final levelColors = {
    Level.verbose: AnsiColor.fg(AnsiColor.grey(0.5)),
    Level.debug: AnsiColor.none(),
    Level.info: AnsiColor.fg(12),
    Level.warning: AnsiColor.fg(208),
    Level.error: AnsiColor.fg(196),
    Level.wtf: AnsiColor.fg(199),
  };
  static final levelEmojis = {
    Level.verbose: 'ℹ',
    Level.debug: '🐛 ',
    Level.info: '💡 ',
    Level.warning: '⚠️ ',
    Level.error: '⛔ ',
    Level.wtf: '👾 ',
  };

  SimpleLogPrinter(this._className, {this.colors = true});

  String _labelFor(Level level) {
    var color = levelColors[level];
    var emoji = levelEmojis[level];
    String finalLabel = emoji! + level.toString();
    return colors ? color!(finalLabel) : finalLabel;
  }

  String _stringifyMessage(dynamic message) {
    String result;
    if (message is Map || message is Iterable) {
      var encoder = JsonEncoder.withIndent(
          null); // print everything as one line
      result = encoder.convert(message);
    } else {
      result = message.toString();
    }
    return result;
  }

  @override
  List<String> log(LogEvent event) {
    var messageStr = _stringifyMessage(event.message);
    var errorStr = event.error != null ? '  ERROR: ${event.error}' : '';
    return ['${_labelFor(event.level)} [$_className] - $messageStr$errorStr'];
  }
}