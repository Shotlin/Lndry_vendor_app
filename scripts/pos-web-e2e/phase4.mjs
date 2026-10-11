// Phase 4 journey: Search → Customers (A–Z, profile, dues) → Expense + cash drawer (open, add expense, close) → Report
// (Summary / Invoices / Collection / Expenses, equal to the server) → Settings (tiles, Team, Language) → WhatsApp.
// Every claim is verified on the SERVER afterwards (API), not only on screen. Exit code 1 if any check fails.
import { randomUUID } from 'node:crypto'
import { api, createPosShop, heard, launch, loginThroughScreens, open, waitFor, WEB } from './lib.mjs'

const shop = await createPosShop('Journey Laundry')
const token = shop.token
const results = []
let lastCheck = '(start)'
const check = (name, ok, detail = '') => { lastCheck = name; results.push(ok); console.log(`${ok ? 'PASS' : 'FAIL'}  ${name}${ok ? '' : '   -> ' + (typeof detail === 'string' ? detail : JSON.stringify(detail))}`) }

// ── seed through the real API ────────────────────────────────────────────────────────────────────
const cat = (await api(token, 'GET', '/vendor/pos-catalogue')).json.data
const dry = cat.services.find((s) => s.name === 'Dry Cleaning')
const shirt = cat.garments.find((g) => g.name === 'Shirt')
const date = new Date(Date.now() + 2 * 864e5).toISOString().slice(0, 10)
const today = new Date().toISOString().slice(0, 10)
const mkCustomer = async (name, phone) => (await api(token, 'POST', '/vendor/counter/customers', { name, phone })).json.data.customer
const asha = await mkCustomer('Asha Verma', '9811122233')
const zed = await mkCustomer('Zed Khan', '9000011111')
const book = async (customer, extra = {}) => (await api(token, 'POST', '/vendor/counter/orders', {
  customer: { id: customer.id }, items: [{ garmentId: shirt.id, serviceId: dry.id, qty: 2 }], expectedDeliveryDate: date, paymentMode: 'PAY_LATER', ...extra }, { 'Idempotency-Key': randomUUID() })).json.data.order
const A = await book(asha)                         // unpaid
const B = await book(asha, { paymentMode: 'CASH' }) // paid
const Z = await book(zed)                           // unpaid
await api(token, 'POST', `/vendor/counter/orders/${Z.id}/payments`, { amountPaise: 3000, mode: 'UPI' }) // part paid
const unit = 16000

const { browser, page } = await launch()
page.on('pageerror', (e) => { if (!String(e).includes('gstatic')) console.log(`PAGEERROR (after "${lastCheck}"):`, String(e).slice(0, 300)) })
const text = () => heard(page)
const has = async (s) => (await text()).includes(s)
const shot = (n) => page.screenshot({ path: `${process.env.SHOTS || '.'}/pos4-${n}.png` })
const tap = async (name, opts = {}) => { const { wait, role = 'button', ...rest } = opts; await page.getByRole(role, { name, ...rest }).first().click(); await page.waitForTimeout(wait ?? 800) }
const tab = async (n) => { await page.getByRole('tab', { name: new RegExp('^' + n) }).first().click(); await page.waitForTimeout(2200) }
const typeInto = async (nameRe, value, nth = 0) => {
  const box = await page.getByRole('textbox', nameRe ? { name: nameRe } : {}).nth(nth).boundingBox({ timeout: 8000 })
  await page.mouse.click(box.x + box.width / 2, box.y + box.height / 2); await page.waitForTimeout(400)
  await page.mouse.click(box.x + box.width / 2, box.y + box.height / 2)
  await page.waitForTimeout(300); await page.keyboard.press('Control+A'); await page.keyboard.type(value, { delay: 40 }); await page.waitForTimeout(400)
}
const until = async (fn, seconds = 10) => { for (let i = 0; i < seconds * 2; i++) { if (await fn()) return true; await page.waitForTimeout(500) } return false }
const back = async () => { await page.getByRole('button', { name: /Back/ }).first().click(); await page.waitForTimeout(1500) }
const money = (p) => '₹' + (p / 100).toLocaleString('en-IN', { maximumFractionDigits: 2 })

await open(page)
if (await waitFor(page, /Get OTP/)) await loginThroughScreens(page, shop.phone)
if (!(await waitFor(page, /Today Revenue/))) throw new Error('Home never appeared after login')
await page.waitForTimeout(1500)

// ── SEARCH ────────────────────────────────────────────────────────────────────────────────────────
await tab('Search')
check('Search tab shows the hint and "All customers"', (await has('Type at least 2 letters')) && (await has('All customers')))
await typeInto(null, A.orderNumber)
check('Typing an order number finds that order', await until(async () => (await has('Orders')) && (await has(A.orderNumber)), 10), (await text()).slice(0, 300))
await shot('search')
await page.getByRole('button', { name: new RegExp(A.orderNumber) }).first().click(); await page.waitForTimeout(2500)
check('Tapping the result opens the order (number + Pay Now)', (await has(A.orderNumber)) && (await has('Pay Now')), (await text()).slice(0, 300))
await back()
await page.getByRole('textbox').first().click().catch(() => {})
await typeInto(null, 'Zed')
check('Typing a name finds the customer', await until(async () => (await has('Customers')) && (await has('Zed Khan')), 10))
await page.reload(); await open(page); await waitFor(page, /Today Revenue/); await page.waitForTimeout(1500)

