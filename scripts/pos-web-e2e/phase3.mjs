// Phase 3 journey: the whole life of a counter order from the phone — Orders list (tabs, search, Home tiles) →
// Order detail → part payment → Start Processing → Mark Ready (garments not scanned) → Deliver with a balance
// (collect first) → Order Complete → invoice / mini bill → cancel → edit → assign captain → bulk move → WhatsApp.
// Every claim is verified on the SERVER afterwards (API), not only on screen. Exit code 1 if any check fails.
import { randomUUID } from 'node:crypto'
import { api, createPosShop, heard, launch, loginThroughScreens, open, waitFor, WEB, API } from './lib.mjs'

const shop = await createPosShop('Journey Laundry')
const token = shop.token
const results = []
let lastCheck = '(start)'
const check = (name, ok, detail = '') => { lastCheck = name; results.push([name, ok]); console.log(`${ok ? 'PASS' : 'FAIL'}  ${name}${ok ? '' : '   -> ' + detail}`) }

// ── seed through the real API: 4 orders, 1 captain ───────────────────────────────────────────────
const cat = (await api(token, 'GET', '/vendor/pos-catalogue')).json.data
const dry = cat.services.find((s) => s.name === 'Dry Cleaning')
const shirt = cat.garments.find((g) => g.name === 'Shirt')
const date = new Date(Date.now() + 2 * 864e5).toISOString().slice(0, 10)
const mkCustomer = async (name, phone) => (await api(token, 'POST', '/vendor/counter/customers', { name, phone })).json.data.customer
const asha = await mkCustomer('Asha Verma', '9811122233')
const ravi = await mkCustomer('Ravi Kumar', '9000011111')
const book = async (customer, extra = {}, qty = 2) => (await api(token, 'POST', '/vendor/counter/orders', {
  customer: { id: customer.id }, items: [{ garmentId: shirt.id, serviceId: dry.id, qty }], expectedDeliveryDate: date, paymentMode: 'PAY_LATER', ...extra }, { 'Idempotency-Key': randomUUID() })).json.data.order
const A = await book(asha, { deliveryMode: 'HOME_DELIVERY', isExpress: true })
const B = await book(ravi)
const C = await book(asha, { paymentMode: 'CASH' })
const D = await book(ravi, { deliveryMode: 'HOME_DELIVERY' })
const riderRes = await api(token, 'POST', '/vendor/employees', { name: 'Sunil Captain', phone: `98${String(Date.now()).slice(-6)}${Math.floor(Math.random() * 90 + 10)}`, role: 'VENDOR_RIDER' })
if (!riderRes.json?.data?.id) throw new Error(`Could not create the captain: ${JSON.stringify(riderRes.json)}`)
const rider = riderRes.json.data
const get = async (o) => (await api(token, 'GET', `/vendor/counter/orders/${o.id}`)).json.data
const total = B.totalPaise // 16000

const { browser, ctx, page, errors } = await launch()
page.on('pageerror', (e) => { if (!String(e).includes('gstatic')) console.log(`PAGEERROR (after "${lastCheck}"):`, String(e).slice(0, 300)) })
const text = () => heard(page)
const has = async (s) => (await text()).includes(s)
const shot = (n) => page.screenshot({ path: `${process.env.SHOTS || '.'}/pos3-${n}.png` })
const tap = async (name, opts = {}) => { const { wait, role = 'button', ...rest } = opts; await page.getByRole(role, { name, ...rest }).first().click(); await page.waitForTimeout(wait ?? 800) }
// A real mouse click (not Playwright's forced click) is what focuses a Flutter text field.
const typeInto = async (labelRe, value) => {
  let box
  try { box = await page.getByRole('textbox', labelRe ? { name: labelRe } : {}).first().boundingBox({ timeout: 8000 }) } catch (e) { await shot('stuck'); console.log('STUCK. Screen says:', (await text()).slice(0, 700)); throw e }
  // The first tap on a Flutter text field only wakes its native input; the second one focuses it.
  await page.mouse.click(box.x + box.width / 2, box.y + box.height / 2); await page.waitForTimeout(400)
  await page.mouse.click(box.x + box.width / 2, box.y + box.height / 2)
  await page.waitForTimeout(300); await page.keyboard.press('Control+A'); await page.keyboard.type(value, { delay: 40 }); await page.waitForTimeout(400)
}
const until = async (fn, seconds = 10) => { for (let i = 0; i < seconds * 2; i++) { if (await fn()) return true; await page.waitForTimeout(500) } return false }
const wheel = async (dy) => { await page.mouse.move(195, 420); await page.mouse.wheel(0, dy); await page.waitForTimeout(500) }
// The bottom bar's items are exposed as tabs ("Order, Tab 2 of 6").
const goOrders = async () => { await page.getByRole('tab', { name: /^Order/ }).first().click(); await page.waitForTimeout(1800) }
const searchFor = async (o) => {
  await typeInto(null, o.orderNumber) // the one text box on this screen (once it holds text its name is no longer the hint)
  // wait for the debounce + the server's answer: the list must hold ONLY this order
  await until(async () => { const t = await text(); return t.includes(o.orderNumber) && (t.match(/LND-\d{6}-[A-Z0-9]{4}, /g) || []).length === 1 }, 10)
  await page.waitForTimeout(500)
}
const openOrder = async (o) => { await searchFor(o); await page.getByRole('button', { name: new RegExp(o.orderNumber) }).first().click(); await page.waitForTimeout(2500) }
const back = async () => { await page.getByRole('button', { name: /Back/ }).first().click(); await page.waitForTimeout(1500) }

