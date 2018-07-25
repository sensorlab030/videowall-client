#include "websocket.h"

#include <QDebug>
#include "animation.h"

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

	try {

		// Parse message to root object
		QJsonDocument msgJson = QJsonDocument::fromJson(message.toUtf8());
		if (msgJson.isNull() || msgJson.isEmpty() || !msgJson.isObject()) {
			throw new QString("Invalid JSON message object");
		}
		QJsonObject root = msgJson.object();

		// Read message type
		QJsonValue msgTypeValue = root.value("msg");
		if (!msgTypeValue.isString()) {
			throw new QString("Invalid 'msg' property");
		}
		QString msgType = msgTypeValue.toString().toLower();

		// Fetch data object
		QJsonValue dataValue = root.value("data");
		if (!dataValue.isObject() && !dataValue.isNull()) {
			throw new QString("Invalid 'data' property");
		}
		QJsonObject data = dataValue.toObject();

		// Channel message to correct method
		if (msgType == "config") {
			hanleWallConfigMsg(data);
		} else {
			throw new QString("Unknown message type");
		}

	} catch (const QString& error) {
		qDebug() << "Disregarding invalid message:" << error;
	}

}

void WebSocket::hanleWallConfigMsg(const QJsonObject& data) {

	try {

		// @TODO Wall properties


		// Animations
		QJsonValue animationListValue = data.value("animations");
		if (!animationListValue.isArray()) {
			throw new QString("Invalid 'animations' property");
		}
		QJsonArray animationList = animationListValue.toArray();

		QList<Animation*> animationResultList;
		QJsonArray::iterator animationIt;
		for (animationIt = animationList.begin(); animationIt != animationList.end(); animationIt++) {

			// Fetch object
			QJsonValue animationValue = *animationIt;
			if (!animationValue.isObject()) {
				throw new QString("Invalid animation object");
			}
			QJsonObject animation = animationValue.toObject();

			// Fetch properties
			QJsonValue idValue = animation.value("id");
			if (!idValue.isDouble()) {
				throw new QString("Invalid animation 'id' property");
			}
			int id = (int) idValue.toDouble();

			QJsonValue nameValue = animation.value("name");
			if (!nameValue.isString()) {
				throw new QString("Invalid animation 'name' property");
			}
			QString name = nameValue.toString();

			QJsonValue descriptionValue = animation.value("description");
			if (!descriptionValue.isString()) {
				throw new QString("Invalid animation 'description' property");
			}
			QString description = descriptionValue.toString();

			animationResultList.append(new Animation(id, name, description));
		}

		emit animationsChanged(animationResultList);

	} catch (const QString& error) {
		qDebug() << "Disregarding invalid wall config message:" << error;
	}

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


