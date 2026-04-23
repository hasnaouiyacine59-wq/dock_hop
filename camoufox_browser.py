import json
from camoufox.sync_api import Camoufox
from browserforge.fingerprints import Screen

COOKIES_FILE = "cookies.json"

with Camoufox(
    os=["windows", "macos", "linux"],
    screen=Screen(max_width=1920, max_height=1080),
    geoip=True,          # auto-detects geo/timezone/locale from VPN exit IP
    humanize=True,
    headless=False,
    # headless="virtual",
    block_webrtc=True,   # prevent real IP leaks
    locale="en-US",
) as browser:
    page = browser.new_page()
    page.goto(
        "https://nordaccount.com/product/nordvpn/login/success?exchange_token=ZWVmMzg0ZDE4NjQxNjMyZmZkODM5NTdlYWQ3ZGU4MmY1M2E4ODIyYjY5OGM1MGFkYjRiMDBjZTgzMTU1MzhiMg%3D%3D&redirect_upon_open=1&return=1",
        wait_until="domcontentloaded",
        timeout=60000,
    )
    print(page.content())
    page.goto("https://example.com", wait_until="domcontentloaded", timeout=60000)
    page.wait_for_load_state("networkidle", timeout=60000)
    print("Title:", page.title())
    input('lol')

    # Save cookies
    cookies = browser.contexts[0].cookies()
    with open(COOKIES_FILE, "w") as f:
        json.dump(cookies, f, indent=2)
    print(f"Cookies saved to {COOKIES_FILE}")
