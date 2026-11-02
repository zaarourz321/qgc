/****************************************************************************
 * Hunter serial-port selector
 ****************************************************************************/

import QtQuick          2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts  1.11

import QGroundControl               1.0
import QGroundControl.Controls      1.0
import QGroundControl.Palette       1.0
import QGroundControl.ScreenTools   1.0

Item {
    id: root

    width: selectorLabel.width
    visible: ScreenTools.isSerialAvailable

    property var _portNames: []
    property var _portPaths: []
    property var _menuItems: []
    property string selectedPort: ""
    property int selectedBaud: 115200

    function refreshMenu() {
        QGroundControl.linkManager.refreshSerialPorts()
        _portNames = QGroundControl.linkManager.serialPortStrings
        _portPaths = QGroundControl.linkManager.serialPorts

        if (_portPaths.length) {
            var selectedIndex = _portPaths.indexOf(root.selectedPort)
            portCombo.currentIndex = selectedIndex >= 0 ? selectedIndex : 0
        }
        var baudIndex = baudCombo.find(root.selectedBaud.toString())
        baudCombo.currentIndex = baudIndex >= 0 ? baudIndex : 0
    }

    QGCPalette { id: qgcPal }

    QGCLabel {
        id: selectorLabel
        anchors.verticalCenter: parent.verticalCenter
        color: qgcPal.buttonText
        font.pointSize: ScreenTools.mediumFontPointSize
        text: root.selectedPort.length ? qsTr("SERIAL: %1 @ %2").arg(root.selectedPort).arg(root.selectedBaud) : qsTr("SERIAL: CONNECT")

        MouseArea {
            anchors.fill: parent
            onClicked: {
                root.refreshMenu()
                serialPortPopup.open()
            }
        }
    }

    Popup {
        id:             serialPortPopup
        parent:         mainWindow.contentItem
        width:          Math.max(ScreenTools.defaultFontPixelWidth * 32, 300)
        padding:        ScreenTools.defaultFontPixelWidth
        modal:          false
        focus:          true
        closePolicy:    Popup.CloseOnEscape | Popup.CloseOnPressOutside

        onOpened: {
            var pos = mainWindow.contentItem.mapFromItem(root, 0, root.height)
            x = Math.max(ScreenTools.defaultFontPixelWidth, Math.min(pos.x, mainWindow.contentItem.width - width - ScreenTools.defaultFontPixelWidth))
            y = pos.y + ScreenTools.defaultFontPixelHeight * 0.25
        }

        background: Rectangle {
            radius:      ScreenTools.defaultFontPixelWidth * 0.5
            color:       qgcPal.window
            border.width: 1
            border.color: qgcPal.colorOrange
        }

        contentItem: ColumnLayout {
            spacing: ScreenTools.defaultFontPixelHeight * 0.6

            QGCLabel {
                text:           qsTr("Serial Connection")
                color:          qgcPal.colorOrange
                font.bold:      true
                font.pointSize: ScreenTools.mediumFontPointSize
            }

            QGCLabel {
                text: qsTr("Port")
            }
            QGCComboBox {
                id:                 portCombo
                Layout.fillWidth:   true
                model:              root._portNames
                sizeToContents:     false
            }

            QGCLabel {
                text: qsTr("Baud rate")
            }
            QGCComboBox {
                id:                 baudCombo
                Layout.fillWidth:   true
                model:              QGroundControl.linkManager.serialBaudRates
                sizeToContents:     false
            }

            RowLayout {
                Layout.fillWidth: true
                QGCButton {
                    text:               qsTr("Connect")
                    Layout.fillWidth:   true
                    enabled:            portCombo.currentIndex >= 0 && root._portPaths.length > portCombo.currentIndex
                    onClicked: {
                        var port = root._portPaths[portCombo.currentIndex]
                        var baud = parseInt(baudCombo.currentText)
                        if (QGroundControl.linkManager.connectSerialPort(port, baud)) {
                            root.selectedPort = root._portNames[portCombo.currentIndex]
                            root.selectedBaud = baud
                            serialPortPopup.close()
                        }
                    }
                }
                QGCButton {
                    text:               qsTr("Disconnect")
                    Layout.fillWidth:   true
                    onClicked: {
                        QGroundControl.linkManager.disconnectSerialPort()
                        root.selectedPort = ""
                        serialPortPopup.close()
                    }
                }
            }
        }
    }
}
