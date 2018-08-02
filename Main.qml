import QtQuick 2.11
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.1
import QtQml.StateMachine 1.0 as DSM
import nl.sensorlab.videowall 1.0

Window {
	id: main
	visible: true
	width: 480
	height: 800
	title: qsTr("Video Wall Controller")
	Material.theme: Material.theme
	color: Material.background

	// Constants
	readonly property int gridSize: height * 0.02;
	readonly property int fontSizeNormal: gridSize * 1.5
	readonly property int fontSizeBig:  gridSize * 2
	readonly property int fontSizeSmall: gridSize
	readonly property bool debugMode: true
	readonly property color barColor: "#FF2a373e"

	// Current active view
	property int activeViewId: -1

	// All views
	AnimationListView {
		id: listView
		readonly property int viewId: 1
		visible: (activeViewId === this.viewId)
		opacity: (activeViewId === this.viewId) ? 1 : 0
		Behavior on opacity { ViewChangeTransition{} }
	}

	SettingsView {
		id: settingsView
		readonly property int viewId: 2
		visible: (activeViewId === this.viewId)
		opacity: (activeViewId === this.viewId) ? 1 : 0
		Behavior on opacity { ViewChangeTransition{} }
	}

	DisconnectedView {
		id: disconnectedView
		readonly property int viewId: 3
		visible: (activeViewId === this.viewId)
		opacity: (activeViewId === this.viewId) ? 1 : 0
		Behavior on opacity { ViewChangeTransition{} }
	}

	ConnectingView {
		id: connectingView
		readonly property int viewId: 4
		visible: (activeViewId === this.viewId)
		opacity: (activeViewId === this.viewId) ? 1 : 0
		Behavior on opacity { ViewChangeTransition{} }
	}

	DebugGrid{}

	// Application view state
	// One layer for connection (connected, connecting, disconnected)
	// Then the connected layer with multiple views
	DSM.StateMachine {
		id: applicationState
		initialState: disconnectedState
		running: true

		DSM.State {
			id: connectedState
			initialState: listState

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

			DSM.State {
				id: listState

				DSM.SignalTransition {
					targetState: settingsState
					signal: listView.settingsClicked
				}

				onEntered: {
					activeViewId = listView.viewId
				}
			}

			DSM.State {
				id: settingsState

				DSM.SignalTransition {
					targetState: listState
					signal: settingsView.backClicked
				}

				onEntered: {
					activeViewId = settingsView.viewId
				}
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
				targetState: connectedState
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

}
