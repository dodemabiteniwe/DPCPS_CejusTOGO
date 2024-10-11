# Load the necessary library and dataset
# Function to install and load a single package
install_and_load <- function(package) {
  if (!require(package,character.only = TRUE)) {
    install.packages(package, dependencies = TRUE)
    library(package,character.only = TRUE)
  }
}

# List of required packages
required_packages <- c("janitor","kableExtra","gridExtra","data.table", "tidyverse", "lubridate","ggplot2","readxl","corrplot","scales" ,"knitr","bookdown")

# Install and load all required packages
for (pkg in required_packages) {
  install_and_load(pkg)
}

#  Data Loading
temp <- tempfile()
download.file("https://raw.githubusercontent.com/dodemabiteniwe/DPCPS_CejusTOGO/main/SPCPS_Analyse_Men_Togo241007.zip", temp)
unzip(temp, files = "SPCPS_Analyse_Men_Togo241007.xlsx", exdir = "data")
spcps_data <- read_excel("data/SPCPS_Analyse_Men_Togo241007.xlsx")
# Supprimer les colonnes entièrement vides
spcps_data1 <- spcps_data %>% select(where(~ any(!is.na(.))))

#str(spcps_data)
#dim(spcps_data)


# 1. Suppression des colonnes inutiles (métadonnées)
#dput(names(spcps_data1))
columns_to_remove <- c("_uuid", "_submission_time", "_status", "_submitted_by", "__version__",
                       "start-geopoint","_start-geopoint_latitude","_start-geopoint_longitude",
                       "_start-geopoint_precision","today","deviceid","audit","audit_URL",
                       "DM1_start","DM5_end","DM1_start_t","DM5_end_t","start_section_d","end_section_d","start_section_d_t",
                       "end_section_d_t","start_objective_1", "end_objective1", "start_objective_1_t", "end_objective_1_t",
                       "start_objective2", "end_objective2", "start_objective2_t", "end_objective2_t",
                       "start_objective3", "end_objective3", "start_objective3_t", "end_objective3_t",
                       "start_Q1a", "end_Q1c", "start_t", "end_t","start_questiont", "end_questiont", "start_questiont_t", "end_questiont_t")


spcps_data1 <- spcps_data1 %>% select(-all_of(columns_to_remove))


