#ifndef VIDEOWALLCONTROLLER_H
#define VIDEOWALLCONTROLLER_H

#include <QObject>
#include "enums.h"

class VideoWallController : public QObject {
	Q_OBJECT
	Q_PROPERTY(ConnectionState::Enum connectionState READ connectionState NOTIFY connectionStateChanged)

public:
	explicit VideoWallController(QObject *parent = nullptr);

	ConnectionState::Enum connectionState() const;

signals:
	void connectionStateChanged(ConnectionState::Enum state);

private slots:
	void toggleConnectedDev();
	void setConnectionState(ConnectionState::Enum state);

private:

	// Connectivity
	QString					_address;
	int						_port;
	ConnectionState::Enum	_connectionState;

};

#endif // VIDEOWALLCONTROLLER_H
