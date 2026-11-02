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

SetupPage {
    id:             tuningPage
    pageComponent:  pageComponent
    property bool   tuningUndocked: false

    Component {
        id: pageComponent

        Item {
            width:  availableWidth
            height: availableHeight

            PX4TuningComponentCopterAll {
                anchors.fill: parent
                visible:      !tuningPage.tuningUndocked
                undocked:     false
                onUndockRequested: {
                    tuningPage.tuningUndocked = true
                    mainWindow.createWindowedPIDTuningPage(qsTr("PID Tuning"), "qrc:/qml/PX4TuningComponentCopterAll.qml")
                }
            }
        }
    } // Component - pageComponent
} // SetupPage
