import QtQuick 2.0
import QtQuick.Controls 1.4

Item {
	id: disconnectedView
	anchors.fill: parent

	Item {
		anchors.fill: parent

		Column {
			anchors.centerIn: parent
			spacing: gridSize * 2

			Text {
				text: "Disconnected from Video Wall"
				anchors.horizontalCenter: parent.horizontalCenter
				font.pixelSize: fontSizeBig
				color: 'white'
			}

			Text {
				text: controller.socketError
				anchors.horizontalCenter: parent.horizontalCenter
				font.pixelSize: fontSizeNormal
				color: 'white'
			}

			Button {
				text: "Reconnect"
				anchors.horizontalCenter: parent.horizontalCenter
				onClicked: controller.openSocket()
			}

		}

	}

}
