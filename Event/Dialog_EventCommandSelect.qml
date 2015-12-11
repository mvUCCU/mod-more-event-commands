import QtQuick 2.3
import QtQuick.Controls 1.2
import "../BasicControls"
import "../BasicLayouts"
import "../Singletons"
import "../Singletons/more-event-commands"

ModalWindow {
    id: root

    title: qsTr("Event Commands")

    property int eventCode: 101
    property var eventData
    property int troopId: 0

    resources: [
        Timer {
            id: windowCloser
            interval: 1
            onTriggered: root.close()
        }
    ]

    DialogBox {
        id: dialogBox

        okEnabled: false
        okVisible: false
        applyVisible: false

        signal triggered(var code)

        onInit: {
            initCommands();

            var last = DataManager.lastEventCode;
            var tabIndex = undefined;
            if (last) {
              tabIndex = MoreEventCommandsManager.codePageIndexMap[last]
            }

            if (tabIndex !== undefined) {
                var tab = tabView.getTab(tabIndex);
                tab.active = true;
                searchAndFocusEventButton(tab.item, DataManager.lastEventCode);
                tabView.currentIndex = tabIndex;
            }
        }

        property var pages: null

        function initCommands() {
            if (!MoreEventCommandsManager.pagesCache)
                updatePagesCache();

            pages = MoreEventCommandsManager.pagesCache;
        }

        function updatePagesCache() {
            var indexMap = {};
            var groupBoxHeight = 34;
            var groupBoxSpacing = 10;
            var commandHeight = 25;
            var columnHeightThreshold = 555;

            var lastColumn = [];
            var lastHeight = 0;
            var columns = [lastColumn];
            var commands = getCommands();
            while (commands.length > 0) {
                var group = commands[0];
                var height = groupBoxHeight + group.codeList.length * commandHeight;
                if (lastHeight + height < columnHeightThreshold) {
                    commands.splice(0, 1);
                } else {
                    var count = Math.floor((columnHeightThreshold - lastHeight - groupBoxHeight) / commandHeight);
                    var newGroup = { title: group.title, continue: true };
                    newGroup.codeList = group.codeList.slice(count);
                    group.codeList = group.codeList.slice(0, count);
                    height = groupBoxHeight + group.codeList.length * commandHeight;
                    commands.splice(0, 1, newGroup);
                }
                lastColumn.push(group);
                lastHeight += height + groupBoxSpacing;

                for (var i = 0; i < group.codeList.length; i++) {
                    var code = group.codeList[i];
                    if (!indexMap[code])
                        indexMap[code] = Math.floor((columns.length - 1) / 2);
                }

                if (lastHeight + groupBoxHeight + commandHeight > columnHeightThreshold) {
                    columns.push(lastColumn = []);
                    lastHeight = 0;
                }
            }

            var pages = [];
            for (var i = 0; i < columns.length; i += 2) {
                var data = [];
                if (columns[i + 0]) data.push(columns[i + 0]);
                if (columns[i + 1]) data.push(columns[i + 1]);

                pages.push({
                    "title": " " + String(pages.length + 1) + " ",
                    "columns": data
                });
            }
            MoreEventCommandsManager.pagesCache = pages;
            MoreEventCommandsManager.codePageIndexMap = indexMap;
        }

        function getCommands() {
            return getBuiltInCommands();
        }

        function getBuiltInCommands() {
            return [
                { title: qsTr("Message"),          codeList: [101, 102, 103, 104, 105] },
                { title: qsTr("Game Progression"), codeList: [121, 122, 123, 124] },
                { title: qsTr("Flow Control"),     codeList: [111, 112, 113, 115, 117, 118, 119, 108] },
                { title: qsTr("Party"),            codeList: [125, 126, 127, 128, 129] },
                { title: qsTr("Actor"),            codeList: [311, 312, 326, 313, 314, 315, 316, 317, 318, 319, 320, 321, 324, 325] },
                { title: qsTr("Movement"),         codeList: [201, 202, 203, 204, 205, 206] },
                { title: qsTr("Character"),        codeList: [211, 216, 217, 212, 213, 214] },
                { title: qsTr("Picture"),          codeList: [231, 232, 233, 234, 235] },
                { title: qsTr("Timing"),           codeList: [230] },
                { title: qsTr("Screen"),           codeList: [221, 222, 223, 224, 225, 236] },
                { title: qsTr("Audio & Video"),    codeList: [241, 242, 243, 244, 245, 246, 249, 250, 251, 261] },
                { title: qsTr("Scene Control"),    codeList: [301, 302, 303, 351, 352, 353, 354] },
                { title: qsTr("System Settings"),  codeList: [132, 133, 139, 140, 134, 135, 136, 137, 138, 322, 323] },
                { title: qsTr("Map"),              codeList: [281, 282, 283, 284, 285] },
                { title: qsTr("Battle"),           codeList: [331, 332, 342, 333, 334, 335, 336, 337, 339, 340] },
                { title: qsTr("Advanced"),         codeList: [355, 356] },
                { title: qsTr("UCCU"),         codeList: [356, 356, 356, 356, 356, 356, 356] },
                { title: qsTr("UCCU"),         codeList: [356, 356, 356, 356, 356, 356, 356] },
                { title: qsTr("UCCU"),         codeList: [356, 356, 356, 356, 356, 356, 356] },
                { title: qsTr("UCCU"),         codeList: [356, 356, 356, 356, 356, 356, 356] },
                { title: qsTr("UCCU"),         codeList: [356, 356, 356, 356, 356, 356, 356] },
                { title: qsTr("UCCU"),         codeList: [356, 356, 356, 356, 356, 356, 356] },
                { title: qsTr("UCCU"),         codeList: [356, 356, 356, 356, 356, 356, 356] },
                { title: qsTr("UCCU"),         codeList: [356, 356, 356, 356, 356, 356, 356] },
                { title: qsTr("UCCU"),         codeList: [356, 356, 356, 356, 356, 356, 356] },
            ];
        }

        TabView {
            id: tabView
            width: 508
            height: 596

            Repeater {
                model: pages ? pages.length : 0
                Tab {
                    property var page: pages[index]

                    title: page.title
                    GroupBoxRow {
                        anchors.fill: parent
                        anchors.margins: 8
                        Repeater {
                            model: page.columns.length

                            GroupBoxColumn {
                                property var column: page.columns[index]

                                Repeater {
                                    model: column.length
                                    EventCommandGroup {
                                        property var group: column[index]

                                        title: group.title + (group.continue ? " (cont.)" : "")
                                        codeList: group.codeList
                                        onTriggered: dialogBox.triggered(code)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        Dialog_EventCommand {
            id: commandDialog
            troopId: root.troopId
            onOk: {
                root.eventData = eventData;
                root.ok();
                windowCloser.start();
            }
        }

        onTriggered: {
            eventCode = code;
            DataManager.lastEventCode = code;
            if (EventCommands.flag(code) === 0) {
                makeSimpleEventData();
                root.ok();
                root.close();
            } else {
                commandDialog.eventCode = eventCode;
                commandDialog.eventData = null;
                commandDialog.open();
            }
        }

        function searchAndFocusEventButton(item, eventCode) {
            for (var i = 0; i < item.children.length; i++) {
                var child = item.children[i];
                if (child.eventCode === eventCode) {
                    root.firstFocusItem = child;
                    return true;
                }
                if (searchAndFocusEventButton(child, eventCode)) {
                    return true;
                }
            }
            return false;
        }

        function makeSimpleEventData() {
            root.eventData = [{ code: eventCode, indent: 0, parameters: [] }];
            if (eventCode === 112) {    // Loop
                root.eventData.push({ code: 0, indent: 1, parameters: [] });
                root.eventData.push({ code: 413, indent: 0, parameters: [] });
            }
        }
    }
}
