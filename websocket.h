#ifndef WEBSOCKET_H
#define WEBSOCKET_H

#include <QObject>
#include <QWebSocket>
#include <QJsonDocument>
#include <QJsonValue>
#include <QJsonArray>
#include <QJsonObject>
#include <QList>

#include "enums.h"

class Animation;

class WebSocket : public QObject {
	Q_OBJECT

public:
	explicit WebSocket(QObject *parent = nullptr);

	ConnectionState::Enum	connectionState() const;
	QString					errorString() const;

signals:
	// Content signals
	void animationsChanged(const QList<Animation*> &animations);
	void activeAnimationIdChanged(int id);
	void brightnessChanged(int brightness);
	void playModeChange(int playMode);

	// Connection signals
	void connectionStateChanged(ConnectionState::Enum state);
	void errorString(const QString& errorString);

public slots:
    void open(const QString &url);
	void close();

	// Property change requests
	void sendActivateAnimationId(int activeAnimationId);
	void sendBrightness(int brightness);
	void sendPlayMode(int playMode);

private slots:
	void onStateChanged(QAbstractSocket::SocketState state);
	void onSocketError(QAbstractSocket::SocketError error);
	void onMessage(const QString& message);

private:
	void hanleWallConfigMsg(const QJsonValue& data);
	void handlePropertyChangesMsg(const QJsonValue& data);
	void handleWallPropertyChange(const QString& propertyName, const QVariant& value);
	void handleAnimationPropertyChange(int animationId, const QString& propertyName, const QVariant& value);
	void sendWallPropertyChange(const QString& propertyName, const QVariant& value);
	void sendAnimationPropertyChange(int animationId, const QString& propertyName, const QVariant& value);

	QWebSocket*				_socket;
	ConnectionState::Enum	_connectionState;
	QString					_errorString;

};

#endif // WEBSOCKET_H
