const pino = require('pino');
const ecsFormat = require('@elastic/ecs-pino-format');

const logger = pino(ecsFormat({ convertReqRes: true }));

const express = require('express');
const app = express();

app.use((req, res, next) => {
  req.logger = logger;
  next();
});

app.get('/', (req, res) => {
  req.logger.info('Received a request');
  res.send('Hello, World!');
});

app.get('/warn', (req, res) => {
  req.logger.warn('This is a sample warning!');
  res.send('Triggered a warning!');
});

app.get('/debug', (req, res) => {
  req.logger.debug('This is a sample debug message!');
  res.send('Triggered a debug message!');
});

app.get('/error', (req, res) => {
  throw new Error('This is a sample error!');
});

// Error handling middleware
app.use((err, req, res, next) => {
  req.logger.error(err.message);
  res.status(500).send('Something broke!');
});

app.listen(3000, () => {
  logger.info('Listening on port 3000');
});
