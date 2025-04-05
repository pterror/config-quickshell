// @ts-nocheck
/**
 * Bundled by jsDelivr using Rollup v2.79.2 and Terser v5.37.0.
 * Original file: /npm/temporal-polyfill@0.2.5/index.js
 *
 * Do NOT use SRI with dynamically generated files! More information: https://www.jsdelivr.com/using-sri-with-dynamic-files
 */
function n(n, r, o, i, c) {
	return t(r, e(n, r), o, i, c);
}
function t(n, t, e, r, o, i) {
	const c = N(t, e, r);
	if (o && t !== c) throw new RangeError(Zo(n, t, e, r, i));
	return c;
}
function e(n, t) {
	const e = n[t];
	if (void 0 === e) throw new TypeError(Co(t));
	return e;
}
function r(n) {
	return null !== n && /object|function/.test(typeof n);
}
function o(n, t = Map) {
	const e = new t();
	return (t, ...r) => {
		if (e.has(t)) return e.get(t);
		const o = n(t, ...r);
		return e.set(t, o), o;
	};
}
function i(n) {
	return c({ name: n }, 1);
}
function c(n, t) {
	return f((n) => ({ value: n, configurable: 1, writable: !t }), n);
}
function s(n) {
	return f((n) => ({ get: n, configurable: 1 }), n);
}
function u(n) {
	return { [Symbol.toStringTag]: { value: n, configurable: 1 } };
}
function a(n, t) {
	const e = {};
	let r = n.length;
	for (const o of t) e[n[--r]] = o;
	return e;
}
function f(n, t, e) {
	const r = {};
	for (const o in t) r[o] = n(t[o], o, e);
	return r;
}
function l(n, t, e) {
	const r = {};
	for (let o = 0; o < t.length; o++) {
		const i = t[o];
		r[i] = n(i, o, e);
	}
	return r;
}
function d(n, t, e) {
	const r = {};
	for (let o = 0; o < n.length; o++) r[t[o]] = e[n[o]];
	return r;
}
function h(n, t) {
	const e = {};
	for (const r of n) e[r] = t[r];
	return e;
}
function g(n, t) {
	const e = {};
	for (const r in t) n.has(r) || (e[r] = t[r]);
	return e;
}
function m(n) {
	n = Object.assign({}, n);
	const t = Object.keys(n);
	for (const e of t) void 0 === n[e] && delete n[e];
	return n;
}
function w(n, t, e) {
	for (const r of n) if (t[r] !== e[r]) return 0;
	return 1;
}
function p(n, t, e) {
	const r = Object.assign({}, e);
	for (let e = 0; e < t; e++) r[n[e]] = 0;
	return r;
}
function y(n, ...t) {
	return (...e) => n(...t, ...e);
}
function b(n) {
	return n[0].toUpperCase() + n.substring(1);
}
function O(n) {
	return n.slice().sort();
}
function v(n, t) {
	return String(t).padStart(n, "0");
}
function M(n, t) {
	return Math.sign(n - t);
}
function N(n, t, e) {
	return Math.min(Math.max(n, t), e);
}
function E(n, t) {
	return [Math.floor(n / t), F(n, t)];
}
function F(n, t) {
	return ((n % t) + t) % t;
}
function j(n, t) {
	return [I(n, t), T(n, t)];
}
function I(n, t) {
	return Math.trunc(n / t) || 0;
}
function T(n, t) {
	return n % t || 0;
}
function R(n) {
	return 0.5 === Math.abs(n % 1);
}
function D(n, t, e) {
	let r = 0,
		o = 0;
	for (let i = 0; i <= t; i++) {
		const t = n[e[i]],
			c = Ti[i],
			s = Ii / c,
			[u, a] = j(t, s);
		(r += a * c), (o += u);
	}
	const [i, c] = j(r, Ii);
	return [o + i, c];
}
function S(n, t, e) {
	const r = {};
	for (let o = t; o >= 0; o--) {
		const t = Ti[o];
		(r[e[o]] = I(n, t)), (n = T(n, t));
	}
	return r;
}
function Z(n) {
	if (void 0 !== n) return C(n);
}
function P(n) {
	return L(C(n));
}
function C(n) {
	return x(nc(n));
}
function Y(n) {
	if (null == n) throw new TypeError("Cannot be null or undefined");
	return n;
}
function k(n, t) {
	if (null == t) throw new RangeError(Co(n));
	return t;
}
function U(n) {
	if (!r(n)) throw new TypeError(So);
	return n;
}
function $(n, t, e = n) {
	if (typeof t !== n) throw new TypeError(Po(e, t));
	return t;
}
function x(n, t = "number") {
	if (!Number.isInteger(n)) throw new RangeError(Fo(t, n));
	return n || 0;
}
function L(n, t = "number") {
	if (n <= 0) throw new RangeError(jo(t, n));
	return n;
}
function B(n) {
	if ("symbol" == typeof n) throw new TypeError(Do);
	return String(n);
}
function A(n, t) {
	return r(n) ? String(n) : Xi(n, t);
}
function q(n) {
	if ("string" == typeof n) return BigInt(n);
	if ("bigint" != typeof n) throw new TypeError(Ro(n));
	return n;
}
function W(n, t = "number") {
	if ("bigint" == typeof n) throw new TypeError(To(t));
	if (((n = Number(n)), !Number.isFinite(n))) throw new RangeError(Io(t, n));
	return n;
}
function J(n, t) {
	return Math.trunc(W(n, t)) || 0;
}
function H(n, t) {
	return x(W(n, t), t);
}
function _(n, t) {
	return L(J(n, t), t);
}
function z(n, t) {
	let [e, r] = j(t, Ii),
		o = n + e;
	const i = Math.sign(o);
	return i && i === -Math.sign(r) && ((o -= i), (r += i * Ii)), [o, r];
}
function G(n, t, e = 1) {
	return z(n[0] + t[0] * e, n[1] + t[1] * e);
}
function K(n, t) {
	return z(n[0], n[1] + t);
}
function V(n, t) {
	return G(t, n, -1);
}
function X(n, t) {
	return M(n[0], t[0]) || M(n[1], t[1]);
}
function Q(n, t, e) {
	return -1 === X(n, t) || 1 === X(n, e);
}
function nn(n, t = 1) {
	const e = BigInt(Ii / t);
	return [Number(n / e), Number(n % e) * t];
}
function tn(n, t = 1) {
	const e = Ii / t,
		[r, o] = j(n, e);
	return [r, o * t];
}
function en(n, t = 1) {
	const [e, r] = n,
		o = Math.floor(r / t),
		i = Ii / t;
	return BigInt(e) * BigInt(i) + BigInt(o);
}
function rn(n, t = 1, e) {
	const [r, o] = n,
		[i, c] = j(o, t);
	return r * (Ii / t) + (i + (e ? c / t : 0));
}
function on(n, t, e = E) {
	const [r, o] = n,
		[i, c] = e(o, t);
	return [r * (Ii / t) + i, c];
}
function cn(n, t) {
	const e = n.formatToParts(t),
		r = {};
	for (const n of e) r[n.type] = n.value;
	return r;
}
function sn(t) {
	return (
		n(t, "isoYear", jc, Fc, 1),
		t.isoYear === jc
			? n(t, "isoMonth", 4, 12, 1)
			: t.isoYear === Fc && n(t, "isoMonth", 1, 9, 1),
		t
	);
}
function un(n) {
	return an(Object.assign({}, n, pc, { isoHour: 12 })), n;
}
function an(t) {
	const e = n(t, "isoYear", jc, Fc, 1),
		r = e === jc ? 1 : e === Fc ? -1 : 0;
	return (
		r &&
			fn(
				wn(
					Object.assign({}, t, {
						isoDay: t.isoDay + r,
						isoNanosecond: t.isoNanosecond - r,
					})
				)
			),
		t
	);
}
function fn(n) {
	if (!n || Q(n, Ec, Nc)) throw new RangeError(ii);
	return n;
}
function ln(n) {
	return D(n, 5, lc)[1];
}
function dn(n) {
	const [t, e] = E(n, Ii);
	return [S(e, 5, lc), t];
}
function hn(n) {
	return gn(n)[0];
}
function gn(n) {
	return on(n, Ei);
}
function mn(n) {
	return bn(
		n.isoYear,
		n.isoMonth,
		n.isoDay,
		n.isoHour,
		n.isoMinute,
		n.isoSecond,
		n.isoMillisecond
	);
}
function wn(n) {
	const t = mn(n);
	if (void 0 !== t) {
		const [e, r] = j(t, Oi);
		return [e, r * Ni + (n.isoMicrosecond || 0) * Mi + (n.isoNanosecond || 0)];
	}
}
function pn(n, t) {
	const [e, r] = dn(ln(n) - t);
	return fn(wn(Object.assign({}, n, { isoDay: n.isoDay + r }, e)));
}
function yn(...n) {
	return bn(...n) / vi;
}
function bn(...n) {
	const [t, e] = On(...n),
		r = t.valueOf();
	if (!isNaN(r)) return r - e * Oi;
}
function On(n, t = 1, e = 1, r = 0, o = 0, i = 0, c = 0) {
	const s = n === jc ? 1 : n === Fc ? -1 : 0,
		u = new Date();
	return u.setUTCHours(r, o, i, c), u.setUTCFullYear(n, t - 1, e + s), [u, s];
}
function vn(n, t) {
	let [e, r] = K(n, t);
	r < 0 && ((r += Ii), (e -= 1));
	const [o, i] = E(r, Ni),
		[c, s] = E(i, Mi);
	return Mn(e * Oi + o, c, s);
}
function Mn(n, t = 0, e = 0) {
	const r = Math.ceil(Math.max(0, Math.abs(n) - Mc) / Oi) * Math.sign(n),
		o = new Date(n - r * Oi);
	return a(hc, [
		o.getUTCFullYear(),
		o.getUTCMonth() + 1,
		o.getUTCDate() + r,
		o.getUTCHours(),
		o.getUTCMinutes(),
		o.getUTCSeconds(),
		o.getUTCMilliseconds(),
		t,
		e,
	]);
}
function Nn(n) {
	return [n.isoYear, n.isoMonth, n.isoDay];
}
function En() {
	return Rc;
}
function Fn(n, t) {
	switch (t) {
		case 2:
			return In(n) ? 29 : 28;
		case 4:
		case 6:
		case 9:
		case 11:
			return 30;
	}
	return 31;
}
function jn(n) {
	return In(n) ? 366 : 365;
}
function In(n) {
	return n % 4 == 0 && (n % 100 != 0 || n % 400 == 0);
}
function Tn(n) {
	const [t, e] = On(n.isoYear, n.isoMonth, n.isoDay);
	return F(t.getUTCDay() - e, 7) || 7;
}
function Rn({ isoYear: n }) {
	return n < 1 ? ["bce", 1 - n] : ["ce", n];
}
function Dn(n) {
	const t = mn(n);
	if (t < Dc) return Rn(n);
	const e = cn($s(Gi), t),
		{ era: r, eraYear: o } = Tr(e, Gi);
	return [r, o];
}
function Sn(n) {
	return Zn(n), Yn(n, 1), n;
}
function Zn(n) {
	return Cn(n, 1), n;
}
function Pn(n) {
	return w(dc, n, Cn(n));
}
function Cn(t, e) {
	const { isoYear: r } = t,
		o = n(t, "isoMonth", 1, En(), e);
	return { isoYear: r, isoMonth: o, isoDay: n(t, "isoDay", 1, Fn(r, o), e) };
}
function Yn(t, e) {
	return a(lc, [
		n(t, "isoHour", 0, 23, e),
		n(t, "isoMinute", 0, 59, e),
		n(t, "isoSecond", 0, 59, e),
		n(t, "isoMillisecond", 0, 999, e),
		n(t, "isoMicrosecond", 0, 999, e),
		n(t, "isoNanosecond", 0, 999, e),
	]);
}
function kn(n) {
	return void 0 === n ? 0 : zc(U(n));
}
function Un(n, t = 0) {
	n = zn(n);
	const e = Gc(n),
		r = Kc(n, t);
	return [zc(n), r, e];
}
function $n(n) {
	return Gc(zn(n));
}
function xn(n, t, e, r = 9, o = 0, i = 4) {
	t = zn(t);
	let c = Hc(t, r, o),
		s = Jn(t),
		u = ns(t, i);
	const a = Jc(t, r, o, 1);
	return (
		null == c ? (c = Math.max(e, a)) : nt(c, a),
		(s = Hn(s, a, 1)),
		n && (u = ((n) => (n < 4 ? (n + 2) % 4 : n))(u)),
		[c, a, s, u]
	);
}
function Ln(n, t = 6, e) {
	let r = Jn((n = Gn(n, Zc)));
	const o = ns(n, 7);
	let i = Jc(n, t);
	return (i = k(Zc, i)), (r = Hn(r, i, void 0, e)), [i, r, o];
}
function Bn(n) {
	return Vc(zn(n));
}
function An(n, t) {
	return qn(zn(n), t);
}
function qn(n, t = 4) {
	const e = _n(n);
	return [ns(n, 4), ...Wn(Jc(n, t), e)];
}
function Wn(n, t) {
	return null != n
		? [Ti[n], n < 4 ? 9 - 3 * n : -1]
		: [void 0 === t ? 1 : 10 ** (9 - t), t];
}
function Jn(n) {
	const t = n[Cc];
	return void 0 === t ? 1 : J(t, Cc);
}
function Hn(n, e, r, o) {
	const i = o ? Ii : Ti[e + 1];
	if (i) {
		const r = Ti[e];
		if (i % ((n = t(Cc, n, 1, i / r - (o ? 0 : 1), 1)) * r))
			throw new RangeError(Po(Cc, n));
	} else n = t(Cc, n, 1, r ? 10 ** 9 : 1, 1);
	return n;
}
function _n(n) {
	let e = n[Yc];
	if (void 0 !== e) {
		if ("number" != typeof e) {
			if ("auto" === B(e)) return;
			throw new RangeError(Po(Yc, e));
		}
		e = t(Yc, Math.floor(e), 0, 9, 1);
	}
	return e;
}
function zn(n) {
	return void 0 === n ? {} : U(n);
}
function Gn(n, t) {
	return "string" == typeof n ? { [t]: n } : U(n);
}
function Kn(n) {
	if (void 0 !== n) {
		if (r(n)) return Object.assign(Object.create(null), n);
		throw new TypeError(So);
	}
}
function Vn(n, t) {
	return n && Object.assign(Object.create(null), n, { overflow: $c[t] });
}
function Xn(n, e, r = 9, o = 0, i) {
	let c = e[n];
	if (void 0 === c) return i ? o : void 0;
	if (((c = B(c)), "auto" === c)) return i ? o : null;
	let s = yi[c];
	if ((void 0 === s && (s = sc[c]), void 0 === s))
		throw new RangeError($o(n, c, yi));
	return t(n, s, o, r, 1, bi), s;
}
function Qn(n, t, e, r = 0) {
	const o = e[n];
	if (void 0 === o) return r;
	const i = B(o),
		c = t[i];
	if (void 0 === c) throw new RangeError($o(n, i, t));
	return c;
}
function nt(n, t) {
	if (t > n) throw new RangeError(li);
}
function tt(n) {
	return { branding: ss, epochNanoseconds: n };
}
function et(n, t, e) {
	return { branding: cs, calendar: e, timeZone: t, epochNanoseconds: n };
}
function rt(n, t = n.calendar) {
	return Object.assign({ branding: os, calendar: t }, h(wc, n));
}
function ot(n, t = n.calendar) {
	return Object.assign({ branding: rs, calendar: t }, h(gc, n));
}
function it(n, t = n.calendar) {
	return Object.assign({ branding: ts, calendar: t }, h(gc, n));
}
function ct(n, t = n.calendar) {
	return Object.assign({ branding: es, calendar: t }, h(gc, n));
}
function st(n) {
	return Object.assign({ branding: is }, h(mc, n));
}
function ut(n) {
	return Object.assign({ branding: us, sign: Fe(n) }, h(rc, n));
}
function at(n) {
	return on(n.epochNanoseconds, Ni)[0];
}
function ft(n) {
	return n.epochNanoseconds;
}
function lt(n) {
	return "string" == typeof n ? n : Xi(n.id);
}
function dt(n, t) {
	return n === t || lt(n) === lt(t);
}
function ht(n, t) {
	return rn(Te(n), Ti[t], 1);
}
function gt(n, t, e, r, o, i, c) {
	const s = ec[e],
		u = Object.assign({}, t, { [s]: t[s] + r }),
		a = c(n, o, t),
		f = c(n, o, u);
	return [i(a), i(f)];
}
function mt(n, t, e) {
	const r = rn(V(t, e));
	if (!r) throw new RangeError(Ko);
	return rn(V(t, n)) / r;
}
function wt(n, t, e, r) {
	return pt(n, Ot(t, e), r);
}
function pt(n, t, e) {
	const [r, o] = yt(n, t, e);
	return an(Object.assign({}, me(n, o), r));
}
function yt(n, t, e) {
	return dn(It(ln(n), t, e));
}
function bt(n) {
	return It(n, Fi, 7);
}
function Ot(n, t) {
	return Ti[n] * t;
}
function vt(n) {
	const t = Mt(n);
	return [t, me(t, 1)];
}
function Mt(n) {
	return yc(6, n);
}
function Nt(n, t, e) {
	const r = Math.min(Ze(n), 6);
	return Re(jt(Te(n, r), t, e), r);
}
function Et(n, t, e, r, o, i, c, s, u, a) {
	if (0 === r && 1 === o) return n;
	const f = ve(r, s) ? (Oe(s) && r < 6 && e >= 6 ? Dt : Rt) : St;
	let [l, d, h] = f(n, t, e, r, o, i, c, s, u, a);
	return (
		h &&
			7 !== r &&
			(l = ((n, t, e, r, o, i, c, s) => {
				const u = Fe(n);
				for (let a = r + 1; a <= e; a++) {
					if (7 === a && 7 !== e) continue;
					const r = fc(a, n);
					r[ec[a]] += u;
					const f = rn(V(c(s(o, i, r)), t));
					if (f && Math.sign(f) !== u) break;
					n = r;
				}
				return n;
			})(l, d, e, Math.max(6, r), c, s, u, a)),
		l
	);
}
function Ft(n, t, e, r, o) {
	if (6 === t) {
		const t = ((n) => n[0] + n[1] / Ii)(n);
		return [It(t, e, r), 0];
	}
	return jt(n, Ot(t, e), r, o);
}
function jt(n, t, e, r) {
	let [o, i] = n;
	r && i < 0 && ((i += Ii), (o -= 1));
	const [c, s] = E(It(i, t, e), Ii);
	return z(o + c, s);
}
function It(n, t, e) {
	return Tt(n / t, e) * t;
}
function Tt(n, t) {
	return as[t](n);
}
function Rt(n, t, e, r, o, i) {
	const c = Fe(n),
		s = Te(n),
		u = Ft(s, r, o, i),
		a = V(s, u),
		f = Math.sign(u[0] - s[0]) === c,
		l = Re(u, Math.min(e, 6));
	return [Object.assign({}, n, l), G(t, a), f];
}
function Dt(n, t, e, r, o, i, c, s, u, a) {
	const f = Fe(n),
		l = rn(Te(n, 5)),
		d = Ot(r, o);
	let h = It(l, d, i);
	const [g, m] = gt(c, Object.assign({}, n, ac), 6, f, s, u, a),
		w = h - rn(V(g, m));
	let p = 0;
	w && Math.sign(w) !== f
		? (t = K(g, h))
		: ((p += f), (h = It(w, d, i)), (t = K(m, h)));
	const y = De(h);
	return [Object.assign({}, n, y, { days: n.days + p }), t, Boolean(p)];
}
function St(n, t, e, r, o, i, c, s, u, a) {
	const f = Fe(n),
		l = ec[r],
		d = fc(r, n);
	7 === r &&
		(n = Object.assign({}, n, { weeks: n.weeks + Math.trunc(n.days / 7) }));
	const h = I(n[l], o) * o;
	d[l] = h;
	const [g, m] = gt(c, d, r, o * f, s, u, a),
		w = h + mt(t, g, m) * f * o,
		p = It(w, o, i),
		y = Math.sign(p - w) === f;
	return (d[l] = p), [d, y ? m : g, y];
}
function Zt(n, t, e, r) {
	const [o, i, c, s] = ((n) => {
			const t = qn((n = zn(n)));
			return [n.timeZone, ...t];
		})(r),
		u = void 0 !== o;
	return ((n, t, e, r, o, i) => {
		e = jt(e, o, r, 1);
		const c = t.getOffsetNanosecondsFor(e);
		return At(vn(e, c), i) + (n ? _t(bt(c)) : "Z");
	})(u, t(u ? n(o) : fs), e.epochNanoseconds, i, c, s);
}
function Pt(n, t, e) {
	const [r, o, i, c, s, u] = ((n) => {
		n = zn(n);
		const t = Vc(n),
			e = _n(n),
			r = Qc(n),
			o = ns(n, 4),
			i = Jc(n, 4);
		return [t, Xc(n), r, o, ...Wn(i, e)];
	})(e);
	return ((n, t, e, r, o, i, c, s, u, a) => {
		r = jt(r, u, s, 1);
		const f = n(e).getOffsetNanosecondsFor(r);
		return (
			At(vn(r, f), a) +
			_t(bt(f), c) +
			((n, t) => (1 !== t ? "[" + (2 === t ? "!" : "") + lt(n) + "]" : ""))(
				e,
				i
			) +
			zt(t, o)
		);
	})(n, t.calendar, t.timeZone, t.epochNanoseconds, r, o, i, c, s, u);
}
function Ct(n, t) {
	const [e, r, o, i] = ((n) => ((n = zn(n)), [Vc(n), ...qn(n)]))(t);
	return (c = n.calendar), (s = e), (u = i), At(pt(n, o, r), u) + zt(c, s);
	var c, s, u;
}
function Yt(n, t) {
	return (e = n.calendar), (r = n), (o = Bn(t)), qt(r) + zt(e, o);
	var e, r, o;
}
function kt(n, t) {
	return Lt(n.calendar, Wt, n, Bn(t));
}
function Ut(n, t) {
	return Lt(n.calendar, Jt, n, Bn(t));
}
function $t(n, t) {
	const [e, r, o] = An(t);
	return (i = o), Ht(yt(n, r, e)[0], i);
	var i;
}
function xt(n, t) {
	const [e, r, o] = An(t, 3);
	return (
		r > 1 && (n = Object.assign({}, n, Nt(n, r, e))),
		((n, t) => {
			const { sign: e } = n,
				r = -1 === e ? Ee(n) : n,
				{ hours: o, minutes: i } = r,
				[c, s] = on(Te(r, 3), Ei, j);
			Ie(c);
			const u = Kt(s, t),
				a = t >= 0 || !e || u;
			return (
				(e < 0 ? "-" : "") +
				"P" +
				Bt({ Y: Xt(r.years), M: Xt(r.months), W: Xt(r.weeks), D: Xt(r.days) }) +
				(o || i || c || a
					? "T" + Bt({ H: Xt(o), M: Xt(i), S: Xt(c, a) + u })
					: "")
			);
		})(n, o)
	);
}
function Lt(n, t, e, r) {
	const o = lt(n),
		i = r > 1 || (0 === r && o !== _i);
	return 1 === r
		? o === _i
			? t(e)
			: qt(e)
		: i
		? qt(e) + Gt(o, 2 === r)
		: t(e);
}
function Bt(n) {
	const t = [];
	for (const e in n) {
		const r = n[e];
		r && t.push(r, e);
	}
	return t.join("");
}
function At(n, t) {
	return qt(n) + "T" + Ht(n, t);
}
function qt(n) {
	return Wt(n) + "-" + pi(n.isoDay);
}
function Wt(n) {
	const { isoYear: t } = n;
	return (
		(t < 0 || t > 9999 ? Vt(t) + v(6, Math.abs(t)) : v(4, t)) +
		"-" +
		pi(n.isoMonth)
	);
}
function Jt(n) {
	return pi(n.isoMonth) + "-" + pi(n.isoDay);
}
function Ht(n, t) {
	const e = [pi(n.isoHour), pi(n.isoMinute)];
	return (
		-1 !== t &&
			e.push(
				pi(n.isoSecond) +
					((n, t, e, r) => Kt(n * Ni + t * Mi + e, r))(
						n.isoMillisecond,
						n.isoMicrosecond,
						n.isoNanosecond,
						t
					)
			),
		e.join(":")
	);
}
function _t(n, t = 0) {
	if (1 === t) return "";
	const [e, r] = E(Math.abs(n), ji),
		[o, i] = E(r, Fi),
		[c, s] = E(i, Ei);
	return Vt(n) + pi(e) + ":" + pi(o) + (c || s ? ":" + pi(c) + Kt(s) : "");
}
function zt(n, t) {
	if (1 !== t) {
		const e = lt(n);
		if (t > 1 || (0 === t && e !== _i)) return Gt(e, 2 === t);
	}
	return "";
}
function Gt(n, t) {
	return "[" + (t ? "!" : "") + "u-ca=" + n + "]";
}
function Kt(n, t) {
	let e = v(9, n);
	return (
		(e = void 0 === t ? e.replace(gs, "") : e.slice(0, t)), e ? "." + e : ""
	);
}
function Vt(n) {
	return n < 0 ? "-" : "+";
}
function Xt(n, t) {
	return n || t ? n.toLocaleString("fullwide", { useGrouping: 0 }) : "";
}
function Qt(n, t) {
	const { epochNanoseconds: e } = n,
		r = (t.getOffsetNanosecondsFor ? t : t(n.timeZone)).getOffsetNanosecondsFor(
			e
		),
		o = vn(e, r);
	return Object.assign({ calendar: n.calendar }, o, { offsetNanoseconds: r });
}
function ne(n, t, e, r = 0, o = 0, i, c) {
	if (void 0 !== e && 1 === r && (1 === r || c)) return pn(t, e);
	const s = n.getPossibleInstantsFor(t);
	if (void 0 !== e && 3 !== r) {
		const n = ((n, t, e, r) => {
			const o = wn(t);
			r && (e = bt(e));
			for (const t of n) {
				let n = rn(V(t, o));
				if ((r && (n = bt(n)), n === e)) return t;
			}
		})(s, t, e, i);
		if (void 0 !== n) return n;
		if (0 === r) throw new RangeError(ri);
	}
	return c ? wn(t) : te(n, t, o, s);
}
function te(n, t, e = 0, r = n.getPossibleInstantsFor(t)) {
	if (1 === r.length) return r[0];
	if (1 === e) throw new RangeError(oi);
	if (r.length) return r[3 === e ? 1 : 0];
	const o = wn(t),
		i = ((n, t) => {
			const e = n.getOffsetNanosecondsFor(K(t, -Ii));
			return re(n.getOffsetNanosecondsFor(K(t, Ii)) - e);
		})(n, o),
		c = i * (2 === e ? -1 : 1);
	return (r = n.getPossibleInstantsFor(vn(o, c)))[2 === e ? 0 : r.length - 1];
}
function ee(n) {
	if (Math.abs(n) >= Ii) throw new RangeError(ti);
	return n;
}
function re(n) {
	if (n > Ii) throw new RangeError(ei);
	return n;
}
function oe(n, t, e) {
	return tt(
		fn(
			G(
				t.epochNanoseconds,
				((n) => {
					if (Se(n)) throw new RangeError(ai);
					return Te(n, 5);
				})(n ? Ee(e) : e)
			)
		)
	);
}
function ie(n, t, e, r, o, i = Object.create(null)) {
	const c = t(r.timeZone),
		s = n(r.calendar);
	return Object.assign({}, r, fe(c, s, r, e ? Ee(o) : o, i));
}
function ce(n, t, e, r, o = Object.create(null)) {
	const { calendar: i } = e;
	return rt(le(n(i), e, t ? Ee(r) : r, o), i);
}
function se(n, t, e, r, o) {
	const { calendar: i } = e;
	return ot(de(n(i), e, t ? Ee(r) : r, o), i);
}
function ue(n, t, e, r, o = Object.create(null)) {
	const i = e.calendar,
		c = n(i);
	let s = he(c, e);
	t && (r = Ne(r)),
		r.sign < 0 &&
			((s = c.dateAdd(s, Object.assign({}, uc, { months: 1 }))),
			(s = me(s, -1)));
	const u = c.dateAdd(s, r, o);
	return it(he(c, u), i);
}
function ae(n, t, e) {
	return st(ge(t, n ? Ee(e) : e)[0]);
}
function fe(n, t, e, r, o) {
	const i = Te(r, 5);
	let c = e.epochNanoseconds;
	if (Se(r)) {
		const s = ms(e, n);
		c = G(
			te(n, Object.assign({}, de(t, s, Object.assign({}, r, ac), o), h(lc, s))),
			i
		);
	} else (c = G(c, i)), kn(o);
	return { epochNanoseconds: fn(c) };
}
function le(n, t, e, r) {
	const [o, i] = ge(t, e);
	return an(
		Object.assign(
			{},
			de(n, t, Object.assign({}, e, ac, { days: e.days + i }), r),
			o
		)
	);
}
function de(n, t, e, r) {
	if (e.years || e.months || e.weeks) return n.dateAdd(t, e, r);
	kn(r);
	const o = e.days + Te(e, 5)[0];
	return o ? un(me(t, o)) : t;
}
function he(n, t, e = 1) {
	return me(t, e - n.day(t));
}
function ge(n, t) {
	const [e, r] = Te(t, 5),
		[o, i] = dn(ln(n) + r);
	return [o, e + i];
}
function me(n, t) {
	return t ? Object.assign({}, n, Mn(mn(n) + t * Oi)) : n;
}
function we(n, t, e) {
	const r = n(e.calendar);
	return Oe(e) ? [e, r, t(e.timeZone)] : [Object.assign({}, e, pc), r];
}
function pe(n) {
	return n ? ft : wn;
}
function ye(n) {
	return n ? y(fe, n) : le;
}
function be(n) {
	return n ? y(mr, n) : wr;
}
function Oe(n) {
	return n && n.epochNanoseconds;
}
function ve(n, t) {
	return n <= 6 - (Oe(t) ? 1 : 0);
}
function Me(n, t, e, r, o, i, c) {
	const s = n(zn(c).relativeTo),
		u = Math.max(Ze(o), Ze(i));
	if (ve(u, s))
		return ut(
			je(
				((n, t, e, r) => {
					const o = G(Te(n), Te(t), r ? -1 : 1);
					if (!Number.isFinite(o[0])) throw new RangeError(ii);
					return Object.assign({}, uc, Re(o, e));
				})(o, i, u, r)
			)
		);
	if (!s) throw new RangeError(ui);
	r && (i = Ee(i));
	const [a, f, l] = we(t, e, s),
		d = ye(l),
		h = be(l),
		g = d(f, a, o);
	return ut(h(f, a, d(f, g, i), u));
}
function Ne(n) {
	return ut(Ee(n));
}
function Ee(n) {
	const t = {};
	for (const e of ec) t[e] = -1 * n[e] || 0;
	return t;
}
function Fe(n, t = ec) {
	let e = 0;
	for (const r of t) {
		const t = Math.sign(n[r]);
		if (t) {
			if (e && e !== t) throw new RangeError(si);
			e = t;
		}
	}
	return e;
}
function je(n) {
	for (const e of cc) t(e, n[e], -ws, ws, 1);
	return Ie(rn(Te(n), Ei)), n;
}
function Ie(n) {
	if (!Number.isSafeInteger(n)) throw new RangeError(ci);
}
function Te(n, t = 6) {
	return D(n, t, ec);
}
function Re(n, t = 6) {
	const [e, r] = n,
		o = S(r, t, ec);
	if (((o[ec[t]] += e * (Ii / Ti[t])), !Number.isFinite(o[ec[t]])))
		throw new RangeError(ii);
	return o;
}
function De(n, t = 5) {
	return S(n, t, ec);
}
function Se(n) {
	return Boolean(Fe(n, ic));
}
function Ze(n) {
	let t = 9;
	for (; t > 0 && !n[ec[t]]; t--);
	return t;
}
function Pe(n, t) {
	return [n, t];
}
function Ce(n) {
	const t = Math.floor(n / ls) * ls;
	return [t, t + ls];
}
function Ye(n) {
	const t = Je(n);
	if (void 0 === t) throw new RangeError(di(n));
	return t;
}
function ke(n) {
	const t = Ae(Xi(n));
	if (!t || t.m) throw new RangeError(di(n));
	return ot(t.p ? xe(t) : Le(t));
}
function Ue(n) {
	if (n.calendar !== _i) throw new RangeError(hi(n.calendar));
}
function $e(n, t, e = 0, r = 0) {
	const o = Qe(n.timeZone),
		i = ps(o);
	return et(ne(i, Sn(n), t, e, r, !i.v, n.m), o, Ur(n.calendar));
}
function xe(n) {
	return Be(an(Sn(n)));
}
function Le(n) {
	return Be(un(Zn(n)));
}
function Be(n) {
	return Object.assign({}, n, { calendar: Ur(n.calendar) });
}
function Ae(n) {
	const t = Ds.exec(n);
	return t
		? ((n) => {
				const t = n[10],
					e = "Z" === (t || "").toUpperCase();
				return Object.assign(
					{
						isoYear: He(n),
						isoMonth: parseInt(n[4]),
						isoDay: parseInt(n[5]),
					},
					_e(n.slice(5)),
					ze(n[16]),
					{
						p: Boolean(n[6]),
						m: e,
						offset: e ? void 0 : t,
					}
				);
		  })(t)
		: void 0;
}
function qe(n) {
	const t = Ts.exec(n);
	return t
		? ((n) =>
				Object.assign(
					{
						isoYear: He(n),
						isoMonth: parseInt(n[4]),
						isoDay: 1,
					},
					ze(n[5])
				))(t)
		: void 0;
}
function We(n) {
	const t = Rs.exec(n);
	return t
		? ((n) =>
				Object.assign(
					{
						isoYear: Tc,
						isoMonth: parseInt(n[1]),
						isoDay: parseInt(n[2]),
					},
					ze(n[3])
				))(t)
		: void 0;
}
function Je(n, t) {
	const e = Zs.exec(n);
	return e
		? ((n, t) => {
				const e = n[4] || n[5];
				if (t && e) throw new RangeError(hi(e));
				return ee(
					(Xe(n[2]) * ji + Xe(n[3]) * Fi + Xe(n[4]) * Ei + Ge(n[5] || "")) *
						Ve(n[1])
				);
		  })(e, t)
		: void 0;
}
function He(n) {
	const t = Ve(n[1]),
		e = parseInt(n[2] || n[3]);
	if (t < 0 && !e) throw new RangeError(hi(-0));
	return t * e;
}
function _e(n) {
	const t = Xe(n[3]);
	return Object.assign({}, dn(Ge(n[4] || ""))[0], {
		isoHour: Xe(n[1]),
		isoMinute: Xe(n[2]),
		isoSecond: 60 === t ? 59 : t,
	});
}
function ze(n) {
	let t, e;
	const r = [];
	if (
		(n.replace(Ps, (n, o, i) => {
			const c = Boolean(o),
				[s, u] = i.split("=").reverse();
			if (u) {
				if ("u-ca" === u) r.push(s), t || (t = c);
				else if (c || /[A-Z]/.test(u)) throw new RangeError(hi(n));
			} else {
				if (e) throw new RangeError(hi(n));
				e = s;
			}
			return "";
		}),
		r.length > 1 && t)
	)
		throw new RangeError(hi(n));
	return { timeZone: e, calendar: r[0] || _i };
}
function Ge(n) {
	return parseInt(n.padEnd(9, "0"));
}
function Ke(n) {
	return new RegExp(`^${n}$`, "i");
}
function Ve(n) {
	return n && "+" !== n ? -1 : 1;
}
function Xe(n) {
	return void 0 === n ? 0 : parseInt(n);
}
function Qe(n) {
	const t = tr(n);
	return "number" == typeof t
		? _t(t)
		: t
		? ((n) => {
				if (ks.test(n)) throw new RangeError(ni);
				return n
					.toLowerCase()
					.split("/")
					.map((n, t) =>
						(n.length <= 3 || /\d/.test(n)) && !/etc|yap/.test(n)
							? n.toUpperCase()
							: n.replace(/baja|dumont|[a-z]+/g, (n, e) =>
									(n.length <= 2 && !t) || "in" === n || "chat" === n
										? n.toUpperCase()
										: n.length > 2 || !e
										? b(n).replace(/island|noronha|murdo|rivadavia|urville/, b)
										: n
							  )
					)
					.join("/");
		  })(n)
		: fs;
}
function nr(n) {
	const t = tr(n);
	return "number" == typeof t ? t : t ? t.resolvedOptions().timeZone : fs;
}
function tr(n) {
	const t = Je((n = n.toUpperCase()), 1);
	return void 0 !== t ? t : n !== fs ? Ys(n) : void 0;
}
function er(n, t) {
	return X(n.epochNanoseconds, t.epochNanoseconds);
}
function rr(n, t) {
	return X(n.epochNanoseconds, t.epochNanoseconds);
}
function or(n, t) {
	return ir(n, t) || cr(n, t);
}
function ir(n, t) {
	return M(mn(n), mn(t));
}
function cr(n, t) {
	return M(ln(n), ln(t));
}
function sr(n, t) {
	if (n === t) return 1;
	const e = lt(n),
		r = lt(t);
	if (e === r) return 1;
	try {
		return nr(e) === nr(r);
	} catch (n) {}
}
function ur(n, t, e, r) {
	const o = xn(n, Kn(r), 3, 5),
		i = br(t.epochNanoseconds, e.epochNanoseconds, ...o);
	return ut(n ? Ee(i) : i);
}
function ar(n, t, e, r, o, i) {
	const c = Er(r.calendar, o.calendar),
		s = Kn(i),
		[u, a, f, l] = xn(e, s, 5),
		d = r.epochNanoseconds,
		h = o.epochNanoseconds,
		g = X(h, d);
	let m;
	if (g)
		if (u < 6) m = br(d, h, u, a, f, l);
		else {
			const e = t(
					((n, t) => {
						if (!sr(n, t)) throw new RangeError(Qo);
						return n;
					})(r.timeZone, o.timeZone)
				),
				i = n(c);
			(m = pr(i, e, r, o, g, u, s)),
				(m = Et(m, h, u, a, f, l, i, r, ft, y(fe, e)));
		}
	else m = uc;
	return ut(e ? Ee(m) : m);
}
function fr(n, t, e, r, o) {
	const i = Er(e.calendar, r.calendar),
		c = Kn(o),
		[s, u, a, f] = xn(t, c, 6),
		l = wn(e),
		d = wn(r),
		h = X(d, l);
	let g;
	if (h)
		if (s <= 6) g = br(l, d, s, u, a, f);
		else {
			const t = n(i);
			(g = yr(t, e, r, h, s, c)), (g = Et(g, d, s, u, a, f, t, e, wn, le));
		}
	else g = uc;
	return ut(t ? Ee(g) : g);
}
function lr(n, t, e, r, o) {
	const i = Er(e.calendar, r.calendar),
		c = Kn(o);
	return hr(t, () => n(i), e, r, ...xn(t, c, 6, 9, 6), c);
}
function dr(n, t, e, r, o) {
	const i = Er(e.calendar, r.calendar),
		c = Kn(o),
		s = xn(t, c, 9, 9, 8),
		u = n(i);
	return hr(t, () => u, he(u, e), he(u, r), ...s, c);
}
function hr(n, t, e, r, o, i, c, s, u) {
	const a = wn(e),
		f = wn(r);
	let l;
	if (X(f, a))
		if (6 === o) l = br(a, f, o, i, c, s);
		else {
			const n = t();
			(l = n.dateUntil(e, r, o, u)),
				(6 === i && 1 === c) || (l = Et(l, f, o, i, c, s, n, e, wn, de));
		}
	else l = uc;
	return ut(n ? Ee(l) : l);
}
function gr(n, t, e, r) {
	const o = Kn(r),
		[i, c, s, u] = xn(n, o, 5, 5),
		a = It(Nr(t, e), Ot(c, s), u),
		f = Object.assign({}, uc, De(a, i));
	return ut(n ? Ee(f) : f);
}
function mr(n, t, e, r, o, i) {
	const c = X(r.epochNanoseconds, e.epochNanoseconds);
	return c
		? o < 6
			? Or(e.epochNanoseconds, r.epochNanoseconds, o)
			: pr(t, n, e, r, c, o, i)
		: uc;
}
function wr(n, t, e, r, o) {
	const i = wn(t),
		c = wn(e),
		s = X(c, i);
	return s ? (r <= 6 ? Or(i, c, r) : yr(n, t, e, s, r, o)) : uc;
}
function pr(n, t, e, r, o, i, c) {
	const [s, u, a] = ((n, t, e, r) => {
		function o() {
			return (
				(l = Object.assign({}, me(s, a++ * -r), c)),
				(d = te(n, l)),
				X(u, d) === -r
			);
		}
		const i = ms(t, n),
			c = h(lc, i),
			s = ms(e, n),
			u = e.epochNanoseconds;
		let a = 0;
		const f = Nr(i, s);
		let l, d;
		if ((Math.sign(f) === -r && a++, o() && (-1 === r || o())))
			throw new RangeError(Ko);
		const g = rn(V(d, u));
		return [i, l, g];
	})(t, e, r, o);
	var f, l;
	return Object.assign(
		6 === i
			? ((f = s), (l = u), Object.assign({}, uc, { days: vr(f, l) }))
			: n.dateUntil(s, u, i, c),
		De(a)
	);
}
function yr(n, t, e, r, o, i) {
	const [c, s, u] = ((n, t, e) => {
		let r = t,
			o = Nr(n, t);
		return Math.sign(o) === -e && ((r = me(t, -e)), (o += Ii * e)), [n, r, o];
	})(t, e, r);
	return Object.assign({}, n.dateUntil(c, s, o, i), De(u));
}
function br(n, t, e, r, o, i) {
	return Object.assign({}, uc, Re(Ft(V(n, t), r, o, i), e));
}
function Or(n, t, e) {
	return Object.assign({}, uc, Re(V(n, t), e));
}
function vr(n, t) {
	return Mr(mn(n), mn(t));
}
function Mr(n, t) {
	return Math.trunc((t - n) / Oi);
}
function Nr(n, t) {
	return ln(t) - ln(n);
}
function Er(n, t) {
	if (!dt(n, t)) throw new RangeError(Vo);
	return n;
}
function Fr(n) {
	function t(n) {
		return ((n, t) =>
			Object.assign({}, Tr(n, t), { F: n.month, day: parseInt(n.day) }))(
			cn(e, n),
			r
		);
	}
	const e = $s(n),
		r = $r(n);
	return { id: n, O: jr(t), B: Ir(t) };
}
function jr(n) {
	return o((t) => {
		const e = mn(t);
		return n(e);
	}, WeakMap);
}
function Ir(n) {
	const t = n(0).year - Ic;
	return o((e) => {
		let r,
			o = bn(e - t);
		const i = [],
			c = [];
		do {
			o += 400 * Oi;
		} while ((r = n(o)).year <= e);
		do {
			(o += (1 - r.day) * Oi),
				r.year === e && (i.push(o), c.push(r.F)),
				(o -= Oi);
		} while ((r = n(o)).year >= e);
		return { k: i.reverse(), C: mi(c.reverse()) };
	});
}
function Tr(n, t) {
	let e,
		r,
		o = Rr(n);
	if (n.era) {
		const i = Ki[t];
		void 0 !== i &&
			((e =
				"islamic" === t
					? "ah"
					: n.era
							.normalize("NFD")
							.toLowerCase()
							.replace(/[^a-z0-9]/g, "")),
			"bc" === e || "b" === e
				? (e = "bce")
				: ("ad" !== e && "a" !== e) || (e = "ce"),
			(r = o),
			(o = Jr(r, i[e] || 0)));
	}
	return { era: e, eraYear: r, year: o };
}
function Rr(n) {
	return parseInt(n.relatedYear || n.year);
}
function Dr(n) {
	const { year: t, F: e, day: r } = this.O(n),
		{ C: o } = this.B(t);
	return [t, o[e] + 1, r];
}
function Sr(n, t = 1, e = 1) {
	return this.B(n).k[t - 1] + (e - 1) * Oi;
}
function Zr(n) {
	const t = kr(this, n),
		e = kr(this, n - 1),
		r = t.length;
	if (r > e.length) {
		const n = _r(this);
		if (n < 0) return -n;
		for (let n = 0; n < r; n++) if (t[n] !== e[n]) return n + 1;
	}
}
function Pr(n) {
	return Mr(Sr.call(this, n), Sr.call(this, n + 1));
}
function Cr(n, t) {
	const { k: e } = this.B(n);
	let r = t + 1,
		o = e;
	return (
		r > e.length && ((r = 1), (o = this.B(n + 1).k)), Mr(e[t - 1], o[r - 1])
	);
}
function Yr(n) {
	return this.B(n).k.length;
}
function kr(n, t) {
	return Object.keys(n.B(t).C);
}
function Ur(n) {
	if (
		(n = n.toLowerCase()) !== _i &&
		n !== zi &&
		$r(n) !== $r($s(n).resolvedOptions().calendar)
	)
		throw new RangeError(Xo(n));
	return n;
}
function $r(n) {
	return "islamicc" === n && (n = "islamic"), n.split("-")[0];
}
function xr(n) {
	return this.R(n)[0];
}
function Lr(n) {
	return this.R(n)[1];
}
function Br(n) {
	const [t] = this.h(n);
	return Mr(this.q(t), mn(n)) + 1;
}
function Ar(n) {
	const t = xs.exec(n);
	if (!t) throw new RangeError(Jo(n));
	return [parseInt(t[1]), Boolean(t[2])];
}
function qr(n, t, e) {
	return n + (t || (e && n >= e) ? 1 : 0);
}
function Wr(n, t) {
	return n - (t && n >= t ? 1 : 0);
}
function Jr(n, t) {
	return (t + n) * (Math.sign(t) || 1) || 0;
}
function Hr(n) {
	return Ki[zr(n)];
}
function _r(n) {
	return Vi[zr(n)];
}
function zr(n) {
	return $r(n.id || _i);
}
function Gr(n, t, e, r) {
	const o = Qr(e, r, qi, [], Ci);
	if (void 0 !== o.timeZone) {
		const r = e.dateFromFields(o),
			i = to(o),
			c = n(o.timeZone);
		return {
			epochNanoseconds: ne(
				t(c),
				Object.assign({}, r, i),
				void 0 !== o.offset ? Ye(o.offset) : void 0
			),
			timeZone: c,
		};
	}
	return Object.assign({}, e.dateFromFields(o), pc);
}
function Kr(n, t, e, r = []) {
	const o = Qr(n, t, qi, r);
	return n.dateFromFields(o, e);
}
function Vr(n, t, e, r) {
	const o = Qr(n, t, Bi, r);
	return n.yearMonthFromFields(o, e);
}
function Xr(n, t, e, r, o = []) {
	const i = Qr(n, e, qi, o);
	return (
		t &&
			void 0 !== i.month &&
			void 0 === i.monthCode &&
			void 0 === i.year &&
			(i.year = Tc),
		n.monthDayFromFields(i, r)
	);
}
function Qr(n, t, e, r = [], o = []) {
	return no(t, [...n.fields(e), ...o].sort(), r);
}
function no(n, t, e, r = !e) {
	const o = {};
	let i,
		c = 0;
	for (const r of t) {
		if (r === i) throw new RangeError(ko(r));
		if ("constructor" === r || "__proto__" === r) throw new RangeError(Yo(r));
		let t = n[r];
		if (void 0 !== t) (c = 1), qs[r] && (t = qs[r](t, r)), (o[r] = t);
		else if (e) {
			if (e.includes(r)) throw new TypeError(Co(r));
			o[r] = Hi[r];
		}
		i = r;
	}
	if (r && !c) throw new TypeError(Uo(t));
	return o;
}
function to(n, t) {
	return Yn(Ws(Object.assign({}, Hi, n)), t);
}
function eo(n, t, e, r, o = [], i = []) {
	const c = [...n.fields(r), ...o].sort();
	let s = no(t, c, i);
	const u = no(e, c);
	return (s = n.mergeFields(s, u)), no(s, c, []);
}
function ro(n, t) {
	const e = Qr(n, t, Ji);
	return n.monthDayFromFields(e);
}
function oo(n, t, e) {
	const r = Qr(n, t, Ai);
	return n.yearMonthFromFields(r, e);
}
function io(n, t, e, r, o) {
	(t = h((e = n.fields(e)), t)), (r = no(r, (o = n.fields(o)), []));
	let i = n.mergeFields(t, r);
	return (i = no(i, [...e, ...o].sort(), [])), n.dateFromFields(i);
}
function co(n, t) {
	let { era: e, eraYear: r, year: o } = t;
	const i = Hr(n);
	if (void 0 !== e || void 0 !== r) {
		if (void 0 === e || void 0 === r) throw new TypeError(Bo);
		if (!i) throw new RangeError(Lo);
		const n = i[e];
		if (void 0 === n) throw new RangeError(qo(e));
		const t = Jr(r, n);
		if (void 0 !== o && o !== t) throw new RangeError(Ao);
		o = t;
	} else if (void 0 === o) throw new TypeError(Wo(i));
	return o;
}
function so(n, e, r, o) {
	let { month: i, monthCode: c } = e;
	if (void 0 !== c) {
		const t = ((n, t, e, r) => {
			const o = n.U(e),
				[i, c] = Ar(t);
			let s = qr(i, c, o);
			if (c) {
				const t = _r(n);
				if (void 0 === t) throw new RangeError(Go);
				if (t > 0) {
					if (s > t) throw new RangeError(Go);
					if (void 0 === o) {
						if (1 === r) throw new RangeError(Go);
						s--;
					}
				} else {
					if (s !== -t) throw new RangeError(Go);
					if (void 0 === o && 1 === r) throw new RangeError(Go);
				}
			}
			return s;
		})(n, c, r, o);
		if (void 0 !== i && i !== t) throw new RangeError(Ho);
		(i = t), (o = 1);
	} else if (void 0 === i) throw new TypeError(_o);
	return t("month", i, 1, n.L(r), o);
}
function uo(t, e, r, o, i) {
	return n(e, "day", 1, t.j(o, r), i);
}
function ao(n, t, e, r) {
	let o = 0;
	const i = [];
	for (const n of e) void 0 !== t[n] ? (o = 1) : i.push(n);
	if ((Object.assign(n, t), o)) for (const t of r || i) delete n[t];
}
function fo(n, t, e = _i) {
	return et(n.epochNanoseconds, t, e);
}
function lo(n, t) {
	return rt(ms(t, n));
}
function ho(n, t) {
	return ot(ms(t, n));
}
function go(n, t) {
	return st(ms(t, n));
}
function mo(n, t) {
	return Object.assign({}, n, { calendar: t });
}
function wo(n, t) {
	if (n === t) return n;
	const e = lt(n),
		r = lt(t);
	if (e === r || e === _i) return t;
	if (r === _i) return n;
	throw new RangeError(Vo);
}
function po(n, t) {
	return (e) =>
		e === _i
			? n
			: e === zi || e === Gi
			? Object.assign(Object.create(n), { id: e })
			: Object.assign(Object.create(t), Us(e));
}
function yo(n, t, e) {
	const r = new Set(e);
	return (o) => (
		((n, t) => {
			for (const e of t) if (e in n) return 1;
			return 0;
		})((o = g(r, o)), n) || Object.assign(o, t),
		e &&
			((o.timeZone = fs),
			["full", "long"].includes(o.timeStyle) && (o.timeStyle = "medium")),
		o
	);
}
function bo(n, t = Oo) {
	const [e, , , r] = n;
	return (o, i = bu, ...c) => {
		const s = t(r && r(...c), o, i, e),
			u = s.resolvedOptions();
		return [s, ...vo(n, u, c)];
	};
}
function Oo(n, t, e, r) {
	if (((e = r(e)), n)) {
		if (void 0 !== e.timeZone) throw new TypeError(gi);
		e.timeZone = n;
	}
	return new bc(t, e);
}
function vo(n, t, e) {
	const [, r, o] = n;
	return e.map(
		(n) => (
			n.calendar &&
				((n, t, e) => {
					if ((e || n !== _i) && n !== t) throw new RangeError(Vo);
				})(lt(n.calendar), t.calendar, o),
			r(n, t)
		)
	);
}
function Mo(n) {
	const t = No();
	return vn(t, n.getOffsetNanosecondsFor(t));
}
function No() {
	return tn(Date.now(), Ni);
}
function Eo() {
	return Iu || (Iu = new bc().resolvedOptions().timeZone);
}
const Fo = (n, t) => `Non-integer ${n}: ${t}`,
	jo = (n, t) => `Non-positive ${n}: ${t}`,
	Io = (n, t) => `Non-finite ${n}: ${t}`,
	To = (n) => `Cannot convert bigint to ${n}`,
	Ro = (n) => `Invalid bigint: ${n}`,
	Do = "Cannot convert Symbol to string",
	So = "Invalid object",
	Zo = (n, t, e, r, o) =>
		o ? Zo(n, o[t], o[e], o[r]) : Po(n, t) + `; must be between ${e}-${r}`,
	Po = (n, t) => `Invalid ${n}: ${t}`,
	Co = (n) => `Missing ${n}`,
	Yo = (n) => `Invalid field ${n}`,
	ko = (n) => `Duplicate field ${n}`,
	Uo = (n) => "No valid fields: " + n.join(),
	$o = (n, t, e) => Po(n, t) + "; must be " + Object.keys(e).join(),
	xo = "Invalid calling context",
	Lo = "Forbidden era/eraYear",
	Bo = "Mismatching era/eraYear",
	Ao = "Mismatching year/eraYear",
	qo = (n) => `Invalid era: ${n}`,
	Wo = (n) => "Missing year" + (n ? "/era/eraYear" : ""),
	Jo = (n) => `Invalid monthCode: ${n}`,
	Ho = "Mismatching month/monthCode",
	_o = "Missing month/monthCode",
	zo = "Cannot guess year",
	Go = "Invalid leap month",
	Ko = "Invalid protocol results",
	Vo = "Mismatching Calendars",
	Xo = (n) => `Invalid Calendar: ${n}`,
	Qo = "Mismatching TimeZones",
	ni = "Forbidden ICU TimeZone",
	ti = "Out-of-bounds offset",
	ei = "Out-of-bounds TimeZone gap",
	ri = "Invalid TimeZone offset",
	oi = "Ambiguous offset",
	ii = "Out-of-bounds date",
	ci = "Out-of-bounds duration",
	si = "Cannot mix duration signs",
	ui = "Missing relativeTo",
	ai = "Cannot use large units",
	fi = "Required smallestUnit or largestUnit",
	li = "smallestUnit > largestUnit",
	di = (n) => `Cannot parse: ${n}`,
	hi = (n) => `Invalid substring: ${n}`,
	gi = "Cannot specify TimeZone",
	mi = y(l, (n, t) => t),
	wi = y(l, (n, t, e) => e),
	pi = y(v, 2),
	yi = {
		nanosecond: 0,
		microsecond: 1,
		millisecond: 2,
		second: 3,
		minute: 4,
		hour: 5,
		day: 6,
		week: 7,
		month: 8,
		year: 9,
	},
	bi = Object.keys(yi),
	Oi = 864e5,
	vi = 1e3,
	Mi = 1e3,
	Ni = 1e6,
	Ei = 1e9,
	Fi = 6e10,
	ji = 36e11,
	Ii = 864e11,
	Ti = [1, Mi, Ni, Ei, Fi, ji, Ii],
	Ri = bi.slice(0, 6),
	Di = O(Ri),
	Si = ["offset"],
	Zi = ["timeZone"],
	Pi = Ri.concat(Si),
	Ci = Pi.concat(Zi),
	Yi = ["era", "eraYear"],
	ki = Yi.concat(["year"]),
	Ui = ["year"],
	$i = ["monthCode"],
	xi = ["month"].concat($i),
	Li = ["day"],
	Bi = xi.concat(Ui),
	Ai = $i.concat(Ui),
	qi = Li.concat(Bi),
	Wi = Li.concat(xi),
	Ji = Li.concat($i),
	Hi = wi(Ri, 0),
	_i = "iso8601",
	zi = "gregory",
	Gi = "japanese",
	Ki = {
		[zi]: { bce: -1, ce: 0 },
		[Gi]: {
			bce: -1,
			ce: 0,
			meiji: 1867,
			taisho: 1911,
			showa: 1925,
			heisei: 1988,
			reiwa: 2018,
		},
		ethioaa: { era0: 0 },
		ethiopic: { era0: 0, era1: 5500 },
		coptic: { era0: -1, era1: 0 },
		roc: { beforeroc: -1, minguo: 0 },
		buddhist: { be: 0 },
		islamic: { ah: 0 },
		indian: { saka: 0 },
		persian: { ap: 0 },
	},
	Vi = { chinese: 13, dangi: 13, hebrew: -6 },
	Xi = y($, "string"),
	Qi = y($, "boolean"),
	nc = y($, "number"),
	tc = y($, "function"),
	ec = bi.map((n) => n + "s"),
	rc = O(ec),
	oc = ec.slice(0, 6),
	ic = ec.slice(6),
	cc = ic.slice(1),
	sc = mi(ec),
	uc = wi(ec, 0),
	ac = wi(oc, 0),
	fc = y(p, ec),
	lc = [
		"isoNanosecond",
		"isoMicrosecond",
		"isoMillisecond",
		"isoSecond",
		"isoMinute",
		"isoHour",
	],
	dc = ["isoDay", "isoMonth", "isoYear"],
	hc = lc.concat(dc),
	gc = O(dc),
	mc = O(lc),
	wc = O(hc),
	pc = wi(mc, 0),
	yc = y(p, hc),
	bc = Intl.DateTimeFormat,
	Oc = "en-GB",
	vc = 1e8,
	Mc = vc * Oi,
	Nc = [vc, 0],
	Ec = [-vc, 0],
	Fc = 275760,
	jc = -271821,
	Ic = 1970,
	Tc = 1972,
	Rc = 12,
	Dc = bn(1868, 9, 8),
	Sc = o(Dn, WeakMap),
	Zc = "smallestUnit",
	Pc = "unit",
	Cc = "roundingIncrement",
	Yc = "fractionalSecondDigits",
	kc = "relativeTo",
	Uc = { constrain: 0, reject: 1 },
	$c = Object.keys(Uc),
	xc = { compatible: 0, reject: 1, earlier: 2, later: 3 },
	Lc = { reject: 0, use: 1, prefer: 2, ignore: 3 },
	Bc = { auto: 0, never: 1, critical: 2, always: 3 },
	Ac = { auto: 0, never: 1, critical: 2 },
	qc = { auto: 0, never: 1 },
	Wc = {
		floor: 0,
		halfFloor: 1,
		ceil: 2,
		halfCeil: 3,
		trunc: 4,
		halfTrunc: 5,
		expand: 6,
		halfExpand: 7,
		halfEven: 8,
	},
	Jc = y(Xn, Zc),
	Hc = y(Xn, "largestUnit"),
	_c = y(Xn, Pc),
	zc = y(Qn, "overflow", Uc),
	Gc = y(Qn, "disambiguation", xc),
	Kc = y(Qn, "offset", Lc),
	Vc = y(Qn, "calendarName", Bc),
	Xc = y(Qn, "timeZoneName", Ac),
	Qc = y(Qn, "offset", qc),
	ns = y(Qn, "roundingMode", Wc),
	ts = "PlainYearMonth",
	es = "PlainMonthDay",
	rs = "PlainDate",
	os = "PlainDateTime",
	is = "PlainTime",
	cs = "ZonedDateTime",
	ss = "Instant",
	us = "Duration",
	as = [
		Math.floor,
		(n) => (R(n) ? Math.floor(n) : Math.round(n)),
		Math.ceil,
		(n) => (R(n) ? Math.ceil(n) : Math.round(n)),
		Math.trunc,
		(n) => (R(n) ? Math.trunc(n) || 0 : Math.round(n)),
		(n) => (n < 0 ? Math.floor(n) : Math.ceil(n)),
		(n) => Math.sign(n) * Math.round(Math.abs(n)) || 0,
		(n) => (R(n) ? (n = Math.trunc(n) || 0) + (n % 2) : Math.round(n)),
	],
	fs = "UTC",
	ls = 5184e3,
	ds = yn(1847),
	hs = yn(new Date().getUTCFullYear() + 10),
	gs = /0+$/,
	ms = o(Qt, WeakMap),
	ws = 2 ** 32 - 1,
	ps = o((n) => {
		const t = tr(n);
		return "object" == typeof t ? new bs(t) : new ys(t || 0);
	});
