import QtQuick 2.9
import QtQuick.Controls.Material 2.1
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtGraphicalEffects 1.0

Item {
	id: controlBar

	height: gridSize * 4
	anchors.bottom: parent.bottom
	anchors.left: parent.left
	anchors.right: parent.right

	z: 20

	// Bar background
	Rectangle {
		id: bar
		anchors.fill: parent
		color: main.barColor

		// Settings button
        Item {

			id: settingsBtn
			width: gridSize * 2.5
			height: width
			anchors.left: parent.left
			anchors.leftMargin: gridSize
			anchors.verticalCenter: parent.verticalCenter
			state: settingsPanel.state
			z: parent.z + 1

			// SVG image
			Image {
				id: settingsBtnSvgImage
				width: parent.width
				height: width
				visible: false
				sourceSize.width: width
				sourceSize.height: height
			}
			ColorOverlay{
				source:settingsBtnSvgImage
				anchors.centerIn: parent
				width: source.width
				height: source.height
				color: Material.foreground
				antialiasing: true
			}

			states: [
				State {
					name: "closed"
					PropertyChanges {
						target: settingsBtnSvgImage;
						source: 'static/icons/baseline-expand_less.svg' }
				},
				State {
					name: "open"
					PropertyChanges {
						target: settingsBtnSvgImage;
						source: 'static/icons/baseline-expand_more.svg' }
				}
			]

			MouseArea {
				anchors.fill: parent
				onClicked: {
					settingsPanel.state = (settingsPanel.state == "closed") ? "open" : "closed"
				}
			}

        }

		Column {
            anchors.left: settingsBtn.right
            anchors.leftMargin: gridSize
			anchors.right: playBtn.left
			anchors.rightMargin: gridSize
			anchors.verticalCenter: parent.verticalCenter

			spacing: gridSize * 0.25

			Label {
				id: animationName
				width: parent.width

				horizontalAlignment: Text.AlignHCenter
				verticalAlignment: Text.AlignVCenter

				font.pixelSize: fontSizeSmall
				elide: Text.ElideRight
			}

			Label {
				id: animationDescription

				width: parent.width

				horizontalAlignment: Text.AlignHCenter
				verticalAlignment: Text.AlignVCenter

				opacity: 0.6
				text: "ers\Wilco\Projects\sensorlab\videowall\videowall-client\debug\VideoWallClient"

				font.pixelSize: fontSizeSmall
				elide: Text.ElideRight
			}

			Connections {
				target: controller

				onActiveAnimationChanged: {
					animationName.text = name;
					animationDescription.text = description
				}

			}

		}

		// Play pause button
		Item {
			id: playBtn
			width: gridSize * 2.5
			height: width
			anchors.right: parent.right
			anchors.rightMargin: gridSize
			anchors.verticalCenter: parent.verticalCenter
			z: parent.z + 1

			// SVG image
			Image {
				id: playBtnSvgImage
				width: parent.width
				height: width
				visible: false
				sourceSize.width: width
				sourceSize.height: height
			}

			ColorOverlay {
				anchors.centerIn: parent
				width: source.width
				height: source.height
				source:playBtnSvgImage
				color: Material.foreground
				antialiasing: true
			}

			states: [
				State {
					name: "playing"
					PropertyChanges {
						target: playBtnSvgImage;
						source: 'static/icons/baseline-pause_circle_outline.svg' }
				},
				State {
					name: "paused"
					PropertyChanges {
						target: playBtnSvgImage;
						source: 'static/icons/baseline-play_circle_outline.svg' }
				}
			]

			MouseArea {
				anchors.fill: parent
				onClicked: {
					controller.setPlayMode(parent.state === "playing" ? 0 : 1);
				}
			}

			Connections {
				target: controller

				onPlayModeChanged: {
					playBtn.state = playMode === 1 ? "playing" : "paused"
				}

			}

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
		downShadow: false
	}

}
