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
	void connectionStateChanged(ConnectionState::Enum state);
	void animationsChanged(const QList<Animation*> &animations);
	void errorString(const QString& errorString);

public slots:
	void open();
	void close();

private slots:
	void onStateChanged(QAbstractSocket::SocketState state);
	void onSocketError(QAbstractSocket::SocketError error);
	void onMessage(const QString& message);

private:
	void hanleWallConfigMsg(const QJsonObject& data);

	QWebSocket*				_socket;
	ConnectionState::Enum	_connectionState;
	QString					_errorString;

};

#endif // WEBSOCKET_H
