import QtQuick 2.0
Item {
    id: root
    property double maximum: 10
    property double value:    0
    property double minimum:  0
    signal clicked(double value);  //onClicked:{root.value = value;  print('onClicked', value)}
    opacity: enabled  &&  !mouseArea.pressed? 1: 0.3 // disabled/pressed state
    Repeater { // left and right trays (so tray doesn't shine through pill in disabled state)
        model: 2
        delegate: Rectangle {
            // x:     !index?               0: pill.x + pill.width - radius
            width: !index? radius: root.width - x
            height: 0.3 * root.height
            radius: 0.5 * height
            // color: '#cf1b42'
            color: "red"
            opacity: 0.5
            anchors.verticalCenter: parent.verticalCenter
        }
    }
    Rectangle { // pill
        id: pill
        anchors.verticalCenter: parent.verticalCenter
        width: (value - minimum) / (maximum - minimum) * (root.width)
        height: parent.height - 14
        radius: 0.5 * height
        color: "red"
    }
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        drag {
            target:   pill
            axis:     Drag.XAxis
            maximumX: root.width
            minimumX: 0
        }
        onPositionChanged:  if(drag.active) setPixels(mouse.x) // drag pill
        onClicked: setPixels(mouse.x) // tap tray
    }
    function setPixels(pixels) {
        pill.width = Math.min(root.width, Math.max(0, pixels)); // adjust pill's width to mouse.x
        var value = (maximum) / (root.width) * (pixels) // value from pixels
        clicked(Math.min(Math.max(minimum, value), maximum)) // emit
    }
}
