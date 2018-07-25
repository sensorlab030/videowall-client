#include "animationmodel.h"

#include "animation.h"
#include <QDebug>

AnimationModel::AnimationModel(QObject* parent) : QAbstractListModel(parent) {}

void AnimationModel::clear() {
	beginResetModel();
	qDeleteAll(_animations);
	_animations.clear();
	endResetModel();
}

void AnimationModel::addAnimation(Animation* animation) {
	beginInsertRows(QModelIndex(), rowCount(), rowCount());
	connect(animation, SIGNAL(activeChanged(bool)), this, SLOT(onAnimationActiveChanged(bool)));
	animation->setParent(this);
	_animations.append(animation);
	endInsertRows();
}

void AnimationModel::setAnimations(const QList<Animation*> &animations) {
	clear();
	foreach (Animation* animation, animations) {
		addAnimation(animation);
	}
}

QHash<int, QByteArray> AnimationModel::roleNames() const {
	QHash<int, QByteArray> roles;
	roles[IdRole] = "id";
	roles[NameRole] = "name";
	roles[DescriptionRole] = "description";
	roles[ActiveRole] = "active";
	return roles;
}

int AnimationModel::rowCount(const QModelIndex & parent) const {
	Q_UNUSED(parent);
	return _animations.count();
}

void AnimationModel::onAnimationActiveChanged(bool active) {
	Q_UNUSED(active);

	QVector<int> roles;
	roles.append(ActiveRole);

	QModelIndex topLeft = index(0, 0);
	QModelIndex bottomRight = index(_animations.size() - 1, 0);

	qDebug() << "AM: Update data" << 0 << _animations.size() - 1;
	emit dataChanged(topLeft, bottomRight, roles);
}

QVariant AnimationModel::data(const QModelIndex& index, int role) const {

	if (index.row() < 0 || index.row() >= _animations.count()) {
		return QVariant();
	}

	Animation* animation = _animations[index.row()];
	if (role == IdRole) {
		return animation->id();
	} else if (role == NameRole) {
		return animation->name();
	} else if (role == DescriptionRole) {
		return animation->description();
	} else if (role == ActiveRole) {
		return animation->active();
	} else {
		return QVariant();
	}

}

Animation* AnimationModel::getAnimation(int id) {

	QList<Animation*>::iterator i;
	for (i = _animations.begin(); i != _animations.end(); i++) {
		Animation* animation = *i;
		if (animation->id() == id) {
			return animation;
		}
	}

	return 0;

}