#dput(names(spcps_data1))
columns_to_remove2 <-c( 
  "Q7d. Selon vous, quelles sont les plus grandes menace à la cohésion sociale dans votre communauté ? /Litiges fonciers (Problème lié à la terre)", 
  "Q7d. Selon vous, quelles sont les plus grandes menace à la cohésion sociale dans votre communauté ? /Ressources communes partagées (eau, espace public, pâturage, etc.)", 
  "Q7d. Selon vous, quelles sont les plus grandes menace à la cohésion sociale dans votre communauté ? /Divisions ethniques", 
  "Q7d. Selon vous, quelles sont les plus grandes menace à la cohésion sociale dans votre communauté ? /Divisions religieuses", 
  "Q7d. Selon vous, quelles sont les plus grandes menace à la cohésion sociale dans votre communauté ? /Facteurs économiques (pauvreté, chômage, etc.)", 
  "Q7d. Selon vous, quelles sont les plus grandes menace à la cohésion sociale dans votre communauté ? /Insécurité (présence de groupes d'autodéfense, usage excessif de la force par les forces de sécurité, présence de groupes armés)", 
  "Q7d. Selon vous, quelles sont les plus grandes menace à la cohésion sociale dans votre communauté ? /Violences sexuelles et sexistes", 
  "Q7d. Selon vous, quelles sont les plus grandes menace à la cohésion sociale dans votre communauté ? /Conflits politiques", 
  "Q7d. Selon vous, quelles sont les plus grandes menace à la cohésion sociale dans votre communauté ? /Insécurité alimentaire", 
  "Q7d. Selon vous, quelles sont les plus grandes menace à la cohésion sociale dans votre communauté ? /Conflit lié au pouvoir local/chefferie traditionnelle", 
  "Q7d. Selon vous, quelles sont les plus grandes menace à la cohésion sociale dans votre communauté ? /Autres (Veuillez préciser)", 
  "Q7d. Selon vous, quelles sont les plus grandes menace à la cohésion sociale dans votre communauté ? /Ne sait pas", 
  "Q7d. Selon vous, quelles sont les plus grandes menace à la cohésion sociale dans votre communauté ? /Préfère ne pas répondre", 
  "Q8c. Si oui, quel(s) rôle(s) jouent-elles dans ces processus de consolidation de la paix ?/Leadership", 
  "Q8c. Si oui, quel(s) rôle(s) jouent-elles dans ces processus de consolidation de la paix ?/Coordination", 
  "Q8c. Si oui, quel(s) rôle(s) jouent-elles dans ces processus de consolidation de la paix ?/Soutien/Rôles sexospécifiques (Soutien différencier selon le sexe)", 
  "Q8c. Si oui, quel(s) rôle(s) jouent-elles dans ces processus de consolidation de la paix ?/Autres (Veuillez préciser)", 
  "Q8c. Si oui, quel(s) rôle(s) jouent-elles dans ces processus de consolidation de la paix ?/Ne sait pas", 
  "Q8c. Si oui, quel(s) rôle(s) jouent-elles dans ces processus de consolidation de la paix ?/Préfère ne pas répondre", 
  "Q8f. Selon vous quels facteurs empêchent la participation significative des femmes dans des rôles substantiels au sein des processus de consolidation de la paix ?/Structure sociétale (dominance masculine, dynamique du pouvoir)", 
  "Q8f. Selon vous quels facteurs empêchent la participation significative des femmes dans des rôles substantiels au sein des processus de consolidation de la paix ?/Culture/Tradition", 
  "Q8f. Selon vous quels facteurs empêchent la participation significative des femmes dans des rôles substantiels au sein des processus de consolidation de la paix ?/Religion", 
  "Q8f. Selon vous quels facteurs empêchent la participation significative des femmes dans des rôles substantiels au sein des processus de consolidation de la paix ?/Situation économique", 
  "Q8f. Selon vous quels facteurs empêchent la participation significative des femmes dans des rôles substantiels au sein des processus de consolidation de la paix ?/Éducation", 
  "Q8f. Selon vous quels facteurs empêchent la participation significative des femmes dans des rôles substantiels au sein des processus de consolidation de la paix ?/Charge domestique", 
  "Q8f. Selon vous quels facteurs empêchent la participation significative des femmes dans des rôles substantiels au sein des processus de consolidation de la paix ?/Autres (veuillez préciser)", 
  "Q8f. Selon vous quels facteurs empêchent la participation significative des femmes dans des rôles substantiels au sein des processus de consolidation de la paix ?/Ne sait pas", 
  "Q8f. Selon vous quels facteurs empêchent la participation significative des femmes dans des rôles substantiels au sein des processus de consolidation de la paix ?/Préfère ne pas répondre",
  "Q10a. D’une manière générale, quelles sont vos sources d’information ? /Leader communautaire", 
  "Q10a. D’une manière générale, quelles sont vos sources d’information ? /Chef religieux", 
  "Q10a. D’une manière générale, quelles sont vos sources d’information ? /Membres du gouvernement", 
  "Q10a. D’une manière générale, quelles sont vos sources d’information ? /Amis", 
  "Q10a. D’une manière générale, quelles sont vos sources d’information ? /Membres de la famille", 
  "Q10a. D’une manière générale, quelles sont vos sources d’information ? /Site d'actualités", 
  "Q10a. D’une manière générale, quelles sont vos sources d’information ? /Journal", 
  "Q10a. D’une manière générale, quelles sont vos sources d’information ? /Médias sociaux", 
  "Q10a. D’une manière générale, quelles sont vos sources d’information ? /Radio", 
  "Q10a. D’une manière générale, quelles sont vos sources d’information ? /Télévision", 
  "Q10a. D’une manière générale, quelles sont vos sources d’information ? /Centre d'information communautaire", 
  "Q10a. D’une manière générale, quelles sont vos sources d’information ? /Autres (veuillez préciser)", 
  "Q10a. D’une manière générale, quelles sont vos sources d’information ? /Ne sait pas", 
  "Q10g. Comment déterminez-vous si les informations que vous lisez ou entendez sont correctes et dignes de confiance ?/Je suppose que ce que je lis/entends doit être vrai parce que c'est public.", 
  "Q10g. Comment déterminez-vous si les informations que vous lisez ou entendez sont correctes et dignes de confiance ?/Tout ce qui se trouve sur Internet est exact.", 
  "Q10g. Comment déterminez-vous si les informations que vous lisez ou entendez sont correctes et dignes de confiance ?/Je regarde la source pour voir si elle est fiable.", 
  "Q10g. Comment déterminez-vous si les informations que vous lisez ou entendez sont correctes et dignes de confiance ?/Je demande à quelqu'un à qui j'ai confiance s'il pense que la nouvelle est vraie ou fausse.", 
  "Q10g. Comment déterminez-vous si les informations que vous lisez ou entendez sont correctes et dignes de confiance ?/Je suis sceptique à propos de tout ce qui se trouve sur internet.", 
  "Q10g. Comment déterminez-vous si les informations que vous lisez ou entendez sont correctes et dignes de confiance ?/La plupart des informations sont discutables.", 
  "Q10g. Comment déterminez-vous si les informations que vous lisez ou entendez sont correctes et dignes de confiance ?/Autres (Veuillez préciser)", 
  "Q10g. Comment déterminez-vous si les informations que vous lisez ou entendez sont correctes et dignes de confiance ?/Ne sait pas", 
  "Q10g. Comment déterminez-vous si les informations que vous lisez ou entendez sont correctes et dignes de confiance ?/Préfère ne pas répondre", 
  "Q19c. Quelle a été la principale raison pour laquelle vous avez choisi cette option pour résoudre le conflit ?/Je n’ai pas pu le résoudre moi-même.", 
  "Q19c. Quelle a été la principale raison pour laquelle vous avez choisi cette option pour résoudre le conflit ?/J’ai fait confiance aux autorités pour gérer le litige.", 
  "Q19c. Quelle a été la principale raison pour laquelle vous avez choisi cette option pour résoudre le conflit ?/Je pensais que le problème était trop grave pour être traité de manière informelle.", 
  "Q19c. Quelle a été la principale raison pour laquelle vous avez choisi cette option pour résoudre le conflit ?/Je voulais une résolution juridiquement contraignante.", 
  "Q19c. Quelle a été la principale raison pour laquelle vous avez choisi cette option pour résoudre le conflit ?/Il était nécessaire de suivre une procédure formelle.", 
  "Q19c. Quelle a été la principale raison pour laquelle vous avez choisi cette option pour résoudre le conflit ?/Je pensais que le problème n'était pas assez important pour une action formelle.", 
  "Q19c. Quelle a été la principale raison pour laquelle vous avez choisi cette option pour résoudre le conflit ?/J'étais convaincu que je pouvais facilement le résoudre moi-même.", 
  "Q19c. Quelle a été la principale raison pour laquelle vous avez choisi cette option pour résoudre le conflit ?/Je ne faisais pas confiance aux autorités formelles.", 
  "Q19c. Quelle a été la principale raison pour laquelle vous avez choisi cette option pour résoudre le conflit ?/C’était plus pratique ou moins coûteux.", 
  "Q19c. Quelle a été la principale raison pour laquelle vous avez choisi cette option pour résoudre le conflit ?/Certains aspects du litige nécessitaient une résolution formelle, d'autres non.", 
  "Q19c. Quelle a été la principale raison pour laquelle vous avez choisi cette option pour résoudre le conflit ?/Je voulais d'abord essayer de le résoudre de manière informelle avant de passer au formel.", 
  "Q19c. Quelle a été la principale raison pour laquelle vous avez choisi cette option pour résoudre le conflit ?/La situation est passée de l'informel au formel.", 
  "Q19c. Quelle a été la principale raison pour laquelle vous avez choisi cette option pour résoudre le conflit ?/Je n'étais pas sûr de la meilleure approche, alors j'ai utilisé les deux.", 
  "Q19c. Quelle a été la principale raison pour laquelle vous avez choisi cette option pour résoudre le conflit ?/Ne sait pas", 
  "Q19c. Quelle a été la principale raison pour laquelle vous avez choisi cette option pour résoudre le conflit ?/Préfère ne pas répondre", 
   "Q19d. Quelle institution a pris la décision finale ?/Aucune décision n'a été prise : le différend a été abandonné, ou a été résolu autrement", 
  "Q19d. Quelle institution a pris la décision finale ?/Aucune décision n'a été prise, car l'affaire est toujours en cours", 
  "Q19d. Quelle institution a pris la décision finale ?/Cour ou tribunal (avocat, parajuriste)", 
  "Q19d. Quelle institution a pris la décision finale ?/Police (ou autres forces de l'ordre)", 
  "Q19d. Quelle institution a pris la décision finale ?/Un bureau gouvernemental ou municipal ou une autre autorité ou organisme officiellement désigné.", 
  "Q19d. Quelle institution a pris la décision finale ?/Chef ou autorité religieuse", 
  "Q19d. Quelle institution a pris la décision finale ?/Leader ou autorité communautaire (comme l’ainé du village ou un dirigeant local)", 
  "Q19d. Quelle institution a pris la décision finale ?/Autres plaintes officielles ou processus d'appel", 
  "Q19d. Quelle institution a pris la décision finale ?/Autre aide externe, telle que la médiation, la conciliation, l'arbitrage", 
  "Q19d. Quelle institution a pris la décision finale ?/Autre personne ou organisation", 
  "Q19d. Quelle institution a pris la décision finale ?/Je n'ai consulté personne pour résoudre le problème", 
  "Q19d. Quelle institution a pris la décision finale ?/Ne sait pas", 
  "Q19d. Quelle institution a pris la décision finale ?/Préfère ne pas répondre", 
  "Q20a. Dans votre communauté, quels sont les principaux acteurs ou institutions chargés de juger les personnes responsables de crimes ou d'actes répréhensibles ? /Système judiciaire de l'État", 
  "Q20a. Dans votre communauté, quels sont les principaux acteurs ou institutions chargés de juger les personnes responsables de crimes ou d'actes répréhensibles ? /Système de justice coutumier", 
  "Q20a. Dans votre communauté, quels sont les principaux acteurs ou institutions chargés de juger les personnes responsables de crimes ou d'actes répréhensibles ? /Système de justice religieux", 
  "Q20a. Dans votre communauté, quels sont les principaux acteurs ou institutions chargés de juger les personnes responsables de crimes ou d'actes répréhensibles ? /Autre (veuillez préciser)", 
  "Q20a. Dans votre communauté, quels sont les principaux acteurs ou institutions chargés de juger les personnes responsables de crimes ou d'actes répréhensibles ? /Personne", 
  "Q20a. Dans votre communauté, quels sont les principaux acteurs ou institutions chargés de juger les personnes responsables de crimes ou d'actes répréhensibles ? /Ne sait pas", 
  "Q20a. Dans votre communauté, quels sont les principaux acteurs ou institutions chargés de juger les personnes responsables de crimes ou d'actes répréhensibles ? /Préfère ne pas répondre",
  "Q21a. Quelles sont les principales forces de sécurité responsable de la sécurité des personnes et des biens dans votre communauté ?/Police", 
  "Q21a. Quelles sont les principales forces de sécurité responsable de la sécurité des personnes et des biens dans votre communauté ?/Armée", 
  "Q21a. Quelles sont les principales forces de sécurité responsable de la sécurité des personnes et des biens dans votre communauté ?/Agent des services frontaliers ou de l'immigration", 
  "Q21a. Quelles sont les principales forces de sécurité responsable de la sécurité des personnes et des biens dans votre communauté ?/Gendarmerie", 
  "Q21a. Quelles sont les principales forces de sécurité responsable de la sécurité des personnes et des biens dans votre communauté ?/Groupes communautaires d'autodéfense", 
  "Q21a. Quelles sont les principales forces de sécurité responsable de la sécurité des personnes et des biens dans votre communauté ?/Groupes armés", 
  "Q21a. Quelles sont les principales forces de sécurité responsable de la sécurité des personnes et des biens dans votre communauté ?/Autres (veuillez préciser)", 
  "Q21a. Quelles sont les principales forces de sécurité responsable de la sécurité des personnes et des biens dans votre communauté ?/Ne sait pas", 
  "Q21a. Quelles sont les principales forces de sécurité responsable de la sécurité des personnes et des biens dans votre communauté ?/Préfère ne pas répondre", 
  "25a. Au cours des 12 derniers mois, avez-vous été en contact avec les acteurs suivants ?/Fonctionnaires municipaux ou provinciaux/départementaux", 
  "25a. Au cours des 12 derniers mois, avez-vous été en contact avec les acteurs suivants ?/Représentants élus des communautés locales aux niveaux provincial, communal, cantonal, etc.", 
  "25a. Au cours des 12 derniers mois, avez-vous été en contact avec les acteurs suivants ?/Représentants élus du gouvernement national ou fédéral", 
  "25a. Au cours des 12 derniers mois, avez-vous été en contact avec les acteurs suivants ?/Agents de la sécurité sociale ou   des services sociaux", 
  "25a. Au cours des 12 derniers mois, avez-vous été en contact avec les acteurs suivants ?/Enseignants, professeurs dans les écoles publiques ou les universités", 
  "25a. Au cours des 12 derniers mois, avez-vous été en contact avec les acteurs suivants ?/Médecins, infirmières ou autres responsables de la santé d'une clinique ou d'un hôpital public (Agents de sante)", 
  "25a. Au cours des 12 derniers mois, avez-vous été en contact avec les acteurs suivants ?/Agents de police", 
  "25a. Au cours des 12 derniers mois, avez-vous été en contact avec les acteurs suivants ?/Procureurs, juges ou magistrats", 
  "25a. Au cours des 12 derniers mois, avez-vous été en contact avec les acteurs suivants ?/Agents des impôts ou du trésor", 
  "25a. Au cours des 12 derniers mois, avez-vous été en contact avec les acteurs suivants ?/Douaniers", 
  "25a. Au cours des 12 derniers mois, avez-vous été en contact avec les acteurs suivants ?/Agents ou inspecteurs des services publics (électricité, eau, assainissement, etc.)", 
  "25a. Au cours des 12 derniers mois, avez-vous été en contact avec les acteurs suivants ?/Fonctionnaires du service des passeports", 
  "25a. Au cours des 12 derniers mois, avez-vous été en contact avec les acteurs suivants ?/Personnel du service d'immatriculation des véhicules ou de délivrance des permis de conduire (Les services du transport)", 
  "25a. Au cours des 12 derniers mois, avez-vous été en contact avec les acteurs suivants ?/Les agents des forces armées", 
  "25a. Au cours des 12 derniers mois, avez-vous été en contact avec les acteurs suivants ?/Agents des services du domaine et du foncier", 
  "25a. Au cours des 12 derniers mois, avez-vous été en contact avec les acteurs suivants ?/Autres", 
  "25a. Au cours des 12 derniers mois, avez-vous été en contact avec les acteurs suivants ?/Aucune de ces réponses", 
  "25a. Au cours des 12 derniers mois, avez-vous été en contact avec les acteurs suivants ?/Préfère ne pas répondre", 
  "Q27a. De quels groupes armés avez-vous entendu parler au cours des trois derniers mois ?/Boko Haram", 
  "Q27a. De quels groupes armés avez-vous entendu parler au cours des trois derniers mois ?/Mouvement pour le Salut de l'Azawad", 
  "Q27a. De quels groupes armés avez-vous entendu parler au cours des trois derniers mois ?/Jama'at Nasr al-Islam wal Muslimin", 
  "Q27a. De quels groupes armés avez-vous entendu parler au cours des trois derniers mois ?/Al-Qaïda au Maghreb islamique", 
  "Q27a. De quels groupes armés avez-vous entendu parler au cours des trois derniers mois ?/Ansar al-Dine", 
  "Q27a. De quels groupes armés avez-vous entendu parler au cours des trois derniers mois ?/Katiba Macina", 
  "Q27a. De quels groupes armés avez-vous entendu parler au cours des trois derniers mois ?/Autres (Veuillez préciser)", 
  "Q27a. De quels groupes armés avez-vous entendu parler au cours des trois derniers mois ?/Ne connais aucun groupe", 
  "Q27a. De quels groupes armés avez-vous entendu parler au cours des trois derniers mois ?/Préfère ne pas répondre...319", 
  "Q27a. De quels groupes armés avez-vous entendu parler au cours des trois derniers mois ?/Préfère ne pas répondre...320")

