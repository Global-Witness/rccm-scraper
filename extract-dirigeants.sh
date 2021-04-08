#!/bin/bash
echo "rccm,nomEtPrenom,civilite,prenom,nom,postNom,sexe,dateNaissance,nationalite,paysNaissance,lieuNaissance,numeroPieceIdentite,adresse,email,telephoneMobile"
jq -r "
  .details |
  {
    rccm: .[] | select(.rccm.value != null) | .rccm.value,
    person: .[] | select(.dirigeants.value != null) | .dirigeants.value[]
  } |
  [
    .rccm,
    (.person.personne.prenom // null) + \" \" +
      (.person.personne.nom // null),
    (.person.personne.civilite.value // null),
    (.person.personne.prenom // null),
    (.person.personne.nom // null),
    (.person.personne.postNom // null),
    (.person.personne.sexe.value // null),
    (.person.personne.dateNaissance // null),
    (.person.personne.nationalite.value // null),
    (.person.personne.paysNaissance.value // null),
    (.person.personne.lieuNaissance // null),
    (.person.personne.numeroPieceIdentite // null),
    (.person.personne.adresse._name // null),
    (.person.personne.email // null),
    (.person.personne.telephoneMobile // null)
  ] |
  @csv
"
