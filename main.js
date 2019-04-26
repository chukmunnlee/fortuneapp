const { join } = require('path');
const morgan = require('morgan');
const hbs = require('express-handlebars');
const express = require('express');

const FORTUNES = require('fortune-cookie')

const APP_PORT = parseInt(process.argv[2]) || parseInt(process.env.APP_PORT) || 3000;

const app = express();

app.engine('hbs', hbs());
app.set('view engine', 'hbs')

app.use(morgan('common'));

app.get(['/', '/fortune'], (req, resp) => {
	const idx = Math.floor(Math.random() * FORTUNES.length);
	const fortuneText = FORTUNES[idx];
	resp.status(200);
	resp.format({
		'text/plain': () => {
			resp.send(fortuneText)
		}, 
		'text/html': () => {
			resp.render('fortunes', { text: fortuneText });
		},
		'application/json': () => {
			resp.json({ fortune: fortuneText });
		},
		'default': () => {
			resp.status(406).send('Not Acceptable');
		}
	})
});

app.get('/health', (req, resp) => {
	resp.status(200).json({ time: (new Date()).getTime() });
});

app.use(express.static(join(__dirname, 'public')));

app.use((req, resp) => {
	resp.status(404).type('text/html');
	resp.sendFile(join(__dirname, 'public/404.html'));
});

app.listen(APP_PORT, () => {
	console.info('Application started at port %d on %s'
		, APP_PORT, (new Date()).toString());
});
