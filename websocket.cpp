#include "websocket.h"

#include <QDebug>
#include "animation.h"
#include "socketpropertynames.h"

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
	_socket->open(QUrl("ws://videowall.sensorlab:9003"));
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

		// Channel message to correct method
		if (msgType == WS_MSG_TYPE_CONFIG) {
			hanleWallConfigMsg(dataValue);
		} else if (msgType == WS_MSG_TYPE_PROPERTIES) {
			handlePropertyChangesMsg(dataValue);
		} else {
			throw new QString("Unknown message type");
		}

	} catch (const QString& error) {
		qWarning() << "Disregarding invalid message:" << error;
	}

}

void WebSocket::hanleWallConfigMsg(const QJsonValue& data) {

	try {

		// Check data
		if (data.isNull() || !data.isObject()) {
			throw new QString("Invalid data");
		}
		QJsonObject dataObj = data.toObject();

		// @TODO Static wall properties

		// Animations
		QJsonValue animationListValue = dataObj.value("animations");
		if (!animationListValue.isArray()) {
			throw new QString("Invalid 'animations' property");
		}
		QJsonArray animationList = animationListValue.toArray();

		QList<Animation*> animationResultList;
		QJsonArray::iterator it;
		for (it = animationList.begin(); it != animationList.end(); it++) {

			// Fetch object
			QJsonValue animationValue = *it;
			if (!animationValue.isObject()) {
				throw new QString("Invalid animation object");
			}
			QJsonObject animation = animationValue.toObject();

			// Fetch properties
			QJsonValue idValue = animation.value("id");
			if (!idValue.isDouble()) {
				throw new QString("Invalid animation 'id' property");
			}
			int id = idValue.toInt();

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

			Animation* animationObj = new Animation(id, name, description);
			connect(this, SIGNAL(activeAnimationIdChanged(int)), animationObj, SLOT(onActiveAnimationChanged(int)));

			animationResultList.append(animationObj);
		}

		emit animationsChanged(animationResultList);

	} catch (const QString& error) {
		qWarning() << "Disregarding invalid wall config message:" << error;
	}

}

void WebSocket::handlePropertyChangesMsg(const QJsonValue& data) {

	try {

		// Check data
		if (data.isNull() || !data.isArray()) {
			throw new QString("Invalid data");
		}
		QJsonArray propertyArray = data.toArray();

		// Loop over properties
		QJsonArray::iterator it;
		for (it = propertyArray.begin(); it != propertyArray.end(); it++) {
			QJsonValue propertyVal = *it;

			try {

				// Parse to object
				if (!propertyVal.isObject()) {
					throw new QString("invalid object");
				}
				QJsonObject propertyObj = propertyVal.toObject();

				// Parse scope
				QJsonValue scopeValue = propertyObj.value("scope");
				if (!scopeValue.isString()) {
					throw new QString("'scope' property invalid");
				}
				QString scope = scopeValue.toString();

				// Parse name
				QJsonValue nameValue = propertyObj.value("name");
				if (!nameValue.isString()) {
					throw new QString("'name' property invalid");
				}
				QString name = nameValue.toString();

				// Parse value
				QJsonValue valueValue = propertyObj.value("value");
				if (valueValue.isNull()) {
					throw new QString("'value' property invalid");
				}
				QVariant value = valueValue.toVariant();

				if (scope == "wall") {

					// Handle property change
					handleWallPropertyChange(name, value);

				} else if (scope == "animation") {

					QJsonValue animationIdValue = propertyObj.value("animationId");
					if (!animationIdValue.isDouble()) {
						throw new QString("'animationId' property invalid");
					}
					int animationId = animationIdValue.toInt();

					// Handle property change
					handleAnimationPropertyChange(animationId, name, value);

				} else {
					throw new QString("'scope' property value invalid");
				}

			} catch (const QString& error) {
				qWarning() << "Ignoring property msg, " << error;
			}

		}

	} catch (const QString& error) {
		qWarning() << "Disregarding invalid active animation change message:" << error;
	}

}

void WebSocket::handleWallPropertyChange(const QString& propertyName, const QVariant& value) {
	if (propertyName == WS_WALL_ACTIVE_ANIMATION_ID) {
		emit activeAnimationIdChanged(value.toInt());
	} else if (propertyName == WS_WALL_BRIGHTNESS) {
		emit brightnessChanged(value.toInt());
	} else if (propertyName == WS_WALL_PLAYMODE) {
		emit playModeChange(value.toInt());
	}
}

void WebSocket::handleAnimationPropertyChange(int animationId, const QString& propertyName, const QVariant& value) {
	qDebug() << "handle animProp" << animationId << propertyName << value;
}

void WebSocket::sendActivateAnimationId(int activeAnimationId) {
	sendWallPropertyChange(WS_WALL_ACTIVE_ANIMATION_ID, activeAnimationId);
}

void WebSocket::sendBrightness(int brightness) {
	sendWallPropertyChange(WS_WALL_BRIGHTNESS, brightness);
}

void WebSocket::sendPlayMode(int playmode) {
	sendWallPropertyChange(WS_WALL_PLAYMODE, playmode);
}


void WebSocket::sendWallPropertyChange(const QString& propertyName, const QVariant& value) {

	// Add property
	QJsonObject propertyObject;
	propertyObject.insert("scope", "wall");
	propertyObject.insert("name", propertyName);
	propertyObject.insert("value", QJsonValue::fromVariant(value));

	// Set data
	QJsonArray data;
	data.append(propertyObject);

	QJsonObject rootObject;
	rootObject.insert("msg", WS_MSG_TYPE_PROPERTIES);
	rootObject.insert("data", data);

	// Create document root
	QJsonDocument document;
	document.setObject(rootObject);

	// Send message
	_socket->sendTextMessage(document.toJson());

}

void WebSocket::sendAnimationPropertyChange(int animationId, const QString& propertyName, const QVariant& value) {
}

QString WebSocket::errorString() const {
	return _errorString;
}

void WebSocket::onSocketError(QAbstractSocket::SocketError error) {
	if (_errorString != _socket->errorString()) {
		_errorString = _socket->errorString();

		qWarning() << "Socket error:" << error << _errorString;
		emit errorString(_errorString);
	}
}


