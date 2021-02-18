#!/usr/bin/env bash
set -euo pipefail

source ~/workspace/elasticsearch-benchmarks/.venv/bin/activate

export INSTALLATION_ID0=$(esrally install --quiet --revision=persistent-async-search-proto --node-name="rally-node-0" --network-host="127.0.0.1" --http-port=39200 --master-nodes="rally-node-0,rally-node-1,rally-node-2" --seed-hosts="127.0.0.1:39300,127.0.0.2:39300,127.0.0.3:39300" | jq --raw-output '.["installation-id"]')
export INSTALLATION_ID1=$(esrally install --quiet --revision=persistent-async-search-proto --node-name="rally-node-1" --network-host="127.0.0.2" --http-port=39200 --master-nodes="rally-node-0,rally-node-1,rally-node-2" --seed-hosts="127.0.0.1:39300,127.0.0.2:39300,127.0.0.3:39300" | jq --raw-output '.["installation-id"]')
export INSTALLATION_ID2=$(esrally install --quiet --revision=persistent-async-search-proto --node-name="rally-node-2" --network-host="127.0.0.3" --http-port=39200 --master-nodes="rally-node-0,rally-node-1,rally-node-2" --seed-hosts="127.0.0.1:39300,127.0.0.2:39300,127.0.0.3:39300" | jq --raw-output '.["installation-id"]')
export INSTALLATION_ID3=$(esrally install --quiet --revision=persistent-async-search-proto --node-name="rally-node-1" --network-host="127.0.0.4" --http-port=39200 --master-nodes="rally-node-0,rally-node-1,rally-node-2" --seed-hosts="127.0.0.1:39300,127.0.0.2:39300,127.0.0.3:39300" | jq --raw-output '.["installation-id"]')
export INSTALLATION_ID4=$(esrally install --quiet --revision=persistent-async-search-proto --node-name="rally-node-2" --network-host="127.0.0.5" --http-port=39200 --master-nodes="rally-node-0,rally-node-1,rally-node-2" --seed-hosts="127.0.0.1:39300,127.0.0.2:39300,127.0.0.3:39300" | jq --raw-output '.["installation-id"]')
export INSTALLATION_ID5=$(esrally install --quiet --revision=persistent-async-search-proto --node-name="rally-node-3" --network-host="127.0.0.6" --http-port=39200 --master-nodes="rally-node-0,rally-node-1,rally-node-2" --seed-hosts="127.0.0.1:39300,127.0.0.2:39300,127.0.0.3:39300" | jq --raw-output '.["installation-id"]')

export RACE_ID=34d8de0c-e8cc-4e1c-b074-c3e3a3277244
echo $RACE_ID
esrally start --installation-id="${INSTALLATION_ID0}" --race-id="${RACE_ID}"
esrally start --installation-id="${INSTALLATION_ID1}" --race-id="${RACE_ID}"
esrally start --installation-id="${INSTALLATION_ID2}" --race-id="${RACE_ID}"
esrally start --installation-id="${INSTALLATION_ID3}" --race-id="${RACE_ID}"
esrally start --installation-id="${INSTALLATION_ID4}" --race-id="${RACE_ID}"
esrally start --installation-id="${INSTALLATION_ID5}" --race-id="${RACE_ID}"

esrally race --telemetry jfr --pipeline=benchmark-only --target-host=127.0.0.1:39200,127.0.0.2:39200,127.0.0.3:39200,127.0.0.4:39200,127.0.0.5:39200,127.0.0.6:39200  --revision=persistent-async-search-proto --kill-running-processes --track-path=persistent_search

esrally stop --installation-id="${INSTALLATION_ID0}"
esrally stop --installation-id="${INSTALLATION_ID1}"
esrally stop --installation-id="${INSTALLATION_ID2}"
esrally stop --installation-id="${INSTALLATION_ID3}"
esrally stop --installation-id="${INSTALLATION_ID4}"
esrally stop --installation-id="${INSTALLATION_ID5}"
