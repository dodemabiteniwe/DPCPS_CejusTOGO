# Load the necessary library and dataset
# Function to install and load a single package
install_and_load <- function(package) {
  if (!require(package,character.only = TRUE)) {
    install.packages(package, dependencies = TRUE)
    library(package,character.only = TRUE)
  }
}

# List of required packages
required_packages <- c("janitor","kableExtra","data.table", "tidyverse", "lubridate","ggplot2","readxl","corrplot","scales" ,"knitr","bookdown")

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
x <- colnames(spcps_data1)
print(x)

str(spcps_data)
dim(spcps_data)


# 1. Suppression des colonnes inutiles (métadonnées)
dput(names(spcps_data1))
columns_to_remove <- c("_uuid", "_submission_time", "_status", "_submitted_by", "__version__",
                       "_index","start-geopoint","_start-geopoint_latitude","_start-geopoint_longitude",
                       "_start-geopoint_precision","today","deviceid","audit","audit_URL",
                       "DM1_start","DM5_end","DM1_start_t","DM5_end_t","start_section_d","end_section_d","start_section_d_t",
                       "end_section_d_t","start_objective_1", "end_objective1", "start_objective_1_t", "end_objective_1_t",
                       "start_objective2", "end_objective2", "start_objective2_t", "end_objective2_t",
                       "start_objective3", "end_objective3", "start_objective3_t", "end_objective3_t",
                       "start_Q1a", "end_Q1c", "start_t", "end_t","start_questiont", "end_questiont", "start_questiont_t", "end_questiont_t")


spcps_data1 <- spcps_data1 %>% select(-all_of(columns_to_remove))


dput(names(spcps_data1))
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

# 2. Séparer les identifiants des libellés et stocker les libellés
libelles <- list()  # Créer une liste pour stocker les libellés