spcps_data2 <- spcps_data1 %>% select(-all_of(columns_to_remove2))

spcps_data2 <- spcps_data2 %>%rename("ID_enqeteur"="ID de l'enquêteur", 
       "debut_entr"="Heure de début de l'entretien",
       "fin_entr"="Heure de fin de l'entretien",
       "ZD"="Grappe (ZD)",
       "DM3_Autres"="Autres (Veuillez préciser)...29", 
       "DM4_Autres"="Autres (Veuillez préciser)...31", 
       "DM5_Autres"="Autres (Veuillez préciser)...33",
       "Q5c_Autres"="Autres (Veuillez préciser)...62",
       "Q7d_Autres"="Autres (Veuillez préciser)...83",
       "Q8c_Autres"="Autres (Veuillez préciser)...94",
       "Q8f_Autres"="Autres (veuillez préciser)...107", 
       "Q10a_Autres"="Autres (veuillez préciser)...124",
       "Q10g_Autres"="Autres (Veuillez préciser)...140",
       "Q19d_Autre"="Autre personne ou organisation", 
       "Q21a_Autres"="Autres (veuillez préciser)...254", 
       "Q27a_Autres"="Autres (Veuillez préciser)...321" )


# 2. Séparer les identifiants des libellés et stocker les libellés
libelles <- list()  # Créer une liste pour stocker les libellés

