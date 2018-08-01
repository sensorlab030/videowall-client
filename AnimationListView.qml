import QtQuick 2.0
import QtQuick.Controls.Material 2.1

Item {
	id: listView
	anchors.fill: parent

	signal settingsClicked

	// Top menu
	ActionBar {
		id: actionBar
		text: "Animations"

		// Button 1
		//button1IconSource: "static/icons/baseline-arrow_back.svg"
		//onButton1Clicked: listView.listCancelled()

		// Button 2
		button2IconSource: "static/icons/baseline-settings.svg"
		onButton2Clicked: listView.settingsClicked();

	}

	ListView {
		anchors.top: actionBar.bottom
		anchors.horizontalCenter: parent.horizontalCenter
		anchors.bottom: controlBar.top
		width: parent.width - gridSize * 2
		spacing: gridSize
		model: animationModel
		delegate: animationDelegate
	}

	Component {

		id: animationDelegate
		Rectangle {
			id: animationCard
			width: parent.width
			height: gridSize * 5
			color: active ? Material.accent : 'white'

			Column {
				width: parent.width - gridSize * 2
				height: parent.height - gridSize * 2
				anchors.centerIn: parent
				spacing: gridSize * 0.25

				Text {
					width: parent.width
					text: name
					font.pixelSize: fontSizeNormal
					elide: Text.ElideRight
				}

				Text {
					width: parent.width
					text: description
					font.pixelSize: fontSizeSmall
					elide: Text.ElideRight
				}

			}

			MouseArea {
				anchors.fill: parent
				onClicked: {
					controller.setActiveAnimation(id);
				}
			}

		}

	}

	ControlBar {
		id: controlBar
	}

}