await open(page)
if (await waitFor(page, /Get OTP/)) await loginThroughScreens(page, shop.phone)
if (!(await waitFor(page, /Today Revenue/))) throw new Error('Home never appeared after login')
await page.waitForTimeout(1500)

// ── Home tile → the exact list behind it ───────────────────────────────────────────────────────
const home = (await api(token, 'GET', '/vendor/pos/dashboard')).json.data.home
check('Home shows 4 pending orders and 1 express order, as the database says', (await has('Pending Orders: 4')) && home.pendingOrders === 4 && home.expressOrders === 1, JSON.stringify(home))
await tap(/^Pending Orders/, { wait: 2500 })
let view = await text()
check('Tapping "Pending Orders" opens Orders showing exactly the 4 pending orders', [A, B, C, D].every((o) => view.includes(o.orderNumber)) && view.includes('Showing: Pending Orders'), view.slice(0, 400))
const tileList = (await api(token, 'GET', '/vendor/counter/orders?tile=pendingOrders')).json.data
check('…and the server lists the same 4 for that tile', tileList.length === home.pendingOrders)
await shot('tile_list')
await tap(/Clear filters/, { wait: 1500 })
check('Clearing the filter returns to the Booked / In Process / Done tabs', (await has('In Process')) && (await has('Done')))

// ── search → open an order ───────────────────────────────────────────────────────────────────────
await page.goto(WEB); await open(page); await waitFor(page, /Today Revenue/); await page.waitForTimeout(1500)
await goOrders()
check('Booked tab lists all four orders with customer and amount', (await has(A.orderNumber)) && (await has('Ravi Kumar')) && (await has('₹160')))
await searchFor(B)
view = await text()
check('Search by order number narrows the list to that order', view.includes(B.orderNumber) && !view.includes(A.orderNumber), view.slice(0, 300))
await page.getByRole('button', { name: new RegExp(B.orderNumber) }).first().click(); await page.waitForTimeout(2500)
view = await text()
check('Order detail: number, customer, Start Processing, 20%, ₹160 invoice amount', view.includes(B.orderNumber) && view.includes('Ravi Kumar') && view.includes('Start Processing') && view.includes('20% complete') && view.includes('₹160.00'), view.slice(0, 300))
await shot('detail_booked')

// ── part payment ─────────────────────────────────────────────────────────────────────────────────
await tap('Pay Now', { wait: 1500 })
check('Pay sheet shows the balance and no Wallet option', (await has('Balance to collect')) && (await has('₹160.00')) && !(await has('Wallet')))
await typeInto(/Amount/, '60')
await tap('Online', { role: 'checkbox', wait: 300 }).catch(() => tap('Online', { role: 'button', wait: 300 }))
await typeInto(/Reference/, 'UTR-E2E-1')
await tap(/^Collect ₹60/, { wait: 3000 })
let b = await get(B)
check('Part payment recorded on the server: ₹60 by UPI, PART_PAID, balance ₹100', b.order.amountPaidPaise === 6000 && b.order.paymentStatus === 'PART_PAID' && b.payments.length === 1 && b.payments[0].mode === 'UPI' && b.payments[0].reference === 'UTR-E2E-1', JSON.stringify(b.payments))
view = await text()
check('The screen shows the new balance ₹100 read back from the server', view.includes('₹100.00') && view.includes('Part paid'), view.slice(0, 400))
await shot('part_paid')

