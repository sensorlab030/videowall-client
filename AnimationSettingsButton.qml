import QtQuick 2.0

Rectangle {

	property int size
	signal clicked

	anchors.centerIn: parent

	width: size
	height: size

	color: "#FFFF0000"

	MouseArea {
		id: mouseArea
		anchors.fill: parent
		onClicked: parent.clicked();
	}

}
