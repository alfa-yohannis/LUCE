// Bob's Account:
// Address: rPV4auTNVLzdBJJ3bKUtz3DmdhuG7W15c8
// Secret: sny8ne9UkMFWA184Lifn1VVFdqrHp
// Charlie's Account:
// Address: r9SKj7C6uWMCMbDWib1ednjbRJktWEhaZu
// Secret: sasPP9PiLPATNRhjSx7rBc4yfRYNw


'use strict';
const RippleAPI = require('ripple-lib').RippleAPI;

const api = new RippleAPI({
  server: 'wss://s.altnet.rippletest.net:51233' // testnet
});

/***
 * Bob's ACCOUNT
 */
 api.connect().then(() => {
  /* begin custom code ------------------------------------ */
  const myAddress = 'rPV4auTNVLzdBJJ3bKUtz3DmdhuG7W15c8';

  console.log('getting account info for', "Bob: " + myAddress + "sny8ne9UkMFWA184Lifn1VVFdqrHp");
  return api.getAccountInfo(myAddress);

}).then(info => {
  console.log(info);
  console.log('getAccountInfo done');

  /* end custom code -------------------------------------- */
}).then(() => {
  return api.disconnect();
}).then(() => {
  console.log('done and disconnected.');
}).catch(console.error);


/***
 * CHARLIE's ACCOUNT
 */
api.connect().then(() => {
  /* begin custom code ------------------------------------ */
  const myAddress = 'r9SKj7C6uWMCMbDWib1ednjbRJktWEhaZu';

  console.log('getting account info for', "Charlie: " + myAddress + "sasPP9PiLPATNRhjSx7rBc4yfRYNw");
  return api.getAccountInfo(myAddress);

}).then(info => {
  console.log(info);
  console.log('getAccountInfo done');

/* end custom code -------------------------------------- */
}).then(() => {
  return api.disconnect();
}).then(() => {
  console.log('done and disconnected.');
}).catch(console.error);



