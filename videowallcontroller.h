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
	Q_PROPERTY(int brightness READ brightness WRITE setBrightness NOTIFY brightnessChanged)
	Q_PROPERTY(QString socketError READ socketError NOTIFY socketError)

public:
	explicit VideoWallController(QObject *parent = nullptr);

	AnimationModel* getAnimationModel();

	// Property getters
	ConnectionState::Enum connectionState() const;
	int brightness() const;

	QString socketError() const;
	int activeAnimationId() const;

signals:
	void activeAnimationIdChanged(int activeAnimationId);
	void activeAnimationChanged(int id, const QString& name);
	void brightnessChanged(int brightness);

	void connectionStateChanged(ConnectionState::Enum state);
	void socketError(const QString& errorString);

public slots:
	void openSocket();
	void closeSocket();
	void setActiveAnimation(int animationId);
	void setBrightness(int brightness);

private slots:
	void onActiveAnimationIdChanged(int id);
	void onBrightnessChanged(int brightness);

private:
	WebSocket*			_socket;
	AnimationModel*		_animationModel;
	Animation*			_activeAnimation;
	int					_brightness;

};

#endif // VIDEOWALLCONTROLLER_H
