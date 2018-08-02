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
	Q_PROPERTY(int playMode READ playMode WRITE setPlayMode NOTIFY playModeChanged)
	Q_PROPERTY(QString socketError READ socketError NOTIFY socketError)

public:
	explicit VideoWallController(QObject *parent = nullptr);

	AnimationModel* getAnimationModel();

	// Property getters
	ConnectionState::Enum connectionState() const;
	int brightness() const;
	int playMode() const;

	QString socketError() const;
	int activeAnimationId() const;

signals:
	void activeAnimationIdChanged(int activeAnimationId);
	void activeAnimationChanged(int id, const QString& name, const QString& description);
	void brightnessChanged(int brightness);
	void playModeChanged(int playMode);

	void connectionStateChanged(ConnectionState::Enum state);
	void socketError(const QString& errorString);

public slots:
	void openSocket();
	void closeSocket();
	void setActiveAnimation(int animationId);
	void setBrightness(int brightness);
	void setPlayMode(int playMode);

private slots:
	void onActiveAnimationIdChanged(int id);
	void onBrightnessChanged(int brightness);
	void onPlayModeChanged(int playMode);

private:
	WebSocket*			_socket;
	AnimationModel*		_animationModel;
	Animation*			_activeAnimation;
	int					_brightness;
	int					_playMode;

};

#endif // VIDEOWALLCONTROLLER_H
