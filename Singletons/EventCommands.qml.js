var ModAPI = require('modapi')
var _ = require('lodash')

var qml = ModAPI.QMLFile("Singletons/EventCommands.qml")
var node = qml.root.node

var prop = node.publicMember("moreEventCommandsManager")
prop.kind = "property"
prop.returnType = "var"
prop.statment = "null"

node.function("setMoreEventCommandsManager", [
  'function setMoreEventCommandsManager(obj) {',
  '    moreEventCommandsManager = obj;',
  '}',
].join("\n"))

node.function("get", [
  'function get(code) {',
  '    return commandTable[code] || moreEventCommandsManager.get(code) || commandTable[999];',
  '}',
].join("\n"))

node.function("hint", [
  'function hint(code) {',
  '    return hintTable[code] || moreEventCommandsManager.hint(code);',
  '}',
].join("\n"))

qml.save()
