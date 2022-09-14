const { spawn } = require('node:child_process');

/**
 *
 * @param {String} command - Command to start
 * @param {String[] | undefined} args - Arguments fot the command
 */
function spawnProc(command, args) {
  return new Promise((resolve, reject) => {
    console.log(`$ ${command} ${(args?.join(' ') ?? '')}`)
    const data = [];
    const errors = []
    const process = spawn(command, args);
    process.stdout.on('data', (chunk) => data.push(chunk.toString('utf-8')));

    try {
      process.stderr.on('data', (chunk) => errors.push(chunk.toString('utf-8')));
    } catch (err) {
      console.error('HMMMM', err)
    }

    process.on('error', reject);
    process.on('close', () => errors.length ? reject(errors.join('')) : resolve(data.join('')))
  });
}

module.exports = spawnProc;