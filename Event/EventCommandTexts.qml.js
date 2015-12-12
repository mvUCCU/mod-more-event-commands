var ModAPI = require('modapi')
var _ = require('lodash')

var qml = ModAPI.QMLFile("Event/EventCommandTexts.qml")
var node = qml.root.node

node.function("eventCodeOverThreshold", [
  'function eventCodeOverThreshold(code) {',
  '    if (Object.prototype.toString.call(code) === "[object String]" && code.length > 0)',
  '        return false;',
  '',
  '    return code >= 400;',
  '}',
].join("\n"))

node.function("symbolText", [
  'function symbolText(data) {',
  '    return !eventCodeOverThreshold(data.code) ? diamond : colon;',
  '}',
].join("\n"))

node.function("commandParamText", [
  'function commandParamText(data) {',
  '    var func = this["commandParamText" + data.code];',
  '    return func ? func(data.parameters) : "";',
  '}',
].join("\n"))

qml.save()