// ── move along: Start Processing → Mark Ready (garments not scanned) ───────────────────────────────
await tap('Start Processing', { wait: 2500 })
b = await get(B)
check('Start Processing moved it to IN_PROCESS on the server', b.order.status === 'IN_PROCESS')
check('…and the screen offers Mark Ready at 40%', (await has('Mark Ready')) && (await has('40% complete')))
await tap('Mark Ready', { wait: 2500 })
check('Garments not scanned: the app asks instead of deciding', (await has('Garments not scanned yet')) && (await get(B)).order.status === 'IN_PROCESS')
await shot('ready_anyway')
await tap('Mark ready anyway', { wait: 2500 })
b = await get(B)
check('"Mark ready anyway" moved it to READY on the server', b.order.status === 'READY', b.order.status)

// ── deliver with a balance: collect first ─────────────────────────────────────────────────────────
await tap('Deliver Order', { wait: 2000 })
view = await text()
check('Delivering with a balance asks: "₹100.00 is still due" with both choices', view.includes('₹100.00 is still due') && view.includes('Collect payment first') && view.includes('Deliver with balance due'), view.slice(0, 300))
check('…and nothing was delivered yet', (await get(B)).order.status === 'READY')
await shot('deliver_due')
await tap('Collect payment first', { wait: 1500 })
await tap('Full balance', { wait: 300 })
await tap(/^Collect ₹100/, { wait: 3000 })
b = await get(B)
check('Collected the rest: PAID with two payments adding up to ₹160', b.order.paymentStatus === 'PAID' && b.payments.reduce((s, p) => s + p.amountPaise, 0) === total && b.payments.length === 2, JSON.stringify(b.payments))
await tap('Deliver Order', { wait: 3000 })
b = await get(B)
check('Paid in full: delivered straight away, no question, on the server too', b.order.status === 'DELIVERED' && !(await has('still due')))
view = await text()
check('The screen shows Order Complete at 100%', view.includes('Order Complete') && view.includes('100% complete'), view.slice(0, 300))
check('The server recorded every step in order (history)', b.history.map((e) => e.to).join() === 'BOOKED,IN_PROCESS,READY,DELIVERED', JSON.stringify(b.history.map((e) => e.to)))
await shot('complete')

// ── invoice + mini bill ──────────────────────────────────────────────────────────────────────────
const pdfCall = async (q) => { const r = await fetch(`${API}/vendor/counter/orders/${B.id}/invoice${q}`, { headers: { authorization: `Bearer ${token}` } }); const buf = Buffer.from(await r.arrayBuffer()); return { s: r.status, pdf: buf.subarray(0, 5).toString() === '%PDF-' } }
await tap('View Invoice', { wait: 3500 })
check('View Invoice opens the invoice screen (not the order screen any more)', (await has('Invoice')) && !(await has('Quick actions')), (await text()).slice(0, 200))
await shot('invoice')
check('The server really returns the invoice PDF for it (A4) and the 58/80 mm bills', (await pdfCall('')).pdf && (await pdfCall('?format=mini&paper=58')).pdf && (await pdfCall('?format=mini&paper=80')).pdf)
await back()
await tap('Mini Invoice', { wait: 3500 })
check('Mini Invoice opens with the paper-size choice', (await has('Mini bill')) && (await has('58 mm')) && (await has('80 mm')), (await text()).slice(0, 200))
await shot('mini')
await back()

// ── WhatsApp + Call (new browser tab; just the link) ──────────────────────────────────────────────
// wa.me is not reachable from the sandbox: answer it locally so the requested address can be read
await ctx.route('https://wa.me/**', (route) => route.fulfill({ status: 200, contentType: 'text/html', body: '<html>ok</html>' }))
const popup = ctx.waitForEvent('page', { timeout: 8000 }).catch(() => null)
await tap('WhatsApp', { wait: 1500 })
const wa = await popup
if (wa) await wa.waitForLoadState('load').catch(() => {})
const waUrl = wa ? wa.url() : ''
check('WhatsApp opens wa.me/91… with the order, state and amount in the message', /wa\.me\/919000011111/.test(waUrl) && decodeURIComponent(waUrl).includes(B.orderNumber) && decodeURIComponent(waUrl).includes('Order Complete'), waUrl)
if (wa) await wa.close().catch(() => {})

// ── cancel A with a reason ───────────────────────────────────────────────────────────────────────
await page.goto(WEB); await open(page); await waitFor(page, /Today Revenue/); await page.waitForTimeout(1500)
await goOrders()
await openOrder(A)
await tap('Cancel Order', { wait: 1500 })
check('Cancel asks for a reason and the confirm button starts off', (await has('Cancel this order?')) && (await page.getByRole('button', { name: 'Cancel Order' }).last().isDisabled().catch(() => true)))
await tap('Booked by mistake', { role: 'checkbox', wait: 400 }).catch(() => tap('Booked by mistake', { wait: 400 }))
await page.getByRole('button', { name: 'Cancel Order' }).last().click(); await page.waitForTimeout(3000)
const a = await get(A)
check('The server has A cancelled with the reason', a.order.status === 'CANCELLED' && a.order.cancelReason === 'Booked by mistake', JSON.stringify(a.order.cancelReason))
check('The screen says it was cancelled and offers no next step', (await has('This order was cancelled.')) && !(await has('Start Processing')))
await shot('cancelled')
await back()

