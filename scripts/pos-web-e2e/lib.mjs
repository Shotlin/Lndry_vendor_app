// Helpers for the real-browser POS journeys. Flutter web draws on a canvas, so the journeys drive the app through
// its accessibility tree (Flutter's "semantics" DOM), the same thing a screen reader uses.
import fs from 'node:fs'
import os from 'node:os'
import path from 'node:path'
import { chromium } from 'playwright-core'

export const API = process.env.API || 'http://localhost:4500/api/v1'
export const WEB = process.env.WEB || 'http://localhost:8081/'
export const OTP = process.env.OTP || '123456'
const CHROME = process.env.CHROME || '/opt/pw-browsers/chromium-1194/chrome-linux/chrome'
export const STATE = path.join(os.tmpdir(), 'pos-web-e2e-state.json')

export async function launch(viewport = { width: 390, height: 844 }) {
  const browser = await chromium.launch({ executablePath: CHROME, args: ['--no-sandbox'] })
  const ctx = await browser.newContext({ viewport, deviceScaleFactor: 1 })
  const page = await ctx.newPage()
  const errors = []
  page.on('pageerror', (e) => errors.push(String(e).slice(0, 300)))
  return { browser, ctx, page, errors }
}

export async function api(token, method, p, body, headers = {}) {
  const r = await fetch(API + p, {
    method,
    headers: { 'content-type': 'application/json', ...(token ? { authorization: `Bearer ${token}` } : {}), ...headers },
    body: body === undefined ? undefined : JSON.stringify(body),
  })
  return { status: r.status, json: await r.json().catch(() => null) }
}

/** A brand-new POS shop made through the real onboarding API (random phone). Returns the owner's API token. */
export async function createPosShop(name = 'Journey Laundry') {
  const phone = `9${String(Date.now()).slice(-5)}${Math.floor(Math.random() * 9000 + 1000)}`
  await api(null, 'POST', '/auth/send-otp', { phone })
  const login = (await api(null, 'POST', '/auth/verify-otp', { phone, otp: OTP })).json?.data
  if (!login?.accessToken) throw new Error('Login failed — start the API with TEST_BYPASS_OTP_PHONES=* (local only)')
  await api(login.accessToken, 'POST', '/vendor/pos-onboarding/start', {})
  const token = (await api(null, 'POST', '/auth/refresh-token', { refreshToken: login.refreshToken })).json.data.accessToken
  for (const [step, data] of [
    ['shop', { name, ownerName: 'Ravi', addressLine1: '12 MG Road', city: 'Pune', pincode: '411001' }],
    ['tax', { gstEnabled: false }],
    ['counter', { printerProfile: 'none', orderSeriesPrefix: 'JR', defaultDeliveryDays: 2 }],
    ['pricelist', { choice: 'starter' }],
  ]) await api(token, 'PATCH', '/vendor/pos-onboarding', { step, data })
  const done = await api(token, 'POST', '/vendor/pos-onboarding/complete', {})
  if (done.status !== 200) throw new Error(`Onboarding did not complete: ${JSON.stringify(done.json)}`)
  return { phone, token }
}

/** Turns on Flutter's accessibility tree (a hidden button the framework adds). Call after every full page load. */
export async function open(page, url = WEB) {
  await page.goto(url, { waitUntil: 'load' })
  await page.waitForSelector('flt-semantics-placeholder', { state: 'attached', timeout: 30000 })
  await page.locator('flt-semantics-placeholder').first().evaluate((el) => el.click())
  await page.waitForTimeout(1200)
}

/** Everything a screen reader would hear right now: text content and labels of every accessibility node
 *  (headings are rendered as real <header>/<hN> elements by newer Flutter builds, so they are read too). */
export const heard = (page) =>
  page.evaluate(() => [...document.querySelectorAll('flt-semantics, flt-semantics header, flt-semantics h1, flt-semantics h2, flt-semantics h3')].map((n) => `${n.textContent || ''} ${n.getAttribute('aria-label') || ''}`).join(' '))

export async function waitFor(page, re, seconds = 30) {
  for (let i = 0; i < seconds; i++) {
    if (re.test(await heard(page))) return true
    await page.waitForTimeout(1000)
  }
  return false
}

/** Phone → OTP → verify, on the real login screens. */
export async function loginThroughScreens(page, phone) {
  await page.getByRole('textbox').first().click()
  await page.keyboard.type(phone)
  await page.getByRole('button', { name: 'Get OTP' }).click()
  await page.waitForTimeout(1500)
  const field = page.locator('input, textarea').first()
  if (await field.count()) await field.click({ force: true })
  await page.keyboard.type(OTP, { delay: 80 })
  await page.waitForTimeout(500)
  const verify = page.getByRole('button', { name: 'Verify Code' })
  if (await verify.count()) await verify.click().catch(() => {})
}
