import QtQuick 2.0
import QtQuick.Controls.Material 2.1

Item {
	id: listView
	anchors.fill: parent

	signal listCancelled

	// Top menu
	ActionBar {
		id: actionBar
		z: 10;

		// Button 1
		button1IconSource: "static/icons/baseline-arrow_back.svg"
		onButton1Clicked: listView.listCancelled()

	}

	ListView {
		anchors.top: actionBar.bottom
		anchors.horizontalCenter: parent.horizontalCenter
		width: parent.width - gridSize * 2
		height: parent.height - actionBar.height
		spacing: gridSize

		model: animationModel
		delegate: animationDelegate

	}

	Component {

		id: animationDelegate
		Rectangle {
			id: animationCard
			width: parent.width
			height: gridSize * 6
			color: active ? Material.accent : 'white'

			Column {
				width: parent.width - gridSize * 2
				height: parent.height - gridSize * 2
				anchors.centerIn: parent

				Text {
					text: name
					font.pixelSize: fontSizeNormal
				}

				Text {
					text: description
					font.pixelSize: fontSizeSmall
				}

			}

			MouseArea {
				anchors.fill: parent
				onClicked: {
					controller.setActiveAnimation(id);
				}
			}

			//onActiveChanged: console.log("ACTIVE CHANGED")

		}

	}

}