class ys {
	constructor(n) {
		this.v = n;
	}
	getOffsetNanosecondsFor() {
		return this.v;
	}
	getPossibleInstantsFor(n) {
		return [pn(n, this.v)];
	}
	l() {}
}
class bs {
	constructor(n) {
		this.$ = ((n) => {
			function t(n) {
				const t = N(n, c, s),
					[o, u] = Ce(t),
					a = r(o),
					f = r(u);
				return a === f ? a : e(i(o, u), a, f, n);
			}
			function e(t, e, r, o) {
				let i, c;
				for (
					;
					(void 0 === o ||
						void 0 === (i = o < t[0] ? e : o >= t[1] ? r : void 0)) &&
					(c = t[1] - t[0]);

				) {
					const e = t[0] + Math.floor(c / 2);
					n(e) === r ? (t[1] = e) : (t[0] = e + 1);
				}
				return i;
			}
			const r = o(n),
				i = o(Pe);
			let c = ds,
				s = hs;
			return {
				G(n) {
					const e = t(n - 86400),
						r = t(n + 86400),
						o = n - e,
						i = n - r;
					if (e === r) return [o];
					const c = t(o);
					return c === t(i) ? [n - c] : e > r ? [o, i] : [];
				},
				V: t,
				l(n, t) {
					const o = N(n, c, s);
					let [u, a] = Ce(o);
					const f = ls * t,
						l =
							t < 0 ? () => a > c || ((c = o), 0) : () => u < s || ((s = o), 0);
					for (; l(); ) {
						const o = r(u),
							c = r(a);
						if (o !== c) {
							const r = i(u, a);
							e(r, o, c);
							const s = r[0];
							if ((M(s, n) || 1) === t) return s;
						}
						(u += f), (a += f);
					}
				},
			};
		})(
			((n) => (t) => {
				const e = cn(n, t * vi);
				return (
					yn(
						Rr(e),
						parseInt(e.month),
						parseInt(e.day),
						parseInt(e.hour),
						parseInt(e.minute),
						parseInt(e.second)
					) - t
				);
			})(n)
		);
	}
	getOffsetNanosecondsFor(n) {
		return this.$.V(hn(n)) * Ei;
	}
	getPossibleInstantsFor(n) {
		const [t, e] = [
			yn(
				(r = n).isoYear,
				r.isoMonth,
				r.isoDay,
				r.isoHour,
				r.isoMinute,
				r.isoSecond
			),
			r.isoMillisecond * Ni + r.isoMicrosecond * Mi + r.isoNanosecond,
		];
		var r;
		return this.$.G(t).map((n) => fn(K(tn(n, Ei), e)));
	}
	l(n, t) {
		const [e, r] = gn(n),
			o = this.$.l(e + (t > 0 || r ? 1 : 0), t);
		if (void 0 !== o) return tn(o, Ei);
	}
}
const Os = "([+−-])",
	vs = "(?:[.,](\\d{1,9}))?",
	Ms = `(?:(?:${Os}(\\d{6}))|(\\d{4}))-?(\\d{2})`,
	Ns = "(\\d{2})(?::?(\\d{2})(?::?(\\d{2})" + vs + ")?)?",
	Es = Os + Ns,
	Fs = Ms + "-?(\\d{2})(?:[T ]" + Ns + "(Z|" + Es + ")?)?",
	js = "\\[(!?)([^\\]]*)\\]",
	Is = `((?:${js}){0,9})`,
	Ts = Ke(Ms + Is),
	Rs = Ke("(?:--)?(\\d{2})-?(\\d{2})" + Is),
	Ds = Ke(Fs + Is),
	Ss = Ke("T?" + Ns + "(?:" + Es + ")?" + Is),
	Zs = Ke(Es),
	Ps = new RegExp(js, "g"),
	Cs = Ke(
		`${Os}?P(\\d+Y)?(\\d+M)?(\\d+W)?(\\d+D)?(?:T(?:(\\d+)${vs}H)?(?:(\\d+)${vs}M)?(?:(\\d+)${vs}S)?)?`
	),
	Ys = o(
		(n) =>
			new bc(Oc, {
				timeZone: n,
				era: "short",
				year: "numeric",
				month: "numeric",
				day: "numeric",
				hour: "numeric",
				minute: "numeric",
				second: "numeric",
			})
	),
	ks =
		/^(AC|AE|AG|AR|AS|BE|BS|CA|CN|CS|CT|EA|EC|IE|IS|JS|MI|NE|NS|PL|PN|PR|PS|SS|VS)T$/,
	Us = o(Fr),
	$s = o(
		(n) =>
			new bc(Oc, {
				calendar: n,
				timeZone: fs,
				era: "short",
				year: "numeric",
				month: "short",
				day: "numeric",
			})
	),
	xs = /^M(\d{2})(L?)$/,
	Ls = { era: A, eraYear: J, year: J, month: _, monthCode: A, day: _ },
	Bs = wi(Ri, J),
	As = wi(ec, H),
	qs = Object.assign({}, Ls, Bs, As, { offset: A }),
	Ws = y(d, Ri, lc),
	Js = {
		dateAdd(n, e, r) {
			const o = kn(r);
			let i,
				{ years: c, months: s, weeks: u, days: a } = e;
			if (((a += Te(e, 5)[0]), c || s))
				i = ((n, e, r, o, i) => {
					let [c, s, u] = n.h(e);
					if (r) {
						const [e, o] = n.I(c, s);
						(c += r), (s = qr(e, o, n.U(c))), (s = t("month", s, 1, n.L(c), i));
					}
					return (
						o && ([c, s] = n._(c, s, o)),
						(u = t("day", u, 1, n.j(c, s), i)),
						n.q(c, s, u)
					);
				})(this, n, c, s, o);
			else {
				if (!u && !a) return n;
				i = mn(n);
			}
			return (i += (7 * u + a) * Oi), un(Mn(i));
		},
		dateUntil(n, t, e) {
			if (e <= 7) {
				let r = 0,
					o = vr(Object.assign({}, n, pc), Object.assign({}, t, pc));
				return (
					7 === e && ([r, o] = j(o, 7)),
					Object.assign({}, uc, { weeks: r, days: o })
				);
			}
			const r = this.h(n),
				o = this.h(t);
			let [i, c, s] = ((n, t, e, r, o, i, c) => {
				let s = o - t,
					u = i - e,
					a = c - r;
				if (s || u) {
					const f = Math.sign(s || u);
					let l = n.j(o, i),
						d = 0;
					if (Math.sign(a) === -f) {
						const r = l;
						([o, i] = n._(o, i, -f)),
							(s = o - t),
							(u = i - e),
							(l = n.j(o, i)),
							(d = f < 0 ? -r : l);
					}
					if (((a = c - Math.min(r, l) + d), s)) {
						const [r, c] = n.I(t, e),
							[a, l] = n.I(o, i);
						if (((u = a - r || Number(l) - Number(c)), Math.sign(u) === -f)) {
							const e = f < 0 && -n.L(o);
							(s = (o -= f) - t), (u = i - qr(r, c, n.U(o)) + (e || n.L(o)));
						}
					}
				}
				return [s, u, a];
			})(this, ...r, ...o);
			return (
				8 === e && ((c += this.J(i, r[0])), (i = 0)),
				Object.assign({}, uc, { years: i, months: c, days: s })
			);
		},
		dateFromFields(n, t) {
			const e = kn(t),
				r = co(this, n),
				o = so(this, n, r, e),
				i = uo(this, n, o, r, e);
			return ot(un(this.P(r, o, i)), this.id || _i);
		},
		yearMonthFromFields(n, t) {
			const e = kn(t),
				r = co(this, n),
				o = so(this, n, r, e);
			return it(sn(this.P(r, o, 1)), this.id || _i);
		},
		monthDayFromFields(n, r) {
			const o = kn(r),
				i = !this.id,
				{ monthCode: c, year: s, month: u } = n;
			let a, f, l, d, h;
			if (void 0 !== c) {
				([a, f] = Ar(c)), (h = e(n, "day"));
				const r = this.N(a, f, h);
				if (!r) throw new RangeError(zo);
				if ((([l, d] = r), void 0 !== u && u !== d)) throw new RangeError(Ho);
				i &&
					((d = t("month", d, 1, Rc, 1)),
					(h = t("day", h, 1, Fn(void 0 !== s ? s : l, d), o)));
			} else {
				(l = void 0 === s && i ? Tc : co(this, n)),
					(d = so(this, n, l, o)),
					(h = uo(this, n, d, l, o));
				const t = this.U(l);
				(f = d === t), (a = Wr(d, t));
				const e = this.N(a, f, h);
				if (!e) throw new RangeError(zo);
				[l, d] = e;
			}
			return ct(un(this.P(l, d, h)), this.id || _i);
		},
		fields(n) {
			return Hr(this) && n.includes("year") ? [...n, ...Yi] : n;
		},
		mergeFields(n, t) {
			const e = Object.assign(Object.create(null), n);
			return (
				ao(e, t, xi),
				Hr(this) && (ao(e, t, ki), this.id === Gi && ao(e, t, Wi, Yi)),
				e
			);
		},
		inLeapYear(n) {
			const [t] = this.h(n);
			return this.K(t);
		},
		monthsInYear(n) {
			const [t] = this.h(n);
			return this.L(t);
		},
		daysInMonth(n) {
			const [t, e] = this.h(n);
			return this.j(t, e);
		},
		daysInYear(n) {
			const [t] = this.h(n);
			return this.X(t);
		},
		dayOfYear: Br,
		era(n) {
			return this.ee(n)[0];
		},
		eraYear(n) {
			return this.ee(n)[1];
		},
		monthCode(n) {
			const [t, e] = this.h(n),
				[r, o] = this.I(t, e);
			return ((n, t) => "M" + pi(n) + (t ? "L" : ""))(r, o);
		},
		dayOfWeek: Tn,
		daysInWeek: () => 7,
	},
	Hs = { dayOfYear: Br, h: Nn, q: bn },
	_s = Object.assign({}, Hs, {
		weekOfYear: xr,
		yearOfWeek: Lr,
		R(n) {
			function t(n) {
				return (7 - n < r ? 7 : 0) - n;
			}
			function e(n) {
				const e = jn(d + n),
					r = n || 1,
					o = t(F(u + e * r, 7));
				return (f = (e + (o - a) * r) / 7);
			}
			const r = this.id ? 1 : 4,
				o = Tn(n),
				i = this.dayOfYear(n),
				c = F(o - 1, 7),
				s = i - 1,
				u = F(c - s, 7),
				a = t(u);
			let f,
				l = Math.floor((s - a) / 7) + 1,
				d = n.isoYear;
			return l ? l > e(0) && ((l = 1), d++) : ((l = e(-1)), d--), [l, d, f];
		},
	}),
	zs = {
		dayOfYear: Br,
		h: Dr,
		q: Sr,
		weekOfYear: xr,
		yearOfWeek: Lr,
		R: () => [],
	},
	Gs = po(
		Object.assign({}, Js, _s, {
			h: Nn,
			ee(n) {
				return this.id === zi ? Rn(n) : this.id === Gi ? Sc(n) : [];
			},
			I: (n, t) => [t, 0],
			N(n, t) {
				if (!t) return [Tc, n];
			},
			K: In,
			U() {},
			L: En,
			J: (n) => n * Rc,
			j: Fn,
			X: jn,
			P: (n, t, e) => ({ isoYear: n, isoMonth: t, isoDay: e }),
			q: bn,
			_: (n, t, e) => (
				(n += I(e, Rc)),
				(t += T(e, Rc)) < 1 ? (n--, (t += Rc)) : t > Rc && (n++, (t -= Rc)),
				[n, t]
			),
			year: (n) => n.isoYear,
			month: (n) => n.isoMonth,
			day: (n) => n.isoDay,
		}),
		Object.assign({}, Js, zs, {
			h: Dr,
			ee(n) {
				const t = this.O(n);
				return [t.era, t.eraYear];
			},
			I(n, t) {
				const e = Zr.call(this, n);
				return [Wr(t, e), e === t];
			},
			N(n, t, e) {
				let [r, o, i] = Dr.call(this, {
					isoYear: Tc,
					isoMonth: Rc,
					isoDay: 31,
				});
				const c = Zr.call(this, r),
					s = o === c;
				1 === (M(n, Wr(o, c)) || M(Number(t), Number(s)) || M(e, i)) && r--;
				for (let o = 0; o < 100; o++) {
					const i = r - o,
						c = Zr.call(this, i),
						s = qr(n, t, c);
					if (t === (s === c) && e <= Cr.call(this, i, s)) return [i, s];
				}
			},
			K(n) {
				const t = Pr.call(this, n);
				return t > Pr.call(this, n - 1) && t > Pr.call(this, n + 1);
			},
			U: Zr,
			L: Yr,
			J(n, t) {
				const e = t + n,
					r = Math.sign(n),
					o = r < 0 ? -1 : 0;
				let i = 0;
				for (let n = t; n !== e; n += r) i += Yr.call(this, n + o);
				return i;
			},
			j: Cr,
			X: Pr,
			P(n, t, e) {
				return Mn(Sr.call(this, n, t, e));
			},
			q: Sr,
			_(n, t, e) {
				if (e) {
					if (((t += e), !Number.isSafeInteger(t))) throw new RangeError(ii);
					if (e < 0) for (; t < 1; ) t += Yr.call(this, --n);
					else {
						let e;
						for (; t > (e = Yr.call(this, n)); ) (t -= e), n++;
					}
				}
				return [n, t];
			},
			year(n) {
				return this.O(n).year;
			},
			month(n) {
				const { year: t, F: e } = this.O(n),
					{ C: r } = this.B(t);
				return r[e] + 1;
			},
			day(n) {
				return this.O(n).day;
			},
		})
	),
	Ks = "numeric",
	Vs = ["timeZoneName"],
	Xs = { month: Ks, day: Ks },
	Qs = { year: Ks, month: Ks },
	nu = Object.assign({}, Qs, { day: Ks }),
	tu = { hour: Ks, minute: Ks, second: Ks },
	eu = Object.assign({}, nu, tu),
	ru = Object.assign({}, eu, { timeZoneName: "short" }),
	ou = Object.keys(Qs),
	iu = Object.keys(Xs),
	cu = Object.keys(nu),
	su = Object.keys(tu),
	uu = ["dateStyle"],
	au = ou.concat(uu),
	fu = iu.concat(uu),
	lu = cu.concat(uu, ["weekday"]),
	du = su.concat(["dayPeriod", "timeStyle"]),
	hu = lu.concat(du),
	gu = hu.concat(Vs),
	mu = Vs.concat(du),
	wu = Vs.concat(lu),
	pu = Vs.concat(["day", "weekday"], du),
	yu = Vs.concat(["year", "weekday"], du),
	bu = {},
	Ou = [yo(hu, eu), at],
	vu = [
		yo(gu, ru),
		at,
		0,
		(n, t) => {
			const e = lt(n.timeZone);
			if (t && lt(t.timeZone) !== e) throw new RangeError(Qo);
			return e;
		},
	],
	Mu = [yo(hu, eu, Vs), mn],
	Nu = [yo(lu, nu, mu), mn],
	Eu = [yo(du, tu, wu), (n) => ln(n) / Ni],
	Fu = [yo(au, Qs, pu), mn, 1],
	ju = [yo(fu, Xs, yu), mn, 1];
