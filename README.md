# SwagPost 🚀

A Postman clone built with Flutter Web and powered by a Go server to handle CORS issues. SwagPost allows you to test APIs seamlessly with support for multiple authentication methods.

## Features ✨

- 🌐 **Flutter Web** based interface
- 🔒 **Multiple Authentication Types**:
  - API Key (Header/Query Params)
  - Bearer Token
  - OAuth 2.0
  - Basic Auth
- ⚡ **CORS Bypass** using Go server proxy
- 🛠️ **Full HTTP Request Support** (GET, POST, PUT, DELETE, etc.)
- 📦 **Request Body** support (JSON, form-data, raw text)

## Prerequisites 📋

- Flutter SDK (3.0.0 or newer)
- Go (1.20 or newer)
- Chrome/Firefox (for web testing)

## Installation & Setup 🛠️

1. **Clone the repository**
`git clone https://github.com/AnikethMohan1/SwagPost.git`

`cd swagpost`

2. Start Go Server (CORS Proxy)
`cd golang_server`

` go get . `

` go run .`

3. Start Flutter Web App

`cd ../swag_post`

`flutter pub get`

`flutter run -d chrome`


Troubleshooting 🚨
CORS Errors Still Occurring?
• Ensure Go server is running
• Check that request URLs are being routed through the proxy
• Verify server CORS headers in main.go



Happy API Testing! 🎉
