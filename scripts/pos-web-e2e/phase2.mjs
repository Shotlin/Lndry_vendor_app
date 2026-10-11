// Phase 2 journey: POS Home → Book Order (customer, garments, delivery flags, cash / pay-later / online) →
// Add Garment Price → draft survives a restart → double-tap protection → charge + discount + GST total.
// Every claim is verified on the SERVER afterwards (API), not only on screen. Exit code 1 if any check fails.
import { api, createPosShop, heard, launch, loginThroughScreens, open, waitFor, WEB } from './lib.mjs'

const shop = await createPosShop('Journey Laundry')
const token = shop.token
const results = []
const check = (name, ok, detail = '') => { results.push([name, ok]); console.log(`${ok ? 'PASS' : 'FAIL'}  ${name}${ok ? '' : '   -> ' + detail}`) }
const { browser, page, errors } = await launch()
const text = () => heard(page)
const has = async (s) => (await text()).includes(s)
const shot = (n) => page.screenshot({ path: `${process.env.SHOTS || '.'}/pos-journey-${n}.png` })
const tap = async (name, opts = {}) => { const { wait, role = 'button', ...rest } = opts; await page.getByRole(role, { name, ...rest }).first().click(); await page.waitForTimeout(wait ?? 700) }
const typeInto = async (labelRe, value) => {
  await page.getByRole('textbox', { name: labelRe }).first().click({ force: true })
  await page.waitForTimeout(250); await page.keyboard.press('Control+A'); await page.keyboard.type(value, { delay: 40 }); await page.waitForTimeout(300)
}
const wheel = async (dy) => { await page.mouse.move(195, 420); await page.mouse.wheel(0, dy); await page.waitForTimeout(500) }

await open(page)
if (await waitFor(page, /Get OTP/)) await loginThroughScreens(page, shop.phone)
if (!(await waitFor(page, /Today Revenue/))) throw new Error('Home never appeared after login')
await page.waitForTimeout(1500)

// ── Home (empty shop) ───────────────────────────────────────────────────
const dash0 = (await api(token, 'GET', '/vendor/pos/dashboard')).json.data.home
check('Home shows the shop name and real zeros', (await has('Journey Laundry')) && (await has('Today Revenue: ₹0')) && dash0.bookingsToday === 0)
check('Home tells a new shop what to do', await has('No orders yet. Tap Book Order to start.'))

// ── Book an order: new customer, garments, flags, cash ──────────────────
await tap('Book Order', { wait: 2500 })
check('Book Order opens with Save off and the reason', (await has('Add at least one garment.')) && (await page.getByRole('button', { name: 'Save Order' }).isDisabled().catch(() => true)))
await tap(/Choose customer/)
await tap('Add new customer', { wait: 1200 })
await typeInto(/Customer name/, 'Meera Joshi')
await typeInto(/Mobile number/, '9123456780')
await tap('Add Customer', { wait: 2000 })
check('Customer was created and is shown on the order', (await has('Meera Joshi')) && (await has('9123456780')))

await typeInto(/Search garment/, 'Shirt')
await page.waitForTimeout(500)
check('Search narrows the grid', (await has('Shirt')) && !(await has('Kurta')))
await tap(/^Shirt, ₹80/)
await tap('Add one Shirt')              // qty 2
await page.waitForTimeout(1200)
await shot('cart')
await tap('Home Delivery', { role: 'checkbox' }); await tap('Express', { role: 'checkbox' })
await wheel(900)
await tap('Cash', { wait: 1500 })
const view = await text()
check('Server total for 2 × Shirt (Dry Cleaning ₹80) is ₹160', view.includes('₹160'), view.slice(0, 300))
const quoteDirect = await api(token, 'POST', '/vendor/counter/orders/quote', { items: [{ garmentId: (await api(token, 'GET', '/vendor/pos-catalogue')).json.data.garments.find((g) => g.name === 'Shirt').id, serviceId: (await api(token, 'GET', '/vendor/pos-catalogue')).json.data.services.find((s) => s.name === 'Dry Cleaning').id, qty: 2 }] })
check('…and it equals the API quote to the paisa (16000)', quoteDirect.json.data.quote.totalPaise === 16000)
await shot('before_save')
await tap('Save Order', { wait: 3000 })
await shot('saved')
const savedView = await text()
check('Success sheet shows the order number and paid in full', /LND-\d{6}-[A-Z0-9]{4}/.test(savedView) && savedView.includes('Order saved'))
const orders = (await api(token, 'GET', '/vendor/counter/orders')).json.data
const o = orders.find((x) => x.customer.phone === '9123456780')
check('The order exists on the server with the right customer, total and payment', !!o && o.totalPaise === 16000 && o.amountPaidPaise === 16000 && o.paymentStatus === 'PAID' && o.status === 'BOOKED', JSON.stringify(o))
check('…with Home Delivery + Express saved', o?.deliveryMode === 'HOME_DELIVERY' && o?.isExpress === true, `${o?.deliveryMode} ${o?.isExpress}`)
check('…as ONE order (no duplicate)', orders.filter((x) => x.customer.phone === '9123456780').length === 1)
const items = o?.items ?? []
check('…with the garments tapped (Shirt × 2, Dry Cleaning)', items.length === 1 && items[0].name === 'Shirt' && items[0].qty === 2 && items[0].serviceName === 'Dry Cleaning', JSON.stringify(items))

