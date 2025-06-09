## Install Wazuh simple

```bash
sudo apt update && sudo apt full-upgrade -y
sudo apt install curl apt-transport-https ca-certificates software-properties-common -y 
curl -sO https://packages.wazuh.com/4.11/wazuh-install.sh && sudo bash ./wazuh-install.sh -a -i
ou
curl -sO https://packages.wazuh.com/4.12/wazuh-install.sh && sudo bash ./wazuh-install.sh -a -i
````

* C'est fini.

## Agent

```bash
sudo apt update

sudo apt install curl gnupg
curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | sudo gpg --dearmor -o /usr/share/keyrings/wazuh-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/wazuh-archive-keyring.gpg] https://packages.wazuh.com/4.x/apt/ stable main" | sudo tee /etc/apt/sources.list.d/wazuh.list
sudo apt update
sudo apt install wazuh-agent=4.11.0-1

sudo nano /var/ossec/etc/ossec.conf

sudo systemctl daemon-reexec
sudo systemctl enable wazuh-agent
sudo systemctl start wazuh-agent
```

* Avant, vérifier version :

```bash
/var/ossec/bin/wazuh-agentd -V
```

## Enregistrer

* **Sur manager** :

```bash
/var/ossec/bin/manage_agents
```

* Appuyer sur `A` pour ajouter, puis `E` pour exporter la clé.

* **Sur agent** :

```bash
sudo /var/ossec/bin/manage_agents

sudo systemctl restart wazuh-agent
```

* Pour vérifier :

```bash
/var/ossec/bin/agent_control -l
```

---

## Maintenant Suricata
### Sur la machine **agent** :

```bash
sudo add-apt-repository ppa:oisf/suricata-stable
sudo apt-get update
sudo apt-get install suricata -y

```

```bash
cd /tmp/ && curl -LO https://rules.emergingthreats.net/open/suricata-6.0.8/emerging.rules.tar.gz
mkdir -p /etc/suricata/rules/
sudo tar -xvzf emerging.rules.tar.gz && sudo mv rules/*.rules /etc/suricata/rules/
sudo chmod 640 /etc/suricata/rules/*.rules
```
- modifer /etc/suricata/suricata.yaml
```bash

HOME_NET: "<IP_AGENT>"
EXTERNAL_NET: "any"

rule-files:
- "*.rules"
- "/etc/suricata/rules/*.rules"

# Global stats configuration
stats:
enabled: yes

# Linux high speed capture support
af-packet:
  - interface: ens3
```


```bash
sudo nano /var/ossec/etc/ossec.conf
```

Ajouter dans `<ossec_config>` en bas :

```xml
<localfile>
  <log_format>json</log_format>
  <location>/var/log/suricata/eve.json</location>
</localfile>
```

-restart tout 




