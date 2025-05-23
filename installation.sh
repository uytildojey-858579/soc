#!/bin/bash

echo "Cette installation va vous prendre 1 Go :(, si oui, tapez 1"
read test

if [ "$test" -eq 1 ]; then
    git clone https://github.com/wazuh/wazuh-docker.git -b v4.11.0
    cd wazuh-docker/single-node/
    docker-compose -f generate-indexer-certs.yml up

    echo "Voulez-vous le démarrer maintenant et perdre 1 Go, tapez 1"
    read line

    if [ "$line" -eq 1 ]; then
        docker-compose -f docker-compose.yml up -d
        echo "L'utilisateur : admin"
        echo "Le MDP: SecretPassword"
	echo "Allez sur localhost"
    else 
        echo "Installation fini, maintenant il faut le lancer, et avoir 1Go"
    fi
else 
    echo "Ta connection te remercie :)"
fi
