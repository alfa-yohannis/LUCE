docker stop redis alice-node bob-node charlie-node alice-eth bob-eth bob-xrp charlie-xrp
docker rm redis alice-node bob-node charlie-node alice-eth bob-eth bob-xrp charlie-xrp
docker network rm local-ilp

docker pull interledgerrs/ilp-node
docker pull interledgerrs/ilp-cli
docker pull trufflesuite/ganache-cli
docker pull interledgerjs/settlement-xrp
docker pull redis

docker network create local-ilp --subnet=111.111.0.0/24

docker run -d \
  --name redis \
  --network local-ilp \
  --add-host redis:111.111.0.101 \
  --ip 111.111.0.101 \
  redis
  
docker run -d \
  --name alice-eth \
  --network local-ilp \
  --add-host alice-eth:111.111.0.102 \
  --ip 111.111.0.102 \
  -e "RUST_LOG=interledger=trace" \
  interledgerrs/ilp-settlement-ethereum \
  --private_key 4a2cb86c7d3663abebf7ab86a6ddc3900aee399750f35e65a44ecf843ec39116 \
  --confirmations 0 \
  --poll_frequency 1000 \
  --ethereum_url http://192.168.0.4:8545 \
  --connector_url http://alice-node:7771 \
  --redis_url redis://redis:6379/0 \
  --asset_scale 18 \
  --settlement_api_bind_address 0.0.0.0:3000 \
  --watch_incoming \
  --contract_address 0xf38B59a1a73d76de228baC9f63B9760e3b4fD0FD

docker run -d \
  --name alice-node \
  --network local-ilp \
  --add-host alice-node:111.111.0.103 \
  --ip 111.111.0.103 \
  -e "RUST_LOG=interledger=trace" \
  interledgerrs/ilp-node \
  --ilp_address example.alice \
  --secret_seed 8852500887504328225458511465394229327394647958135038836332350604 \
  --admin_auth_token hi_alice \
  --redis_url redis://redis:6379/1 \
  --http_bind_address 0.0.0.0:7770 \
  --settlement_api_bind_address 0.0.0.0:7771 \
  --exchange_rate.provider CoinCap

docker run -d \
  --name bob-eth \
  --network local-ilp \
  --add-host bob-eth:111.111.0.104 \
  --ip 111.111.0.104 \
  -e "RUST_LOG=interledger=trace" \
  interledgerrs/ilp-settlement-ethereum \
  --private_key eeed5b1fc503bd2d9ea7cd2098794bcd4ee9c2f3a07ccab3401a263e02c36f71 \
  --confirmations 0 \
  --poll_frequency 1000 \
  --ethereum_url http://192.168.0.4:8545 \
  --connector_url http://bob-node:7771 \
  --redis_url redis://redis:6379/2 \
  --asset_scale 18 \
  --settlement_api_bind_address 0.0.0.0:3000 \
  --watch_incoming

docker run -d \
  --name bob-xrp \
  --network local-ilp \
  --add-host bob-xrp:111.111.0.105 \
  --ip 111.111.0.105 \
  -e "DEBUG=settlement*" \
  -e "CONNECTOR_URL=http://bob-node:7771" \
  -e "REDIS_URI=redis://redis:6379/3" \
  -e "ENGINE_PORT=3001" \
  -e "XRP_SECRET=sny8ne9UkMFWA184Lifn1VVFdqrHp" \
  interledgerjs/settlement-xrp

docker run -d \
  --name bob-node \
  --network local-ilp \
  --add-host bob-node:111.111.0.106 \
  --ip 111.111.0.106 \
  -e "RUST_LOG=interledger=trace" \
  interledgerrs/ilp-node \
  --ilp_address example.bob \
  --secret_seed 1604966725982139900555208458637022875563691455429373719368053354 \
  --admin_auth_token hi_bob \
  --redis_url redis://redis:6379/4 \
  --http_bind_address 0.0.0.0:7770 \
  --settlement_api_bind_address 0.0.0.0:7771 \
  --exchange_rate.provider CoinCap

docker run -d \
  --name charlie-xrp \
  --network local-ilp \
  --add-host charlie-xrp:111.111.0.107 \
  --ip 111.111.0.107 \
  -e "DEBUG=settlement*" \
  -e "CONNECTOR_URL=http://charlie-node:7771" \
  -e "REDIS_URI=redis://redis:6379/5" \
  -e "ENGINE_PORT=3000" \
  -e "XRP_SECRET=sasPP9PiLPATNRhjSx7rBc4yfRYNw" \
  interledgerjs/settlement-xrp

