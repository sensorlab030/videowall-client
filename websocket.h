#ifndef WEBSOCKET_H
#define WEBSOCKET_H

#include <QObject>
#include <QWebSocket>
#include "enums.h"

class WebSocket : public QObject {
	Q_OBJECT

public:
	explicit WebSocket(QObject *parent = nullptr);

	ConnectionState::Enum	connectionState() const;
	QString					errorString() const;

signals:
	void connectionStateChanged(ConnectionState::Enum state);
	void errorString(const QString& errorString);

public slots:
	void open();
	void close();

private slots:
	void onStateChanged(QAbstractSocket::SocketState state);
	void onSocketError(QAbstractSocket::SocketError error);
	void onMessage(const QString& message);

private:
	QWebSocket*				_socket;
	ConnectionState::Enum	_connectionState;
	QString					_errorString;

};

#endif // WEBSOCKET_H
