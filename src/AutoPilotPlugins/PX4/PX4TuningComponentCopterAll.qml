/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick          2.3
import QtQuick.Controls 1.2
import QtQuick.Layouts  1.2

import QGroundControl               1.0
import QGroundControl.Controls      1.0
import QGroundControl.FactSystem    1.0
import QGroundControl.ScreenTools   1.0

Item {
    id:                               root
    width:                            parent ? parent.width : 0
    property bool _autotuningEnabled: true // used to restore setting when switching between tabs
    property bool undocked: false
    property var floatingWindow: null
    signal undockRequested()

    FactPanelController {
        id:         controller
    }

    QGCTabBar {
        id:             bar
        width:          parent.width - undockButton.width - ScreenTools.defaultFontPixelWidth
        anchors.top:    parent.top
        QGCTabButton {
            width:      implicitWidth
            text:       qsTr("Rate Controller")
        }
        QGCTabButton {
            width:      implicitWidth
            text:       qsTr("Attitude Controller")
        }
        QGCTabButton {
            width:      implicitWidth
            text:       qsTr("Velocity Controller")
        }
        QGCTabButton {
            width:      implicitWidth
            text:       qsTr("Position Controller")
        }
        QGCTabButton {
            width:      implicitWidth
            text:       qsTr("Platform Navigation Telemetry")
        }
        onCurrentIndexChanged: {
            if (typeof loader.item.autotuningEnabled !== "undefined") {
                _autotuningEnabled = loader.item.autotuningEnabled;
            }
        }
    }

    QGCButton {
        id:                 undockButton
        anchors.right:      parent.right
        anchors.verticalCenter: bar.verticalCenter
        text:               root.undocked ? qsTr("Close") : qsTr("Undock")
        onClicked: {
            if (root.undocked && root.floatingWindow) {
                root.floatingWindow.close()
            } else {
                root.undockRequested()
            }
        }
    }

    property var pages:  [
        "PX4TuningComponentCopterRate.qml",
        "PX4TuningComponentCopterAttitude.qml",
        "PX4TuningComponentCopterVelocity.qml",
        "PX4TuningComponentCopterPosition.qml",
        "PX4TuningComponentPlatformNavigation.qml"
    ]

    Loader {
        id:                loader
        source:            pages[bar.currentIndex]
        width:             parent.width
        anchors.top:       bar.bottom
        anchors.topMargin: ScreenTools.defaultFontPixelWidth
        anchors.bottom:    parent.bottom
        onLoaded: {
            if (typeof loader.item.autotuningEnabled !== "undefined") {
                loader.item.autotuningEnabled = _autotuningEnabled;
            }
        }
    }
}
