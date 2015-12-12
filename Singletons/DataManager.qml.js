var ModAPI = require('modapi')
var _ = require('lodash')

var qml = ModAPI.QMLFile("Singletons/DataManager.qml")
var node = qml.root.node
node.publicMember("lastEventCode").returnType = "var"

qml.save()
