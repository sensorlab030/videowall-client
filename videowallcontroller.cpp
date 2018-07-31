#include "videowallcontroller.h"
#include <QDebug>
#include <QtWebSockets>

#include "animation.h"
#include "websocket.h"

VideoWallController::VideoWallController(QObject *parent) : QObject(parent) {

	// Setup animation model
	_animationModel = new AnimationModel(this);

	// Setup socket
	_socket = new WebSocket(this);
	connect(_socket, SIGNAL(connectionStateChanged(ConnectionState::Enum)), this, SIGNAL(connectionStateChanged(ConnectionState::Enum)));
	connect(_socket, SIGNAL(errorString(QString)), this, SIGNAL(socketError(QString)));
	connect(_socket, SIGNAL(animationsChanged(QList<Animation*>)), _animationModel, SLOT(setAnimations(QList<Animation*>)));
	connect(_socket, SIGNAL(activeAnimationIdChanged(int)), this, SIGNAL(activeAnimationIdChanged(int)));

	_activeAnimation = 0;

}

void VideoWallController::openSocket() {
	_socket->open();
}

void VideoWallController::closeSocket() {
	_socket->close();
}

void VideoWallController::setActiveAnimation(int animationId) {
	_socket->sendActivateAnimationId(animationId);
}

int VideoWallController::activeAnimationId() const {
	return (_activeAnimation != 0) ? _activeAnimation->id() : -1;
}

AnimationModel* VideoWallController::getAnimationModel() {
	return _animationModel;
}

ConnectionState::Enum VideoWallController::connectionState() const {
	return _socket->connectionState();
}

QString VideoWallController::socketError() const {
	return _socket->errorString();
}
