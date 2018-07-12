#ifndef ENUMS_H
#define ENUMS_H

#include <QObject>

class ConnectionState : public QObject {
	Q_OBJECT

public:
	enum class Enum : quint8 {
		DISCONNECTED = 0,
		CONNECTING = 1,
		CONNECTED = 2
	};
	Q_ENUM(Enum)

};

#endif // ENUMS_H
