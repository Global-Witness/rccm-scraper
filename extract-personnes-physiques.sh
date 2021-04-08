#!/bin/bash
echo "rccm,nomEtPrenom,civilite,prenom,nom,postNom,sexe,dateNaissance,nationalite,paysNaissance,lieuNaissance"
jq -r "
  .details |
  select(.[] | .personnePhysiqueAssujettie != null) |
  [
    ((.[] | .rccm.value) // null),
    ((.[] | .personnePhysiqueAssujettie.value.prenom) // null) + \" \" +
      ((.[] | .personnePhysiqueAssujettie.value.nom) // null),
    ((.[] | .personnePhysiqueAssujettie.value.civilite.value) // null),
    ((.[] | .personnePhysiqueAssujettie.value.prenom) // null),
    ((.[] | .personnePhysiqueAssujettie.value.nom) // null),
    ((.[] | .personnePhysiqueAssujettie.value.postNom) // null),
    ((.[] | .personnePhysiqueAssujettie.value.sexe.value) // null),
    ((.[] | .personnePhysiqueAssujettie.value.dateNaissance) // null),
    ((.[] | .personnePhysiqueAssujettie.value.nationalite.value) // null),
    ((.[] | .personnePhysiqueAssujettie.value.paysNaissance.value) // null),
    ((.[] | .personnePhysiqueAssujettie.value.lieuNaissance) // null)
  ] |
  @csv
"
