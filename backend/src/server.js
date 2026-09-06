const env = require('./config/environment');
const logger = require('./config/logger');
const { connectDatabase } = require('./config/database');
const app = require('./app');

async function start() {
  await connectDatabase();
  const server = app.listen(env.port, () => {
    logger.info(`${env.appName} listening on port ${env.port}`);
  });

  const shutdown = async () => {
    server.close(() => {
      logger.info('HTTP server closed');
      process.exit(0);
    });
  };

  process.on('SIGINT', shutdown);
  process.on('SIGTERM', shutdown);
}

start().catch((error) => {
  logger.error(error);
  process.exit(1);
});