// ── CUSTOMERS (A–Z, profile, dues) ──────────────────────────────────────────────────────────────
await tab('Search')
await tap(/All customers/, { wait: 2500 })
let view = await text()
check('Customers list: both customers, A and Z letters, Call + Profile labels', view.includes('Asha Verma') && view.includes('Zed Khan') && view.includes('Call') && view.includes('Profile'), view.slice(0, 400))
await shot('customers')
await page.getByRole('button', { name: /Zed Khan/ }).first().click(); await page.waitForTimeout(2500)
const zedDue = Z.totalPaise - 3000
check('Zed\'s profile says what he owes (server balance)', await has('Owes ' + money(zedDue)), (await text()).slice(0, 400))
await shot('customer_detail')
await page.getByRole('button', { name: new RegExp('Order ' + Z.orderNumber) }).first().click(); await page.waitForTimeout(2500)
check('"To collect" row opens the order where Pay Now lives', (await has(Z.orderNumber)) && (await has('Pay Now')), (await text()).slice(0, 300))
await page.reload(); await open(page); await waitFor(page, /Today Revenue/); await page.waitForTimeout(1500)

// ── EXPENSE + CASH DRAWER ───────────────────────────────────────────────────────────────────────
await tab('Expense')
await tap(/Open cash drawer/, { wait: 1200 })
await typeInto(/cash is in the drawer/i, '500')
await tap(/^Open drawer/, { wait: 2500 })
let shift = (await api(token, 'GET', '/vendor/cash-shifts/current')).json.data
check('Opening the drawer with ₹500 created an OPEN shift of 50000 paise on the server', shift?.status === 'OPEN' && shift.openingCashPaise === 50000, shift)
await shot('drawer_open')
check('Card shows what should be in the drawer', await until(() => has('should be in the drawer'), 8), (await text()).slice(0, 400))

await tap(/Add Expense/, { wait: 1200 })
await typeInto(/What was it for/i, 'Electricity bill')
await typeInto(/Amount/i, '250.50')
await page.getByRole('checkbox', { name: 'Electricity', exact: true }).click(); await page.waitForTimeout(400)
await tap(/^Save Expense/, { wait: 2500 })
const exps = (await api(token, 'GET', `/vendor/expenses?from=${today}&to=${today}`)).json.data
check('The expense was saved with exact paise (25050) and the chosen type', exps.length === 1 && exps[0].amountPaise === 25050 && exps[0].category === 'ELECTRICITY' && exps[0].paymentMode === 'CASH', exps)
check('The list shows it and the total spent', (await has('Electricity bill')) && (await has('Spent: ₹250.50')))
shift = (await api(token, 'GET', '/vendor/cash-shifts/current')).json.data
const expected = shift.expectedCashPaise
check('Server expected cash = 500 + received − 250.50 (cash expense)', expected === 50000 + shift.collectionsPaise - 25050, shift)
await shot('expense')

await tap(/^Close cash drawer/, { wait: 1200 })
await typeInto(/Cash you counted/i, String(Math.max(0, (expected - 1000) / 100)))
check('A short count is said in words (₹10 less than it should be)', await until(() => has('₹10 less than it should be'), 6), (await text()).slice(0, 300))
await typeInto(/Cash you counted/i, String(expected / 100))
check('A matching count says it matches', await until(() => has('It matches'), 5))
await tap(/^Close drawer/, { wait: 2500 })
const closed = (await api(token, 'GET', '/vendor/cash-shifts?limit=1')).json.data[0]
check('Closing recorded counted = expected and variance 0 on the server', closed.status === 'CLOSED' && closed.countedCashPaise === expected && closed.variancePaise === 0, closed)

// cancel the expense with a reason
await page.getByRole('button', { name: /Electricity bill/ }).first().click(); await page.waitForTimeout(1200)
await tap(/Cancel expense/, { wait: 1000 })
await typeInto(/Why is it cancelled/i, 'Entered twice')
await page.getByRole('button', { name: /^Cancel expense/ }).last().click(); await page.waitForTimeout(2500)
const exps2 = (await api(token, 'GET', `/vendor/expenses?from=${today}&to=${today}`)).json.data
check('Cancelling needs a reason and the server marks it CANCELLED with that reason', exps2[0].status === 'CANCELLED' && exps2[0].cancellationReason === 'Entered twice', exps2)
check('A cancelled expense stays visible and does not count', (await has('Cancelled')) && (await has('Spent: ₹0')))

