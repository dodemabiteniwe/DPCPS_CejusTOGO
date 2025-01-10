
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
spcpsT_data <- read_excel("data2/SPCPS_Open-end.xlsx")
str(spcpsT_data)






# 2. Séparer les identifiants des libellés et stocker les libellés
libelles <- list()  # Créer une liste pour stocker les libellés

# Parcourir les colonnes pour séparer les identifiants des libellés
for (col in colnames(spcpsT_data)) {
  
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
    colnames(spcpsT_data)[colnames(spcpsT_data) == col] <- identifiant
  }
}


# 4. Enregistrer les libellés dans un fichier CSV pour une utilisation ultérieure
libelles_df <- data.frame(identifiant = names(libelles), libelle = unlist(libelles), stringsAsFactors = FALSE)
write.csv(libelles_df, "data2/libelles_variables.csv", row.names = FALSE)

# 5. Optionnel: Enregistrer les données nettoyées dans un fichier CSV
write.csv(spcpsT_data, "data2/SPCPS_Analyse_Men_Togo_cleaned_recoded.csv", row.names = FALSE)

save(spcpsT_data, file = "rdas/spcps.rda")

dput(names(spcpsT_data))
library(gtsummary)
spcpsT_data%>%tbl_cross(row = DM1., col = DM2., percent = "row")
xd<-spcpsT_data%>%tbl_cross(row = DM1., col = DM2., percent = "row")
str(xd)




crostab1<-spcpsT_data%>%tbl_cross(row = DM1., col = DM2., percent = "row")
kable(
  crostab1, booktabs = TRUE, caption = "Algorithms performance.")





