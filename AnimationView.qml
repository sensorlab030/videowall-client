import QtQuick 2.0
import QtQml.StateMachine 1.0 as DSM
import QtQuick.Controls 2.1
import QtQuick.Controls.Material 2.1

Item {
	id: animationView
	anchors.fill: parent

	signal gotoAnimationList

	// Top menu
	ActionBar {
		id: actionBar

		button1IconSource: "static/icons/baseline-view_list.svg"
		button2IconSource: "static/icons/baseline-settings.svg"

		onButton1Clicked: animationView.gotoAnimationList()
		onButton2Clicked: {
			console.log("Open wall settings");
		}

	}

	Rectangle {
		id: animationInfo

		anchors.top: actionBar.bottom
		anchors.horizontalCenter: parent.horizontalCenter
		width: parent.width - gridSize * 2
		height: animationInfoContent.height
		color: 'black'

		Column {
			id: animationInfoContent
			anchors.centerIn: parent
			width: parent.width

			Label {
				font.pixelSize: fontSizeBig
				text: "ANIMATION NAME"
				height: 40
			}

		}

	}

	Column {

		anchors.top: animationInfo.bottom

		//topPadding: gridSize * 2

		anchors.horizontalCenter: parent.horizontalCenter
		width: parent.width - gridSize * 2

		Label {
			font.pixelSize: fontSizeNormal
			leftPadding: gridSize * 2
			text: "Brightness"
		}

		Slider {
			width: parent.width
			value: 0.5
		}

		Label {
			font.pixelSize: fontSizeNormal
			leftPadding: gridSize * 2
			text: "FLAR"
		}

		Slider {
			width: parent.width
			value: 0.5
		}

	}

}
