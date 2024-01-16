# GitLab-13.10.3-Enumeration
GitLab Community Edition (CE) 13.10.3 - User Enumeration
# GitLab User Enumeration Script
A simple Bash script designed to perform user enumeration on a vulnerable GitLab Community Edition (CE) instance. By sending targeted GET requests towards user profile pages and inspecting the resulting HTTP status codes, the script can determine whether the specified user accounts actually exist within said GitLab installation.


## Features
- Quickly identifies existing users based on supplied wordlists
- Compatibility across various platforms due to its Bash foundation
- Customizable through modification of built-in variables such as target URL and wordlist location

## Prerequisites
* **Wordlist**: Containing user account names, formatted with one entry per line

## Setup & Configuration
1. Clone the repository onto your desired platform
```bash
git clone https://github.com/pikafou/GitLab-13.10.3-Enumeration.git
cd pikafou
chmod +x enum.sh
./enum.sh -u http://gitlab.example.com --wordlist /path/to/username.txt