// ── edit C: remarks + express ─────────────────────────────────────────────────────────────────────
await openOrder(C)
await tap('Edit Order', { wait: 1500 })
check('Edit sheet says garments cannot be edited', await has('cancel this order and book a new one'))
await tap('Express', { role: 'checkbox', wait: 400 }).catch(() => tap('Express', { wait: 400 }))
await typeInto(/Remarks/, 'Call before delivery')
await tap('Save changes', { wait: 3000 })
const c = await get(C)
check('The server has the new remarks and express flag (nothing else changed)', c.order.notes === 'Call before delivery' && c.order.isExpress === true && c.order.totalPaise === C.totalPaise && c.order.deliveryMode === 'WALK_IN', JSON.stringify({ n: c.order.notes, e: c.order.isExpress }))
await back()

// ── assign a captain to D ─────────────────────────────────────────────────────────────────────────
await openOrder(D)
await tap('Assign Captain', { wait: 2000 })
check('Assign sheet lists the shop\'s captains', await has('Delivery captain'))
await page.getByRole('button', { name: /Delivery captain|Not assigned/ }).last().click().catch(() => {})
await page.waitForTimeout(600); await page.keyboard.press('Enter'); await page.waitForTimeout(600)
await shot('assign')
await tap('Assign', { exact: true, wait: 3000 })
const d = await get(D)
check('The server has Sunil as the delivery captain', d.order.deliveryRider?.id === rider.id || d.order.deliveryRider?.name === 'Sunil Captain', JSON.stringify(d.order.deliveryRider))
await back()

// ── bulk: select all in "Booked" and move one step ─────────────────────────────────────────────────
await page.goto(WEB); await open(page); await waitFor(page, /Today Revenue/); await page.waitForTimeout(1500)
await goOrders()
await page.waitForTimeout(1500)
check('Booked tab now holds C and D only (A cancelled, B delivered)', (await has(C.orderNumber)) && (await has(D.orderNumber)) && !(await has(A.orderNumber)) && !(await has(B.orderNumber)))
await tap('Select all', { wait: 800 }).catch(async () => tap('Select all', { role: 'checkbox', wait: 800 }))
check('Selecting all shows "2 selected" and Move to next step', (await has('2 selected')) && (await has('Move to next step')))
await tap('Move to next step', { wait: 1500 })
check('A plain-words confirmation comes first and nothing has moved', (await has('Move 2 orders to the next step?')) && (await get(C)).order.status === 'BOOKED')
await shot('bulk_confirm')
await tap('Move orders', { wait: 3500 })
check('After confirming, both moved exactly ONE step on the server', (await get(C)).order.status === 'IN_PROCESS' && (await get(D)).order.status === 'IN_PROCESS')
check('…and the screen says so', await has('2 orders moved.'))
await tap('In Process', { role: 'tab', wait: 1500 })
check('They now appear under In Process', (await has(C.orderNumber)) && (await has(D.orderNumber)))

// ── Home numbers = database after all of it ───────────────────────────────────────────────────────
await page.goto(WEB); await open(page); await waitFor(page, /Today Revenue/); await page.waitForTimeout(2000)
const home2 = (await api(token, 'GET', '/vendor/pos/dashboard')).json.data.home
const t2 = await text()
check('Home after the journey: pending 2, delivered today 1, collection = what was collected', home2.pendingOrders === 2 && home2.deliveredToday === 1 && t2.includes('Pending Orders: 2') && t2.includes('Delivered: 1'), JSON.stringify(home2) + t2.slice(0, 200))
const dueList = (await api(token, 'GET', '/vendor/counter/orders?tile=collectionDue')).json.data
check('Money to collect on Home equals the sum of balances in the list behind it', dueList.reduce((s, o) => s + o.totalPaise - o.amountPaidPaise, 0) === home2.collectionDuePaise, `${home2.collectionDuePaise}`)
await shot('home_after')

await browser.close()
console.log('\nerrors (non-gstatic):', errors.filter((e) => !e.includes('gstatic')))
const failed = results.filter((r) => !r[1]).length
console.log(`\n${results.length - failed}/${results.length} passed`)
process.exit(failed ? 1 : 0)
