var ModAPI = require('modapi')
var _ = require('lodash')

var qml = ModAPI.QMLFile("Event/Dialog_EventCommand.qml")
var node = qml.root.node
node.publicMember("eventCode").returnType = "var"

qml.save()
