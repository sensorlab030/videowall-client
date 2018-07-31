#ifndef ANIMATIONMODEL_H
#define ANIMATIONMODEL_H

#include <QAbstractListModel>
#include <QByteArray>
#include <QHash>
#include <QList>

class Animation;

class AnimationModel : public QAbstractListModel {
	Q_OBJECT

public:
	enum AnimationRoles {
		IdRole = Qt::UserRole + 1,
		NameRole,
		DescriptionRole,
		ActiveRole
	};

	explicit AnimationModel(QObject* parent = nullptr);

	QHash<int, QByteArray> roleNames() const;

	int rowCount(const QModelIndex& parent = QModelIndex()) const;
	QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const;

	Animation* getAnimation(int id);

public slots:
	void clear();
	void addAnimation(Animation* animation);
	void setAnimations(const QList<Animation*> &animations);

private slots:
	void onAnimationPropertyChanged();

private:
	QList<Animation*>	_animations;

};

#endif // ANIMATIONMODEL_H
