import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import nl.sensorlab.videowall 1.0

Item {
	id: settingsView
	anchors.fill: parent

	signal backClicked

	// Top menu
	ActionBar {
		id: actionBar
		text: "Settings"
		button1IconSource: "static/icons/baseline-arrow_back.svg"
		onButton1Clicked: settingsView.backClicked()
	}

	Column {

		anchors.top: actionBar.bottom
		anchors.horizontalCenter: parent.horizontalCenter
		topPadding: 40
		width: parent.width - gridSize * 2

		Label {
			font.pixelSize: fontSizeNormal
			leftPadding: gridSize * 2
			text: "Brightness"
		}

		Slider {
			id: brightnessSlider
			width: parent.width
			value: controller.brightness
			from: 0
			to: 255
			stepSize: 1
			live: false

			onValueChanged: {
				controller.brightness = value;
			}

		}

	}
}
