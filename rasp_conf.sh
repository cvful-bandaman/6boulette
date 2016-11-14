#!/bin/bash

#Ce script va configurer l'interface fournie en argument : 
#une adresse IP statique lui sera attribuée ainsi qu'une route pour que l'ordinateur puisse communiquer avec le Pi 

if [ $# -eq 0 ]; then
    echo "Aucune interface fournie.";
    exit 1;
fi

interface_raspberry=$1;
echo "Interface sélectionnée : $1";
echo "Configuration de l'interface...";
ifconfig $1 192.168.10.254 netmask 255.255.255.0;
echo "Ajout de la route...";
route add -net 192.168.10.0 netmask 255.255.255.0 dev $1;
echo "Affichage de l'interface :";
ifconfig $1;
echo "Affichage des routes de l'interface :";
route -n | grep $1;
echo "Activation du forwarding...";
echo 1 > /proc/sys/net/ipv4/ip_forward;
echo "Vérification :";
cat /proc/sys/net/ipv4/ip_forward;
