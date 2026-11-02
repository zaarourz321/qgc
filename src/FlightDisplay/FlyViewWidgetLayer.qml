/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick                  2.12
import QtQuick.Controls         2.4
import QtQuick.Dialogs          1.3
import QtQuick.Layouts          1.12

import QtLocation               5.3
import QtPositioning            5.3
import QtQuick.Window           2.2
import QtQml.Models             2.1

import QGroundControl               1.0
import QGroundControl.Controls      1.0
import QGroundControl.Controllers   1.0
import QGroundControl.Controls      1.0
import QGroundControl.FactSystem    1.0
import QGroundControl.FlightDisplay 1.0
import QGroundControl.FlightMap     1.0
import QGroundControl.Palette       1.0
import QGroundControl.ScreenTools   1.0
import QGroundControl.Vehicle       1.0

// This is the ui overlay layer for the widgets/tools for Fly View
Item {
    id: _root

    property var    parentToolInsets
    property var    totalToolInsets:        _totalToolInsets
    property var    mapControl

    property var    _activeVehicle:         QGroundControl.multiVehicleManager.activeVehicle
    property var    _planMasterController:  globals.planMasterControllerFlyView
    property var    _missionController:     _planMasterController.missionController
    property var    _geoFenceController:    _planMasterController.geoFenceController
    property var    _rallyPointController:  _planMasterController.rallyPointController
    property var    _guidedController:      globals.guidedControllerFlyView
    property real   _margins:               ScreenTools.defaultFontPixelWidth / 2
    property real   _toolsMargin:           ScreenTools.defaultFontPixelWidth * 0.75
    property rect   _centerViewport:        Qt.rect(0, 0, width, height)
    property real   _rightPanelWidth:       ScreenTools.defaultFontPixelWidth * 30
    property alias  _gripperMenu:           gripperOptions

    QGCToolInsets {
        id:                     _totalToolInsets
        leftEdgeTopInset:       toolStrip.leftEdgeTopInset
        leftEdgeCenterInset:    parentToolInsets.leftEdgeCenterInset
        leftEdgeBottomInset:    virtualJoystickMultiTouch.visible ? virtualJoystickMultiTouch.leftEdgeBottomInset : parentToolInsets.leftEdgeBottomInset
        rightEdgeTopInset:      instrumentPanel.rightEdgeTopInset
        rightEdgeCenterInset:   (telemetryPanel.rightEdgeCenterInset > photoVideoControl.rightEdgeCenterInset) ? telemetryPanel.rightEdgeCenterInset : photoVideoControl.rightEdgeCenterInset
        rightEdgeBottomInset:   virtualJoystickMultiTouch.visible ? virtualJoystickMultiTouch.rightEdgeBottomInset : parentToolInsets.rightEdgeBottomInset
        topEdgeLeftInset:       toolStrip.topEdgeLeftInset
        topEdgeCenterInset:     mapScale.topEdgeCenterInset
        topEdgeRightInset:      instrumentPanel.topEdgeRightInset
        bottomEdgeLeftInset:    virtualJoystickMultiTouch.visible ? virtualJoystickMultiTouch.bottomEdgeLeftInset : parentToolInsets.bottomEdgeLeftInset
        bottomEdgeCenterInset:  telemetryPanel.bottomEdgeCenterInset
        bottomEdgeRightInset:   virtualJoystickMultiTouch.visible ? virtualJoystickMultiTouch.bottomEdgeRightInset : parentToolInsets.bottomEdgeRightInset
    }

    FlyViewMissionCompleteDialog {
        missionController:      _missionController
        geoFenceController:     _geoFenceController
        rallyPointController:   _rallyPointController
    }

    Row {
        id:                 multiVehiclePanelSelector
        anchors.margins:    _toolsMargin
        anchors.top:        parent.top
        anchors.right:      parent.right
        width:              _rightPanelWidth
        spacing:            ScreenTools.defaultFontPixelWidth
        visible:            QGroundControl.multiVehicleManager.vehicles.count > 1 && QGroundControl.corePlugin.options.flyView.showMultiVehicleList

        property bool showSingleVehiclePanel:  !visible || singleVehicleRadio.checked

        QGCMapPalette { id: mapPal; lightColors: true }

        QGCRadioButton {
            id:             singleVehicleRadio
            text:           qsTr("Single")
            checked:        true
            textColor:      mapPal.text
        }

        QGCRadioButton {
            text:           qsTr("Multi-Vehicle")
            textColor:      mapPal.text
        }
    }

    MultiVehicleList {
        anchors.margins:    _toolsMargin
        anchors.top:        multiVehiclePanelSelector.bottom
        anchors.right:      parent.right
        width:              _rightPanelWidth
        height:             parent.height - y - _toolsMargin
        visible:            !multiVehiclePanelSelector.showSingleVehiclePanel
    }


    GuidedActionConfirm {
        anchors.margins:            _toolsMargin
        anchors.top:                parent.top
        anchors.horizontalCenter:   parent.horizontalCenter
        z:                          QGroundControl.zOrderTopMost
        guidedController:           _guidedController
        guidedValueSlider:          _guidedValueSlider
    }

    FlyViewInstrumentPanel {
        id:                         instrumentPanel
        anchors.margins:            _toolsMargin
        anchors.top:                multiVehiclePanelSelector.visible ? multiVehiclePanelSelector.bottom : parent.top
        anchors.right:              parent.right
        width:                      _rightPanelWidth
        spacing:                    _toolsMargin
        visible:                    QGroundControl.corePlugin.options.flyView.showInstrumentPanel && multiVehiclePanelSelector.showSingleVehiclePanel
        availableHeight:            parent.height - y - _toolsMargin

        property real rightEdgeTopInset: visible ? parent.width - x : 0
        property real topEdgeRightInset: visible ? y + height : 0
    }

    PhotoVideoControl {
        id:                     photoVideoControl
        anchors.margins:        _toolsMargin
        anchors.right:          parent.right
        width:                  _rightPanelWidth

        property real rightEdgeCenterInset: visible ? parent.width - x : 0

        state:                  _verticalCenter ? "verticalCenter" : "topAnchor"
        states: [
            State {
                name: "verticalCenter"
                AnchorChanges {
                    target:                 photoVideoControl
                    anchors.top:            undefined
                    anchors.verticalCenter: _root.verticalCenter
                }
            },
            State {
                name: "topAnchor"
                AnchorChanges {
                    target:                 photoVideoControl
                    anchors.verticalCenter: undefined
                    anchors.top:            instrumentPanel.bottom
                }
            }
        ]

        property bool _verticalCenter: !QGroundControl.settingsManager.flyViewSettings.alternateInstrumentPanel.rawValue
    }

    TelemetryValuesBar {
        id:                 telemetryPanel
        x:                  recalcXPosition()
        anchors.margins:    _toolsMargin

        property real bottomEdgeCenterInset: 0
        property real rightEdgeCenterInset: 0

        // States for custom layout support
        states: [
            State {
                name: "bottom"
                when: telemetryPanel.bottomMode

                AnchorChanges {
                    target: telemetryPanel
                    anchors.top: undefined
                    anchors.bottom: parent.bottom
                    anchors.right: undefined
                    anchors.verticalCenter: undefined
                }

                PropertyChanges {
                    target: telemetryPanel
                    x: recalcXPosition()
                    bottomEdgeCenterInset: visible ? parent.height-y : 0
                    rightEdgeCenterInset: 0
                }
            },

            State {
                name: "right-video"
                when: !telemetryPanel.bottomMode && photoVideoControl.visible

                AnchorChanges {
                    target: telemetryPanel
                    anchors.top: photoVideoControl.bottom
                    anchors.bottom: undefined
                    anchors.right: parent.right
                    anchors.verticalCenter: undefined
                }
                PropertyChanges {
                    target: telemetryPanel
                    bottomEdgeCenterInset: 0
                    rightEdgeCenterInset: visible ? parent.width - x : 0
                }
            },

            State {
                name: "right-novideo"
                when: !telemetryPanel.bottomMode && !photoVideoControl.visible

                AnchorChanges {
                    target: telemetryPanel
                    anchors.top: undefined
                    anchors.bottom: undefined
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                }
                PropertyChanges {
                    target: telemetryPanel
                    bottomEdgeCenterInset: 0
                    rightEdgeCenterInset: visible ? parent.width - x : 0
                }
            }
        ]

        function recalcXPosition() {
            // First try centered
            var halfRootWidth   = _root.width / 2
            var halfPanelWidth  = telemetryPanel.width / 2
            var leftX           = (halfRootWidth - halfPanelWidth) - _toolsMargin
            var rightX          = (halfRootWidth + halfPanelWidth) + _toolsMargin
            if (leftX >= parentToolInsets.leftEdgeBottomInset || rightX <= parentToolInsets.rightEdgeBottomInset ) {
                // It will fit in the horizontalCenter
                return halfRootWidth - halfPanelWidth
            } else {
                // Anchor to left edge
                return parentToolInsets.leftEdgeBottomInset + _toolsMargin
            }
        }
    }

    Loader {
        id: gpslessNavParameterController
        active: !!_activeVehicle
        sourceComponent: Component {
            FactPanelController { }
        }
    }

    Rectangle {
        id: gpslessNavControlPanel
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: diveControls.top
        anchors.bottomMargin: _toolsMargin
        width: ScreenTools.defaultFontPixelWidth * 54
        height: content.implicitHeight + ScreenTools.defaultFontPixelHeight * 2
        radius: ScreenTools.defaultFontPixelHeight * 0.5
        color: controlPalette.window
        border.color: controlPalette.buttonText
        border.width: 1
        z: QGroundControl.zOrderTopMost
        visible: _activeVehicle && _activeVehicle.fixedWing && _activeVehicle.flightMode === qsTr("GPS-less NAV")

        property bool _parametersReady: QGroundControl.multiVehicleManager.parameterReadyVehicleAvailable
        property Fact altitudeFact: _parametersReady && gpslessNavParameterController.item ? gpslessNavParameterController.item.getParameterFact(-1, "FW_GPSNAV_ALT", false) : null
        property Fact altitudeModeFact: _parametersReady && gpslessNavParameterController.item ? gpslessNavParameterController.item.getParameterFact(-1, "FW_GPSNAV_ALTMOD", false) : null
        property Fact headingFact: _parametersReady && gpslessNavParameterController.item ? gpslessNavParameterController.item.getParameterFact(-1, "FW_GPSNAV_HDG", false) : null
        property Fact airspeedFact: _parametersReady && gpslessNavParameterController.item ? gpslessNavParameterController.item.getParameterFact(-1, "FW_GPSNAV_ASPD", false) : null
        property Fact airspeedMinFact: _parametersReady && gpslessNavParameterController.item ? gpslessNavParameterController.item.getParameterFact(-1, "FW_AIRSPD_MIN", false) : null
        property Fact airspeedMaxFact: _parametersReady && gpslessNavParameterController.item ? gpslessNavParameterController.item.getParameterFact(-1, "FW_AIRSPD_MAX", false) : null
        property real airspeedMinimum: airspeedMinFact ? Number(airspeedMinFact.value) : 5
        property real airspeedMaximum: airspeedMaxFact ? Number(airspeedMaxFact.value) : 50

        function setAltitudeSetpoint(value) {
            if (!altitudeFact || !altitudeModeFact || !isFinite(value)) {
                return
            }
            altitudeModeFact.value = 1
            altitudeFact.value = Math.max(-1000, Math.min(10000, value))
        }

        function setHeadingSetpoint(value) {
            if (headingFact && isFinite(value)) {
                headingFact.value = Math.max(-180, Math.min(180, Math.round(value)))
            }
        }

        function setAirspeedSetpoint(value) {
            if (airspeedFact && isFinite(value)) {
                airspeedFact.value = Math.max(airspeedMinimum, Math.min(airspeedMaximum, value))
            }
        }

        QGCPalette {
            id: controlPalette
            colorGroupEnabled: gpslessNavControlPanel.enabled
        }

        ColumnLayout {
            id: content
            anchors.fill: parent
            anchors.margins: ScreenTools.defaultFontPixelWidth
            spacing: ScreenTools.defaultFontPixelHeight * 0.5

            QGCLabel {
                Layout.fillWidth: true
                text: qsTr("GPS-less Navigation")
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: ScreenTools.defaultFontPixelWidth

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: ScreenTools.defaultFontPixelHeight * 0.25

                    QGCLabel { text: qsTr("Altitude setpoint (AMSL)") }

                    RowLayout {
                        Layout.fillWidth: true

                        QGCSlider {
                            id: altitudeSlider
                            Layout.fillWidth: true
                            minimumValue: -1000
                            maximumValue: 10000
                            stepSize: 1
                            value: gpslessNavControlPanel.altitudeFact ? Number(gpslessNavControlPanel.altitudeFact.value) : 0
                            onValueChanged: if (pressed) gpslessNavControlPanel.setAltitudeSetpoint(value)
                        }

                        QGCTextField {
                            id: altitudeInput
                            Layout.preferredWidth: ScreenTools.defaultFontPixelWidth * 9
                            numericValuesOnly: true
                            text: gpslessNavControlPanel.altitudeFact ? Number(gpslessNavControlPanel.altitudeFact.value).toFixed(1) : ""
                            onEditingFinished: gpslessNavControlPanel.setAltitudeSetpoint(Number(text))
                        }

                        QGCLabel { text: qsTr("m") }
                    }
                }

                Rectangle {
                    Layout.preferredWidth: 1
                    Layout.fillHeight: true
                    color: controlPalette.buttonText
                }

                ColumnLayout {
                    Layout.preferredWidth: ScreenTools.defaultFontPixelWidth * 13
                    spacing: 0

                    QGCLabel {
                        Layout.fillWidth: true
                        text: qsTr("Heading")
                        horizontalAlignment: Text.AlignHCenter
                    }

                    Item {
                        id: headingCompass
                        Layout.alignment: Qt.AlignHCenter
                        Layout.preferredWidth: ScreenTools.defaultFontPixelWidth * 12
                        Layout.preferredHeight: Layout.preferredWidth

                        property real headingDegrees: gpslessNavControlPanel.headingFact ? Number(gpslessNavControlPanel.headingFact.value) : 0

                        function bearingFromPoint(x, y) {
                            // atan2(x, -y) makes 0 degrees point North and angles
                            // increase clockwise: East=90, South=180, West=-90.
                            return Math.atan2(x - width / 2, -(y - height / 2)) * 180 / Math.PI
                        }

                        function setHeadingFromPoint(x, y) {
                            gpslessNavControlPanel.setHeadingSetpoint(Math.round(bearingFromPoint(x, y)))
                        }

                        Canvas {
                            id: compassCanvas
                            anchors.fill: parent
                            antialiasing: true

                            onPaint: {
                                var ctx = getContext("2d")
                                var centerX = width / 2
                                var centerY = height / 2
                                var radius = Math.min(width, height) / 2 - 2
                                var bearing = ((headingCompass.headingDegrees % 360) + 360) % 360
                                var radians = bearing * Math.PI / 180

                                ctx.clearRect(0, 0, width, height)
                                ctx.beginPath()
                                ctx.arc(centerX, centerY, radius, 0, Math.PI * 2)
                                ctx.fillStyle = controlPalette.button
                                ctx.fill()
                                ctx.lineWidth = 1
                                ctx.strokeStyle = controlPalette.buttonText
                                ctx.stroke()

                                ctx.fillStyle = controlPalette.buttonText
                                ctx.font = Math.max(10, radius * 0.24) + "px sans-serif"
                                ctx.textAlign = "center"
                                ctx.textBaseline = "middle"
                                var labelRadius = radius * 0.76
                                ctx.fillText("N", centerX, centerY - labelRadius)
                                ctx.fillText("E", centerX + labelRadius, centerY)
                                ctx.fillText("S", centerX, centerY + labelRadius)
                                ctx.fillText("W", centerX - labelRadius, centerY)

                                var arrowLength = radius * 0.64
                                var arrowX = centerX + Math.sin(radians) * arrowLength
                                var arrowY = centerY - Math.cos(radians) * arrowLength
                                var sideAngle = radians + Math.PI * 0.72
                                var otherSideAngle = radians - Math.PI * 0.72
                                var headLength = radius * 0.25

                                ctx.strokeStyle = "#f28c28"
                                ctx.fillStyle = "#f28c28"
                                ctx.lineWidth = Math.max(2, radius * 0.08)
                                ctx.lineCap = "round"
                                ctx.beginPath()
                                ctx.moveTo(centerX, centerY)
                                ctx.lineTo(arrowX, arrowY)
                                ctx.stroke()
                                ctx.beginPath()
                                ctx.moveTo(arrowX, arrowY)
                                ctx.lineTo(arrowX + Math.sin(sideAngle) * headLength, arrowY - Math.cos(sideAngle) * headLength)
                                ctx.lineTo(arrowX + Math.sin(otherSideAngle) * headLength, arrowY - Math.cos(otherSideAngle) * headLength)
                                ctx.closePath()
                                ctx.fill()
                                ctx.beginPath()
                                ctx.arc(centerX, centerY, Math.max(3, radius * 0.09), 0, Math.PI * 2)
                                ctx.fill()
                            }

                            onWidthChanged: requestPaint()
                            onHeightChanged: requestPaint()
                        }

                        onHeadingDegreesChanged: compassCanvas.requestPaint()
                        Component.onCompleted: compassCanvas.requestPaint()

                        MouseArea {
                            anchors.fill: parent
                            onPressed: headingCompass.setHeadingFromPoint(mouse.x, mouse.y)
                            onPositionChanged: if (pressed) headingCompass.setHeadingFromPoint(mouse.x, mouse.y)
                        }
                    }

                    QGCLabel {
                        Layout.fillWidth: true
                        text: (((headingCompass.headingDegrees % 360) + 360) % 360).toFixed(0) + qsTr("°")
                        horizontalAlignment: Text.AlignHCenter
                    }
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: ScreenTools.defaultFontPixelHeight * 0.25

                QGCLabel { text: qsTr("Airspeed setpoint") }

                RowLayout {
                    Layout.fillWidth: true

                    QGCSlider {
                        id: airspeedSlider
                        Layout.fillWidth: true
                        minimumValue: gpslessNavControlPanel.airspeedMinimum
                        maximumValue: Math.max(gpslessNavControlPanel.airspeedMinimum + 0.1, gpslessNavControlPanel.airspeedMaximum)
                        stepSize: 0.1
                        value: gpslessNavControlPanel.airspeedFact ? Math.max(minimumValue, Math.min(maximumValue, Number(gpslessNavControlPanel.airspeedFact.value))) : minimumValue
                        onValueChanged: if (pressed) gpslessNavControlPanel.setAirspeedSetpoint(value)
                    }

                    QGCTextField {
                        id: airspeedInput
                        Layout.preferredWidth: ScreenTools.defaultFontPixelWidth * 9
                        numericValuesOnly: true
                        text: gpslessNavControlPanel.airspeedFact ? Number(gpslessNavControlPanel.airspeedFact.value).toFixed(1) : ""
                        onEditingFinished: gpslessNavControlPanel.setAirspeedSetpoint(Number(text))
                    }

                    QGCLabel { text: qsTr("m/s") }
                }
            }
        }
    }

    Row {
        id:                         diveControls
        anchors.horizontalCenter:   parent.horizontalCenter
        anchors.bottom:             telemetryPanel.bottomMode ? telemetryPanel.top : parent.bottom
        anchors.bottomMargin:       _toolsMargin
        spacing:                    ScreenTools.defaultFontPixelWidth
        z:                          QGroundControl.zOrderTopMost

        Rectangle {
            id:                         diveHold
            width:                      ScreenTools.defaultFontPixelWidth * 27
            height:                     ScreenTools.implicitButtonHeight * 1.35
            radius:                     height / 2
            color:                      "#23465A"
            border.color:               "#5FA9D0"
            property bool holding:      false
            property double progress:   0
            property double holdStarted: 0
            opacity:                    _activeVehicle && _activeVehicle.flightModeSetAvailable ? 1 : 0.45
            visible:                    !QGroundControl.videoManager.fullScreen
            QGCLabel {
                anchors.centerIn:       parent
                color:                  "white"
                font.bold:              true
                font.pointSize:         ScreenTools.largeFontPointSize
                text:                   diveHold.holding ? qsTr("HOLDING %1%").arg(Math.round(diveHold.progress * 100)) : qsTr("HOLD 2s TO DIVE")
            }
            Canvas {
                anchors.fill:           parent
                antialiasing:           true
                property double progress: diveHold.progress
                onProgressChanged: requestPaint()
                onPaint: {
                    var context = getContext("2d")
                    context.reset()
                    var inset = 2
                    var radius = (height - inset * 2) / 2
                    var straight = Math.max(0, width - inset * 2 - radius * 2)
                    var perimeter = 2 * straight + 2 * Math.PI * radius
                    context.lineWidth = 3
                    context.strokeStyle = "#65D5FF"
                    var remaining = perimeter * progress
                    function line(x1, y1, x2, y2) {
                        var length = Math.sqrt(Math.pow(x2 - x1, 2) + Math.pow(y2 - y1, 2))
                        var fraction = length > 0 ? Math.min(1, remaining / length) : 0
                        if (fraction > 0) { context.beginPath(); context.moveTo(x1, y1); context.lineTo(x1 + (x2 - x1) * fraction, y1 + (y2 - y1) * fraction); context.stroke() }
                        remaining -= length * fraction
                    }
                    function arc(cx, cy, start, end) {
                        var length = radius * Math.abs(end - start)
                        var fraction = length > 0 ? Math.min(1, remaining / length) : 0
                        if (fraction > 0) { context.beginPath(); context.arc(cx, cy, radius, start, start + (end - start) * fraction, false); context.stroke() }
                        remaining -= length * fraction
                    }
                    line(inset + radius, inset, width - inset - radius, inset)
                    arc(width - inset - radius, inset + radius, -Math.PI / 2, Math.PI / 2)
                    line(width - inset - radius, height - inset, inset + radius, height - inset)
                    arc(inset + radius, inset + radius, Math.PI / 2, Math.PI * 1.5)
                }
            }
            Timer {
                interval:                30
                running:                 diveHold.holding
                repeat:                  true
                onTriggered: {
                    diveHold.progress = Math.min(1, (Date.now() - diveHold.holdStarted) / 2000)
                    if (diveHold.progress >= 1) {
                        diveHold.holding = false
                        _activeVehicle.flightMode = "Hunter"
                        diveHold.progress = 0
                    }
                }
            }
            MouseArea {
                anchors.fill:           parent
                enabled:                _activeVehicle && _activeVehicle.flightModeSetAvailable
                onPressed: { diveHold.holdStarted = Date.now(); diveHold.progress = 0; diveHold.holding = true }
                onReleased: { diveHold.holding = false; diveHold.progress = 0 }
                onCanceled: { diveHold.holding = false; diveHold.progress = 0 }
            }
        }

        QGCButton {
            id:                         abortButton
            text:                       qsTr("ABORT")
            backRadius:                 ScreenTools.defaultFontPixelHeight * 0.7
            pointSize:                  ScreenTools.largeFontPointSize
            enabled:                    _activeVehicle && _activeVehicle.flightModeSetAvailable
            visible:                    !QGroundControl.videoManager.fullScreen
            onClicked: {
                if (_activeVehicle && _activeVehicle.flightModeSetAvailable) {
                    _activeVehicle.flightMode = "Mission"
                }
            }
        }
    }

    // Uses the uploaded termination-point mission item. The aircraft-side
    // failsafe owns the same point when communication is no longer available.
    QGCButton {
        id:                         abortMissionButton
        anchors.right:              parent.right
        anchors.bottom:             parent.bottom
        anchors.rightMargin:        _toolsMargin
        anchors.bottomMargin:       _toolsMargin
        z:                          QGroundControl.zOrderTopMost
        text:                       qsTr("ABORT MISSION")
        backRadius:                 ScreenTools.defaultFontPixelHeight * 0.7
        pointSize:                  ScreenTools.largeFontPointSize
        visible:                    !QGroundControl.videoManager.fullScreen
        enabled:                    _activeVehicle && _activeVehicle.flightModeSetAvailable && _terminationPointSequence() >= 0
        onClicked: {
            var sequence = _terminationPointSequence()
            if (sequence >= 0 && _activeVehicle) {
                _activeVehicle.setCurrentMissionSequence(sequence)
                _activeVehicle.flightMode = "Mission"
            }
        }
    }

    function _terminationPointSequence() {
        if (!_missionController || !_missionController.visualItems) {
            return -1
        }
        for (var i = 0; i < _missionController.visualItems.count; ++i) {
            var item = _missionController.visualItems.get(i)
            if (item && item.command === 31021) {
                return item.sequenceNumber
            }
        }
        return -1
    }

    //-- Virtual Joystick
    Loader {
        id:                         virtualJoystickMultiTouch
        z:                          QGroundControl.zOrderTopMost + 1
        width:                      parent.width  - (_pipOverlay.width / 2)
        height:                     Math.min(parent.height * 0.25, ScreenTools.defaultFontPixelWidth * 16)
        visible:                    _virtualJoystickEnabled && !QGroundControl.videoManager.fullScreen && !(_activeVehicle ? _activeVehicle.usingHighLatencyLink : false)
        anchors.bottom:             parent.bottom
        anchors.bottomMargin:       parentToolInsets.leftEdgeBottomInset + ScreenTools.defaultFontPixelHeight * 2
        anchors.horizontalCenter:   parent.horizontalCenter
        source:                     "qrc:/qml/VirtualJoystick.qml"
        active:                     _virtualJoystickEnabled && !(_activeVehicle ? _activeVehicle.usingHighLatencyLink : false)

        property bool autoCenterThrottle: QGroundControl.settingsManager.appSettings.virtualJoystickAutoCenterThrottle.rawValue

        property bool _virtualJoystickEnabled: QGroundControl.settingsManager.appSettings.virtualJoystick.rawValue

        property real bottomEdgeLeftInset: parent.height-y
        property real bottomEdgeRightInset: parent.height-y

        // Width is difficult to access directly hence this hack which may not work in all circumstances
        property real leftEdgeBottomInset: visible ? bottomEdgeLeftInset + width/18 - ScreenTools.defaultFontPixelHeight*2 : 0
        property real rightEdgeBottomInset: visible ? bottomEdgeRightInset + width/18 - ScreenTools.defaultFontPixelHeight*2 : 0
    }

    FlyViewToolStrip {
        id:                     toolStrip
        anchors.leftMargin:     _toolsMargin + parentToolInsets.leftEdgeCenterInset
        anchors.topMargin:      _toolsMargin + parentToolInsets.topEdgeLeftInset
        anchors.left:           parent.left
        anchors.top:            parent.top
        z:                      QGroundControl.zOrderWidgets
        maxHeight:              parent.height - y - parentToolInsets.bottomEdgeLeftInset - _toolsMargin
        visible:                !QGroundControl.videoManager.fullScreen

        onDisplayPreFlightChecklist: preFlightChecklistPopup.createObject(mainWindow).open()


        property real topEdgeLeftInset: visible ? y + height : 0
        property real leftEdgeTopInset: visible ? x + width : 0
    }

    GripperMenu {
        id: gripperOptions
    }

    VehicleWarnings {
        anchors.centerIn:   parent
        z:                  QGroundControl.zOrderTopMost
    }

    MapScale {
        id:                 mapScale
        anchors.margins:    _toolsMargin
        anchors.left:       toolStrip.right
        anchors.top:        parent.top
        mapControl:         _mapControl
        buttonsOnLeft:      false
        visible:            !ScreenTools.isTinyScreen && QGroundControl.corePlugin.options.flyView.showMapScale && mapControl.pipState.state === mapControl.pipState.fullState

        property real topEdgeCenterInset: visible ? y + height : 0
    }

    Component {
        id: preFlightChecklistPopup
        FlyViewPreFlightChecklistPopup {
        }
    }
}
