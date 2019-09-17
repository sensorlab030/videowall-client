import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Dialogs 1.2
import QtQuick.Controls.Material 2.2

Item {
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.leftMargin: 20
    anchors.rightMargin: 20
    height: 80

    Row {
        anchors.fill: parent
        spacing: gridSize

        Label {
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: fontSizeNormal
            text: "Host: " + controller.hostUrl            
        }
        ActionBarButton {
            id: editButton
            size: gridSize * 2
            onClicked: hostDialog.visible = true
            iconSource: "static/icons/baseline-settings.svg"
        }
    }

    Dialog {
        id: hostDialog
        visible: false
        title: "Set host settings"
        standardButtons: StandardButton.Apply | StandardButton.Cancel

        onVisibilityChanged: {
            hostUrlText.text = controller.hostUrl
        }

        onApply: {
            controller.setHostUrl(hostUrlText.text);
            controller.openSocket();
            close();
        }

        contentItem: Column {
            anchors.fill: parent

            Row {
                Text {
                    text: "Host"
                }
                TextField {
                    id: hostUrlText
                    text: controller.hostUrl
                }
            }

            Row {
                Button {
                    text: "Apply"
                    onClicked: hostDialog.apply()
                }
                Button {
                    text: "Cancel"
                    onClicked: hostDialog.close()
                }
            }
        }
    }
}
