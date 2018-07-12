import QtQuick 2.0
import QtQuick.Controls.Material 2.1
import QtGraphicalEffects 1.0

/**
 * Action bar + bottom margin
 */
Item {
	id: actionBar
	property int margin: gridSize
	property int barHeight: gridSize * 6

	property string button1IconSource
	property string button2IconSource

	signal button1Clicked
	signal button2Clicked

	width: parent.width
	height: (barHeight + margin)
	anchors.top: parent.top

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
			iconSource: button1IconSource
			anchors.left: parent.left
			anchors.leftMargin: parent.buttonMargin
			onClicked: actionBar.button1Clicked()
		}

		// Button 2
		ActionBarButton {
			id: button2
			size: parent.buttonSize
			iconSource: button2IconSource
			anchors.right: parent.right
			anchors.rightMargin: parent.buttonMargin
			onClicked: actionBar.button2Clicked()
		}

	}

	DropShadow {
		anchors.fill: actionBar
		horizontalOffset: 0
		verticalOffset: 3
		radius: 4
		samples: 9
		color: "#30000000"
		source: bar
	}

}
