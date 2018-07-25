#include "websocket.h"

#include <QDebug>

WebSocket::WebSocket(QObject *parent) : QObject(parent) {

	_socket = new QWebSocket(QString(), QWebSocketProtocol::VersionLatest, this);
	connect(_socket, SIGNAL(textMessageReceived(QString)), this, SLOT(onMessage(QString)));
	connect(_socket, SIGNAL(error(QAbstractSocket::SocketError)), this, SLOT(onSocketError(QAbstractSocket::SocketError)));
	connect(_socket, SIGNAL(stateChanged(QAbstractSocket::SocketState)), this, SLOT(onStateChanged(QAbstractSocket::SocketState)));
	_connectionState = ConnectionState::Enum::DISCONNECTED;

	// Set initial state
	_connectionState = ConnectionState::Enum::DISCONNECTED;

}

void WebSocket::open() {
	_socket->open(QUrl("ws://localhost:9003"));
}

void WebSocket::close() {
	_socket->close();
}

ConnectionState::Enum WebSocket::connectionState() const {
	return _connectionState;
}

void WebSocket::onStateChanged(QAbstractSocket::SocketState state) {

	ConnectionState::Enum newState;
	switch (state) {
		case QAbstractSocket::ConnectedState:
			newState = ConnectionState::Enum::CONNECTED;
			break;
		case QAbstractSocket::HostLookupState:
		case QAbstractSocket::ConnectingState:
			newState = ConnectionState::Enum::CONNECTING;
			break;
		default:
			newState = ConnectionState::Enum::DISCONNECTED;
			break;
	}

	if (newState != _connectionState) {
		_connectionState = newState;
		emit connectionStateChanged(_connectionState);
		qDebug() << "Connection state:" << _connectionState;
	}

}

void WebSocket::onMessage(const QString& message) {
	qDebug() << message;
}

QString WebSocket::errorString() const {
	return _errorString;
}

void WebSocket::onSocketError(QAbstractSocket::SocketError error) {
	if (_errorString != _socket->errorString()) {
		_errorString = _socket->errorString();

		qDebug() << "Socket error:" << error << _errorString;
		emit errorString(_errorString);
	}
}


