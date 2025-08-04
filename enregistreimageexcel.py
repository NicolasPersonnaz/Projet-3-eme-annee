import os
from docx import Document

def extract_images_from_word(word_file, output_folder, base_name):
    # Vérifiez si le fichier Word existe
    if not os.path.exists(word_file):
        print(f"Le fichier Word spécifié n'existe pas : {word_file}")
        return

    # Créez le dossier de destination s'il n'existe pas
    os.makedirs(output_folder, exist_ok=True)

    # Chargez le fichier Word
    doc = Document(word_file)

    # Compteur pour nommer les images
    image_counter = 1

    # Parcourez toutes les relations dans le document
    for rel in doc.part.rels.values():
        # Vérifiez si la relation contient une image
        try:
            if "image" in rel.target_ref:
                # Vérifiez si target_part est défini (relation interne)
                if hasattr(rel, 'target_part') and rel.target_part:
                    image_data = rel.target_part.blob
                    image_extension = rel.target_part.content_type.split("/")[-1]

                    # Créez un nom personnalisé pour chaque image
                    image_filename = f"{base_name}_image_{image_counter}.{image_extension}"
                    image_path = os.path.join(output_folder, image_filename)

                    # Enregistrez l'image
                    with open(image_path, "wb") as img_file:
                        img_file.write(image_data)

                    print(f"Image enregistrée : {image_path}")
                    image_counter += 1
        except Exception as e:
            print(f"Erreur lors du traitement d'une relation : {e}")

if __name__ == "__main__":
    # Chemin du fichier Word
    word_file = input("Où se trouve ton fichier : ")

    # Dossier de destination
    output_folder = input("Où veux-tu enregistrer tes images : ")

    # Nom de base pour les fichiers d'image
    base_name = input("Quel nom de base veux-tu utiliser pour les fichiers d'image : ")

    # Extraction des images
    extract_images_from_word(word_file, output_folder, base_name)