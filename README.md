## Install Wazuh simple

```bash
sudo apt update && sudo apt full-upgrade -y
sudo apt install curl apt-transport-https ca-certificates software-properties-common -y 
curl -sO https://packages.wazuh.com/4.11/wazuh-install.sh && sudo bash ./wazuh-install.sh -a -i -v
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

```
sudo apt install suricata
```

### Sur la machine **agent** :

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

Puis :

```bash
sudo systemctl restart wazuh-agent
```

### Sur la machine **manager** :

```bash
sudo nano /var/ossec/etc/decoders/suricata_decoder.xml
```

Contenu :
```
<decoder name="suricata-alert">
  <program_name>suricata</program_name>
  <prematch>suricata</prematch>
  <regex>^\w{3} \d+ \d+:\d+:\d+ .*</regex>
  <order>json</order>
</decoder>


Ensuite créer une règle :

```bash
sudo nano /var/ossec/etc/rules/suricata_rule.xml
```

Contenu :

```xml
<group name="surcata,">
  <rule id="100100" level="10">
    <field name="alert.signature">.*</field>
    <description>Suricata alert detected: $alert.signature</description>
    <group>suricata</group>
  </rule>
</group>
```

Redémarrer le manager :

```bash
sudo systemctl restart wazuh-manager
```

### Tester que c'est bon :

```bash
/var/ossec/bin/ossec-logtest
```

Regarder dans :

```bash
/var/ossec/logs/bin/wazuh-logtest
```


