// Address
// r9SKj7C6uWMCMbDWib1ednjbRJktWEhaZu
// Secret
// sasPP9PiLPATNRhjSx7rBc4yfRYNw

'use strict';
const RippleAPI = require('ripple-lib').RippleAPI;

const api = new RippleAPI({
  server: 'wss://s.altnet.rippletest.net:51233' // testnet
});

api.connect().then(() => {
  /* begin custom code ------------------------------------ */
  const secret = 'sasPP9PiLPATNRhjSx7rBc4yfRYNw';

  console.log('Derive address from secret', secret);
  return api.isValidSecret(secret);

}).then(info => {
  console.log(info);
  console.log('isValidSecret done');

  /* end custom code -------------------------------------- */
}).then(() => {
  return api.disconnect();
}).then(() => {
  console.log('done and disconnected.');
}).catch(console.error);