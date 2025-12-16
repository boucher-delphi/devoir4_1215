
#!/bin/bash

shopt -s globstar  # permet la recursion avec **
#"${1:-.}"
start_dir="${1:-.}"

if [[ -z "$start_dir" || ! -d "$start_dir" ]]; then
    echo -e "Executer le script avec un repertoire existant:\t$0 file/directory"
    exit 1 # Fin du script avec erreur
fi

#initialiser les variables
fichierCourantAvecPath=""
fichierCourant=""
fishierCourantDate=""
fichierCourantTaille=0
listFichier=()
input="Non"
compteDeDbl=0

#/** fait la recursion activée par globstar au début
for path in "$start_dir"/**; do 
  # traiter seulement les fichiers, continuer si un repertoire
  if [[ -f "$path" ]]; then
    fichierCourantAvecPath="$path"
	fichierCourant=${fichierCourantAvecPath##*/}
	
	fishierCourantModifDate=$(stat -c "%y" "$fichierCourantAvecPath")
	fichierCourantTaille=$(stat -c "%s" "$fichierCourantAvecPath")
	
	for fichier in "${listFichier[@]}"; do
		# Comparer nom, date de modification et taille de chaque fichier
		if [[ "$fichier" == *"$fichierCourant" && $fishierCourantModifDate == $(stat -c "%y" "$fichier") && $fichierCourantTaille == $(stat -c "%s" "$fichier") ]]; then
			((compteDeDbl++))
			printf "%s\n %s\n %s\n" "Doublons trouvés:" "$fichier" "$fichierCourantAvecPath"
			read -p "Voulez-vous supprimer le fichier (Oui/Non ou autre clé)?" input
			if [[ "$input" == "Y" ]]; then
				rm "$fichierCourantAvecPath"
			else
				rm "$fichier" 
			fi	
		fi
	done
	
	listFichier+=("$path") # ajouter le fichier à la liste de fichiers.
  fi 
done

if [[ $compteDeDbl == 0 ]]; then
	echo "Pas de doublons." # Prompt si il n'y a pas de doublons
fi
