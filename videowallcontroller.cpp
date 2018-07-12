#include "videowallcontroller.h"
#include <QTimer>

VideoWallController::VideoWallController(QObject *parent) : QObject(parent) {

	// Set initial state
	setConnectionState(ConnectionState::Enum::DISCONNECTED);

	// DEV ONLY
	QTimer* fooTimer = new QTimer(this);
	fooTimer->setInterval(1000);
	connect(fooTimer, SIGNAL(timeout()), this, SLOT(toggleConnectedDev()));
	fooTimer->start();

}
ConnectionState::Enum VideoWallController::connectionState() const {
	return _connectionState;
}

void VideoWallController::setConnectionState(ConnectionState::Enum state) {
	if (state != _connectionState) {
		_connectionState = state;
		emit connectionStateChanged(_connectionState);
	}
}

void VideoWallController::toggleConnectedDev() {

	switch (_connectionState) {
		case ConnectionState::Enum::CONNECTED:
			setConnectionState(ConnectionState::Enum::DISCONNECTED);
			break;
		case ConnectionState::Enum::CONNECTING:
			setConnectionState(ConnectionState::Enum::CONNECTED);
			break;
		case ConnectionState::Enum::DISCONNECTED:
			setConnectionState(ConnectionState::Enum::CONNECTING);
			break;
	}

}
