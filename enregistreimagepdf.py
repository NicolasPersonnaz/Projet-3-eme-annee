import os
import fitz  # PyMuPDF

def extract_images_from_pdf(pdf_file, output_folder):
    # Vérifiez si le fichier PDF existe
    if not os.path.exists(pdf_file):
        print(f"Le fichier PDF spécifié n'existe pas : {pdf_file}")
        return

    # Créez le dossier de destination s'il n'existe pas
    os.makedirs(output_folder, exist_ok=True)

    # Obtenez le nom de base du fichier PDF (sans extension)

    # Ouvrir le fichier PDF
    pdf_document = fitz.open(pdf_file)

    # Compteur global pour nommer les images
    image_counter = 1

    # Parcourir chaque page du PDF
    for page_num in range(len(pdf_document)):
        page = pdf_document[page_num]
        images = page.get_images(full=True)

        # Parcourir toutes les images de la page
        for img_index, img in enumerate(images, start=1):
            xref = img[0]
            base_image = pdf_document.extract_image(xref)
            image_bytes = base_image["image"]
            image_extension = base_image["ext"]
            image_filename = f"{base_name}{image_counter}.{image_extension}"
            image_path = os.path.join(output_folder, image_filename)

            # Sauvegarder l'image
            with open(image_path, "wb") as img_file:
                img_file.write(image_bytes)

            print(f"Image enregistrée : {image_path}")
            image_counter += 1

    # Fermer le document PDF
    pdf_document.close()

if __name__ == "__main__":
    # Chemin du fichier PDF
    pdf_file = input("Où se trouve ton fichier : ")

    # Dossier de destination
    output_folder = output_folder = input("Où veux-tu enregistrer tes images : ")

  # Nom de base pour les fichiers d'image
    base_name = input("Quel nom de base veux-tu utiliser pour les fichiers d'image : ")
    
    # Extraction des images
    extract_images_from_pdf(pdf_file, output_folder)