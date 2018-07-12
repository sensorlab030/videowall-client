#ifndef ANIMATION_H
#define ANIMATION_H

#include <QObject>

class Animation : public QObject {
	Q_OBJECT
	Q_PROPERTY(int id READ id)
	Q_PROPERTY(QString name READ name)

public:
	explicit Animation(QObject *parent = nullptr);

signals:

public slots:

public:
	int id() const;
	QString name() const;

private:
	int			_id;
	QString		_name;

};

#endif // ANIMATION_H
