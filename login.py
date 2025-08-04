from selenium import webdriver
from selenium.webdriver.edge.service import Service
from selenium.webdriver.edge.options import Options
from selenium.webdriver.common.by import By
import time

# script pour faire en sorte de se connecter à la page web de surveillance de l'entreprise

# Chemin vers msedgedriver
edge_driver_path = r"C:\Users\Nicolas\msedgedriver.exe"

# Service et options Edge
service = Service(executable_path=edge_driver_path)
options = Options()
# options.add_argument("--headless")  # Décommente si tu veux lancer sans interface

# Lancement du navigateur
driver = webdriver.Edge(service=service, options=options)

# Aller à la page de login
login_url = "https://test.fr"  
driver.get(login_url)
time.sleep(3)  # Attente pour que la page charge

# Remplir les champs
username_input = driver.find_element(By.ID, "id3d81b718-e0e9-4926-88ec-79110d6436a9")
password_input = driver.find_element(By.ID, "id354ecfde-0418-40b4-943c-8e0944167f48")

username_input.send_keys("admin")
password_input.send_keys("password")
time.sleep(1)

# Cliquer sur le bouton de connexion
login_button = driver.find_element(By.ID, "idd8a5a04a-1f4b-4d1d-b660-e0e423311b61")
login_button.click()

# Attendre que la redirection ou la page post-login se charge
time.sleep(10)

# Fermer le navigateur
driver.quit()

