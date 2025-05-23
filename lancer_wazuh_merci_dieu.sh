#!/bin/bash


cd ./wazuh-docker/single-node
docker-compose -f docker-compose.yml up -d

echo "  → Utilisateur : admin"
echo "  → Mot de passe : SecretPassword"
echo "  → Accès : http://localhost:5601"
