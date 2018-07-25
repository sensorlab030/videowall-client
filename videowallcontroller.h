#ifndef VIDEOWALLCONTROLLER_H
#define VIDEOWALLCONTROLLER_H

#include <QObject>
#include "enums.h"
#include "animationmodel.h"

class WebSocket;

class VideoWallController : public QObject {
	Q_OBJECT
	Q_PROPERTY(ConnectionState::Enum connectionState READ connectionState NOTIFY connectionStateChanged)
	Q_PROPERTY(int activeAnimationId READ activeAnimationId NOTIFY activeAnimationIdChanged)
	Q_PROPERTY(QString socketError READ socketError NOTIFY socketError)

public:
	explicit VideoWallController(QObject *parent = nullptr);

	AnimationModel* getAnimationModel();

	// Property getters
	ConnectionState::Enum connectionState() const;
	QString socketError() const;
	int activeAnimationId() const;

signals:
	void connectionStateChanged(ConnectionState::Enum state);
	void activeAnimationIdChanged(int activeAnimationId);
	void socketError(const QString& errorString);

public slots:
	void openSocket();
	void setActiveAnimation(int animationId);

private:
	WebSocket*			_socket;
	AnimationModel*		_animationModel;
	Animation*			_activeAnimation;

};

#endif // VIDEOWALLCONTROLLER_H