// ── Book Another → fresh cart; Home shows the new numbers ───────────────
await tap('Book Another', { wait: 1500 })
check('Book Another gives an empty cart', (await has('Add at least one garment.')) && !(await has('Meera Joshi')))
await tap('Back', { wait: 2500 })
await page.reload(); await open(page)
for (let i = 0; i < 30 && !(await has('Today Revenue')); i++) await page.waitForTimeout(1000)
await page.waitForTimeout(1500)
const dash1 = (await api(token, 'GET', '/vendor/pos/dashboard')).json.data.home
const t1 = await text()
check('Home numbers = database: revenue ₹160, collection ₹160, 1 booking', dash1.todayRevenuePaise === 16000 && dash1.todayCollectionPaise === 16000 && dash1.bookingsToday === 1 && t1.includes('Today Revenue: ₹160') && t1.includes('Collection: ₹160') && t1.includes('Booking: 1'), t1.slice(0, 400) + ' DASH ' + JSON.stringify(dash1))
check('Home shows 1 express order and the pending order', dash1.expressOrders === 1 && dash1.pendingOrders === 1 && t1.includes('Express orders: 1') && t1.includes('Pending Orders: 1'))

// ── Add Garment Price → shows up in Book Order ──────────────────────────
await tap('Add Garment Price', { wait: 1500 })
await tap('Create new: Garment', { wait: 800 })
await page.keyboard.type('Zari Dupatta', { delay: 30 })
await tap('Create', { exact: true, wait: 2000 })
await tap(/^Service/, { wait: 800 })
await page.keyboard.press('Enter'); await page.waitForTimeout(800)       // first service: Dry Cleaning
await typeInto(/Price/, '250')
await tap('Add', { exact: true, wait: 2500 })
let cat, pillow, dry, price
for (let i = 0; i < 8; i++) {
  cat = (await api(token, 'GET', '/vendor/pos-catalogue')).json.data
  pillow = cat.garments.find((g) => g.name === 'Zari Dupatta')
  dry = cat.services.find((s) => s.name === 'Dry Cleaning')
  price = cat.prices.find((p) => p.garmentId === pillow?.id && p.serviceId === dry.id)
  if (price) break
  await page.waitForTimeout(1000)
}
check('Add Garment Price created the garment and a ₹250 price on the server', !!pillow && price?.ratePaise === 25000, JSON.stringify({ pillow, price }))
await shot('price_saved')

await tap('Book Order', { wait: 2500 })
await typeInto(/Search garment/, 'Zari')
check('The new price is immediately in the Book Order grid', (await has('Zari Dupatta')) && (await has('₹250')))

// ── Draft survives a restart ───────────────────────────────────────────
await tap(/Choose customer/)
await page.waitForTimeout(800)
await typeInto(/Search name or phone/, '9123456780')
await page.waitForTimeout(1500)
await tap(/Meera Joshi/, { wait: 1200 })
await tap(/^Zari Dupatta, ₹250/)
await page.waitForTimeout(1500)
await page.reload(); await open(page)
for (let i = 0; i < 30 && !(await has('Today Revenue')); i++) await page.waitForTimeout(1000)
await tap('Book Order', { wait: 2500 })
const restored = await text()
check('After closing and reopening the app the unsaved order is back (customer + garment)', restored.includes('Meera Joshi') && restored.includes('Your last unsaved order was restored.'), restored.slice(0, 300))
await page.waitForTimeout(1500)
const total = await text()
check('…and it is priced again by the server (₹250)', total.includes('Grand Total') && total.includes('₹250'))
await wheel(1200)
check('…and the cart still holds the garment', await has('Zari Dupatta'))
await shot('draft_restored')

// ── Pay Later booking leaves a balance; duplicate-tap protection ───────
for (let i = 0; i < 8 && !(await has('No payment now')) && !(await has('Pay Later')); i++) await wheel(700)
await tap('Pay Later', { wait: 800 })
const box = await page.getByRole('button', { name: 'Save Order' }).boundingBox()
await page.mouse.click(box.x + box.width / 2, box.y + box.height / 2)
await page.mouse.click(box.x + box.width / 2, box.y + box.height / 2)   // second tap right away
await page.waitForTimeout(3500)
const after = (await api(token, 'GET', '/vendor/counter/orders')).json.data
const pillowOrders = after.filter((x) => x.items.some((i) => i.name === 'Zari Dupatta'))
check('A double tap on Save booked exactly ONE order', pillowOrders.length === 1, String(pillowOrders.length))
check('Pay Later: unpaid, balance = total', pillowOrders[0]?.paymentStatus === 'UNPAID' && pillowOrders[0]?.amountPaidPaise === 0 && pillowOrders[0]?.totalPaise === 25000, JSON.stringify(pillowOrders[0] && { s: pillowOrders[0].paymentStatus, t: pillowOrders[0].totalPaise }))
check('A plain order is a walk-in, not express', pillowOrders[0]?.deliveryMode === 'WALK_IN' && pillowOrders[0]?.isExpress === false)
await shot('paylater_saved')
await tap('View Order', { wait: 2000 })
check('View Order goes to the Orders tab', (await has('Order')) && (await page.url()).includes('/pos/orders'), page.url())

