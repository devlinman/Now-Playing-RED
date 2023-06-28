import QtQuick 2.12
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.12
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
                "width": 1,
                "height": 1
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
                "width": 1,
                "height": 1
            }
        }
        // ,{
        //     "flow": GridLayout.TopToBottom,
        //     "columns": 1,
        //     "rows": -1,
        //     "layoutDirection": Qt.LeftToRight,
        //     "track": {
        //         "horizontalAlignment": Text.AlignCenter,
        //         "alignment": Qt.AlignCenter,
        //         "elide": Text.ElideNone
        //     },
        //     "title": {
        //         "horizontalAlignment": Text.AlignCenter,
        //         "alignment": Qt.AlignCenter,
        //     },
        //     "separator": {
        //         "fillWidth": false,
        //         "fillHeight": true,
        //         "width": 1,
        //         "height": 1
        //     }
        // },{
        //     "flow": GridLayout.TopToBottom,
        //     "columns": 1,
        //     "rows": -1,
        //     "layoutDirection": Qt.RightToLeft,
        //     "track": {
        //         "horizontalAlignment": Text.AlignCenter,
        //         "alignment": Qt.AlignCenter,
        //         "elide": Text.ElideNone
        //     },
        //     "title": {
        //         "horizontalAlignment": Text.AlignCenter,
        //         "alignment": Qt.AlignCenter,
        //     },
        //     "separator": {
        //         "fillWidth": true,
        //         "fillHeight": false,
        //         "width": 1,
        //         "height": 1
        //     }
        // }
    ]

    readonly property var alignmentOption: alignmentOpts[plasmoid.configuration.alignment]
    rows: alignmentOption.rows
    flow: alignmentOption.flow
    columns: alignmentOption.columns
    Keys.onReleased: {
        if (!event.modifiers) {
            event.accepted = true
            if (event.key === Qt.Key_Space || event.key === Qt.Key_K) {
                root.mediaToggle()
            } else if (event.key === Qt.Key_P) {
                root.mediaPrev()
            } else if (event.key === Qt.Key_N) {
                root.mediaNext()
            } else {
                event.accepted = false
            }
        }
    }

    layoutDirection: alignmentOption.layoutDirection

    MouseArea {
        id: mediaControlsMouseArea
        width: nowPlayingColumn.width
        Layout.fillWidth: true
        hoverEnabled: true
        ColumnLayout {
        Layout.fillWidth: true
        id: playerName
        Label {
            id: player
            Layout.alignment: alignmentOption.title.alignment
            text: mediaSource.playerName
            lineHeight: 1 //
            font.pixelSize: 16 //
            font.bold: true
            font.family: plasmoid.configuration.fontFamily
            color: "red"
            }
        }
        ColumnLayout {
            anchors.centerIn: parent
            spacing: 1
            id: nowPlayingColumn
            Label {
                id: nowPlayingLabel1
                Layout.alignment: alignmentOption.title.alignment 
                text: mediaSource.playbackStatus
                        === "Playing" ? "NOW" : "LAST"
                lineHeight: 1 //
                font.pixelSize: 20 //
                font.bold: true
                font.family: plasmoid.configuration.fontFamily
                color: "red"
            }
            Label {
                id: nowPlayingLabel2
                Layout.alignment: alignmentOption.title.alignment 
                text: mediaSource.playbackStatus
                        === "Playing" ? "PLAYING" : "PLAYED"
                lineHeight: 1 //
                font.bold: true
                font.pixelSize: 20 //
                font.family: plasmoid.configuration.fontFamily
                color: "red"
            }
            RowLayout {
                id: mediaControls
                opacity: mediaControlsMouseArea.containsMouse
                Behavior on opacity {
                    PropertyAnimation {
                        easing.type: Easing.InOutQuad
                        duration: 200
                    }
                }
                Button {
                    Layout.preferredWidth: nowPlayingLabel2.width / 3
                    contentItem: PlasmaCore.IconItem {
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
                    Layout.preferredWidth: nowPlayingLabel2.width / 3
                    id: playButton
                    contentItem: PlasmaCore.IconItem {
                        source: mediaSource.playbackStatus
                                === "Playing" ? "media-playback-pause" : "media-playback-start"
                    }
                    padding: 1
                    background: null
                    onClicked: {
                        root.mediaToggle()
                        console.log("pause clicked")
                    }
                }
                Button {
                    Layout.preferredWidth: nowPlayingLabel2.width / 3
                    contentItem: PlasmaCore.IconItem {
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
        id: separator
        height: alignmentOption.separator.height
        width: alignmentOption.separator.width
        Layout.fillWidth: alignmentOption.separator.fillWidth
        Layout.fillHeight: alignmentOption.separator.fillHeight
        color: "red"
    }
    ColumnLayout {
        Layout.fillWidth: true
        id: artInfo
        //
        Item {
            width: 200
            height: 200
            clip: true
            Image {
                width: 200
                height: 200
                anchors.centerIn: parent
                source: mediaSource.albumArt
                fillMode: Image.ScaleAspectFit
                smooth: true
            }
        }
        //
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
        PlasmaComponents.Label {
            id: artistLabel
            font.family: plasmoid.configuration.fontFamily
            elide: alignmentOption.track.elide 
            Layout.alignment: alignmentOption.track.alignment 
            Layout.minimumWidth: 250
            Layout.preferredWidth: trackLabel.width / 2
            Layout.fillWidth: true
            text: mediaSource.artist
            font.pixelSize: 24
            wrapMode: Text.Wrap
            maximumLineCount: 2
            horizontalAlignment: alignmentOption.track.horizontalAlignment 
            color: "red"
            lineHeight: 0.8
        }
    }
}