# Parcourir les colonnes pour séparer les identifiants des libellés
for (col in colnames(spcps_data2)) {
  
  # Séparer l'identifiant et le libellé au niveau du point
  split_name <- strsplit(col, " ", fixed = TRUE)[[1]]
  
  # Si le nom contient un point (i.e. deux éléments après split)
  if (length(split_name) > 1) {
    # L'identifiant est le premier élément
    identifiant <- split_name[1]
    
    # Le libellé est le second élément
    libelle <- paste(split_name[-1], collapse = " ")
    
    # Stocker le libellé dans la liste en utilisant l'identifiant comme clé
    libelles[[identifiant]] <- libelle
    
    # Renommer la colonne en utilisant l'identifiant uniquement
    colnames(spcps_data2)[colnames(spcps_data2) == col] <- identifiant
  }
}


# 4. Enregistrer les libellés dans un fichier CSV pour une utilisation ultérieure
libelles_df <- data.frame(identifiant = names(libelles), libelle = unlist(libelles), stringsAsFactors = FALSE)
write.csv(libelles_df, "data/libelles_variables.csv", row.names = FALSE)

# 5. Optionnel: Enregistrer les données nettoyées dans un fichier CSV
write.csv(spcps_data2, "data/SPCPS_Analyse_Men_Togo_cleaned_recoded.csv", row.names = FALSE)

