import QtQuick 2.0
import QtQuick.Controls.Material 2.1
import QtGraphicalEffects 1.0

Item {
	id: actionBar

	property alias text:text.text
	property alias button1IconSource:button1.iconSource
	property alias button2IconSource:button2.iconSource

	signal button1Clicked
	signal button2Clicked

	height: gridSize * 4
	anchors.top: parent.top
	anchors.left: parent.left
	anchors.right: parent.right

	z: 10

	// Bar background
	Rectangle {
		id: bar
		property int buttonSize: gridSize * 2
		property int buttonMargin: (height - buttonSize) / 2

		anchors.fill: parent
		color: main.barColor

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

	BarDropShadow {
		source: bar
	}

}