# Parcourir les colonnes pour séparer les identifiants des libellés
for (col in colnames(spcps_data2)) {
  
  # Séparer l'identifiant et le libellé au niveau du point
  split_name <- strsplit(col, "\\.", fixed = TRUE)[[1]]
  
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

# 3. Renommer les colonnes "Autres (Veuillez préciser)" en ajoutant un suffixe basé sur la question précédente
for (col in colnames(spcps_data2)) {
  
  # Vérifier si le nom de colonne contient "Autres (Veuillez préciser)"
  if (grepl("Autres \\(Veuillez préciser\\)", col)) {
    
    # Identifier la question précédente (celle avant "Autres...")
    # On suppose que la question précédente est celle avec un index juste avant
    col_index <- which(colnames(spcps_data2) == col)
    
    if (col_index > 1) {  # Assurez-vous que ce n'est pas la première colonne
      previous_question_id <- colnames(spcps_data2)[col_index - 1]
      
      # Renommer la colonne en ajoutant "_autre" à l'identifiant de la question précédente
      new_col_name <- paste0(previous_question_id, "_autre")
      colnames(spcps_data2)[col_index] <- new_col_name
    }
  }
}


d <- dput(names(spcps_data2))
d[25]

strsplit(d[10], " ", fixed = TRUE)[[1]]
grepl("Autres \\(Veuillez préciser\\)", d[10])





# 4. Enregistrer les libellés dans un fichier CSV pour une utilisation ultérieure
libelles_df <- data.frame(identifiant = names(libelles), libelle = unlist(libelles), stringsAsFactors = FALSE)
write.csv(libelles_df, "libelles_variables.csv", row.names = FALSE)

# 5. Optionnel: Enregistrer les données nettoyées dans un fichier CSV
write.csv(data, "SPCPS_Analyse_Men_Togo_cleaned_recoded.csv", row.names = FALSE)

# Vérifier les nouveaux noms de colonnes et les libellés
head(colnames(data))
head(libelles_df)






# Step 2: Data Cleaning

nyc_data <- nyc_data %>%select(-c(`BUILDING CLASS AT PRESENT`, `ZIP CODE`, ADDRESS, 
                                  `APARTMENT NUMBER`,`SALE DATE`, V1, `EASE-MENT`))











nyc_data <- nyc_data %>%
  mutate(`RESIDENTIAL UNITS` = as.numeric(gsub(",|-", "", `RESIDENTIAL UNITS`)),
         `COMMERCIAL UNITS` = as.numeric(gsub(",|-", "", `COMMERCIAL UNITS`)),
         `TOTAL UNITS` = as.numeric(gsub(",|-", "", `TOTAL UNITS`)),
         `LAND SQUARE FEET` = as.numeric(gsub(",|-", "", `LAND SQUARE FEET`)),
         `GROSS SQUARE FEET` = as.numeric(gsub(",|-", "", `GROSS SQUARE FEET`)),
         `SALE PRICE` = as.numeric(gsub(",|-", "", `SALE PRICE`)),
         BLOCK = as.numeric(gsub(",|-", "", BLOCK)),
         `YEAR BUILT` = as.numeric(gsub(",|-", "", `YEAR BUILT`)),
         LOT = as.numeric(gsub(",|-", "", LOT)),
         `SALE DATE` = as.Date(`SALE DATE`, format = "%m/%d/%Y"),
         sale_year = year(`SALE DATE`),
         sale_month = month(`SALE DATE`, label = TRUE),
         building_age = year(`SALE DATE`) - `YEAR BUILT`,
         BOROUGH = as.factor(c('1' = 'Manhattan', '2' = 'Bronx', '3' = 'Brooklyn', 
                               '4' = 'Queens', '5' = 'Staten Island')[BOROUGH]),
         across(c("BOROUGH", "NEIGHBORHOOD", "BUILDING CLASS CATEGORY", 
                  "TAX CLASS AT PRESENT", "BUILDING CLASS AT TIME OF SALE", 
                  "TAX CLASS AT TIME OF SALE"), as.factor)) %>%
  select(-c(`BUILDING CLASS AT PRESENT`, `ZIP CODE`, ADDRESS, `APARTMENT NUMBER`,`SALE DATE`, V1, `EASE-MENT`))

# Default correlations before any cleaning
corr_default2 <- nyc_data %>%
  select(where(is.numeric)) %>%  
  cor(use = "complete.obs")


nyc_data2<- nyc_data%>%
  select(c(`BOROUGH`, `BUILDING CLASS CATEGORY`,`BLOCK`, LOT, `TOTAL UNITS`,`LAND SQUARE FEET`, `GROSS SQUARE FEET`, `SALE PRICE`, building_age))
kable(
  head(nyc_data2,10), booktabs = TRUE, caption = "first lines of some relevant columns of data")%>%
  kable_styling(latex_options = c("HOLD_position","scale_down"))



#-------------------------------------------Handle  missing values------------------------
# Remove rows where sale price is missing or zero
nyc_data <- nyc_data %>%
  filter(`SALE PRICE` >100)%>%
  mutate(building_age = ifelse(building_age < 0 | is.na(building_age), NA, building_age))

# Replace empty values with NA
nyc_data2 <- nyc_data%>%
  mutate(across(where(is.factor), as.character)) %>%
  mutate(across(where(is.character), ~na_if(.x, "")))

# Calculate the missing value rate for each column
na_rate2 <- nyc_data2 %>%
  summarise(across(everything(), ~mean(is.na(.)) * 100))%>%t()
colnames(na_rate2) <- "NA_Percentage"
na_rate2 <- as.data.frame(na_rate2)
kable(na_rate2, booktabs = TRUE, caption = "Percentage of missing values by variable.")%>%
  kable_styling(latex_options = c("HOLD_position","scale_down"))

# Drop rows with any missing values (NA) and Remove duplicate rows
nyc_data <- nyc_data %>%
  drop_na() %>%
  distinct() %>%
  filter(`COMMERCIAL UNITS` + `RESIDENTIAL UNITS` == `TOTAL UNITS`) %>%
  filter(`TOTAL UNITS` != 0 &`YEAR BUILT` != 0 & `LAND SQUARE FEET` != 0 & `GROSS SQUARE FEET` != 0)
