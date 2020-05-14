const http = require('http')
const httpProxy = require('http-proxy')
const express = require('express')
const request = require('request')
const httpsrv = require('httpsrv')
const fs = require('fs')
const SECRET = /rpc-secret=(.*)/.exec(
	fs.readFileSync('aria2c.conf', 'utf-8')
)[1]
const ENCODED_SECRET = Buffer.from(SECRET).toString('base64')

const PORT = process.env.PORT || 1234
const app = express()
const proxy = httpProxy.createProxyServer({
	target: 'ws://localhost:6800',
	ws: true
})
const server = http.createServer(app)

// Proxy websocket
server.on('upgrade', (req, socket, head) => {
	proxy.ws(req, socket, head)
})

// Handle normal http traffic
app.use('/jsonrpc', (req, res) => {
	req.pipe(request('http://localhost:6800/jsonrpc')).pipe(res)
})
app.use(
	'/downloads/' + ENCODED_SECRET,
	httpsrv({
		basedir: __dirname + '/downloads'
	})
)
app.use('/ariang', express.static(__dirname + '/ariang'))
app.use('/', express.static(__dirname + '/index'))
server.listen(PORT, () => console.log(`Listening on http://localhost:${PORT}`))

if (process.env.HEROKU_APP_NAME) {
	const readNumUpload = () =>
		new Promise((res, rej) =>
			fs.readFile('numUpload', 'utf-8', (err, text) =>
				err ? rej(err) : res(text)
			)
		)
	const APP_URL = `https://${process.env.HEROKU_APP_NAME}.herokuapp.com`
	const preventIdling = () => {
		request.post(
			'http://localhost:6800/jsonrpc',
			{
				json: {
					jsonrpc: '2.0',
					method: 'aria2.getGlobalStat',
					id: 'preventIdling',
					params: [`token:${SECRET}`]
				}
			},
			async (err, resp, body) => {
				console.log('preventIdling: getGlobalStat response', body)
				const { numActive, numWaiting } = body.result
				const numUpload = await readNumUpload()
				console.log(
					'preventIdling: numbers',
					numActive,
					numWaiting,
					numUpload
				)
				if (
					parseInt(numActive) +
						parseInt(numWaiting) +
						parseInt(numUpload) >
					0
				) {
					console.log('preventIdling: make request to prevent idling')
					request(APP_URL)
				}
			}
		)
		setTimeout(preventIdling, 5 * 60 * 1000) // 5 min
	}
	preventIdling()
}
