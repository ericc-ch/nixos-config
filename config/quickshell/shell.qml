import Quickshell
import QtQuick

Scope {
  id: root

  // Shared time property using SystemClock
  readonly property string time: Qt.formatDateTime(clock.date, "ddd MMM d hh:mm:ss AP t yyyy")

  SystemClock {
    id: clock
    precision: SystemClock.Seconds
  }

  // Create a bar for each screen
  Variants {
    model: Quickshell.screens

    PanelWindow {
      required property var modelData

      screen: modelData

      anchors {
        top: true
        left: true
        right: true
      }

      implicitHeight: 30

      Rectangle {
        anchors.fill: parent
        color: "#1d2021"

        Text {
          anchors.centerIn: parent
          text: root.time
          color: "#ebdbb2"
          font.pixelSize: 14
        }
      }
    }
  }
}