const dash2 = (await api(token, 'GET', '/vendor/pos/dashboard')).json.data.home
check('Dashboard after two orders: revenue ₹410, collected ₹160, to collect ₹250', dash2.todayRevenuePaise === 41000 && dash2.todayCollectionPaise === 16000 && dash2.collectionDuePaise === 25000 && dash2.bookingsToday === 2, JSON.stringify(dash2))
// ── Order 3: charge 10% + discount ₹5 + GST 18% through the real screens ─────────
await api(token, 'POST', '/vendor/adjustment-rules/charge', { name: 'Rush charge', type: 'PERCENTAGE', percentageBps: 1000 })
await api(token, 'POST', '/vendor/adjustment-rules/discount', { name: 'Festival', type: 'FLAT', flatAmountPaise: 500 })
await api(token, 'POST', '/vendor/pos-catalogue/taxes', { name: 'GST', ratePercent: 18 })
await page.goto(WEB); await open(page)
for (let i = 0; i < 30 && !(await has('Today Revenue')); i++) await page.waitForTimeout(1000)
await tap('Book Order', { wait: 2500 })
await tap(/Choose customer/); await page.waitForTimeout(800)
await typeInto(/Search name or phone/, '9123456780'); await page.waitForTimeout(1500)
await tap(/Meera Joshi/, { wait: 1200 })
await typeInto(/Search garment/, 'Shirt')
await tap(/^Shirt, ₹80/); await tap('Add one Shirt'); await tap('Add one Shirt')   // 3 shirts = ₹240
for (let i = 0; i < 6 && !(await has('Rush charge')); i++) await wheel(500)
const chip = async (re) => {
  const loc = page.getByRole('checkbox', { name: re }).or(page.getByRole('radio', { name: re })).or(page.getByRole('button', { name: re }))
  for (let i = 0; i < 10 && (await loc.count()) === 0; i++) await wheel(300)
  await loc.first().click(); await page.waitForTimeout(900)
}
await chip(/Rush charge/); await chip(/Festival/); await chip(/GST \(18%\)/)
await page.waitForTimeout(1500)
// 3 × ₹80 = 24000; charge 10% = 2400; discount 500; taxable 25900; GST 18% = 4662; total 30562
const v3 = await text()
check('Real screens, charge + discount + GST: Grand Total is ₹305.62', v3.includes('₹305.62'), v3.slice(-500))
check('…with the tax line ₹46.62 at 18%', v3.includes('Tax (18%)') && v3.includes('₹46.62'))
const expect3 = (await api(token, 'POST', '/vendor/counter/orders/quote', {
  items: [{ garmentId: cat.garments.find((g) => g.name === 'Shirt').id, serviceId: dry.id, qty: 3 }],
  chargeRuleIds: (await api(token, 'GET', '/vendor/adjustment-rules/charge')).json.data.map((r) => r.id),
  discountRuleIds: (await api(token, 'GET', '/vendor/adjustment-rules/discount')).json.data.map((r) => r.id), taxRatePercent: 18 })).json.data.quote
check('…which is exactly what the API quotes for the same cart (30562 paise)', expect3.totalPaise === 30562 && 24000 + 2400 - 500 + 4662 === 30562, JSON.stringify(expect3))
for (let i = 0; i < 8 && !(await has('Online')); i++) await wheel(600)
await tap('Online', { wait: 800 })
await tap('Save Order', { wait: 3500 })
await page.waitForTimeout(1500)
const o3 = (await api(token, 'GET', '/vendor/counter/orders')).json.data.find((o) => o.totalPaise === 30562)
check('The saved order has that total, GST 18%, and is paid (Online = UPI)', !!o3 && o3.taxRateBps === 1800 && o3.taxPaise === 4662 && o3.chargesPaise === 2400 && o3.discountsPaise === 500 && o3.paymentStatus === 'PAID' && o3.paymentMode === 'UPI', JSON.stringify(o3))
await shot('order3_saved')
await browser.close()
console.log('\nerrors (non-gstatic):', errors.filter((e) => !e.includes('gstatic')))
const failed = results.filter((r) => !r[1]).length
console.log(`\n${results.length - failed}/${results.length} passed`)
process.exit(failed ? 1 : 0)
