#!/bin/bash

#Ce script va configurer l'interface fournie en argument : 
#une adresse IP statique lui sera attribuée ainsi qu'une route pour que l'ordinateur puisse communiquer avec le Pi.
#De plus, le script configure le forwarding en rajoutant deux règles iptables, il ensuite active ce dernier grâce au fichier ip_forward.

if [ $# -eq 0 ]; then
    echo "Aucune interface fournie, la première est celle du Raspberry Pi, la seconde, l'accès Internet.";
    exit 1;
fi

interface_raspberry=$1;
interface_internet=$2;

echo "Interface sélectionnée : $1";
echo "Configuration de l'interface...";
ifconfig $1 192.168.10.254 netmask 255.255.255.0;
echo "Ajout de la route...";
route add -net 192.168.10.0 netmask 255.255.255.0 dev $1;
echo "Affichage de l'interface :";
ifconfig $1;
echo "Affichage des routes de l'interface :";
route -n | grep $1;

echo "Création des règles IPtable de forwarding :";
iptables -t nat -A POSTROUTING -o $2 -j MASQUERADE;
iptables -A FORWARD -i $1 -j ACCEPT;

echo "Vérification des tables :";
echo "Table NAT - POSTROUTING";
iptables -t nat -L | grep -A 3 POSTROUTING;
echo "Table FILTER - FORWARD";
iptables -L | grep -A 3 FORWARD;

echo "Activation du forwarding...";
echo 1 > /proc/sys/net/ipv4/ip_forward;
echo "Vérification :";
cat /proc/sys/net/ipv4/ip_forward;
