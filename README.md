# Koksmat Security

Welcome to the **Koksmat Security** repository! This project provides a suite of PowerShell scripts and tools designed to help organizations automate and maintain best security practices across their GitHub repositories. Each script is crafted to address specific tasks, from repository management to vulnerability scanning, ensuring a streamlined approach to security.

---

## **Scripts Overview**

### **1. `clone-repos.ps1`**

This script automates the cloning of repositories listed in an input file. It reads the repository names from `clone-repos.txt` and clones them into a designated directory. Use this script to create local copies of repositories for further analysis or modification.

- **Input:** `clone-repos.txt` (list of repositories, one per line).
- **Output:** Cloned repositories in the specified directory.

---

### **2. `get-repos.ps1`**

Fetches a list of repositories from a GitHub organization and saves them into an output file. This script simplifies the process of retrieving repository information and ensures up-to-date records.

- **Input:** None (uses GitHub CLI to fetch repositories from the organization).
- **Output:** `repos.txt` (list of repositories).

---

### **3. `gitleaks-install.ps1`**

Checks whether `gitleaks` is installed on the system and installs it if it is not. This script ensures you have the necessary toolset for scanning repositories for sensitive information without manual installation steps.

- **Input:** None.
- **Output:** Installs `gitleaks` if not already available.

---

### **4. `gitleaks-scan.ps1`**

Runs `gitleaks` on cloned repositories to identify sensitive information, such as exposed API keys or secrets. The script generates individual reports for each repository and consolidates the results into a combined JSON report.

- **Input:** `<INPUT_DIRECTORY>` (directory containing cloned repositories).
- **Output:**
  - Individual reports: `<OUTPUT_DIRECTORY>/repo-name-gitleaks.json`.
  - Combined report: `<OUTPUT_FILE>` (e.g., `gitleaks-report.json`).

---

### **5. `make-private.ps1`**

Reads a list of repositories from an input file and ensures they are private. If any repository is found to be public, this script updates its visibility to private using the GitHub CLI.

- **Input:** `repos-makeprivate.txt` (list of repositories, one per line).
- **Output:** Updated repository visibility.

---

## **Folder Structure**

```
.
├── README.md               # This documentation file
└── github
    ├── clone-repos.ps1     # Clones repositories from a list
    ├── get-repos.ps1       # Retrieves a list of repositories from GitHub
    ├── gitleaks-install.ps1 # Installs Gitleaks if not installed
    ├── gitleaks-scan.ps1   # Scans repositories for sensitive information
    └── make-private.ps1    # Ensures repositories are private
```

---

## **Getting Started**

1. **Set Up Dependencies:**

   - Install GitHub CLI (`gh`): [GitHub CLI Installation Guide](https://cli.github.com/manual/installation).
   - Install `gitleaks`: Run `gitleaks-install.ps1` or download manually from [Gitleaks](https://github.com/gitleaks/gitleaks).

2. **Configure GitHub Authentication:**

   - Authenticate GitHub CLI:
     ```bash
     gh auth login
     ```

3. **Run Scripts in Sequence:**
   - Use `get-repos.ps1` to fetch repository names.
   - Use `clone-repos.ps1` to clone repositories locally.
   - Use `gitleaks-scan.ps1` to scan for sensitive data.
   - Use `make-private.ps1` to ensure repositories are private.

---

## **Contributing**

We welcome contributions to enhance and expand this repository! Please follow these steps:

1. Fork the repository.
2. Create a new branch:
   ```bash
   git checkout -b feature/your-feature-name
   ```
3. Submit a pull request with your changes.

---

## **License**

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
