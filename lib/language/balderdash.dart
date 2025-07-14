import 'package:highlight/src/mode.dart';

final balderdash = Mode(
    refs: {},
    aliases: ["data"],
    contains: <Mode>[
      Mode(
        className: 'hash',
        begin: "#",
        endSameAsBegin: true,
      ),
      Mode(
        className: 'number',
        begin: "[0-9]+",
        endSameAsBegin: true,
      ),
      Mode(
          className: 'div',
          begin: "\\{@",
          end: "\\}",
          contains: <Mode>[
            Mode(
              className: 'year',
              begin: "[%A-Z0-9|:]+",
            ),
          ]
      ),
      Mode(
        className: 'vocab-literal',
        begin: "\\{\\[",
        end: "\\}",
          contains: <Mode>[
            Mode(
                className: 'pipe',
                begin: "\\|",
            ),
            Mode(
              className: 'brace',
              begin: "\\[",
            ),
          ]
      ),
      Mode(
        className: 'vocab-ref',
        begin: "\\{",
        end: "\\}",
        illegal: ";",
          contains: <Mode>[
            Mode(
              className: 'repeater',
              begin: "#[0-9]+",
              end: "[0-9]+",
            ),
          ]
      ),
    ]);