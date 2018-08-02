import QtQuick 2.0
import QtGraphicalEffects 1.0

DropShadow {

	property bool downShadow: true

	source: bar
	anchors.fill: source
	horizontalOffset: 0
	verticalOffset: 3 * downShadow ? 1 : -1
	radius: 4
	samples: 9
	color: "#30000000"
}
