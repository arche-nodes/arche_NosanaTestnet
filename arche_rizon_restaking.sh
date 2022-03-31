#!/bin/bash
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color
DELEGATOR='rizon1r24wgdvzpvakk6h32xrstkygu84pl7hd96x5cy'
VALIDATOR='rizonvaloper1r24wgdvzpvakk6h32xrstkygu84pl7hdk7y465'
PASWD='dThd^da/x$ag'
DELAY=1800 #in secs - how often restart the script 
ACC_NAME=ARCHE
NODE=http://localhost:26657 #change it only if you use another rpc port of your node

for (( ;; )); do
        BAL=$(rizond query bank balances ${DELEGATOR} --node ${NODE});
        echo -e "BALANCE: ${GREEN}${BAL}${NC} uatolo\n"
        echo -e "Claim rewards\n"
        echo -e "${PASWD}\n${PASWD}\n" | rizond tx distribution withdraw-rewards ${VALIDATOR} --chain-id groot-011 --from ${ACC_NAME} --node ${NODE} --commission -y --fees 1000uatolo
        for (( timer=10; timer>0; timer-- ))
        do
                printf "* sleep for ${RED}%02d${NC} sec\r" $timer
                sleep 1
        done
        BAL=$(rizond query bank balances ${DELEGATOR} --node ${NODE} -o json | jq -r '.balances | .[].amount');
        echo -e "BALANCE: ${GREEN}${BAL}${NC} uatolo\n"
        echo -e "Stake ALL\n"
        echo -e "${PASWD}\n${PASWD}\n" | rizond tx staking delegate ${VALIDATOR} ${BAL}uatolo --chain-id groot-011 --from ${ACC_NAME} --node ${NODE} -y --fees 1000uatolo
        for (( timer=${DELAY}; timer>0; timer-- ))
        do
                printf "* sleep for ${RED}%02d${NC} sec\r" $timer
                sleep 1
        done
done
