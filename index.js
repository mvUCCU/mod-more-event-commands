var ModAPI = require('modapi')
var Essentials = require('mod')('essentials')
var _ = require('lodash')
var fs = require('fs')
var path = require('path')

var readLocalFile = function(name) {
  return fs.readFileSync(path.join(__dirname, name))
}

Essentials.addSingleton("MoreEventCommandsManager", readLocalFile("Singletons/MoreEventCommandsManager.qml"))

;[
  "Event/Dialog_EventCommandSelect.qml",
].forEach(function(i) {
  if (path.extname(i) == ".js" && path.extname(path.basename(i, ".js")) == ".qml") {
    require("./" + i)
  } else {
    ModAPI.add(i, readLocalFile(i))
  }
})
