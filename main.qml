import QtQuick 2.11
import QtQuick.Window 2.11
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.1
import QtQml.StateMachine 1.0 as DSM
import nl.sensorlab.videowall 1.0

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

	DisconnectedView {
		id: disconnectedView
		readonly property int viewId: 3
		visible: (activeViewId === this.viewId)
	}

	ConnectingView {
		id: connectingView
		readonly property int viewId: 4
		visible: (activeViewId === this.viewId)
	}

	// Handle application view state
	DSM.StateMachine {
		id: applicationState
		initialState: disconnectedState
		running: false

		DSM.State {
			id: listState

			DSM.SignalTransition {
				targetState: disconnectedState
				signal: controller.onConnectionStateChanged
				guard: (controller.connectionState === ConnectionState.DISCONNECTED)
			}

			DSM.SignalTransition {
				targetState: connectingState
				signal: controller.onConnectionStateChanged
				guard: (controller.connectionState === ConnectionState.CONNECTING)
			}

			onEntered: {
				activeViewId = listView.viewId
			}
		}

		DSM.State {
			id: disconnectedState

			DSM.SignalTransition {
				targetState: connectingState
				signal: controller.onConnectionStateChanged
				guard: (controller.connectionState === ConnectionState.CONNECTING)
			}

			onEntered: {
				activeViewId = disconnectedView.viewId
			}

		}
		DSM.State {
			id: connectingState

			DSM.SignalTransition {
				targetState: listState
				signal: controller.onConnectionStateChanged
				guard: (controller.connectionState === ConnectionState.CONNECTED)
			}

			DSM.SignalTransition {
				targetState: disconnectedState
				signal: controller.onConnectionStateChanged
				guard: (controller.connectionState === ConnectionState.DISCONNECTED)
			}

			onEntered: {
				activeViewId = connectingView.viewId
			}
		}

		onStarted: {
			controller.openSocket();
		}

	}

	onClosing: {
		controller.closeSocket();
	}

	Component.onCompleted: {
		applicationState.start();
	}

}
