import QtQuick 2.0
import QtQuick.Controls.Material 2.1
import QtGraphicalEffects 1.0

Item {
	id: controlBar
	property int margin: gridSize
	property int barHeight: gridSize * 6

	width: parent.width
	height: (barHeight + margin)
	anchors.bottom: parent.bottom
	z: 10

	// Bar background
	Rectangle {
		id: bar
		width: parent.width
		height: barHeight
		anchors.bottom: parent.bottom
		color: "#FF2a373e"
	}

	DropShadow {
		anchors.fill: parent
		horizontalOffset: 0
		verticalOffset: -3
		radius: 4
		samples: 9
		color: "#30000000"
		source: bar
	}

}
