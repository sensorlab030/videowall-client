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
		Item {
			id: settingsBtn
			width: gridSize * 4
			height: width
			x: gridSize  *2
			anchors.verticalCenter: parent.verticalCenter

			opacity: 0.2

			// SVG image
			Image {
				id: svgImage
				width: parent.width
				height: width
				visible: false

				source: 'static/icons/baseline-expand_less.svg'
				sourceSize.width: width
				sourceSize.height: height
			}
			ColorOverlay{
				anchors.centerIn: parent
				width: parent.width * 0.6
				height: width

				source:svgImage
				color: Material.foreground
				antialiasing: true
			}

		}

		Column {
			anchors.left: settingsBtn.right
			anchors.leftMargin: gridSize
			anchors.right: playBtn.left
			anchors.rightMargin: gridSize
			anchors.verticalCenter: parent.verticalCenter

			spacing: gridSize * 0.5

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

		}

		// Play pause button
		Item {
			id: playBtn
			width: gridSize * 4
			height: width
			x: parent.width - width - gridSize * 2
			anchors.verticalCenter: parent.verticalCenter
			z: parent.z + 1

			// SVG image
			Image {
				id: playBtnSvgImage
				width: parent.width
				height: width
				visible: false

				source: 'static/icons/baseline-pause_circle_filled.svg'
				sourceSize.width: width
				sourceSize.height: height
			}
			ColorOverlay{
				anchors.centerIn: parent
				width: parent.width * 0.6
				height: width

				source:playBtnSvgImage
				color: Material.foreground
				antialiasing: true
			}

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
			animationDescription.text = description
		}

	}

}
