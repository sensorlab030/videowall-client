#ifndef ANIMATION_H
#define ANIMATION_H

#include <QObject>

class Animation : public QObject {
	Q_OBJECT
	Q_PROPERTY(int id READ id)
	Q_PROPERTY(QString name READ name)
	Q_PROPERTY(QString description READ description)
	Q_PROPERTY(bool active READ active NOTIFY activeChanged)

public:
	explicit Animation(int id, const QString& name, const QString& description, QObject *parent = nullptr);

	int			id() const;
	QString		name() const;
	QString		description() const;
	bool		active() const;

public slots:
	void handleActiveAnimationIdChange(int activeAnimationId);

signals:
	void activeChanged(bool active);

private:
	int			_id;
	QString		_name;
	QString		_description;
	bool		_active;

};

#endif // ANIMATION_H
