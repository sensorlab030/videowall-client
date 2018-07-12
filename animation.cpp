#include "animation.h"

Animation::Animation(QObject *parent) : QObject(parent) {

}

int Animation::id() const {
	return _id;
}

QString Animation::name() const {
	return _name;
}
