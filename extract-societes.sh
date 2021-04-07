#!/bin/bash
echo "rccm,nom,sigle,dateImmatriculationRCCM,formeJuridiqueN1,secteurActivite,adresseSiegeSocial,email,telephone"
jq -rc "
  .details |
  {
    rccm: ((.[] | .rccm.value) // null),
    nom: ((.[] | .denominationSociale.value) // (.[] | .nomCommercial.value) // null),
    sigle: ((.[] | .sigle.value) // null),
    dateImmatriculationRCCM: ((.[] | .dateImmatriculationRCCM.value) // null),
    formeJuridiqueN1: ((.[] | .formeJuridiqueN1.value.value) // null),
    secteurActivite: ((.[] | .secteurActivite.value.value) // null),
    adresseSiegeSocial: ((.[] | .adresseSiegeSocial.value._name) // null),
    email: ((.[] | .email.value) // null),
    telephone: ((.[] | .telephone.value) // null),
  } |
  [
    .rccm,
    .nom,
    .sigle,
    .dateImmatriculationRCCM,
    .formeJuridiqueN1,
    .secteurActivite,
    .adresseSiegeSocial,
    .email,
    .telephone
  ] |
  @csv
"