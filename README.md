# 🍱 Custom Domain for Bento Profile

<div align="center">
    <a href="LICENSE">
        <img src="https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge" alt="MIT License" height="22"/>
    </a>
    <a href="https://github.com/iamvikshan/bento/actions/workflows/git-sync.yml">
        <img src="https://github.com/iamvikshan/bento/actions/workflows/git-sync.yml/badge.svg" alt="GitLab Sync" height="22"/>
    </a>
    <a href="https://github.com/iamvikshan/bento/actions/workflows/releases.yml">
        <img src="https://github.com/iamvikshan/bento/actions/workflows/releases.yml/badge.svg" alt="Releases" height="22"/>
    </a>
    <a href="https://github.com/iamvikshan/bento/actions/workflows/cla.yml">
        <img src="https://github.com/iamvikshan/bento/actions/workflows/cla.yml/badge.svg" alt="CLA" height="22"/>
    </a>
    <a href="https://wakatime.com/badge/user/8535571c-1079-48d4-ac47-11a817f61249/project/e65427d1-3d46-4255-857a-8676a9e9d8aa">
        <img src="https://wakatime.com/badge/user/8535571c-1079-48d4-ac47-11a817f61249/project/e65427d1-3d46-4255-857a-8676a9e9d8aa.svg" alt="WakaTime" height="22"/>
    </a>
</div>

<br>

<div align="center">
    <a href="https://zeabur.com/templates/U3I9WF?referralCode=iamvikshan">
        <img src="https://zeabur.com/button.svg" alt="Deploy on Zeabur" height="30"/>
    </a>
    <a href="https://railway.com/template/6fVSiZ?referralCode=HB99pt">
        <img src="https://railway.com/button.svg" alt="Deploy on Railway" height="30"/>
    </a>
    <a href="https://app.koyeb.com/deploy?type=git&repository=github.com/iamvikshan/bento&name=bento&service_type=web&builder=dockerfile">
        <img src="https://www.koyeb.com/static/images/deploy/button.svg" alt="Deploy to Koyeb" height="30"/>
    </a>
    <a href="https://dashboard.heroku.com/new?template=https%3A%2F%2Fgithub.com%2Fiamvikshan%2Fbento">
        <img src="https://www.herokucdn.com/deploy/button.png" alt="Deploy to Heroku" height="30"/>
    </a>
</div>

<br>

<p align="center">
    <strong>Transform your Bento profile with a personalized domain name!</strong><br>
    <em>Bento doesn't have an official way to do this, so I thought this might be a good workaround.</em>
</p>

## 📖 Table of Contents

