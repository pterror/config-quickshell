function rectsOverlap(a, b, gap = 16) {
	return !(
		a.x + a.width + gap <= b.x ||
		b.x + b.width + gap <= a.x ||
		a.y + a.height + gap <= b.y ||
		b.y + b.height + gap <= a.y
	)
}

function findOpenPosition(config, widgetType, desiredX, desiredY, width, height) {
	const instances = config._widgetInstancesArray()
	const placed = instances.map((instance, index) => config.widgetGeometry(instance, index, instances))
	const screen = config.screens.primary
	const margin = 16
	const step = 32
	const maxX = Math.max(margin, (screen?.width ?? 1920) - width - margin)
	const maxY = Math.max(margin, (screen?.height ?? 1080) - height - margin)
	let x = Math.max(margin, Math.min(desiredX ?? margin, maxX))
	let y = Math.max(margin, Math.min(desiredY ?? margin, maxY))

	for (let attempt = 0; attempt < 1024; ++attempt) {
		const candidate = { x, y, width, height }
		if (!placed.some(rect => rectsOverlap(candidate, rect)))
			return candidate

		x += step
		if (x > maxX) {
			x = margin
			y += step
			if (y > maxY)
				y = margin
		}
	}

	return { x, y, width, height }
}

export function openWidget(config, widgetType, options = {}) {
	if (options.reuseExisting) {
		const existing = config._widgetInstancesArray().find(instance => instance.type === widgetType)
		if (existing) {
			config._.widgets.visible = options.visible ?? true
			config._.widgets.editMode = options.editMode ?? config._.widgets.editMode
			return existing.id
		}
	}

	const fallback = config.widgetDefaultGeometry(widgetType)
	const width = options.width ?? fallback.width
	const height = options.height ?? fallback.height
	const placement = findOpenPosition(config, widgetType, options.x, options.y, width, height)
	const initialState = {
		x: placement.x,
		y: placement.y,
	}
	if (options.width !== undefined) initialState.width = options.width
	if (options.height !== undefined) initialState.height = options.height
	const instanceId = config.addWidgetInstance(widgetType, initialState)
	config._.widgets.visible = options.visible ?? true
	config._.widgets.editMode = options.editMode ?? true
	return instanceId
}

export function toggleOverlay(config) {
	const nextVisible = !config._.widgets.visible
	config._.widgets.visible = nextVisible
	if (!nextVisible)
		config._.widgets.editMode = false
	config.writeConfig()
}
