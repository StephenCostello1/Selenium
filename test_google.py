from selenium import webdriver

from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

options = Options()
# options.add_argument('--headless')  # uncomment this for headless mode
driver = webdriver.Chrome(options=options)

try:
    driver.get("https://the-internet.herokuapp.com/login")

    # Locate username and password fields
    username_input = WebDriverWait(driver, 10).until(
        EC.presence_of_element_located((By.ID, "username"))
    )
    password_input = driver.find_element(By.ID, "password")

    # Enter valid credentials
    username_input.send_keys("tomsmith")
    password_input.send_keys("SuperSecretPassword!")

    # Click login button
    driver.find_element(By.CSS_SELECTOR, "button.radius").click()

    # Wait for success message
    success_message = WebDriverWait(driver, 10).until(
        EC.presence_of_element_located((By.CSS_SELECTOR, ".flash.success"))
    )

    assert "You logged into a secure area!" in success_message.text
    print("✅ Login test passed!")

except Exception as e:
    print("❌ Login test failed:", e)

finally:
    driver.quit()
