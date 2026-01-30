# WordPress Modern Dev Template (2026) 🚀

This repository is a professional, production-ready environment for WordPress plugin and block development using **GitHub Codespaces**.

## ✨ Features
- **Instant Setup**: One click to start a full Ubuntu server with Apache, MySQL, and PHP.
- **Modern Tooling**: Includes Node.js and **pnpm** pre-installed.
- **WP-Scripts Ready**: Pre-configured for @wordpress/scripts and Gutenberg blocks.
- **Proxy-Aware**: Includes automatic SSL/HTTPS fixes for GitHub Codespaces.
- **Symlinked Development**: Plugins are symlinked from the repo to the WP directory for real-time updates.

## 🚀 How to Start
1. Click the **Code** button and select **Create codespace on main**.
2. Wait for the environment to build (approx. 2-3 mins).
3. Once the terminal is ready, go to the **Ports** tab and open port 80.
4. Complete the famous 5-minute WordPress install.
5. Your plugin is already available in the WP Admin!

## 🛠 Tech Stack
- **Server**: Ubuntu 24.04 LTS
- **Web Server**: Apache2 (with `mod_rewrite`)
- **Database**: MySQL 8.0
- **Language**: PHP 8.x + Node.js 20+
- **Package Manager**: pnpm

## 📁 Project Structure
- `.devcontainer/`: Infrastructure as Code (Docker & Setup scripts).
- `plugins/`: Place your custom plugins here. They will be automatically symlinked.
- `themes/`: Place your custom themes here (setup script support coming soon).

## 📝 License
MIT. Feel free to use and contribute!