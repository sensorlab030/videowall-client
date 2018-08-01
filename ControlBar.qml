import QtQuick 2.9
import QtQuick.Controls.Material 2.1
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtGraphicalEffects 1.0

Rectangle {
	id: controlBar
	property int margin: gridSize
	property int barHeight: gridSize * 6

	width: parent.width
	height: barHeight + margin
	anchors.bottom: parent.bottom
	z: 10
	color: 'transparent'

	// Bar background
	Rectangle {
		id: bar
		width: parent.width
		height: barHeight
		anchors.bottom: parent.bottom
		color: "#FF2a373e"

		// Settings button
		Rectangle {
			id: settingsBtn
			width: gridSize * 4
			height: width
			radius: width * 0.5
			x: gridSize  *2
			anchors.verticalCenter: parent.verticalCenter
			color: 'white'
		}

		Label {
			id: animationName

			anchors.left: settingsBtn.right
			anchors.leftMargin: gridSize
			anchors.right: playBtn.left
			anchors.rightMargin: gridSize
			height: parent.height
			anchors.verticalCenter: parent.verticalCenter

			horizontalAlignment: Text.AlignHCenter
			verticalAlignment: Text.AlignVCenter

			font.pixelSize: fontSizeSmall
			elide: Text.ElideRight
		}

		// Play pause button
		Rectangle {
			id: playBtn
			width: gridSize * 4
			height: width
			radius: width * 0.5
			x: parent.width - width - gridSize * 2
			anchors.verticalCenter: parent.verticalCenter
			color: 'white'
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
		verticalOffset: -3
		radius: 4
		samples: 9
		color: "#30000000"
		source: bar
	}

	Connections {
		target: controller

		onActiveAnimationChanged: {
			animationName.text = name;
		}

	}

}
