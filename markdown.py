from fpdf import FPDF

# Le script à pour but d'exporter les pages wiki en markdown en PDF

# Contenu Markdown exemple
markdown_content = """
# Introduction

L’objectif de ce livrable est de rassembler dans un support structuré l’ensemble des processus cibles de l’entrepôt ainsi que la description détaillée de leurs modalités de traitement dans **Speed WMS** et **ExpedManager**.  
Ce document offre une vision synthétique de l’organisation réfléchie pour l’entrepôt, mettant en lumière les nouveaux modes organisationnels et opérationnels en résultant.

Il constitue également le **cahier des charges contractuel** de la phase de mise en œuvre, remplaçant tout document antérieur à sa conception. Ce livrable engage toutes les parties sur la solution finale livrée par **IT-LOG-ONE**.

# Glossaire
| Terme            | Définition                                                                 |
|------------------|----------------------------------------------------------------------------|
| IC               | **Information Complémentaire** : Champs non standard de Speed, créés selon les besoins spécifiques |
| SPD              | **Développement spécifique**                                               |
| Vague (Speed)    | Groupe de commandes lancées simultanément                                  |
| Mission (Speed)  | Ensemble de lignes de préparation                                          |
| Ramasse (Speed)  | Ensemble de missions                                                       |
| Filière          | Méthode de préparation des commandes basée sur leur typologie              |

# Données de base

## 1. Activité 

Les activités prises en charge sont :
- **ITMV**
- **VERP**

## 2. Articles

### 2.1. Structure de la fiche article

- Code Article  
- Désignation longue  
- Identifiant unitaire (EAN)  
- Poids unitaire  
- Photo (URL)  
- …

## 3. Transporteurs

Les **codes transport** sont transmis dans **Speed** pour permettre de réaliser des filtres de lancement de commande. Le transporteur et le service utilisés pour l’expédition sont renseignés dans **EXM CLIENT**.

## 4. Destinataires

- Non gérés dans **Speed**.  
- Chaque commande est transmise avec un code destinataire intermédiaire, tout en permettant la visualisation des champs d’adresse du destinataire final.  
- Chaque commande est associée à un destinataire unique que ce soit dans **Speed** et **ExpedManager**.

## 5. Emplacements

Les emplacements sont générés en mode rafale dans **Speed**.
Au démarrage de l’activité les emplacements suivants seront initialisés :
-	**Quais de réception**
-	**Chariots de rangement (15)**

### 5.1. Codification
- **Magasin** : Ex. 01 pour l’entrepôt principal  
- **Allée** : Ex. allée pour palettier, CHXX pour un chariot  
- **Colonne**  
- **Niveau**  
- **Case**

### 5.2. Étiquettes emplacement

- Imprimées sur imprimante Zebra/TSC  
- Format : **70x40 mm**

## 6. Codes Qualité

Codes qualité actifs au démarrage :  
- **STD** : Code par défaut de **Speed**, non utilisé.  
- **DI** : Code par défaut (**Disponible**).  
- **BK** : Article défectueux ou cassé.  

## 7. Filières de préparation

Les filières suivantes sont actives :

| Filière | Description                                                                                  |
|---------|----------------------------------------------------------------------------------------------|
| **STD** | Filière par défaut permettant de préparer les commandes : <br>- Après une ramasse globale des articles de X commandes (petits articles) <br>- Une par une avec validation radio (gros articles) |
| **MONO** | Préparation de commandes mono référence                                                     |
| **SERIE** | Série de X commandes avec un contenu identique                                             |

# Philosophie générale de Speed

Toutes les vues dans **Speed** sont paramétrables et filtrables. Voici les étapes pour personnaliser une vue :

1. **Accès au paramétrage** :  
   Faites un clic droit, puis sélectionnez **Paramètres**. 
   !bripgeneral1.png

2. **Modification des champs** :  
   Ajoutez, supprimez ou réorganisez les champs selon vos besoins.  
   !bripgeneral2.png

3. **Filtrage des données** :  
   Appliquez des filtres pour limiter l affichage aux données pertinentes.  
   !bripgeneral3.png

4. **Construction de critères efficaces** :  
   Configurez les filtres pour répondre aux exigences spécifiques.  
   !bripgeneral4.png
"""

class PDF(FPDF):
    def header(self):
        self.set_font('Arial', 'B', 12)
        self.cell(0, 10, 'Markdown to PDF', 0, 1, 'C')

    def chapter_title(self, title):
        self.set_font('Arial', 'B', 12)
        self.cell(0, 10, title, 0, 1, 'L')
        self.ln(10)

    def chapter_body(self, body):
        self.set_font('Arial', '', 12)
        self.multi_cell(0, 10, body)
        self.ln()

# Créer une instance de la classe PDF
pdf = PDF()

# Ajouter une page
pdf.add_page()

# Ajouter le contenu Markdown
pdf.chapter_body(markdown_content)

# Sauvegarder le PDF
pdf.output("yet.pdf", "F")


print("Le fichier PDF a été créé avec succès.")
