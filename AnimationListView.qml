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
		anchors.bottom: controlBar.top
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.margins: gridSize
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

	AnimationSettings {
		id: settingsPanel

		height: parent.height - controlBar.height
		anchors.left: parent.left
		anchors.right: parent.right
		z: 15
		state: "closed"

		states: [
			State {
				name: "open"
				AnchorChanges {
					target: settingsPanel;
					anchors.top: parent.top
				}
				PropertyChanges {
					target: settingsPanel
					opacity: 1
				}
			},
			State {
				name: "closed"
				AnchorChanges {
					target: settingsPanel;
					anchors.top: controlBar.top
				}
				PropertyChanges {
					target: settingsPanel
					opacity: 0
				}

			}

		]

		transitions: Transition {
			AnchorAnimation {
				duration: 200
				easing.type: Easing.InOutQuad
			}
			NumberAnimation {
				duration:  200
				properties: "opacity"
				easing.type: Easing.InOutQuad
			}
		}

	}

	ControlBar {
		id: controlBar
	}

}