- [✨ Features](#-features)
- [📋 Prerequisites](#-prerequisites)
- [💻 Recommended VPS Providers](#-recommended-vps-providers)
- [🚀 Installation](#-installation)
- [☁️ Cloud Deployment Options](#️-cloud-deployment-options)
- [🤝 Contributing](#-contributing)
- [📄 License](#-license)
- [💪 Powered By](#-powered-by)

---

> [!TIP]
> - To make changes, navigate to your official [Bento profile](https://bento.me) and make them there.
> - You do not need to re-deploy the app—it will pull those changes before you can even save them! ⚡
> 
> In other words, as long as your deployment is smooth, you will never think about it. Just share your custom domain link, but use Bento as normal! **HOW COOL IS THAT!** 🎉

## ✨ Features

- 🌐 **Easy custom domain setup**
- ☁️ **Multiple deployment options**
- 🔒 **SSL support**
- ⚡ **PM2 process management**
- 🔧 **Apache2/Nginx compatibility**
- 🔄 **Real-time sync with Bento profile**

## 📋 Prerequisites

Before you begin, ensure you have:

- 💻 A computer/VPS running Windows, Linux, macOS, or Ubuntu 20.04+, or a Docker image
- 🟨 [Bun](https://bun.sh) v1.1.36 or later
- 🍱 A [Bento](https://bento.me) account
- 🌐 A custom domain name
- ⚙️ [PM2](https://pm2.keymetrics.io/) (optional)
- 🌐 [Apache2](https://httpd.apache.org/) (required for VPS)
- 🔒 [Certbot](https://certbot.eff.org/) (required for SSL on VPS)

> [!TIP] 
> 💰 Get **$300 free credit** on Vultr to try your app! [Claim now](https://go.vikshan.tech/vultr)

### 💻 Recommended VPS Providers

| Provider | Offer | Link |
|----------|-------|------|
| 🔥 **Ionos** | Special discount available | [Get Discount](https://go.vikshan.tech/ionos) |
| ⚡ **Vultr** | $300 free credit | [Claim Credit](https://go.vikshan.tech/vultr) |
| 🌊 **DigitalOcean** | $200 free credit | [Sign Up](https://go.vikshan.tech/digitalocean) |
| 🏠 **Hostinger** | Discounted rates | [View Deals](https://go.vikshan.tech/hostinger) |
| 🪨 **BigRock VPS** | Special offers | [Check Offers](https://go.vikshan.tech/bigrock) |
| 🐊 **HostGator** | Exclusive deals | [Get Deals](https://go.vikshan.tech/hostgator) |

> [!NOTE] 
> 🤝 Need help with setup? I'm an **Ionos Partner** and can assist you! Contact me at [Vikshan](https://go.vikshan.tech/ionos-partner)

## 🚀 Installation

### 🏠 Local/VPS Installation

1. **Clone and install dependencies:**

```bash
git clone https://github.com/iamvikshan/bento.git
cd bento
bun i
```

2. **Create environment variables:**

```bash
# Create .env file
echo "BENTO_USERNAME=your_username" > .env
```

3. **Start the application:**

```bash
bun start
```

4. **Run tests (optional):**

```bash
bun test
```

> [!IMPORTANT] 
> 🔧 When using a VPS, make sure to set up a reverse proxy using Apache2 or Nginx:
> - 📚 [Apache2 guide](https://docs.vikshan.tech/selfhost/dashboard/domain) 
> - 📚 [Nginx guide](https://docs.nginx.com/nginx/admin-guide/web-server/reverse-proxy/)

## ☁️ Cloud Deployment Options

**First step:** ⭐ Star and [fork](https://github.com/iamvikshan/bento/fork) this repository

### 🚀 Deploy to Zeabur

1. Create a [Zeabur account](https://zeabur.com?referralCode=vikshan&utm_source=vikshan)
2. Select "Deploy from GitHub" in your dashboard
3. Configure environment variables:
   - `BENTO_USERNAME`: Your Bento username

> [!NOTE] 
> 🗑️ Remove the `.env` file if you're setting variables in Zeabur dashboard to avoid conflicts

### 🌟 Deploy to Koyeb (Recommended)

1. [Create a Koyeb account](https://app.koyeb.com/signup)
2. Deploy from your GitHub repository **OR** [click here](https://app.koyeb.com/deploy?type=git&repository=github.com/iamvikshan/bento&name=bento&service_type=web&builder=dockerfile) to automatically create using this repo as template
3. Set required environment variables

> [!WARNING] 
> 💰 Custom domains require a paid Koyeb plan

### 🚂 Deploy to Railway

1. Create a [Railway account](https://railway.com?referralCode=HB99pt) if you don't have one
2. [Click here](https://railway.com/template/6fVSiZ?referralCode=HB99pt) to deploy using this repo as a template
3. Railway will automatically detect the project and set up the necessary environment
4. You'll be prompted to configure environment variables:
   - `BENTO_USERNAME`: Your Bento username
5. Click "Deploy" to start the deployment process
6. Once deployed, you'll get a URL to access your Bento profile with a custom domain

> [!NOTE] 
> 💸 Railway provides a free tier with limited resources. For production use, consider upgrading to a paid plan. You can also configure a custom domain with your Railway deployment. Refer to the Railway [documentation](https://docs.railway.com/guides/public-networking#custom-domains) for more details on custom domains and other features.

### 🟣 Deploy to Heroku

1. [Create a Heroku account](https://signup.heroku.com/)
2. Click [here to deploy](https://dashboard.heroku.com/new?template=https%3A%2F%2Fgithub.com%2Fiamvikshan%2Fbento) using this repo as a template, or use your own fork
3. Configure custom domain in Settings → Domains
4. Enable auto-deploys in Deploy → Deployment method

### 🔧 Additional Deployment Options

- **🐙 Okteto**: [Documentation](https://www.okteto.com/docs/)
- **⚡ Repl.it**: [Documentation](https://docs.replit.com/)
- **🐳 Docker**: [Documentation](https://docs.docker.com/)

---

> [!CAUTION] 
> ⚠️ **Known Issues:**
> 1. 🖼️ Images may not persist due to caching. If this happens, re-add those images in Bento or use VPS deployment for best results
> 2. 🗺️ Maps functionality may not work properly

## 🤝 Contributing

Contributions are always welcome! If you find bugs or have suggestions:

1. 🍴 [Fork](https://github.com/iamvikshan/bento/fork) the repository
2. 🌿 Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. 💾 Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. 📤 Push to the branch (`git push origin feature/AmazingFeature`)
5. 🔄 Open a [Pull Request](https://github.com/iamvikshan/bento/compare)

> [!TIP] 
> 💖 If this project helped you, please consider:
> - ⭐ Giving it a star
> - 🤝 [Becoming a sponsor](https://github.com/sponsors/iamvikshan)
> - 👀 Checking out my [other projects](https://github.com/iamvikshan?tab=repositories)

## 📄 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

---

## 📊 Activity Graph

![Repository Activity](https://repobeats.axiom.co/api/embed/578ac42457107a9ba4a650e59d5d42849ab69c0b.svg "Repobeats analytics image")

---


## 💪 Powered By

<div align="center">
  <a href="https://www.digitalocean.com/?refcode=c5587212fe39&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge">
    <img src="https://web-platforms.sfo2.cdn.digitaloceanspaces.com/WWW/Badge%201.svg" alt="DigitalOcean" height="50">
  </a>
  <a href="https://go.vikshan.tech/vultr">
    <img src="https://www.vultr.com/media/logo_ondark.svg" alt="Vultr" height="50" width="100">
  </a>
  <a href="https://partnernetwork.ionos.com/partner/vikshan?origin=PartnerBadge">
    <img src="https://images-2.partnerportal.ionos.com/items/0461b6bb-dabe-40bb-8d94-feb41be45e49/profiles/b6282cd9-10f6-4260-90dd-0bc4584f9c33/badges/normal_blue_eco" alt="IONOS" height="52" width="108">
  </a>
</div>

---

<div align="center">
  <p><strong>Made with ❤️ by <a href="https://github.com/iamvikshan">Vikshan</a></strong></p>
  <p><em>Give this project a ⭐ if it helped you!</em></p>
</div>
