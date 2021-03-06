import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2
import org.subsurfacedivelog.mobile 1.0
import QtQuick.Layouts 1.0

Rectangle {
	id: page
	objectName: "DiveList"

	Component {
		id: diveDelegate
		Item {
			id: dive

			property real detailsOpacity : 0

			width: diveListView.width - units.spacing
			height: childrenRect.height

			//Mouse region: When clicked, the mode changes to details view
			MouseArea {
				anchors.fill: parent
				onClicked: {
					detailsWindow.width = parent.width
					detailsWindow.location = location
					detailsWindow.dive_id = id
					detailsWindow.buddy = buddy
					detailsWindow.suit = suit
					detailsWindow.airtemp = airtemp
					detailsWindow.watertemp = watertemp
					detailsWindow.divemaster = divemaster
					detailsWindow.notes = notes
					detailsWindow.number = diveNumber
					detailsWindow.date = date
					stackView.push(detailsWindow)
				}
			}

			//Layout of the page: (mini profile, dive no, date at the top
			//And other details at the bottom.
			Item {
				x: units.spacing
				width: parent.width - units.spacing * 2
				height: childrenRect.height + units.spacing * 2
				//spacing: units.spacing / 2
				anchors.margins: units.spacing

				Text {
					id: locationText
					text: location
					color: theme.textColor
					scale: 1.1 // Let's see how this works, otherwise, we'll need the default point size somewhere
					transformOrigin: Item.TopLeft
					anchors {
						left: parent.left
						top: parent.top
					}
				}
				Text {
					text: date
					opacity: 0.6
					color: theme.textColor
					anchors {
						right: parent.right
						top: parent.top
						bottomMargin: units.spacing / 2
					}
				}
				Row {
					id: descriptionText
					anchors {
						left: parent.left
						right: parent.right
						bottom: numberText.bottom
					}
					Text {
						text: 'Depth: '
						opacity: 0.6
						color: theme.textColor
					}
					Text {
						text: depth
						width: Math.max(units.gridUnit * 3, paintedWidth) // helps vertical alignment throughout listview
						color: theme.textColor
					}
					Text {
						text: 'Duration: '
						opacity: 0.6
						color: theme.textColor
					}
					Text {
						text: duration
						color: theme.textColor
					}
				}
				Text {
					id: numberText
					text: "#" + diveNumber
					color: theme.textColor
					scale: 1.2
					transformOrigin: Item.BottomRight
					opacity: 0.4
					anchors {
						right: parent.right
						topMargin: units.spacing
						top: locationText.bottom
					}
				}
				//Text { text: location; width: parent.width }
				Rectangle {
					color: theme.textColor
					opacity: .2
					height: Math.max(1, units.gridUnit / 24) // we really want a thin line
					anchors {
						left: parent.left
						right: parent.right
						top: numberText.bottom
					}
				}
			}
		}
	}

	Component {
		id: tripHeading
		Item {
			width: page.width - units.spacing * 2
			height: childrenRect.height + units.spacing * 2

			Text {
				id: sectionText
				text: section
				anchors {
					top: parent.top
					left: parent.left
					leftMargin: units.spacing
					right: parent.right
				}
				color: theme.textColor
				font.pointSize: 16
			}
			Rectangle {
				height: Math.max(2, units.gridUnit / 12) // we want a thicker line
				anchors {
					top: sectionText.bottom
					left: parent.left
					leftMargin: units.spacing
					right: parent.right
				}
				color: theme.accentColor
			}
		}
	}

	ListView {
		id: diveListView
		anchors.fill: parent
		model: diveModel
		delegate: diveDelegate
		boundsBehavior: Flickable.StopAtBounds
		//highlight: Rectangle { color: theme.highlightColor; width: units.spacing }
		focus: true
		clip: true
		section.property: "trip"
		section.criteria: ViewSection.FullString
		section.delegate: tripHeading
	}
}
