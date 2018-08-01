import QtQuick 2.0
import QtQuick.Controls.Material 2.1
import QtGraphicalEffects 1.0

Item {
	id: actionBar
	property int margin: gridSize
	property int barHeight: gridSize * 4

	property alias text:text.text
	property alias button1IconSource:button1.iconSource
	property alias button2IconSource:button2.iconSource

	signal button1Clicked
	signal button2Clicked

	width: parent.width
	height: (barHeight + margin)
	anchors.top: parent.top
	z: 10

	// Bar background
	Rectangle {
		id: bar
		property int buttonSize: height * 0.8
		property int buttonMargin: (height - buttonSize) / 2

		width: parent.width
		height: barHeight
		anchors.top: parent.top
		color: "#FF2a373e"

		// Button 1
		ActionBarButton {
			id: button1
			size: parent.buttonSize
			anchors.left: parent.left
			anchors.leftMargin: parent.buttonMargin
			onClicked: actionBar.button1Clicked()
			z: parent.z + 1
		}

		Text {
			id: text
			anchors.centerIn: parent
			color: 'white'
			font.pixelSize: fontSizeNormal
		}

		// Button 2
		ActionBarButton {
			id: button2
			size: parent.buttonSize
			iconSource: button2IconSource
			anchors.right: parent.right
			anchors.rightMargin: parent.buttonMargin
			onClicked: actionBar.button2Clicked()
			z: parent.z + 1
		}

		// Have mouseArea so mouse events don't propagate
		// to elements underneath this bar
		MouseArea {
			anchors.fill: parent
			onClicked: mouse.accepted = true
		}

	}

	DropShadow {
		anchors.fill: source
		horizontalOffset: 0
		verticalOffset: 3
		radius: 4
		samples: 9
		color: "#30000000"
		source: bar
	}

}
