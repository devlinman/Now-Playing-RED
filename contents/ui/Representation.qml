import QtQuick 2.12
import QtQuick.Layouts 1.11
// import QtQuick.Controls 2.12
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.plasma.core 2.0 as PlasmaCore

GridLayout {
    id: fullView
    focus: true
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
    layoutDirection: alignmentOption.layoutDirection
    MouseArea {
        id: mediaControlsMouseArea
        Layout.preferredWidth: Math.max(playerName.width, nowPlayingLabel1.width, nowPlayingLabel2.width)
        hoverEnabled: true
        ColumnLayout {
            anchors.centerIn: parent
            id: nowPlayingColumn
            // Label {
            PlasmaComponents.Label {
                id: playerName
                Layout.alignment: alignmentOption.title.alignment
                Layout.minimumWidth: 10
                horizontalAlignment: alignmentOption.track.horizontalAlignment
                text: mediaSource.playerName
                lineHeight: 1 //
                font.pixelSize: 20 //
                font.bold: true
                wrapMode: Text.Wrap
                maximumLineCount: 2
                elide: alignmentOption.track.elide
                font.family: plasmoid.configuration.fontFamily
                color: "red"
            }
            Rectangle {
                height: 20
            }
            // Label {
            PlasmaComponents.Label {
                id: nowPlayingLabel1
                Layout.alignment: alignmentOption.title.alignment 
                text: mediaSource.playbackStatus
                        === "Playing" ? "NOW" : "LAST"
                lineHeight: 1 //
                font.pixelSize: 24 //
                font.bold: true
                font.family: plasmoid.configuration.fontFamily
                color: "red"
                visible: mediaSource.playbackStatus !== ""
                //
            }
            // Label {
            PlasmaComponents.Label {
                id: nowPlayingLabel2
                Layout.alignment: alignmentOption.title.alignment 
                text: mediaSource.playbackStatus
                        === "Playing" ? "PLAYING" : "PLAYED"
                lineHeight: 1 //
                font.bold: true
                font.pixelSize: 24 //
                font.family: plasmoid.configuration.fontFamily
                color: "red"
                visible: mediaSource.playbackStatus !== ""
                //
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
                PlasmaComponents.Button {
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
                PlasmaComponents.Button {
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
                PlasmaComponents.Button {
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
        width: 10
    }
    Rectangle {
        id: separator
        height: alignmentOption.separator.height
        width: alignmentOption.separator.width
        Layout.fillWidth: alignmentOption.separator.fillWidth
        Layout.fillHeight: alignmentOption.separator.fillHeight
        color: "red"
        visible: mediaSource.playbackStatus !== ""
    }
    Rectangle {
        width: 1
    }
    Item {
        id: albumArtContainer
        height: parent.height; width: height
        // height: 200; width: height
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
        width: 10
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
            color: "red"
            lineHeight: 0.8
            font.bold: true
            wrapMode: Text.Wrap
            maximumLineCount: 2
            elide: alignmentOption.track.elide
            horizontalAlignment: alignmentOption.track.horizontalAlignment
        }
        Rectangle {
            height: 10
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
            wrapMode: Text.Wrap
            maximumLineCount: 2
            horizontalAlignment: alignmentOption.track.horizontalAlignment
            color: "red"
            lineHeight: 1
        }
        Rectangle {
            height: 10
        }
        Slider {
            // width: Math.min(trackLabel.width, artistLabel.width, 400)
            width: 350
            height: 20
            maximum: mediaSource.length
            value:  mediaSource.position
            minimum: 0
            onClicked: { // backend = value
                if (value !== mediaSource.position) {
                    var seekPosition = value - mediaSource.position;
                    root.mediaSeek(seekPosition);
                }
            }
            visible: mediaSource.playbackStatus !== ""
        }
        RowLayout {
            id: whereami
            Layout.fillWidth: true
            property string pos: Math.floor(mediaSource.position/1000000)
            property string len: Math.floor(mediaSource.length/1000000)
            PlasmaComponents.Label {
                id: positionWhereAmI
                Layout.alignment: Qt.AlignLeft
                font.family: plasmoid.configuration.fontFamily
                font.pixelSize: 20
                text: root.formatTrackTime(whereami.pos)
                color: "red"
            }
            Rectangle {
                height: 10
                width: 350 - lengthWhereAmI.width -positionWhereAmI.width
                color: "transparent"
            }
            PlasmaComponents.Label {
                id: lengthWhereAmI
                Layout.alignment: Qt.AlignLeft
                font.family: plasmoid.configuration.fontFamily
                font.pixelSize: 20
                text: root.formatTrackTime(whereami.len)
                color: "red"
            }
            visible: mediaSource.playbackStatus !== ""
        }
    }
}