#dput(names(spcps_data2))

# Liste des colonnes à choix multiple (à adapter selon vos données)
multiple_choice_columns <- c("Q7d.", "Q8c.","Q10a.","Q10g.","Q19c.","Q19d.","Q20a.","Q21a.","25a.","Q27a.")  # Remplacer par les noms de colonnes réelles

# Définir une liste d'options possibles pour chaque colonne (ou utiliser la même liste pour toutes les colonnes)
options_possibles <- list(
  "Q7d."= c("Litiges fonciers (Problème lié à la terre)", 
  "Ressources communes partagées (eau, espace public, pâturage, etc.)", 
  "Divisions ethniques", 
  "Divisions religieuses", 
  "Facteurs économiques (pauvreté, chômage, etc.)", 
  "Insécurité (présence de groupes d'autodéfense, usage excessif de la force par les forces de sécurité, présence de groupes armés)", 
  "Violences sexuelles et sexistes", 
  "Conflits politiques", 
  "Insécurité alimentaire", 
  "Conflit lié au pouvoir local/chefferie traditionnelle", 
  "Autres (Veuillez préciser)", 
  "Ne sait pas", 
  "Préfère ne pas répondre"), 
  "Q8c."=c("Leadership", 
  "Coordination", 
  "Soutien/Rôles sexospécifiques (Soutien différencier selon le sexe)", 
  "Autres (Veuillez préciser)", 
  "Ne sait pas", 
  "Préfère ne pas répondre"), 
  "Q8f."=c("Structure sociétale (dominance masculine, dynamique du pouvoir)", 
  "Culture/Tradition", 
  "Religion", 
  "Situation économique", 
  "Éducation", 
  "Charge domestique", 
  "Autres (veuillez préciser)", 
  "Ne sait pas", 
  "Préfère ne pas répondre"),
  "Q10a."=c("Leader communautaire", 
  "Chef religieux", 
  "Membres du gouvernement", 
  "Amis", 
  "Membres de la famille", 
  "Site d'actualités", 
  "Journal", 
  "Médias sociaux", 
  "Radio", 
  "Télévision", 
  "Centre d'information communautaire", 
  "Autres (veuillez préciser)", 
  "Ne sait pas"), 
  "Q10g."=c("Je suppose que ce que je lis/entends doit être vrai parce que c'est public.", 
  "Tout ce qui se trouve sur Internet est exact.", 
  "Je regarde la source pour voir si elle est fiable.", 
  "Je demande à quelqu'un à qui j'ai confiance s'il pense que la nouvelle est vraie ou fausse.", 
  "Je suis sceptique à propos de tout ce qui se trouve sur internet.", 
  "La plupart des informations sont discutables.", 
  "Autres (Veuillez préciser)", 
  "Ne sait pas", 
  "Préfère ne pas répondre"), 
  "Q19c."=c("Je n’ai pas pu le résoudre moi-même.", 
  "J’ai fait confiance aux autorités pour gérer le litige.", 
  "Je pensais que le problème était trop grave pour être traité de manière informelle.", 
  "Je voulais une résolution juridiquement contraignante.", 
  "Il était nécessaire de suivre une procédure formelle.", 
  "Je pensais que le problème n'était pas assez important pour une action formelle.", 
  "J'étais convaincu que je pouvais facilement le résoudre moi-même.", 
  "Je ne faisais pas confiance aux autorités formelles.", 
  "C’était plus pratique ou moins coûteux.", 
  "Certains aspects du litige nécessitaient une résolution formelle, d'autres non.", 
  "Je voulais d'abord essayer de le résoudre de manière informelle avant de passer au formel.", 
  "La situation est passée de l'informel au formel.", 
  "Je n'étais pas sûr de la meilleure approche, alors j'ai utilisé les deux.", 
  "Ne sait pas", 
  "Préfère ne pas répondre"), 
  "Q19d."=c("Aucune décision n'a été prise : le différend a été abandonné, ou a été résolu autrement", 
  "Aucune décision n'a été prise, car l'affaire est toujours en cours", 
  "Cour ou tribunal (avocat, parajuriste)", 
  "Police (ou autres forces de l'ordre)", 
  "Un bureau gouvernemental ou municipal ou une autre autorité ou organisme officiellement désigné.", 
  "Chef ou autorité religieuse", 
  "Leader ou autorité communautaire (comme l’ainé du village ou un dirigeant local)", 
  "Autres plaintes officielles ou processus d'appel", 
  "Autre aide externe, telle que la médiation, la conciliation, l'arbitrage", 
  "Autre personne ou organisation", 
  "Je n'ai consulté personne pour résoudre le problème", 
  "Ne sait pas", 
  "Préfère ne pas répondre"), 
  "Q20a."=c("Système judiciaire de l'État", 
  "Système de justice coutumier", 
  "Système de justice religieux", 
  "Autre (veuillez préciser)", 
  "Personne", 
  "Ne sait pas", 
  "Préfère ne pas répondre"),
  "Q21a."=c("Police", 
  "Armée", 
  "Agent des services frontaliers ou de l'immigration", 
  "Gendarmerie", 
  "Groupes communautaires d'autodéfense", 
  "Groupes armés", 
  "Autres (veuillez préciser)", 
  "Ne sait pas", 
  "Préfère ne pas répondre"), 
  "25a."=c("Fonctionnaires municipaux ou provinciaux/départementaux", 
  "Représentants élus des communautés locales aux niveaux provincial, communal, cantonal, etc.", 
  "Représentants élus du gouvernement national ou fédéral", 
  "Agents de la sécurité sociale ou   des services sociaux", 
  "Enseignants, professeurs dans les écoles publiques ou les universités", 
  "Médecins, infirmières ou autres responsables de la santé d'une clinique ou d'un hôpital public (Agents de sante)", 
  "Agents de police", 
  "Procureurs, juges ou magistrats", 
  "Agents des impôts ou du trésor", 
  "Douaniers", 
  "Agents ou inspecteurs des services publics (électricité, eau, assainissement, etc.)", 
  "Fonctionnaires du service des passeports", 
  "Personnel du service d'immatriculation des véhicules ou de délivrance des permis de conduire (Les services du transport)", 
  "Les agents des forces armées", 
  "Agents des services du domaine et du foncier", 
  "Autres", 
  "Aucune de ces réponses", 
  "Préfère ne pas répondre"), 
  "Q27a."=c("Boko Haram", 
  "Mouvement pour le Salut de l'Azawad", 
  "Jama'at Nasr al-Islam wal Muslimin", 
  "Al-Qaïda au Maghreb islamique", 
  "Ansar al-Dine", 
  "Katiba Macina", 
  "Autres (Veuillez préciser)", 
  "Ne connais aucun groupe", 
  "Préfère ne pas répondre...319", 
  "Préfère ne pas répondre...320")
)

