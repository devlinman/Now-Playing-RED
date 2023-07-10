import QtQuick 2.15
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.15
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.plasma.core 2.0 as PlasmaCore
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.15


Item {
    width: fullView.width
    height: fullView.height
    Item {
        width: parent.width
        height: parent.height
        clip: true
        Image {
            id: blurAlbumArtImage
            opacity: 0.3
            anchors.fill: parent
            source: mediaSource.albumArt
            fillMode: Image.PreserveAspectCrop
            smooth: true
            layer.enabled: true
            layer.effect: FastBlur {
                radius: 100
                source: blurAlbumArtImage
            }
        }
    }
    GridLayout {
        id: fullView
        Layout.preferredHeight: Math.max(infoColumn.height, albumArtContainer.height)
        Layout.preferredWidth: albumArtContainer.width + Math.max(trackLabel.width, artistLabel.width, albumLabel.width) + 11
        readonly property var alignmentOpts: [
            {
                "flow": GridLayout.LeftToRight,
                "columns": -1,
                "rows": 1,
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
                "rows": 1,
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
        Rectangle {
            width: 1
        }
        Item {
            id: albumArtContainer
            width: 202
            height: 202
            visible: mediaSource.albumArt !== ""
            clip: true
            Image {
                id: albumArtImage
                width: 200
                height: 200
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
            id: infoColumn
            Layout.fillWidth: true
            PlasmaComponents.Label {
                id: trackLabel
                elide: fullView.alignmentOption.track.elide
                text: mediaSource.track
                color: "red"
                font.pixelSize: 32
                font.bold: true
                font.family: plasmoid.configuration.fontFamily
                Layout.fillWidth: true
                // wrapMode: Text.Wrap
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                maximumLineCount: 2
                lineHeight: 1
                visible: mediaSource.playbackStatus !== ""
            }
            PlasmaComponents.Label {
                id: artistLabel
                elide: fullView.alignmentOption.track.elide
                text: "Artist:  " + mediaSource.artist
                color: "red"
                font.pixelSize: 24
                font.family: plasmoid.configuration.fontFamily
                Layout.fillWidth: true
                // wrapMode: Text.Wrap
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                maximumLineCount: 2
                lineHeight: 1
                visible: mediaSource.playbackStatus !== ""
            }
            PlasmaComponents.Label {
                id: albumLabel
                elide: fullView.alignmentOption.track.elide
                text: "Album:   " + mediaSource.album
                color: "red"
                font.pixelSize: 24
                font.family: plasmoid.configuration.fontFamily
                Layout.fillWidth: true
                // wrapMode: Text.Wrap
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                maximumLineCount: 2
                lineHeight: 1
                visible: mediaSource.playbackStatus !== ""
            }
            PlasmaComponents.Slider {
                id: slider
                from: 0
                to:  mediaSource.length
                value:  mediaSource.position
                onValueChanged: {
                    if (value !== mediaSource.position) {
                        var seekPosition = value - mediaSource.position;
                        root.mediaSeek(seekPosition);
                    }
                }
                visible: mediaSource.track !== ""
            }
            RowLayout {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
                width: slider.width
                PlasmaComponents.Label {
                    id: whereamiTime
                    Layout.alignment: Qt.AlignLeft
                    font.family: plasmoid.configuration.fontFamily
                    font.pixelSize: 20
                    property string pos: Math.floor(mediaSource.position/1000000)
                    text: root.formatTrackTime(pos)
                    color: "red"
                    visible: mediaSource.playbackStatus !== ""
                }
                PlasmaComponents.Label {
                    id: whereamiTotal
                    Layout.alignment: Qt.AlignRight
                    font.family: plasmoid.configuration.fontFamily
                    font.pixelSize: 20
                    property string len: Math.floor(mediaSource.length/1000000)
                    text: root.formatTrackTime(len)
                    color: "red"
                    visible: mediaSource.playbackStatus !== ""
                }
            }
        }
    }
}
