/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick          2.3
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles  1.4
import QtQuick.Dialogs  1.2
import QtQuick.Layouts      1.2

import QGroundControl               1.0
import QGroundControl.Palette       1.0
import QGroundControl.FactSystem    1.0
import QGroundControl.FactControls  1.0
import QGroundControl.Controls      1.0
import QGroundControl.ScreenTools   1.0
import QGroundControl.Controllers   1.0

AnalyzePage {
    id:                 mavlinkConsolePage
    pageComponent:      pageComponent
    pageDescription:    qsTr("Provides a connection to the vehicle's system shell.")
    allowPopout:        true

    property bool isLoaded: false

    // Key input on mobile is handled differently, so use a separate command input text field.
    // E.g. for android see https://bugreports.qt.io/browse/QTBUG-40803
    readonly property bool _separateCommandInput: ScreenTools.isMobile

    MavlinkConsoleController {
        id: conController
    }

    Component {
        id: pageComponent

        ColumnLayout {
            id:     consoleColumn
            height: availableHeight
            width:  availableWidth

            Connections {
                target: conController

                onDataChanged: {
                    if (isLoaded) {
                        // rate-limit updates to reduce CPU load
                        updateTimer.start();
                    }
                }
            }

            Rectangle {
                id:                     guidedCommandPanel
                Layout.fillWidth:       true
                Layout.preferredHeight: commandControls.implicitHeight + ScreenTools.defaultFontPixelHeight
                color:                  qgcPal.windowShade
                border.width:           1
                border.color:           qgcPal.colorOrange
                radius:                 ScreenTools.defaultFontPixelWidth * 0.5

                readonly property var commandNames: ["dmesg", "uorb top", "listener", "fw_gain_design"]
                readonly property var listenerTopics: [
                    "vehicle_air_data", "pn", "pnlogging", "threeloop", "twoloop", "axon_gyro", "axon_tracker",
                    "gpsless_takeoff_status", "gpsless_nav_status", "gps_checks", "emsad", "fw_gain_design",
                    "fw_gain_design_gains", "pnseeker"
                ]

                function commandText() {
                    var command = commandCombo.currentText
                    if (command === "listener") {
                        return "listener " + topicCombo.currentText + " -r " + listenerRate.text + " -n " + listenerCount.text
                    }
                    if (command === "fw_gain_design") {
                        command += " " + gainDesignAction.currentText
                        if (gainDesignAction.currentText === "excite") {
                            command += " " + exciteAction.currentText
                            if (exciteAction.currentText === "start") {
                                command += " " + exciteAxis.currentText
                            }
                        }
                    }
                    return command
                }

                GridLayout {
                    id:                 commandControls
                    anchors.margins:    ScreenTools.defaultFontPixelHeight * 0.5
                    anchors.fill:       parent
                    columns:            8
                    columnSpacing:      ScreenTools.defaultFontPixelWidth * 0.6
                    rowSpacing:         ScreenTools.defaultFontPixelHeight * 0.35

                    QGCLabel {
                        text:       qsTr("PX4 Quick Command")
                        color:      qgcPal.colorOrange
                        font.bold:  true
                        Layout.columnSpan: 8
                    }

                    QGCComboBox {
                        id:                 commandCombo
                        model:              guidedCommandPanel.commandNames
                        Layout.preferredWidth: ScreenTools.defaultFontPixelWidth * 19
                        sizeToContents:     false
                    }

                    QGCComboBox {
                        id:                 topicCombo
                        visible:            commandCombo.currentText === "listener"
                        model:              guidedCommandPanel.listenerTopics
                        Layout.preferredWidth: ScreenTools.defaultFontPixelWidth * 25
                        sizeToContents:     false
                    }

                    QGCTextField {
                        id:                 listenerRate
                        visible:            commandCombo.currentText === "listener"
                        text:               "1"
                        placeholderText:    qsTr("Rate")
                        inputMethodHints:   Qt.ImhDigitsOnly
                        Layout.preferredWidth: ScreenTools.defaultFontPixelWidth * 8
                    }

                    QGCTextField {
                        id:                 listenerCount
                        visible:            commandCombo.currentText === "listener"
                        text:               "10000000000000"
                        placeholderText:    qsTr("Messages")
                        inputMethodHints:   Qt.ImhDigitsOnly
                        Layout.preferredWidth: ScreenTools.defaultFontPixelWidth * 19
                    }

                    QGCComboBox {
                        id:                 gainDesignAction
                        visible:            commandCombo.currentText === "fw_gain_design"
                        model:              ["start", "stop", "excite"]
                        Layout.preferredWidth: ScreenTools.defaultFontPixelWidth * 12
                        sizeToContents:     false
                    }

                    QGCComboBox {
                        id:                 exciteAction
                        visible:            commandCombo.currentText === "fw_gain_design" && gainDesignAction.currentText === "excite"
                        model:              ["start", "stop"]
                        Layout.preferredWidth: ScreenTools.defaultFontPixelWidth * 12
                        sizeToContents:     false
                    }

                    QGCComboBox {
                        id:                 exciteAxis
                        visible:            commandCombo.currentText === "fw_gain_design" && gainDesignAction.currentText === "excite" && exciteAction.currentText === "start"
                        model:              ["roll", "pitch", "yaw"]
                        Layout.preferredWidth: ScreenTools.defaultFontPixelWidth * 10
                        sizeToContents:     false
                    }

                    Item { Layout.fillWidth: true }

                    QGCButton {
                        text:               qsTr("Send")
                        Layout.preferredWidth: ScreenTools.defaultFontPixelWidth * 12
                        onClicked: {
                            conController.sendCommand(guidedCommandPanel.commandText())
                            consoleColumn.scrollToBottom()
                        }
                    }
                }
            }

            property int _consoleOutputLen: 0

            function scrollToBottom() {
                var flickable = textConsole.flickableItem
                if (flickable.contentHeight > flickable.height)
                    flickable.contentY = flickable.contentHeight-flickable.height
            }
            function getCommand() {
                return textConsole.getText(_consoleOutputLen, textConsole.length)
            }
            function getCommandAndClear() {
                var command = getCommand()
                textConsole.remove(_consoleOutputLen, textConsole.length)
                return command
            }

            function pasteFromClipboard() {
                // we need to handle a few cases here:
                // in the general form we have: <command_pre><cursor><command_post>
                // and the clipboard may contain newlines
                var cursor = textConsole.cursorPosition - _consoleOutputLen
                var command = getCommandAndClear()
                var command_pre = ""
                var command_post = command
                if (cursor > 0) {
                    command_pre = command.substr(0, cursor)
                    command_post = command.substr(cursor)
                }
                var command_leftover = conController.handleClipboard(command_pre) + command_post
                textConsole.insert(textConsole.length, command_leftover)
                textConsole.cursorPosition = textConsole.length - command_post.length
            }

            Timer {
                id: updateTimer
                interval: 30
                running: false
                repeat: false
                onTriggered: {
                    // only update if scroll bar is at the bottom
                    if (textConsole.flickableItem.atYEnd) {
                        // backup & restore cursor & command
                        var command = getCommand()
                        var cursor = textConsole.cursorPosition - _consoleOutputLen
                        textConsole.text = conController.text
                        _consoleOutputLen = textConsole.length
                        textConsole.insert(textConsole.length, command)
                        textConsole.cursorPosition = textConsole.length
                        scrollToBottom()
                        if (cursor >= 0) {
                            // We could restore the selection here too...
                            textConsole.cursorPosition = _consoleOutputLen + cursor
                        }
                    } else {
                        updateTimer.start();
                    }
                }
            }

            TextArea {
                Component.onCompleted: {
                    isLoaded = true
                    _consoleOutputLen = textConsole.length
                    textConsole.cursorPosition = _consoleOutputLen
                    if (!_separateCommandInput)
                        textConsole.forceActiveFocus()
                }
                id:                      textConsole
                wrapMode:                Text.NoWrap
                Layout.preferredWidth:   parent.width
                Layout.fillHeight:       true
                readOnly:                _separateCommandInput
                frameVisible:            false
                textFormat:              TextEdit.RichText
                inputMethodHints:        Qt.ImhNoAutoUppercase | Qt.ImhMultiLine
                text:                    "> "
                focus:                   true

                menu: Menu {
                    id: contextMenu
                    MenuItem {
                        text: qsTr("Copy")
                        onTriggered: {
                            textConsole.copy()
                        }
                    }
                    MenuItem {
                        text: qsTr("Paste")
                        onTriggered: {
                            pasteFromClipboard()
                        }
                    }
                }

                style: TextAreaStyle {
                    textColor:          qgcPal.text
                    backgroundColor:    qgcPal.windowShade
                    selectedTextColor:  qgcPal.windowShade
                    selectionColor:     qgcPal.text
                    font.pointSize:     ScreenTools.defaultFontPointSize
                    font.family:        ScreenTools.fixedFontFamily
                }

                Keys.onPressed: {
                    if (event.key == Qt.Key_Tab) { // ignore tabs
                        event.accepted = true
                    }
                    if (event.matches(StandardKey.Cut)) {
                        // ignore for now
                        event.accepted = true
                    }

                    if (!event.matches(StandardKey.Copy) &&
                        event.key != Qt.Key_Escape &&
                        event.key != Qt.Key_Insert &&
                        event.key != Qt.Key_Pause &&
                        event.key != Qt.Key_Print &&
                        event.key != Qt.Key_SysReq &&
                        event.key != Qt.Key_Clear &&
                        event.key != Qt.Key_Home &&
                        event.key != Qt.Key_End &&
                        event.key != Qt.Key_Left &&
                        event.key != Qt.Key_Up &&
                        event.key != Qt.Key_Right &&
                        event.key != Qt.Key_Down &&
                        event.key != Qt.Key_PageUp &&
                        event.key != Qt.Key_PageDown &&
                        event.key != Qt.Key_Shift &&
                        event.key != Qt.Key_Control &&
                        event.key != Qt.Key_Meta &&
                        event.key != Qt.Key_Alt &&
                        event.key != Qt.Key_AltGr &&
                        event.key != Qt.Key_CapsLock &&
                        event.key != Qt.Key_NumLock &&
                        event.key != Qt.Key_ScrollLock &&
                        event.key != Qt.Key_Super_L &&
                        event.key != Qt.Key_Super_R &&
                        event.key != Qt.Key_Menu &&
                        event.key != Qt.Key_Hyper_L &&
                        event.key != Qt.Key_Hyper_R &&
                        event.key != Qt.Key_Direction_L &&
                        event.key != Qt.Key_Direction_R) {
                        // Note: dead keys do not generate keyPressed event on linux, see
                        // https://bugreports.qt.io/browse/QTBUG-79216

                        scrollToBottom()

                        // ensure cursor position is at an editable region
                        if (textConsole.selectionStart < _consoleOutputLen) {
                            textConsole.select(_consoleOutputLen, textConsole.selectionEnd)
                        }
                        if (textConsole.cursorPosition < _consoleOutputLen) {
                            textConsole.cursorPosition = textConsole.length
                        }
                    }

                    if (event.key == Qt.Key_Left) {
                        // don't move beyond current command
                        if (textConsole.cursorPosition == _consoleOutputLen) {
                            event.accepted = true
                        }
                    }
                    if (event.key == Qt.Key_Backspace) {
                        if (textConsole.cursorPosition <= _consoleOutputLen) {
                            event.accepted = true
                        }
                    }
                    if (event.key == Qt.Key_Enter || event.key == Qt.Key_Return) {
                        conController.sendCommand(getCommandAndClear())
                        event.accepted = true
                    }

                    if (event.matches(StandardKey.Paste)) {
                        pasteFromClipboard()
                        event.accepted = true
                    }

                    // command history
                    if (event.modifiers == Qt.NoModifier && event.key == Qt.Key_Up) {
                        var command = conController.historyUp(getCommandAndClear())
                        textConsole.insert(textConsole.length, command)
                        textConsole.cursorPosition = textConsole.length
                        event.accepted = true
                    } else if (event.modifiers == Qt.NoModifier && event.key == Qt.Key_Down) {
                        var command = conController.historyDown(getCommandAndClear())
                        textConsole.insert(textConsole.length, command)
                        textConsole.cursorPosition = textConsole.length
                        event.accepted = true
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.MiddleButton
                    onClicked: {
                        // disable middle-click pasting (we could add support for that if needed)
                    }
                    onWheel: {
                        // increase scrolling speed (the default is a single line)
                        var numLines = 4
                        var flickable = textConsole.flickableItem
                        var dy = wheel.angleDelta.y * numLines / 120 * textConsole.font.pixelSize
                        flickable.contentY = Math.max(0, Math.min(flickable.contentHeight - flickable.height, flickable.contentY - dy))
                        if (wheel.angleDelta.x != 0) {
                            var dx = wheel.angleDelta.x * numLines / 120 * textConsole.font.pixelSize
                            flickable.contentX = Math.max(0, Math.min(flickable.contentWidth - flickable.width, flickable.contentX - dx))
                        }
                        wheel.accepted = true
                    }
                }
            }

            RowLayout {
                Layout.fillWidth:   true
                visible:            _separateCommandInput
                QGCTextField {
                    id:               commandInput
                    Layout.fillWidth: true
                    placeholderText:  qsTr("Enter Commands here...")
                    inputMethodHints: Qt.ImhNoAutoUppercase

                    function sendCommand() {
                        conController.sendCommand(text)
                        text = ""
                        scrollToBottom()
                    }
                    onAccepted: sendCommand()
                }

                QGCButton {
                    id:        sendButton
                    text:      qsTr("Send")
                    onClicked: commandInput.sendCommand()
                }
            }
        }
    } // Component
} // AnalyzePage
