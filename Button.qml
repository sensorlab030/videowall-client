import QtQuick 2.0

Rectangle {

	property int size

	width: size
	height: size

	color: "#FFFF0000"

	MouseArea {
		id: mouseArea
		anchors.fill: parent
	}

}
