import QtQuick 2.0
import QtGraphicalEffects 1.0
import QtQuick.Controls.Material 2.1

Item {

	property int size
	property string iconSource

	signal clicked

	width: size
	height: width

	anchors.verticalCenter: parent.verticalCenter
	visible: iconSource.length > 0

	// SVG image
	Image {
		id: svgImage
		width: parent.width
		height: width
		visible: false

		source: iconSource
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

	// Mouse/touch interaction
	MouseArea {
		anchors.fill: parent
		onClicked: parent.clicked()
	}

}
