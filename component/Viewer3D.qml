import QtQuick
import QtQuick3D
import QtQuick3D.Helpers

View3D {
	id: root
	anchors.fill: parent
	property alias clearColor: environment.clearColor
	// Initial camera pose, in worldspace. This is ground truth: it's captured
	// once in Component.onCompleted (as initialOffset/initialRotation below)
	// and never overwritten afterwards. The orbit controller applies user
	// interaction as a DELTA on top of this captured pose each frame, so with
	// no interaction the camera stays exactly where these three + rotation
	// put it — writing to these after startup still has no lasting effect,
	// but the startup pose itself is now preserved exactly, not recomputed.
	property alias cameraX: camera.x
	property alias cameraY: camera.y
	property alias cameraZ: camera.z
	property alias cameraRotation: camera.rotation

	// Orbit controls: rotation orbits a worldspace pivot ("orbitTarget", the
	// model origin by default) instead of spinning the camera in place, and
	// right-drag pans that pivot instead of a WASD keyboard controller.
	property vector3d orbitTarget: Qt.vector3d(0, 0, 0)
	// -1 = derive from the initial camera position relative to orbitTarget.
	property real orbitDistance: -1
	property real minDistance: 1
	property real maxDistance: 10000
	property real minPitch: -89
	property real maxPitch: 89
	// Degrees of impulse per pixel dragged. Defaults to a full screen-width
	// drag rotating ~180 degrees; overriding with a literal breaks the
	// binding to root.width, same as any other QML property default.
	property real yawSpeed: 180 / Math.max(1, root.width)
	property real pitchSpeed: 180 / Math.max(1, root.width)
	// Multiplier on top of the exact projected mouse-to-world scale (see
	// panWorldPerPixel below), which alone gives a 1:1 mapping at the orbit
	// plane: dragging N pixels moves the point under orbitTarget ~N pixels
	// on screen. 1 = exact 1:1; keep as a knob for taste.
	property real panSpeed: 1
	// World units per screen pixel at the orbit plane (the plane through
	// orbitTarget, perpendicular to the view direction, at orbitDistance
	// from the camera) — derived from the perspective projection so pan
	// tracks the cursor exactly regardless of distance or FOV.
	property real panWorldPerPixel: root.panSpeed *
		2 * root.orbitDistance * Math.tan(camera.fieldOfView * Math.PI / 360) / Math.max(1, root.height)
	property real zoomSpeed: 1.1 // distance multiplier per wheel notch

	// Momentum: how long motion keeps coasting after the drag ends. 0 stops
	// instantly; closer to 1 coasts for longer. Configured separately for
	// orbit rotation and panning, per the semantics of MomentumAnimation's
	// own `momentum` property (see component/MomentumAnimation.qml).
	property real angularMomentum: 0.35
	property real panMomentum: 0.35

	// Rubber-band spring: gently pulls orbitTarget back toward orbitHome
	// (captured at startup) the further it's been panned away. 0 disables
	// it. Modeled the same way as the analog clock's hand-release spring
	// (widget/AnalogClock.qml) and MomentumAnimation's decay: a per-second
	// retained fraction raised to frameTime, so it's framerate-independent
	// and — because the pull is proportional to displacement — negligible
	// near home and increasingly noticeable the further out you've panned.
	property real panSpringPull: 0.15 // fraction of displacement-from-home pulled back per second
	// Activation threshold: inside this radius of orbitHome, the spring is
	// completely off (free panning); only once displacement exceeds it does
	// the pull above start decaying orbitTarget back toward home.
	property real panSpringRadius: 30 // world units
	property real panSpringEpsilon: 0.1 // world units; below this (from home), snap to home instead of decaying forever
	property vector3d orbitHome: Qt.vector3d(0, 0, 0) // captured from the initial orbitTarget in Component.onCompleted

	property real yaw: 0
	property real pitch: 0
	// Baseline captured once in Component.onCompleted: the yaw/pitch values
	// above *at that moment* (before any interaction). yaw/pitch keep
	// accumulating from there exactly as before; updateCamera() below only
	// ever rotates the ground-truth initial pose by (yaw - initialYaw,
	// pitch - initialPitch), i.e. the delta since startup — never by the
	// absolute yaw/pitch recomputed from scratch.
	property real initialYaw: 0
	property real initialPitch: 0
	// Ground-truth initial pose, captured once in Component.onCompleted and
	// never touched again: initialOffset is the camera's starting position
	// relative to orbitTarget, initialRotation its starting rotation. Every
	// frame, updateCamera() rotates *these* by the interaction delta above,
	// instead of recomputing an absolute position/rotation from yaw/pitch/
	// orbitDistance — that recompute is what used to silently overwrite
	// cameraX/Y/Z/cameraRotation even with zero interaction.
	property vector3d initialOffset: Qt.vector3d(0, 0, 0)
	property quaternion initialRotation: Qt.quaternion(1, 0, 0, 0)

	environment: SceneEnvironment {
		id: environment
		backgroundMode: SceneEnvironment.Color
		clearColor: "#789"
	}

	PerspectiveCamera {
		id: camera
	}

	DirectionalLight {
		brightness: 0.2
		ambientColor: "#c0c0c0"
	}

	MomentumAnimation {
		id: yawMomentum
		momentum: root.angularMomentum
	}
	MomentumAnimation {
		id: pitchMomentum
		momentum: root.angularMomentum
	}
	MomentumAnimation {
		id: panRightMomentum
		momentum: root.panMomentum
	}
	MomentumAnimation {
		id: panUpMomentum
		momentum: root.panMomentum
	}

	function stopMomentum() {
		yawMomentum.stop()
		pitchMomentum.stop()
		panRightMomentum.stop()
		panUpMomentum.stop()
	}

	// Rotates the ground-truth initial offset/rotation by the interaction
	// delta accumulated in yaw/pitch since startup (zero delta = identity
	// rotation = initial pose reproduced exactly), rescales that offset to
	// the current orbitDistance (so wheel zoom works without touching
	// rotation), and re-centers it on the current (possibly panned)
	// orbitTarget. Never recomputes an absolute position/rotation from
	// yaw/pitch/orbitDistance alone — that formula can't reproduce a pose
	// that wasn't exactly "looking at orbitTarget" to begin with, which is
	// exactly how the initial cameraX/Y/Z/cameraRotation used to get
	// silently overwritten.
	function updateCamera() {
		const deltaRotation = Quaternion.fromEulerAngles(
			root.pitch - root.initialPitch,
			root.yaw - root.initialYaw,
			0
		)
		const rotatedOffset = deltaRotation.times(root.initialOffset)
		const offsetLength = rotatedOffset.length()
		const scaledOffset = offsetLength > 0
			? rotatedOffset.times(root.orbitDistance / offsetLength)
			: rotatedOffset
		camera.position = root.orbitTarget.plus(scaledOffset)
		camera.rotation = deltaRotation.times(root.initialRotation)
	}

	Component.onCompleted: {
		root.orbitHome = root.orbitTarget
		// Capture the ground-truth initial pose exactly as set by
		// cameraX/Y/Z/cameraRotation (via PterrorShell.qml). This is never
		// touched again — see initialOffset/initialRotation's doc comment.
		root.initialOffset = camera.position.minus(root.orbitTarget)
		root.initialRotation = camera.rotation
		if (root.orbitDistance < 0) {
			root.orbitDistance = Math.max(root.minDistance, root.initialOffset.length())
			// Derive yaw/pitch from the camera's actual facing direction
			// (cameraRotation), not just its position relative to
			// orbitTarget: the initial pose is tuned by eye and may not
			// point exactly at orbitTarget, and camera.forward is the only
			// thing that captures that. `forward` is target-minus-camera
			// (unit vector); our yaw/pitch parametrize camera-minus-target,
			// i.e. -forward.
			const f = camera.forward
			const horizontal = Math.sqrt(f.x * f.x + f.z * f.z)
			root.yaw = Math.atan2(-f.x, -f.z) * 180 / Math.PI
			root.pitch = Math.atan2(-f.y, horizontal) * 180 / Math.PI
		}
		// yaw/pitch above are the starting values (either derived just now,
		// or their declared defaults if orbitDistance was set explicitly);
		// initialYaw/initialPitch freeze that starting point as the delta
		// baseline for updateCamera(). Deliberately NOT calling
		// updateCamera() here: camera.position/rotation already hold the
		// exact initial pose, and with yaw == initialYaw / pitch ==
		// initialPitch the delta is zero anyway, so skipping it just avoids
		// a redundant (and floating-point-lossy) round trip.
		root.initialYaw = root.yaw
		root.initialPitch = root.pitch
	}

	FrameAnimation {
		running: true
		onTriggered: {
			const orbiting = yawMomentum.velocity !== 0 || pitchMomentum.velocity !== 0
			const panning = panRightMomentum.velocity !== 0 || panUpMomentum.velocity !== 0
			const homeDelta = root.orbitTarget.minus(root.orbitHome)
			const springing = root.panSpringPull > 0 && homeDelta.length() > root.panSpringRadius
			if (!orbiting && !panning && !springing) return

			if (orbiting) {
				root.yaw = (root.yaw + yawMomentum.velocity) % 360
				root.pitch = Math.max(root.minPitch, Math.min(root.maxPitch, root.pitch + pitchMomentum.velocity))
			}

			if (panning) {
				const yawRad = root.yaw * Math.PI / 180
				const right = Qt.vector3d(Math.cos(yawRad), 0, -Math.sin(yawRad))
				const up = Qt.vector3d(0, 1, 0)
				const scale = root.panWorldPerPixel
				const dRight = panRightMomentum.velocity * scale
				const dUp = panUpMomentum.velocity * scale
				root.orbitTarget = Qt.vector3d(
					root.orbitTarget.x + right.x * dRight + up.x * dUp,
					root.orbitTarget.y + right.y * dRight + up.y * dUp,
					root.orbitTarget.z + right.z * dRight + up.z * dUp
				)
			}

			// Rubber-band spring, applied last so it acts on this frame's
			// panned position too. Framerate-independent exponential decay
			// toward orbitHome — see panSpringPull's doc comment above.
			if (springing) {
				const retain = Math.pow(1 - root.panSpringPull, frameTime)
				const pulled = root.orbitTarget.minus(root.orbitHome).times(retain)
				root.orbitTarget = pulled.length() > root.panSpringEpsilon
					? root.orbitHome.plus(pulled)
					: root.orbitHome
			}

			updateCamera()
		}
	}

	MouseArea {
		anchors.fill: parent
		acceptedButtons: Qt.LeftButton | Qt.RightButton
		property real prevX: 0
		property real prevY: 0
		onPressed: event => {
			prevX = event.x
			prevY = event.y
			root.stopMomentum()
		}
		onPositionChanged: event => {
			const dx = event.x - prevX
			const dy = event.y - prevY
			prevX = event.x
			prevY = event.y
			if (pressedButtons & Qt.RightButton) {
				panRightMomentum.impulse(-dx)
				panUpMomentum.impulse(dy)
			} else if (pressedButtons & Qt.LeftButton) {
				yawMomentum.impulse(-dx * root.yawSpeed)
				pitchMomentum.impulse(dy * root.pitchSpeed)
			}
		}
		onWheel: event => {
			root.orbitDistance = Math.max(root.minDistance, Math.min(root.maxDistance,
				root.orbitDistance * Math.pow(root.zoomSpeed, -event.angleDelta.y / 120)))
			root.updateCamera()
		}
	}
}
