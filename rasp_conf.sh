#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Aucune interface fournie.";
    exit 1;
fi

interface_raspberry=$1;
echo "interface sélectionnée : $1";
echo "Configuration de l'interface...";
ifconfig $1 192.168.10.254 netmask 255.255.255.0;
echo "Ajout de la route...";
route add -net 192.168.10.0 netmask 255.255.255.0 dev $1;
echo "Affichage de l'interface :";
ifconfig $1;
echo "Affichage des routes de l'interface :";
route -n | grep $1;
