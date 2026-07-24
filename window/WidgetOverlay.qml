import Quickshell
import Quickshell.Wayland
import QtQuick
import qs.io
import qs.component
import qs

// Hosts desktop-gadget-style widget instances from `Config._.widgets.instances`.
// One fullscreen layer-shell host per screen; input is shaped to the actual widget items
// via `mask`, matching the way the shell already handles sparse decorative surfaces.
Item {
	id: root
	property list<var> extraGrabWindows: []
	readonly property bool isBackground: Config._.widgets.mode === "background"
	property bool shouldShow: isBackground || Config._.widgets.visible || Config._.widgets.editMode

	visible: false

	function managerInstance() {
		const instances = Config._.widgets.instances ?? []
		for (let i = instances.length - 1; i >= 0; --i) {
			if (instances[i].type === "WidgetPaletteWidget") return instances[i]
		}
		return null
	}

	Variants {
		model: Config._.widgetsAcrossAllScreens ? Quickshell.screens : [Config.screens.primary]

		Scope {
			required property var modelData

			PanelWindow {
				id: window
				screen: modelData
				color: "transparent"
				exclusionMode: ExclusionMode.Ignore
				WlrLayershell.namespace: "shell:widgets"
				WlrLayershell.layer: root.isBackground ? WlrLayer.Background : WlrLayer.Overlay
				WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
				anchors { top: true; bottom: true; left: true; right: true }
				visible: root.shouldShow

				contentItem.focus: true

				mask: Region {
					id: maskRoot

					Region {
						item: managerLoader.item
					}
				}

				Loader {
					id: managerLoader
					property var instance: root.shouldShow ? root.managerInstance() : null
					active: !!instance
					sourceComponent: instance ? Config.widgetDefinition("WidgetPaletteWidget")?.component ?? null : null

					onLoaded: {
						item.instanceId = instance.id
						item.widgetType = instance.type
						item.index = 0
					}
				}

				property var widgetRegionsById: ({})
				property var widgetItemsById: ({})

				function ensureRegion(instanceId, item) {
					if (!instanceId || !item)
						return
					if (widgetRegionsById[instanceId]) {
						widgetRegionsById[instanceId].item = item
						maskRoot.changed()
						return
					}

					const region = Qt.createQmlObject(
						'import Quickshell; Region {}',
						window,
						`widgetRegion:${instanceId}`
					)
					if (!region)
						return

					region.item = item
					if (maskRoot.regions?.push)
						maskRoot.regions.push(region)

					const next = Object.assign({}, widgetRegionsById)
					next[instanceId] = region
					widgetRegionsById = next
					maskRoot.changed()
				}

				function clearDynamicWidgets() {
					for (const region of Object.values(widgetRegionsById))
						region.destroy()
					for (const item of Object.values(widgetItemsById))
						item.destroy()
					widgetRegionsById = ({})
					widgetItemsById = ({})
					maskRoot.changed()
				}

				function syncDynamicWidgets() {
					const instances = (Config._.widgets.instances ?? []).filter(instance => instance.type !== "WidgetPaletteWidget")
					const desiredIds = {}

					if (!root.shouldShow) {
						clearDynamicWidgets()
						return
					}

					for (let i = 0; i < instances.length; ++i) {
						const instance = instances[i]
						desiredIds[instance.id] = true

						const existingItem = widgetItemsById[instance.id]
						if (existingItem) {
							existingItem.index = i + (managerLoader.active ? 1 : 0)
							existingItem.widgetType = instance.type
							window.ensureRegion(instance.id, existingItem)
							continue
						}

						const definition = Config.widgetDefinition(instance.type)
						if (!definition?.component)
							continue

						const item = definition.component.createObject(window.contentItem, {
							instanceId: instance.id,
							widgetType: instance.type,
							index: i + (managerLoader.active ? 1 : 0),
						})
						if (!item)
							continue

						const nextItems = Object.assign({}, widgetItemsById)
						nextItems[instance.id] = item
						widgetItemsById = nextItems
						window.ensureRegion(instance.id, item)
					}

					for (const instanceId of Object.keys(widgetItemsById)) {
						if (desiredIds[instanceId])
							continue
						widgetItemsById[instanceId].destroy()
						const nextItems = Object.assign({}, widgetItemsById)
						delete nextItems[instanceId]
						widgetItemsById = nextItems
						window.removeRegion(instanceId)
					}

					maskRoot.changed()
				}

				function removeRegion(instanceId) {
					const region = widgetRegionsById[instanceId]
					if (!region)
						return
					region.destroy()
					const next = Object.assign({}, widgetRegionsById)
					delete next[instanceId]
					widgetRegionsById = next
					maskRoot.changed()
				}

				Connections {
					target: Config._.widgets
					function onVisibleChanged() {
						if (Config._.widgets.visible || Config._.widgets.editMode)
							return
						window.clearDynamicWidgets()
					}
					function onInstancesChanged() {
						Qt.callLater(window.syncDynamicWidgets)
					}
				}

				Component.onCompleted: syncDynamicWidgets()
				onVisibleChanged: Qt.callLater(syncDynamicWidgets)
			}
		}
	}
}
