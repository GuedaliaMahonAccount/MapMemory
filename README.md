cat > README.md << 'EOF'
# 📸 Map Memory – Couple Memory App

Map Memory is a full-stack mobile app that lets couples or close friends save their shared memories with GPS location, photos, date & time – and view them on a timeline or an interactive map.

---

## 🧱 Project Structure

map_memory/ # Flutter frontend map_memory_api/ # Node.js + Express + MongoDB backend

yaml
Copier
Modifier

---

## ⚙️ Backend – `map_memory_api`

### 🛠 Technologies

- Node.js + Express
- MongoDB with Mongoose
- JWT for authentication
- bcrypt for password hashing
- REST API

### 🔧 Setup

1. Go into the backend folder:

```bash
cd map_memory_api
Install dependencies:

bash
Copier
Modifier
npm install
Create a .env file with the following content:

env
Copier
Modifier
PORT=5000
MONGO_URI=your_mongodb_connection_string
JWT_SECRET=cC2h9wT3fXq7n8KsP5dLmB1vTzA4yQvR
Add this to your package.json if not already present:

json
Copier
Modifier
"scripts": {
  "start": "node server.js",
  "dev": "nodemon server.js"
}
Start the server:

bash
Copier
Modifier
npm run dev
The backend API will run on: http://localhost:5000/api

📚 API Endpoints

Method	Endpoint	Description
POST	/auth/register	Register a new user
POST	/auth/login	Login with email and password
POST	/auth/connect	Connect your account with a partner's shared code
POST	/memories	Add a memory
GET	/memories	Get all shared memories
📱 Frontend – map_memory
🛠 Technologies
Flutter SDK (>= 3.16)

Provider, HTTP, Google Maps Flutter, Image Picker

Shared Preferences for auth tokens

🔧 Setup
Go into the Flutter project:

bash
Copier
Modifier
cd map_memory
Install dependencies:

bash
Copier
Modifier
flutter pub get
Run the app:

bash
Copier
Modifier
flutter run
Make sure the backend is already running before launching the app.

🌐 API Base URL
In lib/services/api_service.dart, configure your base URL:

dart
Copier
Modifier
// For Android emulator:
static const String baseUrl = "http://10.0.2.2:5000/api";

// For physical device (replace with your local IP):
static const String baseUrl = "http://192.168.X.X:5000/api";
📁 Assets
Declare any images in pubspec.yaml:

yaml
Copier
Modifier
flutter:
  uses-material-design: true
  assets:
    - assets/
Ensure you have a folder assets/ in your Flutter project root with images.

✅ Features
🔐 Email/password registration and login

🔗 Partner connection via unique shared code

📝 Add memories with title, description, photo, date & location

🗺️ View memories on a map

🗃️ List view for timeline
