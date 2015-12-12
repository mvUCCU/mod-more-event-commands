var ModAPI = require('modapi')
var _ = require('lodash')

var qml = ModAPI.QMLFile("Event/EventCommandListBox.qml")
var node = qml.root.node
node.publicMember("currentCode").returnType = "var"
node.publicMember("validItemSelected").statement = "currentCode && !eventCodeOverThreshold(currentCode)"
node.publicMember("creationEnabled").statement = "!eventCodeOverThreshold(currentCode)"

node.function("eventCodeOverThreshold", [
  'function eventCodeOverThreshold(code) {',
  '    if (Object.prototype.toString.call(code) === "[object String]" && code.length > 0)',
  '        return false;',
  '',
  '    return code >= eventCodeThreshold;',
  '}',
].join("\n"))

var obj

obj = node.object("onMoveCursorUp")
obj.value = obj.value.replace("list[index].code >= eventCodeThreshold", "eventCodeOverThreshold(list[index].code)")

obj = node.object("onMoveCursorDown")
obj.value = obj.value.replace("list[index].code >= eventCodeThreshold", "eventCodeOverThreshold(list[index].code)")

obj = node.function("updateCommandSelection")
obj.content = obj.content.replace("list[i].code < eventCodeThreshold", "!eventCodeOverThreshold(list[i].code)")
obj.content = obj.content.replace("list[i].code < eventCodeThreshold", "!eventCodeOverThreshold(list[i].code)")
obj.content = obj.content.replace("code < eventCodeThreshold", "!eventCodeOverThreshold(code)")

obj = node.function("isSingleCommand")
obj.content = obj.content.replace("list[i].code < eventCodeThreshold", "!eventCodeOverThreshold(list[i].code)")

qml.save()