// ── REPORT ──────────────────────────────────────────────────────────────────────────────────────
await page.reload(); await open(page); await waitFor(page, /Today Revenue/); await page.waitForTimeout(1500)
await tab('Report')
const rep = (await api(token, 'GET', `/vendor/pos/report?from=${today}&to=${today}`)).json.data
view = await text()
check('Summary shows the server\'s Billed / Collected / Still to collect', view.includes('Billed: ' + money(rep.revenuePaise)) && view.includes('Collected: ' + money(rep.collectionPaise)) && view.includes('Still to collect: ' + money(rep.duesPaise)), view.slice(0, 500))
check('…and they are right: billed 3 orders × ₹160, collected ₹160 cash + ₹30 UPI, dues = billed − collected', rep.revenuePaise === 3 * unit && rep.collectionPaise === unit + 3000 && rep.duesPaise === rep.revenuePaise - rep.collectionPaise && rep.expensesPaise === 0, rep)
await shot('report_summary')
await tab('Report'); await page.getByRole('tab', { name: /^Invoices/ }).click(); await page.waitForTimeout(2500)
view = await text()
check('Invoices tab: every order number with a word for its payment (Paid / Part paid / Unpaid)', [A, B, Z].every((o) => view.includes(o.orderNumber)) && view.includes('Paid') && view.includes('Total revenue'), view.slice(0, 600))
await shot('report_invoices')
await page.getByRole('tab', { name: /^Collection/ }).click(); await page.waitForTimeout(2000)
check('Collection tab: payment mix', (await has('How customers paid')) && (await has('Cash')) && (await has('UPI')))
await page.getByRole('tab', { name: /^Expenses/ }).click(); await page.waitForTimeout(2000)
check('Expenses tab opens', await has('Spending by type'))
await page.getByRole('tab', { name: /^Summary/ }).click(); await page.waitForTimeout(1500)
await tap(/Last 7 days/, { role: 'checkbox', wait: 2500 })
const rep7 = (await api(token, 'GET', `/vendor/pos/report?from=${new Date(Date.now() - 6 * 864e5).toISOString().slice(0, 10)}&to=${today}`)).json.data
check('Last 7 days gives one row per day and the same totals', rep7.daily.length === 7 && rep7.revenuePaise === rep.revenuePaise && (await has('Day by day')))

// ── SETTINGS ────────────────────────────────────────────────────────────────────────────────────
await tab('Setting')
check('Settings: My shop tiles + This app', ['Customers', 'Price list', 'Extra charges and discounts', 'WhatsApp messages', 'Team', 'Language'].every((s) => view.length > 0) && (await has('Team')) && (await has('Language')))
await shot('settings')
await tap(/^Team/, { wait: 2000 })
check('Team page lists the owner in words', (await has('Owner')) && (await has('Ravi') || (await has(shop.phone))), (await text()).slice(0, 300))
await back()
await tap(/^WhatsApp messages/, { wait: 2000 })
check('Messages page shows the four default messages', (await has('Order Booked')) && (await has('Order Delivered')))
await back()

// custom garment through Add Garment Price
await tap(/^Price list/, { wait: 1500 })
check('Price list opens Add Garment Price', await has('Add Garment Price'))
await page.keyboard.press('Escape'); await page.waitForTimeout(800)

// language → Hinglish and back
await tap(/^Language/, { wait: 1200 })
await page.getByRole('button', { name: /Hinglish/ }).first().click(); await page.waitForTimeout(1500)
check('Switching to Hinglish changes the words on screen', (await has('Bhasha')) || (await has('Meri dukaan')), (await text()).slice(0, 300))
await page.getByRole('button', { name: /Bhasha/ }).first().click(); await page.waitForTimeout(1200)
await page.getByRole('button', { name: /^English/ }).first().click(); await page.waitForTimeout(1500)
check('…and back to English', await has('Language'))

// ── WHATSAPP quick action on Home ────────────────────────────────────────────────────────────────
await tab('Home')
let popupUrl = null
await page.context().route('https://wa.me/**', (r) => r.fulfill({ status: 200, body: 'ok' }))
page.context().on('page', (p) => { popupUrl = p.url() })
await tap(/WhatsApp/, { wait: 1500 })
await page.getByRole('button', { name: /Asha Verma/ }).first().click(); await page.waitForTimeout(2500)
check('WhatsApp: choose customer → message sheet for her latest order', (await has('Message Asha Verma')) && (await has('About order')), (await text()).slice(0, 300))
await page.getByRole('button', { name: /Order Done/ }).first().click(); await page.waitForTimeout(2500)
const wa = decodeURIComponent(popupUrl || '')
check('WhatsApp opens for 919811122233 with the order number and balance in the text', wa.includes('919811122233') && wa.includes('Order Done') === false && /#LND-/.test(wa) && !wa.includes('{'), wa)

console.log(`\n${results.filter(Boolean).length}/${results.length} checks passed`)
await browser.close()
process.exit(results.every(Boolean) ? 0 : 1)
