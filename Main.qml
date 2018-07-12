import QtQuick 2.11
import QtQuick.Window 2.11
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.1
import QtQml.StateMachine 1.0 as DSM
import nl.sensorlab.videowall 1.0
//import foo 1.0

Window {
	id: main
	visible: true
	width: 600
	height: 1024
	title: qsTr("Video Wall Controller")
	Material.theme: Material.theme
	color: Material.background

	// Constants
	readonly property int gridSize: 12

	readonly property int fontSizeNormal: 24
	readonly property int fontSizeBig:  32
	readonly property int fontSizeSmall: 16

	// Current active view
	property int activeViewId: -1

	VideoWallController {
		id: controller

		onConnectionStateChanged: {
			console.log("CHANGE!", connectionState);

			if (connectionState === ConnectionState.DISCONNECTED) {
				console.log("DISCONNECTED");
			}

		}

	}

	AnimationView {
		id: animationView
		readonly property int viewId: 1
		visible: (activeViewId === this.viewId)
	}

	AnimationList {
		id: listView
		readonly property int viewId: 2
		visible: (activeViewId === this.viewId)
	}

	// Handle application view state
	DSM.StateMachine {
		id: applicationState
		initialState: animationState
		running: true

		DSM.State {
			id: animationState

			DSM.SignalTransition {
				targetState: listState
				signal: animationView.onGotoAnimationList
			}

			onEntered: {
				activeViewId = animationView.viewId
			}

		}

		DSM.State {
			id: listState

			DSM.SignalTransition {
				targetState: animationState
				signal: listView.listCancelled
			}

			onEntered: {
				activeViewId = listView.viewId
			}
		}

	}



}
