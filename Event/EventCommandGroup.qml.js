var ModAPI = require('modapi')
var _ = require('lodash')

var qml = ModAPI.QMLFile("Event/EventCommandGroup.qml")
var node = qml.getObjectsByDescribe("GroupButton")[0].node
node.publicMember("eventCode").returnType = "var"

qml.save()