# Fonction pour traiter chaque variable à choix multiple
process_multiple_choice_column <- function(data, column, options_list) {
  data_long <- data %>%
    rowwise() %>%
    mutate(option_detected = list(str_extract_all({{ column }}, paste(options_list, collapse = "|"))[[1]])) %>%
    unnest(option_detected)
  
  return(data_long)
}

# Appliquer cette fonction à chaque colonne à choix multiple et combiner les résultats
all_choices <- list()
for (col in multiple_choice_columns) {
  temp_data <- process_multiple_choice_column(spcps_data2, !!sym(col), options_possibles[[col]])
  temp_data <- temp_data %>% mutate(variable = col)  # Ajouter une colonne pour identifier la variable
  all_choices[[col]] <- temp_data
}

# Combiner tous les résultats dans un tableau unique
combined_data <- bind_rows(all_choices)

#########################################################
#Option A variable à choix multiple
##################################

# Fonction pour générer un bar plot et un tableau pour chaque variable à choix multiple
plot_and_table_multiple_choice <- function(data, variable) {
  
  # Filtrer les données pour la variable spécifiée
  data_filtered <- data %>% filter(variable == !!variable)
  
  # Calculer la fréquence des options pour cette variable
  freq_table <- data_filtered %>%
    group_by(option_detected) %>%
    summarise(Frequence = n()) %>%
    arrange(desc(Frequence))
  
  # Créer un graphique de fréquence (bar plot)
  p <- ggplot(freq_table, aes(x = reorder(option_detected, Frequence), y = Frequence, fill = option_detected)) +
    geom_bar(stat = "identity", color = "black") +
    coord_flip() +
    theme_minimal() +
    theme(legend.position = "none") +
    labs(title = paste("Distribution de", variable), x = "Option", y = "Fréquence")
  
  # Afficher le graphique et le tableau côte à côte
  gridExtra::grid.arrange(
    p,
    tableGrob(freq_table),
    ncol = 1
  )
}

