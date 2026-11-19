import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { config } from '../config/index.js';

// Writes to the console and to src/logs/app-YYYY-MM-DD.log.
const logsDir = path.join(path.dirname(fileURLToPath(import.meta.url)), '..', 'logs');
fs.mkdirSync(logsDir, { recursive: true });

const LEVELS = { error: 0, warn: 1, info: 2, debug: 3 };
const threshold = LEVELS[config.logLevel] ?? LEVELS.info;

function write(level, message) {
  if (LEVELS[level] > threshold) return;
  const now = new Date();
  const line = `${now.toISOString()} ${level.toUpperCase().padEnd(5)} ${message}`;
  (level === 'error' ? console.error : console.log)(line);
  const file = path.join(logsDir, `app-${now.toISOString().slice(0, 10)}.log`);
  fs.appendFile(file, `${line}\n`, () => {});
}

export const logger = {
  error: (msg) => write('error', msg),
  warn: (msg) => write('warn', msg),
  info: (msg) => write('info', msg),
  debug: (msg) => write('debug', msg),
};