let Iu;
function Tu(n, t, e, r, o) {
	function a(...n) {
		if (!(this instanceof a)) throw new TypeError(xo);
		Ea(this, t(...n));
	}
	function l(n, t) {
		return Object.defineProperties(function (...t) {
			return n.call(this, d(this), ...t);
		}, i(t));
	}
	function d(t) {
		const e = Na(t);
		if (!e || e.branding !== n) throw new TypeError(xo);
		return e;
	}
	return (
		Object.defineProperties(
			a.prototype,
			Object.assign({}, s(f(l, e)), c(f(l, r)), u("Temporal." + n))
		),
		Object.defineProperties(a, Object.assign({}, c(o), i(n))),
		[
			a,
			(n) => {
				const t = Object.create(a.prototype);
				return Ea(t, n), t;
			},
			d,
		]
	);
}
function Ru(n) {
	return (
		(n = n.concat("id").sort()),
		(t) => {
			if (
				!(function (n, t) {
					for (const e of t) if (!(e in n)) return 0;
					return 1;
				})(t, n)
			)
				throw new TypeError("Invalid protocol");
			return t;
		}
	);
}
function Du(n) {
	if (Na(n) || void 0 !== n.calendar || void 0 !== n.timeZone)
		throw new TypeError("Invalid bag");
	return n;
}
function Su(n, t) {
	const e = {};
	for (const r in n)
		e[r] = ({ o: n }, e) => {
			const o = Na(e) || {},
				{ branding: i } = o,
				c = i === rs || t.includes(i) ? o : zu(e);
			return n[r](c);
		};
	return e;
}
function Zu(n) {
	const t = {};
	for (const e in n)
		t[e] = (n) => {
			const { calendar: t } = n;
			return ((r = t),
			"string" == typeof r
				? Gs(r)
				: ((o = r), Object.assign(Object.create(Da), { i: o })))[e](n);
			var r, o;
		};
	return t;
}
function Pu() {
	throw new TypeError("Cannot use valueOf");
}
function Cu({ calendar: n }) {
	return "string" == typeof n ? new Rf(n) : n;
}
function Yu(n, t) {
	if (((t = Kn(t)), r(n))) {
		const e = Na(n);
		if (e && e.branding === es) return kn(t), e;
		const r = na(n);
		return Xr(pf(r || _i), !r, n, t);
	}
	const e = (function (n, t) {
		const e = We(Xi(t));
		if (e) return Ue(e), ct(Zn(e));
		const r = ke(t),
			{ calendar: o } = r,
			i = n(o),
			[c, s, u] = i.h(r),
			[a, f] = i.I(c, s),
			[l, d] = i.N(a, f, u);
		return ct(un(i.P(l, d, u)), o);
	})(Gs, n);
	return kn(t), e;
}
function ku(n, t, e) {
	return ee(C(t.call(n, Ba(tt(e)))));
}
function Uu(n, t = $a) {
	const e = Object.keys(t).sort(),
		r = {};
	for (const o of e) r[o] = y(t[o], n, tc(n[o]));
	return r;
}
function $u(n, t) {
	return "string" == typeof n ? ps(n) : Uu(n, t);
}
function xu(n) {
	return $u(n, xa);
}
function Lu(n) {
	if (r(n)) {
		const t = Na(n);
		if (t)
			switch (t.branding) {
				case ss:
					return t;
				case cs:
					return tt(t.epochNanoseconds);
			}
	}
	return (function (n) {
		const t = Ae((n = A(n)));
		if (!t) throw new RangeError(di(n));
		let e;
		if (t.m) e = 0;
		else {
			if (!t.offset) throw new RangeError(di(n));
			e = Ye(t.offset);
		}
		return t.timeZone && Je(t.timeZone, 1), tt(pn(Sn(t), e));
	})(n);
}
function Bu() {
	return Ba(tt(tn(this.valueOf(), Ni)));
}
function Au(n, t, e) {
	const r = t.l(Lu(e).epochNanoseconds, n);
	return r ? Ba(tt(r)) : null;
}
function qu(n) {
	return r(n)
		? (Na(n) || {}).timeZone || Ja(n)
		: ((n) =>
				Qe(
					(function (n) {
						const t = Ae(n);
						return (t && (t.timeZone || (t.m && fs) || t.offset)) || n;
					})(Xi(n))
				))(n);
}
function Wu(n, t) {
	if (r(n)) {
		const e = Na(n) || {};
		switch (e.branding) {
			case is:
				return kn(t), e;
			case os:
				return kn(t), st(e);
			case cs:
				return kn(t), go(xu, e);
		}
		return (function (n, t) {
			const e = kn(t);
			return st(to(no(n, Di, [], 1), e));
		})(n, t);
	}
	return (
		kn(t),
		(function (n) {
			let t,
				e = ((n) => {
					const t = Ss.exec(n);
					return t ? (ze(t[10]), _e(t)) : void 0;
				})(Xi(n));
			if (!e) {
				if (((e = Ae(n)), !e)) throw new RangeError(di(n));
				if (!e.p) throw new RangeError(di(n));
				if (e.m) throw new RangeError(hi("Z"));
				Ue(e);
			}
			if ((t = qe(n)) && Pn(t)) throw new RangeError(di(n));
			if ((t = We(n)) && Pn(t)) throw new RangeError(di(n));
			return st(Yn(e, 1));
		})(n)
	);
}
function Ju(n) {
	return void 0 === n ? void 0 : Wu(n);
}
function Hu(n, t) {
	if (((t = Kn(t)), r(n))) {
		const e = Na(n);
		return e && e.branding === ts ? (kn(t), e) : Vr(mf(Qu(n)), n, t);
	}
	const e = (function (n, t) {
		const e = qe(Xi(t));
		if (e) return Ue(e), it(sn(Zn(e)));
		const r = ke(t);
		return it(he(n(r.calendar), r));
	})(Gs, n);
	return kn(t), e;
}
function _u(n, t) {
	if (((t = Kn(t)), r(n))) {
		const e = Na(n) || {};
		switch (e.branding) {
			case os:
				return kn(t), e;
			case rs:
				return kn(t), rt(Object.assign({}, e, pc));
			case cs:
				return kn(t), lo(xu, e);
		}
		return (function (n, t, e) {
			const r = Qr(n, t, qi, [], Ri),
				o = kn(e);
			return rt(an(Object.assign({}, n.dateFromFields(r, Vn(e, o)), to(r, o))));
		})(wf(Qu(n)), n, t);
	}
	const e = (function (n) {
		const t = Ae(Xi(n));
		if (!t || t.m) throw new RangeError(di(n));
		return rt(xe(t));
	})(n);
	return kn(t), e;
}
function zu(n, t) {
	if (((t = Kn(t)), r(n))) {
		const e = Na(n) || {};
		switch (e.branding) {
			case rs:
				return kn(t), e;
			case os:
				return kn(t), ot(e);
			case cs:
				return kn(t), ho(xu, e);
		}
		return Kr(wf(Qu(n)), n, t);
	}
	const e = ke(n);
	return kn(t), e;
}
function Gu(n, t, e) {
	return P(t.call(n, nf(ot(e, n))));
}
function Ku(n) {
	return (t) =>
		"string" == typeof t
			? Gs(t)
			: ((n, t) => {
					const e = Object.keys(t).sort(),
						r = {};
					for (const o of e) r[o] = y(t[o], n, n[o]);
					return r;
			  })(t, n);
}
function Vu(n) {
	if (r(n)) {
		const t = Na(n);
		return t && t.branding === us
			? t
			: (function (n) {
					const t = no(n, rc);
					return ut(je(Object.assign({}, uc, t)));
			  })(n);
	}
	return (function (n) {
		const t = ((n) => {
			const t = Cs.exec(n);
			return t
				? ((n) => {
						function t(n, t, i) {
							let c = 0,
								s = 0;
							if ((i && ([c, o] = E(o, Ti[i])), void 0 !== n)) {
								if (r) throw new RangeError(hi(n));
								(s = ((n) => {
									const t = parseInt(n);
									if (!Number.isFinite(t)) throw new RangeError(hi(n));
									return t;
								})(n)),
									(e = 1),
									t && ((o = Ge(t) * (Ti[i] / Ei)), (r = 1));
							}
							return c + s;
						}
						let e = 0,
							r = 0,
							o = 0,
							i = Object.assign(
								{},
								a(ec, [
									t(n[2]),
									t(n[3]),
									t(n[4]),
									t(n[5]),
									t(n[6], n[7], 5),
									t(n[8], n[9], 4),
									t(n[10], n[11], 3),
								]),
								S(o, 2, ec)
							);
						if (!e) throw new RangeError(Uo(ec));
						return Ve(n[1]) < 0 && (i = Ee(i)), i;
				  })(t)
				: void 0;
		})(Xi(n));
		if (!t) throw new RangeError(di(n));
		return ut(je(t));
	})(n);
}
function Xu(n) {
	if (void 0 !== n) {
		if (r(n)) {
			const t = Na(n) || {};
			switch (t.branding) {
				case cs:
				case rs:
					return t;
				case os:
					return ot(t);
			}
			const e = Qu(n);
			return Object.assign({}, Gr(qu, $u, wf(e), n), { calendar: e });
		}
		return (function (n) {
			const t = Ae(Xi(n));
			if (!t) throw new RangeError(di(n));
			if (t.timeZone) return $e(t, t.offset ? Ye(t.offset) : void 0);
			if (t.m) throw new RangeError(di(n));
			return Le(t);
		})(n);
	}
}
function Qu(n) {
	return na(n) || _i;
}
function na(n) {
	const { calendar: t } = n;
	if (void 0 !== t) return ta(t);
}
function ta(n) {
	return r(n)
		? (Na(n) || {}).calendar || Df(n)
		: ((n) =>
				Ur(
					(function (n) {
						const t = Ae(n) || qe(n) || We(n);
						return t ? t.calendar : n;
					})(Xi(n))
				))(n);
}
function ea(n, t) {
	if (((t = Kn(t)), r(n))) {
		const e = Na(n);
		if (e && e.branding === cs) return Un(t), e;
		const r = Qu(n);
		return (function (n, t, e, r, o, i) {
			const c = Qr(e, o, qi, Zi, Ci),
				s = n(c.timeZone),
				[u, a, f] = Un(i),
				l = e.dateFromFields(c, Vn(i, u)),
				d = to(c, u);
			return et(
				ne(
					t(s),
					Object.assign({}, l, d),
					void 0 !== c.offset ? Ye(c.offset) : void 0,
					a,
					f
				),
				s,
				r
			);
		})(qu, $u, wf(r), r, n, t);
	}
	return (function (n, t) {
		const e = Ae(Xi(n));
		if (!e || !e.timeZone) throw new RangeError(di(n));
		const { offset: r } = e,
			o = r ? Ye(r) : void 0,
			[, i, c] = Un(t);
		return $e(e, o, i, c);
	})(n, t);
}
function ra(n) {
	return f((n) => (t) => n(oa(t)), n);
}
function oa(n) {
	return ms(n, xu);
}
function ia() {
	const n = bc.prototype,
		t = Object.getOwnPropertyDescriptors(n),
		e = Object.getOwnPropertyDescriptors(bc),
		r = function (n, t = {}) {
			if (!(this instanceof r)) return new r(n, t);
			kf.set(
				this,
				((n, t = {}) => {
					const e = new bc(n, t),
						r = e.resolvedOptions(),
						i = r.locale,
						c = h(Object.keys(t), r),
						s = o(ua),
						u = (...n) => {
							let t;
							const r = n.map((n, e) => {
								const r = Na(n),
									o = (r || {}).branding;
								if (e && t && t !== o)
									throw new TypeError("Mismatching types for formatting");
								return (t = o), r;
							});
							return t ? s(t)(i, c, ...r) : [e, ...n];
						};
					return (u.u = e), u;
				})(n, t)
			);
		};
	for (const n in t) {
		const e = t[n],
			o = n.startsWith("format") && ca(n);
		"function" == typeof e.value
			? (e.value = "constructor" === n ? r : o || sa(n))
			: o &&
			  (e.get = function () {
					return o.bind(this);
			  });
	}
	return (
		(e.prototype.value = Object.create(n, t)), Object.defineProperties(r, e), r
	);
}
function ca(n) {
	return function (...t) {
		const e = kf.get(this),
			[r, ...o] = e(...t);
		return r[n](...o);
	};
}
function sa(n) {
	return function (...t) {
		return kf.get(this).u[n](...t);
	};
}
function ua(n) {
	const t = aa[n];
	if (!t) throw new TypeError(((n) => `Cannot format ${n}`)(n));
	return bo(t, o(Oo));
}
const aa = {
		Instant: Ou,
		PlainDateTime: Mu,
		PlainDate: Nu,
		PlainTime: Eu,
		PlainYearMonth: Fu,
		PlainMonthDay: ju,
	},
	fa = bo(Ou),
	la = bo(vu),
	da = bo(Mu),
	ha = bo(Nu),
	ga = bo(Eu),
	ma = bo(Fu),
	wa = bo(ju),
	pa = {
		era: function (n) {
			if (void 0 !== n) return Xi(n);
		},
		eraYear: Z,
		year: C,
		month: P,
		daysInMonth: P,
		daysInYear: P,
		inLeapYear: Qi,
		monthsInYear: P,
	},
	ya = { monthCode: Xi },
	ba = { day: P },
	Oa = {
		dayOfWeek: P,
		dayOfYear: P,
		weekOfYear: function (n) {
			if (void 0 !== n) return P(n);
		},
		yearOfWeek: Z,
		daysInWeek: P,
	},
	va = Object.assign({}, pa, ya, ba, Oa),
	Ma = new WeakMap(),
	Na = Ma.get.bind(Ma),
	Ea = Ma.set.bind(Ma),
	Fa = Object.assign(Su(pa, [ts]), Su(Oa, []), Su(ya, [ts, es]), Su(ba, [es])),
	ja = Zu(va),
	Ia = Zu(Object.assign({}, pa, ya)),
	Ta = Zu(Object.assign({}, ya, ba)),
	Ra = { calendarId: (n) => lt(n.calendar) },
	Da = f(
		(n, t) =>
			function (e) {
				const { i: r } = this;
				return n(r[t](nf(ot(e, r))));
			},
		va
	),
	Sa = l((n) => (t) => t[n], ec.concat("sign")),
	Za = l((n, t) => (n) => n[lc[t]], Ri),
	Pa = {
		epochSeconds: function (n) {
			return hn(n.epochNanoseconds);
		},
		epochMilliseconds: at,
		epochMicroseconds: function (n) {
			return en(n.epochNanoseconds, Mi);
		},
		epochNanoseconds: function (n) {
			return en(n.epochNanoseconds);
		},
	},
	Ca = y(g, new Set(["branding"])),
	[Ya, ka, Ua] = Tu(
		es,
		y(function (n, t, e, r = _i, o = Tc) {
			const i = J(t),
				c = J(e),
				s = n(r);
			return ct(un(Zn({ isoYear: J(o), isoMonth: i, isoDay: c })), s);
		}, ta),
		Object.assign({}, Ra, Ta),
		{
			getISOFields: Ca,
			getCalendar: Cu,
			with(n, t, e) {
				return ka(
					(function (n, t, e, r, o) {
						const i = Kn(o);
						return ((n, t, e, r) => {
							const o = eo(n, t, e, qi);
							return n.monthDayFromFields(o, r);
						})(n(t.calendar), e, r, i);
					})(Of, n, this, Du(t), e)
				);
			},
			equals: (n, t) =>
				(function (n, t) {
					return !ir(n, t) && dt(n.calendar, t.calendar);
				})(n, Yu(t)),
			toPlainDate(n, t) {
				return nf(
					(function (n, t, e, r) {
						return ((n, t, e) => io(n, t, Ji, U(e), Ui))(n(t.calendar), e, r);
					})(bf, n, this, t)
				);
			},
			toLocaleString(n, t, e) {
				const [r, o] = wa(t, e, n);
				return r.format(o);
			},
			toString: Ut,
			toJSON: (n) => Ut(n),
			valueOf: Pu,
		},
		{ from: (n, t) => ka(Yu(n, t)) }
	),
	$a = {
		getOffsetNanosecondsFor: ku,
		getPossibleInstantsFor(n, t, e) {
			const r = [...t.call(n, Xa(rt(e, _i)))].map(
					(n) => Aa(n).epochNanoseconds
				),
				o = r.length;
			return o > 1 && (r.sort(X), re(rn(V(r[0], r[o - 1])))), r;
		},
	},
	xa = { getOffsetNanosecondsFor: ku },
	[La, Ba, Aa] = Tu(
		ss,
		function (n) {
			return tt(fn(nn(q(n))));
		},
		Pa,
		{
			add: (n, t) => Ba(oe(0, n, Vu(t))),
			subtract: (n, t) => Ba(oe(1, n, Vu(t))),
			until: (n, t, e) => jf(ur(0, n, Lu(t), e)),
			since: (n, t, e) => jf(ur(1, n, Lu(t), e)),
			round: (n, t) =>
				Ba(
					(function (n, t) {
						const [e, r, o] = Ln(t, 5, 1);
						return tt(Ft(n.epochNanoseconds, e, r, o, 1));
					})(n, t)
				),
			equals: (n, t) =>
				(function (n, t) {
					return !er(n, t);
				})(n, Lu(t)),
			toZonedDateTime(n, t) {
				const e = U(t);
				return Zf(fo(n, qu(e.timeZone), ta(e.calendar)));
			},
			toZonedDateTimeISO: (n, t) => Zf(fo(n, qu(t))),
			toLocaleString(n, t, e) {
				const [r, o] = fa(t, e, n);
				return r.format(o);
			},
			toString: (n, t) => Zt(qu, xu, n, t),
			toJSON: (n) => Zt(qu, xu, n),
			valueOf: Pu,
		},
		{
			from: (n) => Ba(Lu(n)),
			fromEpochSeconds: (n) =>
				Ba(
					(function (n) {
						return tt(fn(tn(n, Ei)));
					})(n)
				),
			fromEpochMilliseconds: (n) =>
				Ba(
					(function (n) {
						return tt(fn(tn(n, Ni)));
					})(n)
				),
			fromEpochMicroseconds: (n) =>
				Ba(
					(function (n) {
						return tt(fn(nn(q(n), Mi)));
					})(n)
				),
			fromEpochNanoseconds: (n) =>
				Ba(
					(function (n) {
						return tt(fn(nn(q(n))));
					})(n)
				),
			compare: (n, t) => er(Lu(n), Lu(t)),
		}
	),
	[qa, Wa] = Tu(
		"TimeZone",
		(n) => {
			const t = (function (n) {
				return Qe(Xi(n));
			})(n);
			return { branding: "TimeZone", id: t, o: ps(t) };
		},
		{ id: (n) => n.id },
		{
			getPossibleInstantsFor: ({ o: n }, t) =>
				n.getPossibleInstantsFor(_u(t)).map((n) => Ba(tt(n))),
			getOffsetNanosecondsFor: ({ o: n }, t) =>
				n.getOffsetNanosecondsFor(Lu(t).epochNanoseconds),
			getOffsetStringFor(n, t) {
				const e = Lu(t).epochNanoseconds;
				return _t(Uu(this, xa).getOffsetNanosecondsFor(e));
			},
			getPlainDateTimeFor(n, t, e = _i) {
				const r = Lu(t).epochNanoseconds,
					o = Uu(this, xa).getOffsetNanosecondsFor(r);
				return Xa(rt(vn(r, o), ta(e)));
			},
			getInstantFor(n, t, e) {
				const r = _u(t),
					o = $n(e),
					i = Uu(this);
				return Ba(tt(te(i, r, o)));
			},
			getNextTransition: ({ o: n }, t) => Au(1, n, t),
			getPreviousTransition: ({ o: n }, t) => Au(-1, n, t),
			equals(n, t) {
				return !!sr(this, qu(t));
			},
			toString: (n) => n.id,
			toJSON: (n) => n.id,
		},
		{
			from(n) {
				const t = qu(n);
				return "string" == typeof t ? new qa(t) : t;
			},
		}
	),
	Ja = Ru(Object.keys($a)),
	[Ha, _a] = Tu(
		is,
		function (n = 0, t = 0, e = 0, r = 0, o = 0, i = 0) {
			return st(Yn(f(J, a(lc, [n, t, e, r, o, i])), 1));
		},
		Za,
		{
			getISOFields: Ca,
			with(n, t, e) {
				return _a(
					(function (n, t, e) {
						return st(
							((n, t, e) => {
								const r = kn(e);
								return to(Object.assign({}, h(Di, n), no(t, Di)), r);
							})(n, t, e)
						);
					})(this, Du(t), e)
				);
			},
			add: (n, t) => _a(ae(0, n, Vu(t))),
			subtract: (n, t) => _a(ae(1, n, Vu(t))),
			until: (n, t, e) => jf(gr(0, n, Wu(t), e)),
			since: (n, t, e) => jf(gr(1, n, Wu(t), e)),
			round: (n, t) =>
				_a(
					(function (n, t) {
						const [e, r, o] = Ln(t, 5);
						var i;
						return st(((i = o), yt(n, Ot(e, r), i)[0]));
					})(n, t)
				),
			equals: (n, t) =>
				(function (n, t) {
					return !cr(n, t);
				})(n, Wu(t)),
			toZonedDateTime: (n, t) =>
				Zf(
					(function (n, t, e, r, o) {
						const i = U(o),
							c = t(i.plainDate),
							s = n(i.timeZone);
						return et(te(e(s), Object.assign({}, c, r)), s, c.calendar);
					})(qu, zu, $u, n, t)
				),
			toPlainDateTime: (n, t) =>
				Xa(
					(function (n, t) {
						return rt(an(Object.assign({}, n, t)));
					})(n, zu(t))
				),
			toLocaleString(n, t, e) {
				const [r, o] = ga(t, e, n);
				return r.format(o);
			},
			toString: $t,
			toJSON: (n) => $t(n),
			valueOf: Pu,
		},
		{ from: (n, t) => _a(Wu(n, t)), compare: (n, t) => cr(Wu(n), Wu(t)) }
	),
	[za, Ga, Ka] = Tu(
		ts,
		y(function (n, t, e, r = _i, o = 1) {
			const i = J(t),
				c = J(e),
				s = n(r);
			return it(sn(Zn({ isoYear: i, isoMonth: c, isoDay: J(o) })), s);
		}, ta),
		Object.assign({}, Ra, Ia),
		{
			getISOFields: Ca,
			getCalendar: Cu,
			with(n, t, e) {
				return Ga(
					(function (n, t, e, r, o) {
						const i = Kn(o);
						return it(
							((n, t, e, r) => {
								const o = eo(n, t, e, Bi);
								return n.yearMonthFromFields(o, r);
							})(n(t.calendar), e, r, i)
						);
					})(yf, n, this, Du(t), e)
				);
			},
			add: (n, t, e) => Ga(ue(Nf, 0, n, Vu(t), e)),
			subtract: (n, t, e) => Ga(ue(Nf, 1, n, Vu(t), e)),
			until: (n, t, e) => jf(dr(Ef, 0, n, Hu(t), e)),
			since: (n, t, e) => jf(dr(Ef, 1, n, Hu(t), e)),
			equals: (n, t) =>
				(function (n, t) {
					return !ir(n, t) && dt(n.calendar, t.calendar);
				})(n, Hu(t)),
			toPlainDate(n, t) {
				return nf(
					(function (n, t, e, r) {
						return ((n, t, e) => io(n, t, Ai, U(e), Li))(n(t.calendar), e, r);
					})(bf, n, this, t)
				);
			},
			toLocaleString(n, t, e) {
				const [r, o] = ma(t, e, n);
				return r.format(o);
			},
			toString: kt,
			toJSON: (n) => kt(n),
			valueOf: Pu,
		},
		{ from: (n, t) => Ga(Hu(n, t)), compare: (n, t) => ir(Hu(n), Hu(t)) }
	),
	[Va, Xa] = Tu(
		os,
		y(function (n, t, e, r, o = 0, i = 0, c = 0, s = 0, u = 0, l = 0, d = _i) {
			return rt(an(Sn(f(J, a(hc, [t, e, r, o, i, c, s, u, l])))), n(d));
		}, ta),
		Object.assign({}, Ra, ja, Za),
		{
			getISOFields: Ca,
			getCalendar: Cu,
			with(n, t, e) {
				return Xa(
					(function (n, t, e, r, o) {
						const i = Kn(o);
						return rt(
							((n, t, e, r) => {
								const o = eo(n, t, e, qi, Ri),
									i = kn(r);
								return an(
									Object.assign({}, n.dateFromFields(o, Vn(r, i)), to(o, i))
								);
							})(n(t.calendar), e, r, i)
						);
					})(bf, n, this, Du(t), e)
				);
			},
			withCalendar: (n, t) => Xa(mo(n, ta(t))),
			withPlainDate: (n, t) =>
				Xa(
					(function (n, t) {
						return rt(Object.assign({}, n, t), wo(n.calendar, t.calendar));
					})(n, zu(t))
				),
			withPlainTime: (n, t) =>
				Xa(
					(function (n, t = pc) {
						return rt(Object.assign({}, n, t));
					})(n, Ju(t))
				),
			add: (n, t, e) => Xa(ce(vf, 0, n, Vu(t), e)),
			subtract: (n, t, e) => Xa(ce(vf, 1, n, Vu(t), e)),
			until: (n, t, e) => jf(fr(Mf, 0, n, _u(t), e)),
			since: (n, t, e) => jf(fr(Mf, 1, n, _u(t), e)),
			round: (n, t) =>
				Xa(
					(function (n, t) {
						return rt(wt(n, ...Ln(t)), n.calendar);
					})(n, t)
				),
			equals: (n, t) =>
				(function (n, t) {
					return !or(n, t) && dt(n.calendar, t.calendar);
				})(n, _u(t)),
			toZonedDateTime: (n, t, e) =>
				Zf(
					(function (n, t, e, r) {
						const o = ((n, t, e, r) => {
							const o = $n(r);
							return te(n(t), e, o);
						})(n, e, t, r);
						return et(fn(o), e, t.calendar);
					})($u, n, qu(t), e)
				),
			toPlainDate: (n) => nf(ot(n)),
			toPlainTime: (n) => _a(st(n)),
			toPlainYearMonth(n) {
				return Ga(
					(function (n, t, e) {
						const r = n(t.calendar);
						return it(Object.assign({}, t, oo(r, e)));
					})(mf, n, this)
				);
			},
			toPlainMonthDay(n) {
				return ka(
					(function (n, t, e) {
						return ro(n(t.calendar), e);
					})(pf, n, this)
				);
			},
			toLocaleString(n, t, e) {
				const [r, o] = da(t, e, n);
				return r.format(o);
			},
			toString: Ct,
			toJSON: (n) => Ct(n),
			valueOf: Pu,
		},
		{ from: (n, t) => Xa(_u(n, t)), compare: (n, t) => or(_u(n), _u(t)) }
	),
	[Qa, nf, tf] = Tu(
		rs,
		y(function (n, t, e, r, o = _i) {
			return ot(un(Zn(f(J, { isoYear: t, isoMonth: e, isoDay: r }))), n(o));
		}, ta),
		Object.assign({}, Ra, ja),
		{
			getISOFields: Ca,
			getCalendar: Cu,
			with(n, t, e) {
				return nf(
					(function (n, t, e, r, o) {
						const i = Kn(o);
						return ((n, t, e, r) => {
							const o = eo(n, t, e, qi);
							return n.dateFromFields(o, r);
						})(n(t.calendar), e, r, i);
					})(bf, n, this, Du(t), e)
				);
			},
			withCalendar: (n, t) => nf(mo(n, ta(t))),
			add: (n, t, e) => nf(se(vf, 0, n, Vu(t), e)),
			subtract: (n, t, e) => nf(se(vf, 1, n, Vu(t), e)),
			until: (n, t, e) => jf(lr(Mf, 0, n, zu(t), e)),
			since: (n, t, e) => jf(lr(Mf, 1, n, zu(t), e)),
			equals: (n, t) =>
				(function (n, t) {
					return !ir(n, t) && dt(n.calendar, t.calendar);
				})(n, zu(t)),
			toZonedDateTime(n, t) {
				const e = !r(t) || t instanceof qa ? { timeZone: t } : t;
				return Zf(
					(function (n, t, e, r, o) {
						const i = n(o.timeZone),
							c = o.plainTime,
							s = void 0 !== c ? t(c) : pc;
						return et(te(e(i), Object.assign({}, r, s)), i, r.calendar);
					})(qu, Wu, $u, n, e)
				);
			},
			toPlainDateTime: (n, t) =>
				Xa(
					(function (n, t = pc) {
						return rt(an(Object.assign({}, n, t)));
					})(n, Ju(t))
				),
			toPlainYearMonth(n) {
				return Ga(
					(function (n, t, e) {
						return oo(n(t.calendar), e);
					})(mf, n, this)
				);
			},
			toPlainMonthDay(n) {
				return ka(
					(function (n, t, e) {
						return ro(n(t.calendar), e);
					})(pf, n, this)
				);
			},
			toLocaleString(n, t, e) {
				const [r, o] = ha(t, e, n);
				return r.format(o);
			},
			toString: Yt,
			toJSON: (n) => Yt(n),
			valueOf: Pu,
		},
		{ from: (n, t) => nf(zu(n, t)), compare: (n, t) => ir(zu(n), zu(t)) }
	),
	ef = { fields: (n, t, e) => [...t.call(n, e)] },
	rf = Object.assign(
		{
			dateFromFields: (n, t, e, r) =>
				tf(t.call(n, Object.assign(Object.create(null), e), r)),
		},
		ef
	),
	of = Object.assign(
		{
			yearMonthFromFields: (n, t, e, r) =>
				Ka(t.call(n, Object.assign(Object.create(null), e), r)),
		},
		ef
	),
	cf = Object.assign(
		{
			monthDayFromFields: (n, t, e, r) =>
				Ua(t.call(n, Object.assign(Object.create(null), e), r)),
		},
		ef
	),
	sf = {
		mergeFields: (n, t, e, r) =>
			U(
				t.call(
					n,
					Object.assign(Object.create(null), e),
					Object.assign(Object.create(null), r)
				)
			),
	},
	uf = Object.assign({}, rf, sf),
	af = Object.assign({}, of, sf),
	ff = Object.assign({}, cf, sf),
	lf = {
		dateAdd: (n, t, e, r, o) => tf(t.call(n, nf(ot(e, n)), jf(ut(r)), o)),
	},
	df = Object.assign({}, lf, {
		dateUntil: (n, t, e, r, o, i) =>
			If(
				t.call(
					n,
					nf(ot(e, n)),
					nf(ot(r, n)),
					Object.assign(Object.create(null), i, { largestUnit: bi[o] })
				)
			),
	}),
	hf = Object.assign({}, lf, { day: Gu }),
	gf = Object.assign({}, df, { day: Gu }),
	mf = Ku(of),
	wf = Ku(rf),
	pf = Ku(cf),
	yf = Ku(af),
	bf = Ku(uf),
	Of = Ku(ff),
	vf = Ku(lf),
	Mf = Ku(df),
	Nf = Ku(hf),
	Ef = Ku(gf),
	[Ff, jf, If] = Tu(
		us,
		function (
			n = 0,
			t = 0,
			e = 0,
			r = 0,
			o = 0,
			i = 0,
			c = 0,
			s = 0,
			u = 0,
			l = 0
		) {
			return ut(je(f(H, a(ec, [n, t, e, r, o, i, c, s, u, l]))));
		},
		Object.assign({}, Sa, {
			blank: function (n) {
				return !n.sign;
			},
		}),
		{
			with: (n, t) =>
				jf(
					(function (n, t) {
						return ut(((e = n), (r = t), je(Object.assign({}, e, no(r, rc)))));
						var e, r;
					})(n, t)
				),
			negated: (n) => jf(Ne(n)),
			abs: (n) =>
				jf(
					(function (n) {
						return -1 === n.sign ? Ne(n) : n;
					})(n)
				),
			add: (n, t, e) => jf(Me(Xu, Mf, $u, 0, n, Vu(t), e)),
			subtract: (n, t, e) => jf(Me(Xu, Mf, $u, 1, n, Vu(t), e)),
			round: (n, t) =>
				jf(
					(function (n, t, e, r, o) {
						const i = Ze(r),
							[c, s, u, a, f] = ((n, t, e) => {
								n = Gn(n, Zc);
								let r = Hc(n);
								const o = e(n[kc]);
								let i = Jn(n);
								const c = ns(n, 7);
								let s = Jc(n);
								if (void 0 === r && void 0 === s) throw new RangeError(fi);
								return (
									null == s && (s = 0),
									null == r && (r = Math.max(s, t)),
									nt(r, s),
									(i = Hn(i, s, 1)),
									[r, s, i, c, o]
								);
							})(o, i, n),
							l = Math.max(i, c);
						if (!Oe(f) && l <= 6)
							return ut(
								je(
									((n, t, e, r, o) => {
										const i = Ft(Te(n), e, r, o);
										return Object.assign({}, uc, Re(i, t));
									})(r, c, s, u, a)
								)
							);
						if (!f) throw new RangeError(ui);
						const [d, h, g] = we(t, e, f),
							m = pe(g),
							w = ye(g),
							p = be(g),
							y = w(h, d, r);
						let b = p(h, d, y, c);
						const O = r.sign,
							v = Fe(b);
						if (O && v && O !== v) throw new RangeError(Ko);
						return v && (b = Et(b, m(y), c, s, u, a, h, d, m, w)), ut(b);
					})(Xu, Mf, $u, n, t)
				),
			total: (n, t) =>
				(function (n, t, e, r, o) {
					const i = Ze(r),
						[c, s] = ((n, t) => {
							const e = t((n = Gn(n, Pc))[kc]);
							let r = _c(n);
							return (r = k(Pc, r)), [r, e];
						})(o, n);
					if (ve(Math.max(c, i), s)) return ht(r, c);
					if (!s) throw new RangeError(ui);
					const [u, a, f] = we(t, e, s),
						l = pe(f),
						d = ye(f),
						h = be(f),
						g = d(a, u, r),
						m = h(a, u, g, c);
					return ve(c, s)
						? ht(m, c)
						: ((n, t, e, r, o, i, c) => {
								const s = Fe(n),
									[u, a] = gt(r, fc(e, n), e, s, o, i, c),
									f = mt(t, u, a);
								return n[ec[e]] + f * s;
						  })(m, l(g), c, a, u, l, d);
				})(Xu, Mf, $u, n, t),
			toLocaleString(n, t, e) {
				return Intl.DurationFormat
					? new Intl.DurationFormat(t, e).format(this)
					: xt(n);
			},
			toString: xt,
			toJSON: (n) => xt(n),
			valueOf: Pu,
		},
		{
			from: (n) => jf(Vu(n)),
			compare: (n, t, e) =>
				(function (n, t, e, r, o, i) {
					const c = n(zn(i).relativeTo),
						s = Math.max(Ze(r), Ze(o));
					if (w(ec, r, o)) return 0;
					if (ve(s, c)) return X(Te(r), Te(o));
					if (!c) throw new RangeError(ui);
					const [u, a, f] = we(t, e, c),
						l = pe(f),
						d = ye(f);
					return X(l(d(a, u, r)), l(d(a, u, o)));
				})(Xu, vf, $u, Vu(n), Vu(t), e),
		}
	),
	Tf = Object.assign({ toString: (n) => n.id, toJSON: (n) => n.id }, Fa, {
		dateAdd: ({ id: n, o: t }, e, r, o) =>
			nf(ot(t.dateAdd(zu(e), Vu(r), o), n)),
		dateUntil: ({ o: n }, t, e, r) =>
			jf(
				ut(
					n.dateUntil(
						zu(t),
						zu(e),
						(function (n) {
							return (n = zn(n)), Hc(n, 9, 6, 1);
						})(r)
					)
				)
			),
		dateFromFields: ({ id: n, o: t }, e, r) =>
			nf(
				Kr(
					t,
					e,
					r,
					(function (n) {
						return n === _i ? ["year", "day"] : [];
					})(n)
				)
			),
		yearMonthFromFields: ({ id: n, o: t }, e, r) =>
			Ga(
				Vr(
					t,
					e,
					r,
					(function (n) {
						return n === _i ? Ui : [];
					})(n)
				)
			),
		monthDayFromFields: ({ id: n, o: t }, e, r) =>
			ka(
				Xr(
					t,
					0,
					e,
					r,
					(function (n) {
						return n === _i ? Li : [];
					})(n)
				)
			),
		fields({ o: n }, t) {
			const e = new Set(qi),
				r = [];
			for (const n of t) {
				if ((Xi(n), !e.has(n))) throw new RangeError(Yo(n));
				e.delete(n), r.push(n);
			}
			return n.fields(r);
		},
		mergeFields: ({ o: n }, t, e) => n.mergeFields(m(Y(t)), m(Y(e))),
	}),
	[Rf] = Tu(
		"Calendar",
		(n) => {
			const t = (function (n) {
				return Ur(Xi(n));
			})(n);
			return { branding: "Calendar", id: t, o: Gs(t) };
		},
		{ id: (n) => n.id },
		Tf,
		{
			from(n) {
				const t = ta(n);
				return "string" == typeof t ? new Rf(t) : t;
			},
		}
	),
	Df = Ru(Object.keys(Tf).slice(4)),
	[Sf, Zf] = Tu(
		cs,
		y(
			function (n, t, e, r, o = _i) {
				return et(fn(nn(q(e))), t(r), n(o));
			},
			ta,
			qu
		),
		Object.assign({}, Pa, Ra, ra(ja), ra(Za), {
			offset: (n) => _t(oa(n).offsetNanoseconds),
			offsetNanoseconds: (n) => oa(n).offsetNanoseconds,
			timeZoneId: (n) => lt(n.timeZone),
			hoursInDay: (n) =>
				(function (n, t) {
					const e = n(t.timeZone),
						r = ms(t, e),
						[o, i] = vt(r),
						c = rn(V(te(e, o), te(e, i)), ji, 1);
					if (c <= 0) throw new RangeError(Ko);
					return c;
				})($u, n),
		}),
		{
			getISOFields: (n) =>
				(function (n, t) {
					const e = ms(t, n);
					return Object.assign({ calendar: t.calendar }, h(wc, e), {
						offset: _t(e.offsetNanoseconds),
						timeZone: t.timeZone,
					});
				})(xu, n),
			getCalendar: Cu,
			getTimeZone: ({ timeZone: n }) => ("string" == typeof n ? new qa(n) : n),
			with(n, t, e) {
				return Zf(
					(function (n, t, e, r, o, i) {
						const c = Kn(i),
							{ calendar: s, timeZone: u } = e;
						return et(
							((n, t, e, r, o) => {
								const i = eo(n, e, r, qi, Pi, Si),
									[c, s, u] = Un(o, 2);
								return ne(
									t,
									Object.assign({}, n.dateFromFields(i, Vn(o, c)), to(i, c)),
									Ye(i.offset),
									s,
									u
								);
							})(n(s), t(u), r, o, c),
							u,
							s
						);
					})(bf, $u, n, this, Du(t), e)
				);
			},
			withCalendar: (n, t) => Zf(mo(n, ta(t))),
			withTimeZone: (n, t) =>
				Zf(
					(function (n, t) {
						return Object.assign({}, n, { timeZone: t });
					})(n, qu(t))
				),
			withPlainDate: (n, t) =>
				Zf(
					(function (n, t, e) {
						const r = t.timeZone,
							o = n(r),
							i = Object.assign({}, ms(t, o), e),
							c = wo(t.calendar, e.calendar);
						return et(ne(o, i, i.offsetNanoseconds, 2), r, c);
					})($u, n, zu(t))
				),
			withPlainTime: (n, t) =>
				Zf(
					(function (n, t, e = pc) {
						const r = t.timeZone,
							o = n(r),
							i = Object.assign({}, ms(t, o), e);
						return et(ne(o, i, i.offsetNanoseconds, 2), r, t.calendar);
					})($u, n, Ju(t))
				),
			add: (n, t, e) => Zf(ie(vf, $u, 0, n, Vu(t), e)),
			subtract: (n, t, e) => Zf(ie(vf, $u, 1, n, Vu(t), e)),
			until: (n, t, e) => jf(ut(ar(Mf, $u, 0, n, ea(t), e))),
			since: (n, t, e) => jf(ut(ar(Mf, $u, 1, n, ea(t), e))),
			round: (n, t) =>
				Zf(
					(function (n, t, e) {
						let { epochNanoseconds: r, timeZone: o, calendar: i } = t;
						const [c, s, u] = Ln(e);
						if (0 === c && 1 === s) return t;
						const a = n(o);
						if (6 === c)
							r = ((n, t, e, r) => {
								const o = ms(e, t),
									[i, c] = n(o),
									s = e.epochNanoseconds,
									u = te(t, i),
									a = te(t, c);
								if (Q(s, u, a)) throw new RangeError(Ko);
								return Tt(mt(s, u, a), r) ? a : u;
							})(vt, a, t, u);
						else {
							const n = a.getOffsetNanosecondsFor(r);
							r = ne(a, wt(vn(r, n), c, s, u), n, 2, 0, 1);
						}
						return et(r, o, i);
					})($u, n, t)
				),
			startOfDay: (n) =>
				Zf(
					(function (n, t) {
						const { timeZone: e, calendar: r } = t,
							o = ((n, t, e) => te(t, n(ms(e, t))))(Mt, n(e), t);
						return et(o, e, r);
					})($u, n)
				),
			equals: (n, t) =>
				(function (n, t) {
					return (
						!rr(n, t) &&
						!!sr(n.timeZone, t.timeZone) &&
						dt(n.calendar, t.calendar)
					);
				})(n, ea(t)),
			toInstant: (n) =>
				Ba(
					(function (n) {
						return tt(n.epochNanoseconds);
					})(n)
				),
			toPlainDateTime: (n) => Xa(lo(xu, n)),
			toPlainDate: (n) => nf(ho(xu, n)),
			toPlainTime: (n) => _a(go(xu, n)),
			toPlainYearMonth(n) {
				return Ga(
					(function (n, t, e) {
						return oo(n(t.calendar), e);
					})(mf, n, this)
				);
			},
			toPlainMonthDay(n) {
				return ka(
					(function (n, t, e) {
						return ro(n(t.calendar), e);
					})(pf, n, this)
				);
			},
			toLocaleString(n, t, e = {}) {
				const [r, o] = la(t, e, n);
				return r.format(o);
			},
			toString: (n, t) => Pt(xu, n, t),
			toJSON: (n) => Pt(xu, n),
			valueOf: Pu,
		},
		{ from: (n, t) => Zf(ea(n, t)), compare: (n, t) => rr(ea(n), ea(t)) }
	),
	Pf = Object.defineProperties(
		{},
		Object.assign(
			u("Temporal.Now"),
			c({
				timeZoneId: () => Eo(),
				instant: () => Ba(tt(No())),
				zonedDateTime: (n, t = Eo()) => Zf(et(No(), qu(t), ta(n))),
				zonedDateTimeISO: (n = Eo()) => Zf(et(No(), qu(n), _i)),
				plainDateTime: (n, t = Eo()) => Xa(rt(Mo(xu(qu(t))), ta(n))),
				plainDateTimeISO: (n = Eo()) => Xa(rt(Mo(xu(qu(n))), _i)),
				plainDate: (n, t = Eo()) => nf(ot(Mo(xu(qu(t))), ta(n))),
				plainDateISO: (n = Eo()) => nf(ot(Mo(xu(qu(n))), _i)),
				plainTimeISO: (n = Eo()) => _a(st(Mo(xu(qu(n))))),
			})
		)
	),
	Cf = Object.defineProperties(
		{},
		Object.assign(
			{},
			u("Temporal"),
			c({
				PlainYearMonth: za,
				PlainMonthDay: Ya,
				PlainDate: Qa,
				PlainTime: Ha,
				PlainDateTime: Va,
				ZonedDateTime: Sf,
				Instant: La,
				Calendar: Rf,
				TimeZone: qa,
				Duration: Ff,
				Now: Pf,
			})
		)
	),
	Yf = ia(),
	kf = new WeakMap(),
	Uf = Object.defineProperties(Object.create(Intl), c({ DateTimeFormat: Yf }));
export { Uf as Intl, Cf as Temporal, Bu as toTemporalInstant };
export default null;
//# sourceMappingURL=/sm/27bcc8f98ac8a90bcd0484c282508aaaf4d509769745cfb94dc93139accb871e.map
