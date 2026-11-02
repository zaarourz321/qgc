import QtQuick 2.11
import QtQuick.Layouts 1.2
import QtCharts 2.2
import QGroundControl 1.0
import QGroundControl.Controls 1.0
import QGroundControl.ScreenTools 1.0

ColumnLayout {
    id: root
    spacing: ScreenTools.defaultFontPixelHeight / 2
    property var vehicle: QGroundControl.multiVehicleManager.activeVehicle
    property int currentTab: 0
    property bool followLive: true
    property bool autoScale: true
    property bool dirty: true
    property bool ready: false
    property double epoch: -1
    property double lastHunterMs: -1
    property double lastRollMs: -1
    property double nowMs: 0
    property int diveFlag: -1
    property int hitFlag: -1
    property double hitCounter: -1
    property double errorMeters: NaN
    property bool trackingLastWaypoint: false
    property var samples: []
    property var rolls: []
    property var frozenSamples: []
    property var frozenRolls: []
    readonly property int maxSamples: 5000
    readonly property double historySeconds: 50
    readonly property bool receiving: lastHunterMs >= 0 && nowMs - lastHunterMs < 2000
    readonly property bool rollReceiving: lastRollMs >= 0 && nowMs - lastRollMs < 2000
    readonly property var plots: [
        {title: qsTr("Acceleration Z"), a: "accz_cmd", b: "accz_meas", an: "Acc Z Cmd", bn: "Acc Z Meas", unit: "m/s²"},
        {title: qsTr("Error"), a: "error", b: "", an: "Error", bn: "", unit: qsTr("Error")},
        {title: qsTr("Acceleration Y"), a: "accy_cmd", b: "accy_meas", an: "Acc Y Cmd", bn: "Acc Y Meas", unit: "m/s²"},
        {title: qsTr("Roll"), a: "roll_sp", b: "roll", an: "Roll Setpoint", bn: "Roll Measured (ATTITUDE)", unit: "deg"},
        {title: qsTr("Hit & Hit Counter"), a: "arrived", b: "counter", an: "Hit (left)", bn: "Hit Counter (right)", unit: qsTr("Hit")},
        {title: qsTr("Q"), a: "q_cmd", b: "q_meas", an: "Q Cmd", bn: "Q Meas", unit: "rad/s"}
    ]
    readonly property bool showCharts: currentTab < plots.length
    readonly property var spec: showCharts ? plots[currentTab] : plots[0]
    readonly property bool dualAxis: currentTab === 4

    function lastMissionWaypoint() {
        var controller = globals.planMasterControllerPlanView || globals.planMasterControllerFlyView
        if (!controller || !controller.missionController || !controller.missionController.visualItems) return null
        var items = controller.missionController.visualItems
        for (var index = items.count - 1; index >= 0; --index) {
            var item = items.get(index)
            if (item && item.specifiesCoordinate && !item.isStandaloneCoordinate && item.coordinate && item.coordinate.isValid) return item
        }
        return null
    }
    function startTrackingLastWaypoint() {
        var waypoint = lastMissionWaypoint()
        if (!vehicle || !waypoint) return
        vehicle.setCurrentMissionSequence(waypoint.lastSequenceNumber)
        trackingLastWaypoint = true
    }
    function startDive() {
        if (vehicle && vehicle.flightModeSetAvailable) vehicle.flightMode = "Hunter"
    }
    function abortDive() {
        if (vehicle && vehicle.flightModeSetAvailable) vehicle.flightMode = "Mission"
    }


    function clearHistory() {
        samples = []; rolls = []; frozenSamples = []; frozenRolls = []
        epoch = -1; lastHunterMs = -1; lastRollMs = -1
        diveFlag = -1; hitFlag = -1; hitCounter = -1; errorMeters = NaN
        followLive = true; autoScale = true; dirty = true
        if (ready) {
            firstSeries.clear(); secondSeries.clear(); counterSeries.clear()
            xAxis.min = 0; xAxis.max = 10
            yAxis.min = -1; yAxis.max = 1
            counterAxis.min = 0; counterAxis.max = 1
        }
    }
    function trim(history, seconds) {
        var count = 0
        while (count < history.length && history[count].t < seconds - historySeconds) ++count
        count = Math.max(count, history.length - maxSamples)
        if (count > 0) history.splice(0, count)
    }
    function ingest(data, isRoll) {
        var now = new Date().getTime()
        if (epoch < 0) epoch = now
        nowMs = now
        var seconds = (now - epoch) / 1000
        if (isRoll) {
            if (!isFinite(data.roll)) return
            lastRollMs = now
            rolls.push({t: seconds, values: data})
            trim(rolls, seconds)
        } else {
            lastHunterMs = now
            diveFlag = data.start_flag
            hitFlag = data.arrived
            hitCounter = data.counter
            errorMeters = data.error
            samples.push({t: seconds, values: data})
            trim(samples, seconds)
        }
        if (followLive) dirty = true
    }
    function freeze() {
        if (followLive) {
            frozenSamples = samples.slice(0)
            frozenRolls = rolls.slice(0)
            followLive = false
        }
    }
    function goLive() {
        followLive = true; autoScale = true
        frozenSamples = []; frozenRolls = []
        xAxis.min = 0; xAxis.max = 10
        dirty = true
        renderPlot()
    }
    function zoom(factor, fx, fy, zoomX, zoomY) {
        freeze(); autoScale = false
        if (zoomX === undefined || zoomX) {
            var span = xAxis.max - xAxis.min
            var newSpan = Math.max(0.1, Math.min(historySeconds, span * factor))
            var anchor = xAxis.min + span * fx
            xAxis.min = Math.max(0, anchor - newSpan * fx)
            xAxis.max = xAxis.min + newSpan
        }
        if (zoomY === undefined || zoomY) {
            root.zoomY(yAxis, factor, fy)
            root.zoomY(counterAxis, factor, fy)
        }
        dirty = true
    }
    function zoomY(axis, factor, fy) {
        var span = axis.max - axis.min
        var newSpan = Math.max(0.00001, Math.min(1e8, span * factor))
        var anchor = axis.min + span * fy
        axis.min = anchor - newSpan * fy
        axis.max = axis.min + newSpan
    }
    function pan(dx, dy) {
        freeze(); autoScale = false
        var span = xAxis.max - xAxis.min
        xAxis.min = Math.max(0, xAxis.min - dx * span)
        xAxis.max = xAxis.min + span
        var shift = dy * (yAxis.max - yAxis.min)
        yAxis.min += shift; yAxis.max += shift
        if (dualAxis) {
            shift = dy * (counterAxis.max - counterAxis.min)
            counterAxis.min += shift; counterAxis.max += shift
        }
        dirty = true
    }
    function fitView() {
        freeze()
        var times = frozenSamples.concat(frozenRolls)
        var low = Infinity, high = -Infinity
        for (var i=0; i<times.length; ++i) { low = Math.min(low,times[i].t); high = Math.max(high,times[i].t) }
        xAxis.min = isFinite(low) ? low : 0
        xAxis.max = isFinite(high) ? Math.max(xAxis.min + 0.1, high) : 10
        autoScale = true; dirty = true
    }
    function boxZoom(x1, y1, x2, y2, width, height) {
        if (Math.abs(x2-x1) < 6 || Math.abs(y2-y1) < 6 || width <= 0 || height <= 0) return
        freeze(); autoScale = false
        var xmin = xAxis.min + (Math.min(x1,x2) / width) * (xAxis.max-xAxis.min)
        var xmax = xAxis.min + (Math.max(x1,x2) / width) * (xAxis.max-xAxis.min)
        var ymax = yAxis.max - (Math.min(y1,y2) / height) * (yAxis.max-yAxis.min)
        var ymin = yAxis.max - (Math.max(y1,y2) / height) * (yAxis.max-yAxis.min)
        xAxis.min = xmin; xAxis.max = Math.max(xmin + 0.001, xmax)
        yAxis.min = ymin; yAxis.max = Math.max(ymin + 0.001, ymax)
        dirty = true
    }
    // Reduce each time bucket to its first/last and extrema. Spikes survive
    // downsampling while QtCharts receives a bounded number of points.
    function points(history, field) {
        if (!field) return []
        var visible = [], previous = null
        for (var i=0; i<history.length; ++i) {
            var row = history[i], value = row.values[field]
            if (typeof value !== "number" || !isFinite(value)) continue
            if (currentTab === 3 && (field === "roll" || field === "roll_sp")) value = value * 180 / Math.PI
            var point = {x: row.t, y: value}
            if (row.t < xAxis.min) { previous = point; continue }
            if (row.t > xAxis.max) { if (visible.length) visible.push(point); break }
            if (!visible.length && previous) visible.push(previous)
            visible.push(point)
        }
        if (visible.length <= 240) return visible
        var result = [], size = Math.ceil(visible.length / 60)
        for (var start=0; start<visible.length; start+=size) {
            var end = Math.min(visible.length - 1, start + size - 1), lo = start, hi = start
            for (var j=start+1; j<=end; ++j) {
                if (visible[j].y < visible[lo].y) lo = j
                if (visible[j].y > visible[hi].y) hi = j
            }
            var indices = [start,lo,hi,end].sort(function(a,b) { return a-b })
            var last = -1
            for (var k=0; k<indices.length; ++k) {
                if (indices[k] !== last) result.push(visible[indices[k]])
                last = indices[k]
            }
        }
        return result
    }
    function fillSeries(series, data, stepped) {
        series.clear()
        for (var i=0; i<data.length; ++i) {
            if (stepped && i > 0) series.append(data[i].x, data[i-1].y)
            series.append(data[i].x, data[i].y)
        }
    }
    function fitY(axis, data) {
        var low = Infinity, high = -Infinity
        for (var i=0; i<data.length; ++i) {
            if (data[i].x < xAxis.min || data[i].x > xAxis.max) continue
            low = Math.min(low,data[i].y); high = Math.max(high,data[i].y)
        }
        if (!isFinite(low)) { axis.min = -1; axis.max = 1; return }
        var margin = Math.max(0.05, (high-low)*0.1)
        axis.min = low-margin; axis.max = high+margin
    }
    function renderPlot() {
        if (!ready || !dirty) return
        dirty = false
        var history = followLive ? samples : frozenSamples
        var attitude = followLive ? rolls : frozenRolls
        if (followLive) {
            var latest = history.length ? history[history.length-1].t : 0
            if (currentTab === 3 && attitude.length) latest = Math.max(latest,attitude[attitude.length-1].t)
            xAxis.max = Math.max(10,latest)
            xAxis.min = Math.max(0,xAxis.max-historySeconds)
        }
        var a = points(history,spec.a)
        var b = points(currentTab === 3 ? attitude : history,spec.b)
        fillSeries(firstSeries,a,dualAxis)
        fillSeries(secondSeries,dualAxis ? [] : b,false)
        fillSeries(counterSeries,dualAxis ? b : [],false)
        fillSeries(diveSeries,points(history,"start_flag"),true)
        fillSeries(hitSeries,points(history,"arrived"),true)
        if (autoScale) {
            fitY(yAxis,dualAxis ? a : a.concat(b))
            if (dualAxis) fitY(counterAxis,b)
        }
    }

    onVehicleChanged: clearHistory()
    onCurrentTabChanged: { autoScale = true; dirty = true }
    Component.onCompleted: { ready = true; renderPlot() }
    Connections {
        target: root.vehicle
        function onPlatformNavigationTelemetryReceived(telemetry) { root.ingest(telemetry,false) }
        function onPlatformNavigationRollReceived(rollRadians) { root.ingest({roll: rollRadians},true) }
    }
    Timer {
        interval: 250; running: root.visible && root.showCharts; repeat: true
        onTriggered: { root.nowMs = new Date().getTime(); root.renderPlot() }
    }
    QGCTabBar {
        Layout.fillWidth: true
        currentIndex: root.currentTab
        onCurrentIndexChanged: root.currentTab = currentIndex
        QGCTabButton { text: qsTr("Acc Z") }
        QGCTabButton { text: qsTr("Error") }
        QGCTabButton { text: qsTr("Acc Y") }
        QGCTabButton { text: qsTr("Roll") }
        QGCTabButton { text: qsTr("Hit / Hit Counter") }
        QGCTabButton { text: qsTr("Q") }
        QGCTabButton { text: qsTr("Tuning") }
    }
    RowLayout {
        Layout.fillWidth: true
        visible: root.showCharts
        Rectangle {
            Layout.preferredWidth: flagText.implicitWidth + 24
            Layout.preferredHeight: flagText.implicitHeight + 14
            radius: 5
            color: !root.receiving ? "#53616D" : root.diveFlag === 1 ? "#147D46" : "#8A5700"
            QGCLabel {
                id: flagText; anchors.centerIn: parent; color: "white"
                font.bold: true
                text: !root.receiving ? qsTr("Dive flag: — (stale)") : qsTr("Dive flag: %1").arg(root.diveFlag)
            }
        }
        Rectangle {
            Layout.preferredWidth: hitText.implicitWidth + 24
            Layout.preferredHeight: hitText.implicitHeight + 14
            radius: 5
            color: !root.receiving ? "#53616D" : root.hitFlag === 1 ? "#147D46" : "#8A5700"
            QGCLabel {
                id: hitText
                anchors.centerIn: parent
                color: "white"
                font.bold: true
                text: !root.receiving ? qsTr("Hit: — (stale)") : qsTr("Hit: %1").arg(root.hitFlag)
            }
        }
        Rectangle {
            Layout.preferredWidth: hitCounterText.implicitWidth + 24
            Layout.preferredHeight: hitCounterText.implicitHeight + 14
            radius: 5
            color: !root.receiving ? "#53616D" : "#1E5F85"
            QGCLabel {
                id: hitCounterText
                anchors.centerIn: parent
                color: "white"
                font.bold: true
                text: !root.receiving ? qsTr("Hit counter: — (stale)") : qsTr("Hit counter: %1").arg(root.hitCounter)
            }
        }
        Rectangle {
            Layout.preferredWidth: errorText.implicitWidth + 24
            Layout.preferredHeight: errorText.implicitHeight + 14
            radius: 5
            color: !root.receiving ? "#53616D" : !isFinite(root.errorMeters) ? "#53616D" : root.errorMeters < 1 ? "#147D46" : root.errorMeters <= 3 ? "#A57500" : "#A52A2A"
            QGCLabel {
                id: errorText
                anchors.centerIn: parent
                color: "white"
                font.bold: true
                text: !root.receiving || !isFinite(root.errorMeters) ? qsTr("Error: — (stale)") : qsTr("Error: %1 m").arg(root.errorMeters.toFixed(2))
            }
        }
        QGCLabel {
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
            text: !root.vehicle ? qsTr("No vehicle connected") :
                  !root.followLive ? qsTr("Reviewing frozen history • telemetry still buffering") :
                  !root.receiving ? qsTr("Waiting for platform telemetry") :
                  root.currentTab === 3 && !root.rollReceiving ? qsTr("Waiting for ATTITUDE roll") :
                  root.trackingLastWaypoint ? qsTr("Final mission waypoint is the current destination") : qsTr("Live telemetry")
        }
    }
    Flow {
        Layout.fillWidth: true
        spacing: 6
        visible: root.showCharts
        QGCButton { text: root.followLive ? qsTr("Pause") : qsTr("Live"); onClicked: { if(root.followLive) root.freeze(); else root.goLive() } }
        QGCButton {
            text: qsTr("Start")
            enabled: root.vehicle && root.lastMissionWaypoint() !== null
            onClicked: root.startTrackingLastWaypoint()
        }
        Rectangle {
            id: diveHold
            Layout.preferredWidth: ScreenTools.defaultFontPixelWidth * 20
            Layout.preferredHeight: ScreenTools.implicitButtonHeight * 1.35
            radius: height / 2
            color: "#23465A"
            border.color: "#5FA9D0"
            property bool holding: false
            property double progress: 0
            property double holdStarted: 0
            opacity: root.vehicle && root.vehicle.flightModeSetAvailable ? 1 : 0.45
            QGCLabel {
                anchors.centerIn: parent
                color: "white"
                font.bold: true
                text: diveHold.holding ? qsTr("HOLDING %1%").arg(Math.round(diveHold.progress * 100)) : qsTr("HOLD 2s TO DIVE")
            }
            Canvas {
                anchors.fill: parent
                antialiasing: true
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
                interval: 30
                running: diveHold.holding
                repeat: true
                onTriggered: {
                    diveHold.progress = Math.min(1, (Date.now() - diveHold.holdStarted) / 2000)
                    if (diveHold.progress >= 1) {
                        diveHold.holding = false
                        root.startDive()
                        diveHold.progress = 0
                    }
                }
            }
            MouseArea {
                anchors.fill: parent
                enabled: root.vehicle && root.vehicle.flightModeSetAvailable
                onPressed: { diveHold.holdStarted = Date.now(); diveHold.progress = 0; diveHold.holding = true }
                onReleased: { diveHold.holding = false; diveHold.progress = 0 }
                onCanceled: { diveHold.holding = false; diveHold.progress = 0 }
            }
        }
        QGCButton {
            text: qsTr("Abort")
            backRadius: ScreenTools.defaultFontPixelHeight / 2
            enabled: root.vehicle && root.vehicle.flightModeSetAvailable
            onClicked: root.abortDive()
        }
        QGCButton { text: qsTr("Zoom +"); onClicked: root.zoom(0.8,0.5,0.5,true,true) }
        QGCButton { text: qsTr("Zoom −"); onClicked: root.zoom(1.25,0.5,0.5,true,true) }
        QGCButton { text: qsTr("X +"); onClicked: root.zoom(0.8,0.5,0.5,true,false) }
        QGCButton { text: qsTr("X −"); onClicked: root.zoom(1.25,0.5,0.5,true,false) }
        QGCButton { text: qsTr("Y +"); onClicked: root.zoom(0.8,0.5,0.5,false,true) }
        QGCButton { text: qsTr("Y −"); onClicked: root.zoom(1.25,0.5,0.5,false,true) }
        QGCButton { text: qsTr("Fit history"); onClicked: root.fitView() }
        QGCButton { text: qsTr("Clear"); onClicked: root.clearHistory() }
    }
    ChartView {
        id: chart; objectName: "navigationChart"
        Layout.fillWidth: true; Layout.fillHeight: true
        visible: root.showCharts
        Layout.minimumHeight: ScreenTools.defaultFontPixelHeight * 12
        title: root.spec.title
        antialiasing: false
        animationOptions: ChartView.NoAnimation
        legend.alignment: Qt.AlignBottom
        ValueAxis { id: xAxis; min: 0; max: 10; titleText: qsTr("Time (s)"); labelFormat: "%.1f"; tickCount: 6 }
        ValueAxis { id: yAxis; min: -1; max: 1; titleText: root.spec.unit; labelFormat: "%.3g"; tickCount: 6 }
        ValueAxis { id: counterAxis; min: 0; max: 1; visible: true; titleText: root.dualAxis ? qsTr("Flags / Counter") : qsTr("Dive / Hit"); labelFormat: "%.3g"; tickCount: 6 }
        LineSeries { id: firstSeries; name: root.spec.an; color: "#0072B2"; width: 2; axisX: xAxis; axisY: yAxis; pointsVisible: count === 1 }
        LineSeries {
            id: secondSeries; name: root.spec.bn; visible: root.spec.b !== "" && !root.dualAxis
            color: "#D55E00"; width: 2; axisX: xAxis
            axisY: yAxis
            pointsVisible: count === 1
        }
        LineSeries {
            id: counterSeries; name: qsTr("Hit Counter"); visible: root.dualAxis
            color: "#D55E00"; width: 2; axisX: xAxis; axisYRight: counterAxis
            pointsVisible: count === 1
        }
        LineSeries { id: diveSeries; name: qsTr("Dive Flag"); color: "#00BFC4"; width: 2; axisX: xAxis; axisYRight: counterAxis; pointsVisible: count === 1 }
        LineSeries { id: hitSeries; name: qsTr("Hit"); color: "#CC79A7"; width: 2; axisX: xAxis; axisYRight: counterAxis; pointsVisible: count === 1 }
        MouseArea {
            x: chart.plotArea.x; y: chart.plotArea.y
            width: chart.plotArea.width; height: chart.plotArea.height
            property real lastX: 0
            property real lastY: 0
            property real startX: 0
            property real startY: 0
            property bool boxMode: false
            cursorShape: pressed ? Qt.ClosedHandCursor : Qt.OpenHandCursor
            onPressed: { lastX = startX = mouse.x; lastY = startY = mouse.y; boxMode = (mouse.modifiers & Qt.ControlModifier) !== 0; root.freeze() }
            onPositionChanged: {
                if (pressed && !boxMode && width > 0 && height > 0) {
                    root.pan((mouse.x-lastX)/width,(mouse.y-lastY)/height)
                    lastX = mouse.x; lastY = mouse.y
                }
            }
            onWheel: {
                if (width > 0 && height > 0) {
                    var factor = wheel.angleDelta.y > 0 ? 0.8 : 1.25
                    if (wheel.modifiers & Qt.ShiftModifier) root.zoom(factor,wheel.x/width,1-wheel.y/height,true,false)
                    else if (wheel.modifiers & Qt.ControlModifier) root.zoom(factor,wheel.x/width,1-wheel.y/height,false,true)
                    else root.zoom(factor,wheel.x/width,1-wheel.y/height,true,true)
                }
                wheel.accepted = true
            }
            onReleased: { if (boxMode) root.boxZoom(startX,startY,mouse.x,mouse.y,width,height) }
            onDoubleClicked: root.goLive()
        }
    }
    QGCLabel {
        Layout.fillWidth: true; wrapMode: Text.WordWrap
        visible: root.showCharts
        text: qsTr("Wheel: zoom both axes • Shift+wheel: horizontal • Ctrl+wheel: vertical • Drag: pan • Ctrl+drag: box zoom • Double-click / Live: follow latest • History: 50 s / 5000 samples per stream • rendered at 4 Hz")
        font.pointSize: ScreenTools.smallFontPointSize
    }
    Loader {
        Layout.fillWidth: true
        Layout.fillHeight: true
        active: root.currentTab === 6
        source: active ? "qrc:/qml/PX4TuningComponentPlatformNavigationTuning.qml" : ""
    }
}
