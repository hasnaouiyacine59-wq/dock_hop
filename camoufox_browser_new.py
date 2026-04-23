import json
import subprocess
import re
from camoufox.sync_api import Camoufox
from browserforge.fingerprints import Screen

COOKIES_FILE = "cookies.json"

# Start NordVPN login and capture the redirect URL

with Camoufox(
    os=["windows", "macos", "linux"],
    screen=Screen(max_width=1920, max_height=1080),
    geoip=True,
    humanize=True,
    headless=False,
    block_webrtc=True,
    locale="en-US",
) as browser:
    page = browser.new_page()
    
    # Open the NordVPN login URL
    page.goto(login_url, wait_until="domcontentloaded", timeout=60000)
    
    # Wait for user to complete login
    print("Complete the login in the browser...")
    input("Press Enter after you've completed the login...")
    
    # Get the final URL after login
    final_url = page.url
    print(f"Final URL: {final_url}")
    
    # Navigate to example.com
    page.goto("https://my.nordaccount.com/", wait_until="domcontentloaded", timeout=60000)
    page.wait_for_load_state("networkidle", timeout=60000)
    print("Title:", page.title())
    result = subprocess.run(
    ["nordvpn", "login"],
    capture_output=True,
    text=True)

    # Extract the URL from the output
    url_match = re.search(r'https://api\.nordvpn\.com/v1/users/oauth/login-redirect\?attempt=[a-f0-9-]+', result.stdout)
    if not url_match:
        print("Failed to get login URL from nordvpn command")
        print("Output:", result.stdout)
        exit(1)
    
    login_url = url_match.group(0)
    print(f"Opening NordVPN login in browser: {login_url}")


    # Save cookies
    cookies = browser.contexts[0].cookies()
    with open(COOKIES_FILE, "w") as f:
        json.dump(cookies, f, indent=2)
    print(f"Cookies saved to {COOKIES_FILE}")
