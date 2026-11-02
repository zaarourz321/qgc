/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick          2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts  1.11
import QtQuick.Dialogs  1.3

import QGroundControl                       1.0
import QGroundControl.Controls              1.0
import QGroundControl.Palette               1.0
import QGroundControl.MultiVehicleManager   1.0
import QGroundControl.ScreenTools           1.0
import QGroundControl.Controllers           1.0

Rectangle {
    id:     _root
    color:  qgcPal.toolbarBackground

    property int currentToolbar: flyViewToolbar

    readonly property int flyViewToolbar:   0
    readonly property int planViewToolbar:  1
    readonly property int simpleToolbar:    2

    property var    _activeVehicle:     QGroundControl.multiVehicleManager.activeVehicle
    property bool   _communicationLost: _activeVehicle ? _activeVehicle.vehicleLinkManager.communicationLost : false
    property color  _mainStatusBGColor: qgcPal.brandingPurple

    function dropMessageIndicatorTool() {
        if (currentToolbar === flyViewToolbar) {
            indicatorLoader.item.dropMessageIndicatorTool();
        }
    }

    QGCPalette { id: qgcPal }

    /// Bottom single pixel divider
    Rectangle {
        anchors.left:   parent.left
        anchors.right:  parent.right
        anchors.bottom: parent.bottom
        height:         1
        color:          qgcPal.windowShadeLight
        visible:        true
    }

    Rectangle {
        anchors.fill:   viewButtonRow
        visible:        currentToolbar === flyViewToolbar

        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0;                                     color: _mainStatusBGColor }
            GradientStop { position: currentButton.x + currentButton.width; color: _mainStatusBGColor }
            GradientStop { position: 1;                                     color: _root.color }
        }
    }

    RowLayout {
        id:                     viewButtonRow
        anchors.bottomMargin:   1
        anchors.top:            parent.top
        anchors.bottom:         parent.bottom
        spacing:                ScreenTools.defaultFontPixelWidth / 2

        QGCToolBarButton {
            id:                     currentButton
            Layout.preferredHeight: viewButtonRow.height
            icon.source:            "/res/QGCLogoFull"
            logo:                   true
            onClicked:              mainWindow.showToolSelectDialog()
        }

        MainStatusIndicator {
            Layout.preferredHeight: viewButtonRow.height
            visible:                currentToolbar === flyViewToolbar
        }
        QGCToolBarButton {
            Layout.preferredHeight: viewButtonRow.height
            icon.source:            "qrc:/qmlimages/MavlinkConsoleIcon"
            onClicked:              mainWindow.showMavlinkConsole()
        }

        QGCToolBarButton {
            Layout.preferredHeight: viewButtonRow.height
            icon.source:            "qrc:/InstrumentValueIcons/tuning.svg"
            onClicked:              mainWindow.showPIDTuning()
        }

        QGCToolBarButton {
            Layout.preferredHeight: viewButtonRow.height
            icon.source:            "qrc:/InstrumentValueIcons/cog.svg"
            onClicked:              mainWindow.showParameters()
        }

        QGCButton {
            id:                     emsadButton
            Layout.preferredHeight: viewButtonRow.height * 0.76
            Layout.preferredWidth:  ScreenTools.defaultFontPixelWidth * 8.5
            text:                   qsTr("EMSAD")
            font.bold:              true
            visible:                currentToolbar === flyViewToolbar && _activeVehicle && _activeVehicle.emsadTelemetryAvailable
            onClicked: emsadPopup.open()
            background: Rectangle {
                radius: 5
                border.width: 1
                border.color: emsadButton.down ? "#ffb347" : "#c46d1a"
                gradient: Gradient {
                    GradientStop { position: 0; color: emsadButton.down ? "#b85c10" : "#442a18" }
                    GradientStop { position: 1; color: emsadButton.down ? "#7c3508" : "#241b16" }
                }
            }
        }

        Rectangle {
            width:                  ScreenTools.defaultFontPixelWidth * 0.9
            height:                 width
            radius:                 width / 2
            visible:                currentToolbar === flyViewToolbar && _activeVehicle && _activeVehicle.emsadTelemetryAvailable
            color:                  !_activeVehicle || !_activeVehicle.emsadTelemetryAvailable ? "#36b56b" :
                                    _activeVehicle.emsadFsmState === 1 ? "#f4d03f" :
                                    _activeVehicle.emsadFsmState === 2 ? "#f39c12" :
                                    _activeVehicle.emsadFsmState === 3 ? "#d64541" : "#36b56b"
            border.color:           "#151515"
            border.width:           1
            Layout.leftMargin:      -ScreenTools.defaultFontPixelWidth * 1.45
            Layout.rightMargin:     ScreenTools.defaultFontPixelWidth * 0.5
            Layout.alignment:       Qt.AlignVCenter
            z:                      2
        }
        QGCButton {
            id:                 disconnectButton
            text:               qsTr("Disconnect")
            onClicked:          _activeVehicle.closeVehicle()
            visible:            _activeVehicle && _communicationLost && currentToolbar === flyViewToolbar
        }
    }

    Popup {
        id:                         emsadPopup
        parent:                     _root
        x:                          emsadButton.x
        y:                          emsadButton.height + ScreenTools.defaultFontPixelHeight * 0.3
        width:                      ScreenTools.defaultFontPixelWidth * 37
        padding:                    ScreenTools.defaultFontPixelWidth
        modal:                      false
        closePolicy:                Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
        background: Rectangle {
            color: qgcPal.window
            border.color: qgcPal.windowShade
            radius: ScreenTools.defaultFontPixelWidth * 0.5
        }

        function stateText() {
            if (!_activeVehicle || !_activeVehicle.emsadTelemetryAvailable) return qsTr("No EMSAD telemetry")
            switch (_activeVehicle.emsadFsmState) {
            case 0: return qsTr("Idle")
            case 1: return qsTr("Wait for arm")
            case 2: return qsTr("Armed")
            case 3: return qsTr("Charged")
            case 4: return qsTr("Shoot")
            default: return qsTr("Unknown (%1)").arg(_activeVehicle.emsadFsmState)
            }
        }

        function statusFlagsText() {
            if (!_activeVehicle || !_activeVehicle.emsadTelemetryAvailable) return "—"

            var flags = _activeVehicle.emsadFlags & 0xff
            var bits = flags.toString(2)
            while (bits.length < 8) bits = "0" + bits
            return flags.toString() + "  ·  0b" + bits.substring(0, 4) + "'" + bits.substring(4, 8)
        }

        ColumnLayout {
            width: parent.width
            spacing: ScreenTools.defaultFontPixelHeight * 0.45

            QGCLabel { text: qsTr("EMSAD status"); font.bold: true; font.pointSize: ScreenTools.largeFontPointSize }
            QGCLabel { text: emsadPopup.stateText() }
            Rectangle { Layout.fillWidth: true; height: 1; color: qgcPal.windowShade }
            QGCLabel { text: qsTr("Capacitor: %1 V").arg(_activeVehicle && _activeVehicle.emsadTelemetryAvailable ? _activeVehicle.emsadCapacitorVolt.toFixed(2) : "—") }
            QGCLabel { text: qsTr("Pressure: %1").arg(_activeVehicle && _activeVehicle.emsadTelemetryAvailable ? _activeVehicle.emsadPressure.toFixed(2) : "—") }
            QGCLabel { text: qsTr("Pressure differential: %1").arg(_activeVehicle && _activeVehicle.emsadTelemetryAvailable ? _activeVehicle.emsadPressureDiff.toFixed(2) : "—") }
            QGCLabel { text: qsTr("Status flags: %1").arg(emsadPopup.statusFlagsText()) }
            QGCLabel { text: qsTr("Charge trigger: %1").arg(_activeVehicle && (_activeVehicle.emsadFlags & 1) ? qsTr("set") : qsTr("clear")) }
            QGCLabel { text: qsTr("Armed: %1").arg(_activeVehicle && (_activeVehicle.emsadFlags & 2) ? qsTr("set") : qsTr("clear")) }
            QGCLabel { text: qsTr("Accelerometer threshold: %1").arg(_activeVehicle && (_activeVehicle.emsadFlags & 4) ? qsTr("set") : qsTr("clear")) }
            QGCLabel { text: qsTr("Barometer threshold: %1").arg(_activeVehicle && (_activeVehicle.emsadFlags & 8) ? qsTr("set") : qsTr("clear")) }
            QGCLabel { text: qsTr("Umbilical detach: %1").arg(_activeVehicle && (_activeVehicle.emsadFlags & 16) ? qsTr("set") : qsTr("clear")) }
            QGCLabel { text: qsTr("Servo switch: %1").arg(_activeVehicle && (_activeVehicle.emsadFlags & 32) ? qsTr("set") : qsTr("clear")) }
            QGCLabel { text: qsTr("Capacitor failure: %1").arg(_activeVehicle && (_activeVehicle.emsadFlags & 64) ? qsTr("set") : qsTr("clear")) }
            QGCButton {
                text: qsTr("ARM")
                Layout.alignment: Qt.AlignRight
                onClicked: { emsadPopup.close(); emsadArmConfirm.open() }
            }
        }
    }

    Popup {
        id:                         emsadArmConfirm
        parent:                     _root
        anchors.centerIn:           parent
        width:                      ScreenTools.defaultFontPixelWidth * 42
        padding:                    ScreenTools.defaultFontPixelWidth * 1.5
        modal:                      true
        closePolicy:                Popup.CloseOnEscape | Popup.CloseOnPressOutside
        property int heldMillis:    0
        background: Rectangle { color: "#3b1717"; border.color: "#e74c3c"; border.width: 2; radius: 6 }

        Timer {
            id: holdArmTimer
            interval: 50
            repeat: true
            onTriggered: {
                emsadArmConfirm.heldMillis += interval
                if (emsadArmConfirm.heldMillis >= 5000) {
                    stop()
                    emsadArmConfirm.heldMillis = 0
                    if (_activeVehicle) _activeVehicle.armEmsad()
                    emsadArmConfirm.close()
                }
            }
        }
        ColumnLayout {
            width: parent.width
            QGCLabel { Layout.fillWidth: true; horizontalAlignment: Text.AlignHCenter; color: "#ff6b6b"; font.bold: true; font.pointSize: ScreenTools.largeFontPointSize; text: qsTr("ARM EMSAD") }
            QGCLabel { Layout.fillWidth: true; wrapMode: Text.WordWrap; horizontalAlignment: Text.AlignHCenter; text: qsTr("Are you sure? Hold ARM continuously for 5 seconds to set EMSAD_ARM to 1 and send ‘emsad_arm arm’. Releasing cancels the action.") }
            QGCButton {
                text: emsadArmConfirm.heldMillis > 0 ? qsTr("ARM %1%").arg(Math.floor(emsadArmConfirm.heldMillis / 50)) : qsTr("HOLD TO ARM")
                Layout.fillWidth: true
                onPressed: { emsadArmConfirm.heldMillis = 0; holdArmTimer.start() }
                onReleased: { if (holdArmTimer.running) { holdArmTimer.stop(); emsadArmConfirm.heldMillis = 0 } }
                background: Rectangle { color: "#c0392b"; radius: 4 }
            }
            QGCButton { text: qsTr("Cancel"); Layout.alignment: Qt.AlignHCenter; onClicked: emsadArmConfirm.close() }
        }
        onClosed: { holdArmTimer.stop(); heldMillis = 0 }
    }

    QGCFlickable {
        id:                     toolsFlickable
        anchors.leftMargin:     ScreenTools.defaultFontPixelWidth * ScreenTools.largeFontPointRatio * 1.5
        anchors.left:           viewButtonRow.right
        anchors.bottomMargin:   1
        anchors.top:            parent.top
        anchors.bottom:         parent.bottom
        anchors.right:          parent.right
        contentWidth:           indicatorLoader.x + indicatorLoader.width
        flickableDirection:     Flickable.HorizontalFlick

        Loader {
            id:                 indicatorLoader
            anchors.left:       parent.left
            anchors.top:        parent.top
            anchors.bottom:     parent.bottom
            source:             currentToolbar === flyViewToolbar ?
                                    "qrc:/toolbar/MainToolBarIndicators.qml" :
                                    (currentToolbar == planViewToolbar ? "qrc:/qml/PlanToolBarIndicators.qml" : "")
        }
    }

    //-------------------------------------------------------------------------
    //-- Branding Logo
    Image {
        anchors.right:          parent.right
        anchors.top:            parent.top
        anchors.bottom:         parent.bottom
        // Give the vehicle brand mark most of the toolbar height. The artwork
        // uses a wide aspect ratio, so reducing this inset makes it legible.
        anchors.margins:        ScreenTools.defaultFontPixelHeight * 0.12
        visible:                currentToolbar !== planViewToolbar && _activeVehicle && !_communicationLost && x > (toolsFlickable.x + toolsFlickable.contentWidth + ScreenTools.defaultFontPixelWidth)
        fillMode:               Image.PreserveAspectFit
        source:                 _outdoorPalette ? _brandImageOutdoor : _brandImageIndoor
        mipmap:                 true

        property bool   _outdoorPalette:        qgcPal.globalTheme === QGCPalette.Light
        property bool   _corePluginBranding:    QGroundControl.corePlugin.brandImageIndoor.length != 0
        property string _userBrandImageIndoor:  QGroundControl.settingsManager.brandImageSettings.userBrandImageIndoor.value
        property string _userBrandImageOutdoor: QGroundControl.settingsManager.brandImageSettings.userBrandImageOutdoor.value
        property bool   _userBrandingIndoor:    _userBrandImageIndoor.length != 0
        property bool   _userBrandingOutdoor:   _userBrandImageOutdoor.length != 0
        property string _brandImageIndoor:      brandImageIndoor()
        property string _brandImageOutdoor:     brandImageOutdoor()

        function brandImageIndoor() {
            if (_userBrandingIndoor) {
                return _userBrandImageIndoor
            } else {
                if (_userBrandingOutdoor) {
                    return _userBrandingOutdoor
                } else {
                    if (_corePluginBranding) {
                        return QGroundControl.corePlugin.brandImageIndoor
                    } else {
                        return _activeVehicle ? _activeVehicle.brandImageIndoor : ""
                    }
                }
            }
        }

        function brandImageOutdoor() {
            if (_userBrandingOutdoor) {
                return _userBrandingOutdoor
            } else {
                if (_userBrandingIndoor) {
                    return _userBrandingIndoor
                } else {
                    if (_corePluginBranding) {
                        return QGroundControl.corePlugin.brandImageOutdoor
                    } else {
                        return _activeVehicle ? _activeVehicle.brandImageOutdoor : ""
                    }
                }
            }
        }
    }

    // Small parameter download progress bar
    Rectangle {
        anchors.bottom: parent.bottom
        height:         _root.height * 0.05
        width:          _activeVehicle ? _activeVehicle.loadProgress * parent.width : 0
        color:          qgcPal.colorGreen
        visible:        !largeProgressBar.visible
    }

    // Large parameter download progress bar
    Rectangle {
        id:             largeProgressBar
        anchors.bottom: parent.bottom
        anchors.left:   parent.left
        anchors.right:  parent.right
        height:         parent.height
        color:          qgcPal.window
        visible:        _showLargeProgress

        property bool _initialDownloadComplete: _activeVehicle ? _activeVehicle.initialConnectComplete : true
        property bool _userHide:                false
        property bool _showLargeProgress:       !_initialDownloadComplete && !_userHide && qgcPal.globalTheme === QGCPalette.Light

        Connections {
            target:                 QGroundControl.multiVehicleManager
            function onActiveVehicleChanged(activeVehicle) { largeProgressBar._userHide = false }
        }

        Rectangle {
            anchors.top:    parent.top
            anchors.bottom: parent.bottom
            width:          _activeVehicle ? _activeVehicle.loadProgress * parent.width : 0
            color:          qgcPal.colorGreen
        }

        QGCLabel {
            anchors.centerIn:   parent
            text:               qsTr("Downloading")
            font.pointSize:     ScreenTools.largeFontPointSize
        }

        QGCLabel {
            anchors.margins:    _margin
            anchors.right:      parent.right
            anchors.bottom:     parent.bottom
            text:               qsTr("Click anywhere to hide")

            property real _margin: ScreenTools.defaultFontPixelWidth / 2
        }

        MouseArea {
            anchors.fill:   parent
            onClicked:      largeProgressBar._userHide = true
        }
    }
}