# Appliquer cette fonction à chaque variable à choix multiple
for (col in multiple_choice_columns) {
  cat(paste("\n### Visualisation pour la variable:", col, "\n\n"))
  plot_and_table_multiple_choice(combined_data, col)
}


#########################################################
#Option B variable à choix multiple
##################################

# Fonction pour générer un bar plot et un tableau pour chaque variable à choix multiple
plot_and_table_multiple_choice <- function(data, variable) {
  
  # Filtrer les données pour la variable spécifiée et retirer les NA
  data_filtered <- data %>% filter(variable == !!variable & !is.na(option_detected))
  
  # Calculer la fréquence et les pourcentages des options pour cette variable
  total_count <- nrow(data_filtered)
  freq_table <- data_filtered %>%
    group_by(option_detected) %>%
    summarise(Frequence = n()) %>%
    arrange(desc(Frequence)) %>%
    mutate(Pourcentage = round((Frequence / total_count) * 100, 2))  # Calcul du pourcentage
  
  # Créer un graphique de fréquence (bar plot) avec pourcentage sur les barres
  p <- ggplot(freq_table, aes(x = reorder(option_detected, Frequence), y = Frequence, fill = option_detected)) +
    geom_bar(stat = "identity", color = "black") +
    geom_text(aes(label = paste0(Pourcentage, "%")), hjust = -0.3, size = 3.5) +  # Ajout du pourcentage
    coord_flip() +
    theme_minimal() +
    theme(legend.position = "none") +
    labs(title = paste("Distribution de", variable), x = "Option", y = "Fréquence") +
    ylim(0, max(freq_table$Frequence) * 1.2)  # Ajouter un peu d'espace pour afficher les labels
  
  # Créer un tableau de fréquence avec une colonne pourcentage
  table_with_percent <- freq_table %>%
    select(Option = option_detected, Frequence, Pourcentage)
  
  # Afficher le graphique et le tableau côte à côte
  gridExtra::grid.arrange(
    p,
    tableGrob(table_with_percent),
    ncol = 1
  )
}

