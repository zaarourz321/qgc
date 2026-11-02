import QtQuick          2.3
import QtQuick.Layouts  1.2

import QGroundControl               1.0
import QGroundControl.Controls      1.0
import QGroundControl.FactControls  1.0
import QGroundControl.FactSystem    1.0
import QGroundControl.ScreenTools   1.0

Item {
    id: root

    readonly property var twoLoopParameters: [
        "BW_RATIO_LAT", "K_GEN_PHI", "K_INT_PHI", "K_PRATE", "LACC_CNT_METH", "LAT_GAIN_METHOD"
    ]
    readonly property var threeLoopParameters: [
        "ACCEL_SOURCE", "ACC_CNT_METH", "ACT_BW", "ACT_SURFACE_LIM", "ACT_SURFACE_SPD", "BW_RATIO",
        "GAIN_METHOD", "K_ACC_DC", "K_INT_ACC_SPM", "K_INT_RATE", "K_RATE"
    ]

    FactPanelController { id: controller }

    Component {
        id: parameterEditor

        RowLayout {
            width: parameterList.width
            spacing: ScreenTools.defaultFontPixelWidth
            property Fact parameterFact: controller.getParameterFact(-1, modelData, false)

            QGCLabel {
                Layout.fillWidth: true
                text: modelData
            }
            Loader {
                Layout.preferredWidth: ScreenTools.defaultFontPixelWidth * 18
                property Fact parameterFact: parent.parameterFact
                sourceComponent: !parameterFact ? unavailable :
                                 parameterFact.enumStrings.length ? enumEditor : numericEditor
            }
        }
    }

    Component {
        id: enumEditor
        FactComboBox {
            fact: parent.parameterFact
            indexModel: false
            sizeToContents: true
        }
    }

    Component {
        id: numericEditor
        FactTextField {
            fact: parent.parameterFact
            showUnits: true
        }
    }

    Component {
        id: unavailable
        QGCLabel { text: qsTr("Not available") }
    }

    QGCFlickable {
        anchors.fill: parent
        contentWidth: width
        contentHeight: parameterList.height

        Column {
            id: parameterList
            width: parent.width
            spacing: ScreenTools.defaultFontPixelHeight

            QGCLabel {
                width: parent.width
                wrapMode: Text.WordWrap
                text: qsTr("Platform navigation controller parameters. Changes are sent to the connected vehicle.")
            }

            QGCLabel {
                text: qsTr("Two Loop Acc")
                font.bold: true
            }
            Repeater {
                model: root.twoLoopParameters
                delegate: parameterEditor
            }

            QGCLabel {
                text: qsTr("Three Loop Acc")
                font.bold: true
            }
            Repeater {
                model: root.threeLoopParameters
                delegate: parameterEditor
            }
        }
    }
}
