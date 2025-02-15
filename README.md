# ProtonMail Bridge for ARM64 (Raspberry Pi)

This repository provides a **Dockerized version of ProtonMail Bridge** ([Official Repository](https://github.com/ProtonMail/proton-bridge)) specifically modified to work on **ARM64-based Raspberry Pi devices**. It is based on the original [shenxn/protonmail-bridge-docker](https://github.com/shenxn/protonmail-bridge-docker) project, which appears to be unmaintained.

## 🛠️ Initial Development

This is the first iteration of ARM64 support, completed over half a weekend with ChatGPT's assistance to get it running successfully on my Raspberry Pi. The changes made so far allow it to work on **my machine**, and I hope this will be useful for others as well. The Dockerfile can likely be further optimized and slimmed down. Contributions and pull requests to enhance it further are highly encouraged!

## 🚀 What's Changed

This fork focuses on **ARM64 support** and ease of deployment on Raspberry Pi devices.

### **🔹 Major Changes in the Dockerfile**

- **Switched to a Debian-based base image and updated the Go build image to the latest supported version** instead of Ubuntu for improved compatibility.
- **Fixed missing dependencies** that prevented ProtonMail Bridge from running:
  - Installed essential libraries (`libsecret-1-0`, `libglib-2.0`, `libgobject-2.0`).
  - Added utilities (`net-tools`, `procps`, `socat`, `iproute2`) for easier debugging.
- **Updated the build process** to ensure correct compilation on ARM64.
- **Removed the **``** folder and moved all files to the main directory** to streamline the build since this repo is specifically targeting ARM64. to streamline the build since this repo is specifically targeting ARM64.

### **🔹 Improvements in EntryPoint Script**

- Fixed issues related to process management by ensuring required utilities are installed.
- Ensured **pass & GPG key initialization** works properly without requiring a passphrase.
- Addressed issues where ProtonMail Bridge could not start due to missing dependencies.
- Improved logging for easier debugging.

## 📌 Supported Platforms

This version has been tested to work on: ✅ **Raspberry Pi 4 (8GB RAM)** running the latest **Raspberry Pi OS (64-bit)**.

## 🚀 How to Build and Run

### **1️⃣ Build the Docker Image**

```sh
docker buildx build --platform linux/arm64 -t protonmail-bridge-arm64 .
```

### **2️⃣ Run the Container**

```sh
docker run --rm -it -v protonmail:/root protonmail-bridge-arm64
```

## 🔧 Troubleshooting & Known Issues

### **Bridge Only Listens on 127.0.0.1**

By default, ProtonMail Bridge **only listens on **``, meaning you cannot bind it to `0.0.0.0` without modifying the source code before building. If you need external access, you will have to patch the Bridge source to allow different binding addresses.

### **Email Sending Issues**

- Ensure that ProtonMail Bridge is running and correctly logged in via the CLI.
- Verify that SMTP settings are properly configured.
- If encountering connection issues, confirm that `socat` is correctly forwarding ports.

### **ProtonMail Bridge Not Running Properly**

- Check the logs using:
  ```sh
  docker logs protonmail-bridge --tail=50
  ```
- Ensure that all required dependencies are installed in the container.
- If the container exits unexpectedly, try running the Bridge manually inside the container to debug:
  ```sh
  docker exec -it protonmail-bridge /protonmail/proton-bridge --cli
  ```

## 📜 License & Attribution

This project is licensed under **GPL-3.0** and is **based on** the original work of [shenxn](https://github.com/shenxn/protonmail-bridge-docker).

---

Let me know if you'd like to add additional sections like **Known Issues** or **Troubleshooting Tips**! 🚀

