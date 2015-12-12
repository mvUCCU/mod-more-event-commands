pragma Singleton
import QtQuick 2.3
import ".."
import "../plugin-parser"

Item {
    property var pagesCache : null
    property var codePageIndexMap : null
    property var pluginCommandsGroupCache : null
    property var pluginCommandsCache : null

    Connections {
        target: DataManager
        onProjectUrlChanged: {
            _cleanCache();
        }
        onPluginsBackupChanged: {
            _cleanCache();
        }
        onPluginsChanged: {
            _cleanCache();
        }
    }

    function getPluginCommands() {
        _checkAndRefreshCache();
        return pluginCommandsGroupCache;
    }

    function get(code) {
        _checkAndRefreshCache();
        var cmd = pluginCommandsCache[code];
        if (!cmd) return undefined;

        return ["red", ((cmd.parameters || []).length > 0) ? 1 : 0, cmd.title || cmd.name || code];
    }

    function hint(code) {
        _checkAndRefreshCache();
        var cmd = pluginCommandsCache[code];
        if (!cmd) return undefined;

        return cmd.description;
    }

    function _checkAndRefreshCache() {
        if (!_checkCache())
            _generateCache();
    }

    function _checkCache() {
        if (!pluginCommandsGroupCache) return false;
        if (!pluginCommandsCache) return false;
        return true;
    }

    function _cleanCache() {
        pluginCommandsGroupCache = null;
        pluginCommandsCache = null;
    }

    function _generateCache() {
        var plugins = DataManager.plugins;
        var groups = {};
        var groupOrder = [];
        var commands = {};

        for(var i = 0; i < plugins.length; i++) {
            var name = plugins[i].name || "";
            if (!name) continue;
            if (!plugins[i].status) continue;

            var data = PluginParser.parsePlugin(name);
            var eventGroups = data.eventGroups || [];

            for (var j = 0; j < eventGroups.length; j++) {
                var eventGroup = eventGroups[j];
                var group = groups[eventGroup.name];
                if (!group) {
                    group = groups[eventGroup.name] = {}
                    group.name = eventGroup.name;
                    group.codeList = [];
                    groupOrder.push(eventGroup.name);
                }
                group.title = group.title || eventGroup.title;

                var eventCommands = eventGroup.eventCommands || [];
                for (var k = 0; k < eventCommands.length; k++) {
                    var eventCommand = eventCommands[k];
                    commands[eventCommand.name] = eventCommand;
                    group.codeList.push(eventCommand.name);
                }
            }
        }

        var groupCache = [];
        for(var i = 0; i < groupOrder.length; i++) {
            groupCache.push(groups[groupOrder[i]]);
        }

        pluginCommandsGroupCache = groupCache;
        pluginCommandsCache = commands;
    }
}
