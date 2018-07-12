import QtQuick 2.0
import QtQuick.Controls.Material 2.1

Item {
	id: listView
	anchors.fill:parent

	signal listCancelled

	// Top menu
	ActionBar {
		id: actionBar
		z: 10;

		// Button 1
		button1IconSource: "static/icons/baseline-arrow_back.svg"
		onButton1Clicked: listView.listCancelled()

	}

	ListModel {
		id: tempModel
		ListElement {
			aid: 1
			name: "Black"
			description: "No display"
		}
		ListElement {
			aid: 2
			name: "Window video stream"
			description: "Video stream of the Plompetorengracht in Utrecht"
		}
		ListElement {
			aid: 3
			name: "Chicago video stream"
			description: "Video stream from the Chicago office"
		}
	}

	ListView {
		anchors.top: actionBar.bottom
		anchors.horizontalCenter: parent.horizontalCenter
		width: parent.width - gridSize * 2
		height: parent.height - actionBar.height
		spacing: gridSize

		model: tempModel
		delegate: animationDelegate

		add: Transition {
			NumberAnimation { properties: "x,y"; from: 100; duration: 1000 }
		}
	}

	Component {

		id: animationDelegate
		Rectangle {
			id: animationCard
			width: parent.width
			height: gridSize * 6
			color: aid === 2 ? Material.accent : 'white'

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
			}

		}

	}

}
