from playwright.sync_api import sync_playwright
import os, time

screenshots = [
    {"name": "dashboard", "view": "dashboard"},
    {"name": "release-review", "view": "release"},
    {"name": "document-wizard", "view": "wizard"},
    {"name": "case-assistant", "view": "assistant"},
    {"name": "bad-company", "view": "consumer"},
    {"name": "credit-score", "view": "creditscore"},
    {"name": "immigrant", "view": "immigrant"},
    {"name": "tools", "view": "tools"},
]

out_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), "screenshots")
os.makedirs(out_dir, exist_ok=True)

with sync_playwright() as p:
    browser = p.chromium.launch(headless=True)
    page = browser.new_page(viewport={"width": 1400, "height": 900})
    
    page.goto("http://localhost:8799/index.html", wait_until="domcontentloaded")
    time.sleep(3)
    
    # Handle password gate - type password and press Enter
    gate_input = page.query_selector("#gate-password")
    if gate_input:
        gate_input.fill("impact")
        time.sleep(0.5)
        gate_input.press("Enter")
        time.sleep(4)
    
    # Wait for boot
    time.sleep(3)
    
    for shot in screenshots:
        try:
            nav_item = page.query_selector(f'[data-view="{shot["view"]}"]')
            if nav_item:
                nav_item.click()
                time.sleep(2)
            
            path = os.path.join(out_dir, f'{shot["name"]}.png')
            page.screenshot(path=path, full_page=False)
            print(f"OK: {shot['name']}.png")
        except Exception as e:
            print(f"FAIL {shot['name']}: {e}")
    
    # Password gate screenshot
    page2 = browser.new_page(viewport={"width": 1400, "height": 900})
    page2.goto("http://localhost:8799/index.html", wait_until="domcontentloaded")
    time.sleep(2)
    path = os.path.join(out_dir, "password-gate.png")
    page2.screenshot(path=path, full_page=False)
    print("OK: password-gate.png")
    
    browser.close()

print("\n=== Done ===")
