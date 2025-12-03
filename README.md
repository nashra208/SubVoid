<h1 align="center"> 👾 Subvoid</h1>

<h2 align="center"> Silent. Fast. Passive Recon. </h2>
<br>
<br>

Subvoid is a **Bash-powered subdomain enumeration tool** designed for bug bounty hunters, security researchers, and anyone who lives in the recon phase.  
It blends multiple passive sources, cleans the noise, checks what’s alive, and quietly delivers everything to your Discord.

---

## ⚡ Features
- Combined passive enumeration (**Subfinder + Assetfinder**)  
- Automatic unique sorting  
- Live host discovery via **httpx**  
- Timestamped workspace creation  
- Discord webhook reporting  
- Tool checks, graceful exits, and Ctrl+C trap  
- Minimal setup. Maximum signal  

---

## 🛠 Requirements
Install or download the following tools:

- **Subfinder** → [https://github.com/projectdiscovery/subfinder](https://github.com/projectdiscovery/subfinder)  
- **Assetfinder** → [https://github.com/tomnomnom/assetfinder](https://github.com/tomnomnom/assetfinder)  
- **httpx** → [https://github.com/projectdiscovery/httpx](https://github.com/projectdiscovery/httpx)  
- **jq** → install with:
```bash
sudo apt install jq
```

## ▶️ Usage

Run Subvoid with a target domain:

```bash
./5ubvoid.sh --s example.com
```


Show help menu:
```bash
./5ubvoid.sh --help
```


## Add your Discord webhook inside webhook.txt:
```bash
webhook="https://discord.com/api/webhooks/xxxx/xxxx"
```

## 📁 Output Structure

Each scan creates a clean workspace under your home directory:
```bash
example.com_YYYY-MM-DD_HH-MM-SS/
```


Files include:

subfinder.txt
assetfinder.txt
unqsubs.txt
finalsubs.txt


Results are automatically chunked and delivered to Discord.

# ⚠️ Disclaimer

Subvoid is created for educational purposes and authorized security testing only.
The author is not responsible for any misuse, damage, or illegal activity performed with this tool.
Only run it on systems you own or have explicit permission to test.

---

<h3 align="center"> 👾 Stay silent. Stay sharp. Happy hunting. </h3>