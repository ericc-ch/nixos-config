import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Services.UPower
import QtQuick
import QtQuick.Layouts

Scope {
    id: root

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property var modelData

            screen: modelData

            anchors {
                left: true
                top: true
                bottom: true
            }

            implicitWidth: 40

            Rectangle {
                anchors.fill: parent
                color: "#1d2021"

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 8
                    spacing: 12

                    ClockSection {}

                    Item {
                        Layout.fillHeight: true
                    }

                    AudioSection {}

                    BatterySection {}
                }
            }
        }
    }

    component ClockSection: Column {
        spacing: 2

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: Qt.formatDateTime(clock.date, "hh:mm")
            color: "#ebdbb2"
            font.pixelSize: 14
            rotation: 270
        }
    }

    component AudioSection: Column {
        spacing: 4

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: {
                var vol = Pipewire.defaultAudioSink?.audio?.volume ?? 0;
                return Math.round(vol * 100) + "%";
            }
            color: "#ebdbb2"
            font.pixelSize: 14
            rotation: 270
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: {
                var muted = Pipewire.defaultAudioSink?.audio?.muted ?? false;
                var vol = Pipewire.defaultAudioSink?.audio?.volume ?? 0;
                if (muted) return "M";
                if (vol > 0.7) return "V";
                if (vol > 0.3) return "v";
                return ".";
            }
            color: "#ebdbb2"
            font.pixelSize: 18
            rotation: 270
        }
    }

    component BatterySection: Column {
        spacing: 4

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: {
                if (!UPower.displayDevice.ready) return "...";
                var pct = UPower.displayDevice.percentage;
                return Math.round(pct <= 1 ? pct * 100 : pct) + "%";
            }
            color: "#ebdbb2"
            font.pixelSize: 14
            rotation: 270
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: {
                if (!UPower.displayDevice.ready) return "?";
                if (UPower.displayDevice.state === UPowerDeviceState.Charging) return "+";
                if (UPower.displayDevice.state === UPowerDeviceState.Discharging) return "-";
                return "=";
            }
            color: "#ebdbb2"
            font.pixelSize: 18
            rotation: 270
        }
    }
}