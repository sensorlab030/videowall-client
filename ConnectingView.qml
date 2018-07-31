import QtQuick 2.0

Item {
	id: connectingView
	anchors.fill: parent

	Column {
		anchors.centerIn: parent
		spacing: gridSize * 3

		PulseLoader {
			anchors.horizontalCenter: parent.horizontalCenter
			barCount: 13
			width: 300
			height: 50
		}

		Text {
			anchors.horizontalCenter: parent.horizontalCenter
			font.pixelSize: fontSizeSmall
			color: 'white'
			text: "Connecting"
		}

	}

}

