import QtQuick 2.12
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.12
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.plasma.core 2.0 as PlasmaCore

GridLayout {
    id: fullView
    readonly property var alignmentOpts: [
        {   
            "flow": GridLayout.LeftToRight,
            "columns": -1,
            "rows": 2,//1
            "layoutDirection": Qt.LeftToRight,
            "track": {
                "horizontalAlignment": Text.AlignLeft,
                "alignment": Qt.AlignLeft,
                "elide": Text.ElideRight
            },
            "title": {
                "horizontalAlignment": Text.AlignRight,
                "alignment": Qt.AlignRight,
            },
            "separator": {
                "fillWidth": false,
                "fillHeight": true,
                "width": 2,
                "height": 2
            }
        },{
            "flow": GridLayout.LeftToRight,
            "columns": -1,
            "rows": 2,//1
            "layoutDirection": Qt.RightToLeft,
            "track": {
                "horizontalAlignment": Text.AlignRight,
                "alignment": Qt.AlignRight,
                "elide": Text.ElideRight
            },
            "title": {
                "horizontalAlignment": Text.AlignLeft,
                "alignment": Qt.AlignLeft,
            },
            "separator": {
                "fillWidth": false,
                "fillHeight": true,
                "width": 2,
                "height": 2,
            }
        }
    ]
    readonly property var alignmentOption: alignmentOpts[plasmoid.configuration.alignment]
    rows: alignmentOption.rows
    flow: alignmentOption.flow
    columns: alignmentOption.columns
   property string colorOpt: plasmoid.configuration.color ? plasmoid.configuration.color : "red"
    // layoutDirection: alignmentOption.layoutDirection
    Rectangle {
        width: 10
    }
    MouseArea {
        id: mediaControlsMouseArea
        Layout.preferredWidth: Math.max(playerName.width, nowPlayingLabel1.width, nowPlayingLabel2.width)
        hoverEnabled: true
        ColumnLayout {
            anchors.centerIn: parent
            id: nowPlayingColumn
            PlasmaComponents.Label {
                id: playerName
                Layout.alignment: Qt.AlignHCenter
                Layout.minimumWidth: 10
                Layout.maximumWidth: 150
                Layout.fillWidth: true
                horizontalAlignment: alignmentOption.track.horizontalAlignment
                text: mediaSource.playerName
                lineHeight: 1 //
                font.pixelSize: 18
                font.bold: true
                wrapMode: Text.Wrap
                maximumLineCount: 3
                // elide: alignmentOption.track.elide
                font.family: plasmoid.configuration.fontFamily
                // color: "red"
                color: colorOpt
            }
            Rectangle {
                height: 20
            }
            PlasmaComponents.Label {
                id: nowPlayingLabel1
                Layout.alignment: alignmentOption.title.alignment 
                text: mediaSource.playbackStatus
                        === "Playing" ? "NOW" : "LAST"
                lineHeight: 1 //
                font.pixelSize: 24 //
                font.bold: true
                font.family: plasmoid.configuration.fontFamily
                // color: "red"
                color: colorOpt
                visible: mediaSource.playbackStatus !== ""
            }
            PlasmaComponents.Label {
                id: nowPlayingLabel2
                Layout.alignment: alignmentOption.title.alignment
                text: mediaSource.playbackStatus
                        === "Playing" ? "PLAYING" : "PLAYED"
                lineHeight: 1 //
                font.bold: true
                font.pixelSize: 24 //
                font.family: plasmoid.configuration.fontFamily
                // color: "red"
                color: colorOpt
                visible: mediaSource.playbackStatus !== ""
            }
            RowLayout {
                id: mediaControls
                opacity: mediaControlsMouseArea.containsMouse
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
                Behavior on opacity {
                    PropertyAnimation {
                        easing.type: Easing.InOutQuad
                        duration: 200
                    }
                }
                Button {
                    Layout.alignment: Qt.AlignLeft
                    Layout.fillWidth: true
                    contentItem: PlasmaCore.IconItem {
                        height: 50  // Set the desired height for the icon
                        source: "media-skip-backward"
                    }
                    padding: 1
                    background: null
                    onClicked: {
                        root.mediaPrev()
                        console.log("prev clicked")
                    }
                }
                Button {
                    id: playButton
                    Layout.alignment: Qt.AlignHCenter
                    Layout.fillWidth: true
                    contentItem: PlasmaCore.IconItem {
                        height: 50  // Set the desired height for the icon
                        source: mediaSource.playbackStatus === "Playing" ? "media-playback-pause" : "media-playback-start"
                    }
                    padding: 1
                    background: null
                    onClicked: {
                        root.mediaToggle()
                        console.log("pause clicked")
                    }
                }
                Button {
                    Layout.alignment: Qt.AlignRight
                    Layout.fillWidth: true
                    contentItem: PlasmaCore.IconItem {
                        height: 50  // Set the desired height for the icon
                        source: "media-skip-forward"
                    }
                    onClicked: {
                        root.mediaNext()
                        console.log(mediaSource.playbackStatus)
                        console.log("next clicked")
                    }
                    padding: 1
                    background: null
                }
            }
        }
    }
    Rectangle {
        width: 5
    }
    Rectangle {
        id: separator
        height: alignmentOption.separator.height
        width: alignmentOption.separator.width
        Layout.fillWidth: alignmentOption.separator.fillWidth
        Layout.fillHeight: alignmentOption.separator.fillHeight
        // color: "red"
        color: colorOpt
        visible: mediaSource.playbackStatus !== ""
    }
    Rectangle {
        width: 5
    }
    Item {
        id: albumArtContainer
        height: parent.height; width: height
        visible: mediaSource.albumArt !== ""
        clip: true
        Image {
            width: height
            height: parent.height
            anchors.centerIn: parent
            source: mediaSource.albumArt
            fillMode: Image.PreserveAspectFit
            smooth: true
        }
    }
    Rectangle {
        width: 5
    }
    ColumnLayout {
        Layout.fillWidth: true
        id: infoColumn
        PlasmaComponents.Label {
            id: trackLabel
            font.family: plasmoid.configuration.fontFamily
            text: mediaSource.track
            Layout.alignment: alignmentOption.track.alignment
            Layout.fillWidth: true
            font.pixelSize: 32
            // color: "red"
            color: colorOpt
            lineHeight: 1.2
            font.bold: true
            wrapMode: Text.Wrap
            maximumLineCount: 2
            elide: alignmentOption.track.elide
            horizontalAlignment: alignmentOption.track.horizontalAlignment
        }
        Rectangle {
            height: 5
        }
        PlasmaComponents.Label {
            id: artistLabel
            font.family: plasmoid.configuration.fontFamily
            elide: alignmentOption.track.elide
            Layout.alignment: alignmentOption.track.alignment
            Layout.minimumWidth: 300
            Layout.preferredWidth: trackLabel.width / 2
            Layout.fillWidth: true
            text: mediaSource.artist
            font.pixelSize: 24
            font.bold: true
            wrapMode: Text.Wrap
            maximumLineCount: 2
            horizontalAlignment: alignmentOption.track.horizontalAlignment
            // color: "red"
            color: colorOpt
            lineHeight: 1
        }
        Rectangle {
            height: 10
        }
        Item {
            width: 350
            height: 30
            Layout.alignment: alignmentOption.track.alignment
            Rectangle {
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width
                height: 0.2 * parent.height
                radius: 0.5 * height
                // color: "red"
                color: colorOpt
                opacity: 0.5
            }
            MouseArea {
                id: mouseArea
                anchors.fill: parent
                drag.target: null
                property double maximum: mediaSource.length
                property double value: mediaSource.position
                property double ratio: 0
                Rectangle { // pill
                    id: pill
                    anchors {
                        verticalCenter: parent.verticalCenter
                        left: parent.left
                    }
                    width: parent.width * ( mouseArea.value / mouseArea.maximum )
                    height: parent.height * 0.2
                    radius: 0.5 * height
                    // color: "red"
                    color: colorOpt
                }
                onClicked: {
                    ratio = mouse.x / parent.width
                    var newValue = maximum * ratio
                    root.mediaSeek(newValue - mediaSource.position)
                    console.log( "Track: " + mediaSource.track + "\n" + "Seek to: " + value + " / " + maximum + ":  :" + ratio)
                }
            }
            visible: mediaSource.playbackStatus !== ""
        }
        Rectangle {
            id: whereami
            width: 350
            color: "transparent"
            height: 20
            // Layout.alignment: alignmentOption.track.alignment
            property string pos: Math.floor(mediaSource.position/1000000)
            property string len: Math.floor(mediaSource.length/1000000)
            PlasmaComponents.Label {
                id: positionWhereAmI
                // Layout.alignment: Qt.AlignLeft
                font.family: plasmoid.configuration.fontFamily
                font.pixelSize: 20
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                text: root.formatTrackTime(whereami.pos)
                // color: "red"
                color: colorOpt
            }
            PlasmaComponents.Label {
                id: lengthWhereAmI
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                // Layout.alignment: Qt.AlignRight
                font.family: plasmoid.configuration.fontFamily
                font.pixelSize: 20
                text: root.formatTrackTime(whereami.len)
                // color: "red"
                color: colorOpt
            }
            visible: mediaSource.playbackStatus !== ""
        }
    }
}
