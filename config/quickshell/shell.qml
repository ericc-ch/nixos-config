import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.UPower
import Quickshell.Services.Pipewire

Scope {
    id: root

    // Shared time property using SystemClock
    readonly property string time: Qt.formatDateTime(clock.date, "ddd MMM d hh:mm:ss AP t yyyy")

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }

    // Track the default audio sink for volume
    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    // Create a bar for each screen
    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property var modelData

            screen: modelData

            // Vertical bar anchored to the left side
            anchors {
                left: true
                top: true
                bottom: true
            }

            implicitWidth: 40

            Rectangle {
                anchors.fill: parent
                color: "#282828"

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 8
                    spacing: 12

                    // Battery section
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: "transparent"

                        Column {
                            anchors.centerIn: parent
                            spacing: 4

                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: {
                                    if (!UPower.displayDevice.ready)
                                        return "...";
                                    var pct = UPower.displayDevice.percentage;
                                    // UPower returns 0-100, but let's handle both cases
                                    return Math.round(pct <= 1 ? pct * 100 : pct) + "%";
                                }
                                color: "#ebdbb2"
                                font.pixelSize: 14
                                rotation: 270
                            }

                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: {
                                    if (!UPower.displayDevice.ready)
                                        return "?";
                                    if (UPower.displayDevice.state === UPowerDeviceState.Charging)
                                        return "⚡";
                                    if (UPower.displayDevice.state === UPowerDeviceState.Discharging)
                                        return "🔋";
                                    return "🔌";
                                }
                                color: "#ebdbb2"
                                font.pixelSize: 18
                                rotation: 270
                            }
                        }
                    }

                    // Audio volume section
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: "transparent"

                        Column {
                            anchors.centerIn: parent
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
                                    if (muted)
                                        return "🔇";
                                    if (vol > 0.7)
                                        return "🔊";
                                    if (vol > 0.3)
                                        return "🔉";
                                    return "🔈";
                                }
                                color: "#ebdbb2"
                                font.pixelSize: 18
                                rotation: 270
                            }
                        }
                    }

                    // Time section
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: "transparent"

                        Column {
                            anchors.centerIn: parent
                            spacing: 2

                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: Qt.formatDateTime(clock.date, "hh:mm")
                                color: "#ebdbb2"
                                font.pixelSize: 14
                                rotation: 270
                            }
                        }
                    }
                }
            }
        }
    }
}