# Appliquer cette fonction à chaque variable à choix multiple
for (col in multiple_choice_columns) {
  cat(paste("\n### Visualisation pour la variable:", col, "\n\n"))
  plot_and_table_multiple_choice(combined_data, col)
}


#########################################################
#Option A variable catégorielle
##################################




# Fonction pour générer un bar plot et un tableau pour une variable catégorielle
plot_and_table_categorical <- function(data, variable) {
  
  # Filtrer les données pour la variable spécifiée et retirer les NA
  data_filtered <- data %>% filter(!is.na({{ variable }}))
  
  # Calculer la fréquence et les pourcentages des catégories pour cette variable
  total_count <- nrow(data_filtered)
  freq_table <- data_filtered %>%
    group_by({{ variable }}) %>%
    summarise(Frequence = n()) %>%
    arrange(desc(Frequence)) %>%
    mutate(Pourcentage = round((Frequence / total_count) * 100, 2))  # Calcul du pourcentage
  
  # Créer un graphique de fréquence (bar plot) avec pourcentage sur les barres
  p <- ggplot(freq_table, aes(x = reorder({{ variable }}, Frequence), y = Frequence, fill = {{ variable }})) +
    geom_bar(stat = "identity", color = "black") +
    geom_text(aes(label = paste0(Pourcentage, "%")), hjust = -0.3, size = 3.5) +  # Ajout du pourcentage
    coord_flip() +
    theme_minimal() +
    theme(legend.position = "none") +
    labs(title = paste("Distribution de", deparse(substitute(variable))), x = "Catégorie", y = "Fréquence") +
    ylim(0, max(freq_table$Frequence) * 1.2)  # Ajouter un peu d'espace pour afficher les labels
  
  # Créer un tableau de fréquence avec une colonne pourcentage
  table_with_percent <- freq_table %>%
    select(Catégorie = {{ variable }}, Frequence, Pourcentage)
  
  # Afficher le graphique et le tableau côte à côte
  gridExtra::grid.arrange(
    p,
    tableGrob(table_with_percent),
    ncol = 2
  )
}

# Identifier les variables catégorielles qui ne sont pas à choix multiple
# Supposons que toutes les variables autres que celles à choix multiple sont catégorielles
categorical_columns <- setdiff(names(data), multiple_choice_columns)

# Appliquer cette fonction à chaque variable catégorielle
for (col in categorical_columns) {
  cat(paste("\n### Visualisation pour la variable catégorielle :", col, "\n\n"))
  plot_and_table_categorical(data, !!sym(col))
}









