docker run -d \
  --name charlie-node \
  --network local-ilp \
  --add-host charlie-node:111.111.0.108 \
  --ip 111.111.0.108 \
  -e "RUST_LOG=interledger=trace" \
  interledgerrs/ilp-node \
  --secret_seed 1232362131122139900555208458637022875563691455429373719368053354 \
  --admin_auth_token hi_charlie \
  --redis_url redis://redis:6379/6 \
  --http_bind_address 0.0.0.0:7770 \
  --settlement_api_bind_address 0.0.0.0:7771 \
  --exchange_rate.provider CoinCap

alias   alice-cli="sudo docker run --rm --network local-ilp interledgerrs/ilp-cli --node http://alice-node:7770"
alias     bob-cli="sudo docker run --rm --network local-ilp interledgerrs/ilp-cli --node http://bob-node:7770"
alias charlie-cli="sudo docker run --rm --network local-ilp interledgerrs/ilp-cli --node http://charlie-node:7770"

alice-cli accounts create alice \
  --auth hi_alice \
  --ilp-address example.alice \
  --asset-code ETH \
  --asset-scale 18 \
  --ilp-over-http-incoming-token alice_password

alice-cli accounts create bob \
  --auth hi_alice \
  --ilp-address example.bob \
  --asset-code ETH \
  --asset-scale 18 \
  --settlement-engine-url http://alice-eth:3000 \
  --ilp-over-http-incoming-token bob_password \
  --ilp-over-http-outgoing-token alice_password \
  --ilp-over-http-url http://bob-node:7770/accounts/alice/ilp \
  --settle-threshold 1 \
  --settle-to 0 \
  --routing-relation Peer

sleep 5s

bob-cli accounts create alice \
  --auth hi_bob \
  --ilp-address example.alice \
  --asset-code ETH \
  --asset-scale 18 \
  --max-packet-amount 100000 \
  --settlement-engine-url http://bob-eth:3000 \
  --ilp-over-http-incoming-token alice_password \
  --ilp-over-http-outgoing-token bob_password \
  --ilp-over-http-url http://alice-node:7770/accounts/bob/ilp \
  --settle-threshold 1 \
  --settle-to 0 \
  --routing-relation Peer

sleep 5s

bob-cli accounts create charlie \
  --auth hi_bob \
  --ilp-address example.charlie \
  --asset-code XRP \
  --asset-scale 6 \
  --settlement-engine-url http://bob-xrp:3001 \
  --ilp-over-http-incoming-token charlie_password \
  --ilp-over-http-outgoing-token bob_other_password \
  --ilp-over-http-url http://charlie-node:7770/accounts/bob/ilp \
  --settle-threshold 1 \
  --settle-to 0 \
  --routing-relation Child

charlie-cli accounts create bob \
  --auth hi_charlie \
  --ilp-address example.bob \
  --asset-code XRP \
  --asset-scale 6 \
  --settlement-engine-url http://charlie-xrp:3000 \
  --ilp-over-http-incoming-token bob_other_password \
  --ilp-over-http-outgoing-token charlie_password \
  --ilp-over-http-url http://bob-node:7770/accounts/charlie/ilp \
  --settle-threshold 1 \
  --settle-to 0 \
  --routing-relation Parent

charlie-cli accounts create charlie \
  --auth hi_charlie \
  --ilp-address example.charlie \
  --asset-code XRP \
  --asset-scale 6 \
  --ilp-over-http-incoming-token charlie_password

printf "\n========= ALICE'S NODE ========="
printf "\nAlice's balance: "
alice-cli accounts balance alice --auth hi_alice
printf "Bob's balance: "
alice-cli accounts balance bob --auth hi_alice

printf "\n========= BOB'S NODE ========="
printf "\nAlice's balance: "
bob-cli accounts balance alice --auth hi_bob
printf "Charlie's balance: "
bob-cli accounts balance charlie --auth hi_bob

printf "\n========= CHARLIE'S NODE ========="
printf "\nBob's balance: "
charlie-cli accounts balance bob --auth hi_charlie
printf "Charlie's balance: "
charlie-cli accounts balance charlie --auth hi_charlie

printf "\nTransfer Money 1 XRP from Charlie to Alice\n"
alice-cli pay charlie \
  --auth charlie_password \
  --amount 1000000 \
  --to http://alice-node:7770/accounts/alice/spsp

printf "\n========= ALICE'S NODE ========="
printf "\nAlice's balance: "
alice-cli accounts balance alice --auth hi_alice
printf "Bob's balance: "
alice-cli accounts balance bob --auth hi_alice

printf "\n========= BOB'S NODE ========="
printf "\nAlice's balance: "
bob-cli accounts balance alice --auth hi_bob
printf "Charlie's balance: "
bob-cli accounts balance charlie --auth hi_bob

printf "\n========= CHARLIE'S NODE ========="
printf "\nBob's balance: "
charlie-cli accounts balance bob --auth hi_charlie
printf "Charlie's balance: "
charlie-cli accounts balance charlie --auth hi_charlie

