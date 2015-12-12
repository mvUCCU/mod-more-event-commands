var ModAPI = require('modapi')
var Essentials = require('mod')('essentials')
var _ = require('lodash')
var fs = require('fs')
var path = require('path')

var readLocalFile = function(name) {
  return fs.readFileSync(path.join(__dirname, name))
}

;[
  "Singletons/more-event-commands/qmldir",
  "Singletons/more-event-commands/MoreEventCommandsManager.qml",
  "Singletons/EventCommands.qml.js",
  "Singletons/DataManager.qml.js",
  "Event/EventCommandBase.qml.js",
  "Event/EventCommandGroup.qml.js",
  "Event/EventCommandListBox.qml.js",
  "Event/EventCommandTexts.qml.js",
  "Event/Dialog_EventCommand.qml.js",
  "Event/Dialog_EventCommandSelect.qml",
].forEach(function(i) {
  if (path.extname(i) == ".js" && path.extname(path.basename(i, ".js")) == ".qml") {
    require("./" + i)
  } else {
    ModAPI.add(i, readLocalFile(i))
  }
})

var qml = ModAPI.QMLFile("Main/MainWindow.qml")
qml.addImportPath("../Singletons/more-event-commands")
var obj = qml.root.node.object("Component.onCompleted")
obj.value = "{\n" + obj.value + "\nEventCommands.setMoreEventCommandsManager(MoreEventCommandsManager);\n}"
qml.save()
