from selenium import webdriver
from selenium.webdriver.common.keys import Keys

import time


def send_keys(element, text, sleep = 0.1):
    for character in text:
        element.send_keys(character)
        time.sleep(sleep)


chrome_options = webdriver.ChromeOptions()
chrome_options.add_argument('--disable-extensions')
chrome_options.add_argument('--profile-directory=Default')
chrome_options.add_argument('--incognito')
chrome_options.add_argument('--disable-plugins-discovery');
chrome_options.add_argument('--start-maximized')
chrome_options.add_argument("user_agent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:46.0) Gecko/20100101 Firefox/46.0'")
chrome_options.add_experimental_option('useAutomationExtension', False)
chrome_options.add_experimental_option('excludeSwitches', ['enable-automation', 'ignore-certificate-errors'])

driver = webdriver.Chrome('/usr/local/bin/chromedriver', chrome_options=chrome_options)
driver.delete_all_cookies()
driver.set_window_size(800, 800)
driver.set_window_position(0, 0)

# Google blocks automation software from authenticating with it directly. So instead,
# we will just authenticate with stackoverflow using our google login.
driver.get('https://stackoverflow.com/users/login/')

print(driver.title)

# Google login button
google_login_btn = driver.find_element_by_css_selector('.s-btn__google')
google_login_btn.click()

time.sleep(5)

# Email or phone
email_or_phone = driver.find_element_by_id('identifierId')
email_or_phone.clear()
send_keys(email_or_phone, 'scott.carnett@gmail.com')
driver.find_element_by_xpath('//*[@id="identifierNext"]').click()

time.sleep(5)

# Password
password = driver.find_element_by_name('password')
password.clear()
send_keys(password, 'wxLApF63eCe6t2A')
driver.find_element_by_xpath('//*[@id="passwordNext"]').click()

print(driver.current_url)

filePath = '/home/scott/Downloads/{}'.format('test.txt')
with open(filePath, 'w+') as file:
    file.write(driver.current_url)

driver.close()
