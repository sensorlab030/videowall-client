import QtQuick 2.5

Canvas {
	id: debugGrid
	visible: false
	z: 100
	anchors.fill: parent
	onPaint: {
		var ctx = debugGrid.getContext('2d');
		ctx.strokeStyle = "#7F00A1E4";

		for (var x = 0; x < width; x += main.gridSize) {
			ctx.beginPath();
			ctx.moveTo(x, 0);
			ctx.lineTo(x, height);
			ctx.stroke();
		}

		for (var y = 0; y < height; y += main.gridSize) {
			ctx.beginPath();
			ctx.moveTo(0, y);
			ctx.lineTo(width, y);
			ctx.stroke();
		}

	}

	Shortcut {
		enabled: debugMode
		sequence: "Ctrl+D"
		onActivated: debugGrid.visible = !debugGrid.visible;
	}

}
