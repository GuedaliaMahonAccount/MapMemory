<img src="map_memory/assets/images/logo10.png" alt="Logo" width="300"/>
[](demo.mp4)

## 📸 Map Memory – Couple Memory App

Map Memory is a full-stack mobile app that lets couples or close friends save their shared memories with GPS location, photos, date & time – and view them on a timeline or an interactive map.

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
npm install
npm run dev
```

The backend API will run on: http://localhost:5000/api




## ⚙️ Frontend – `map_memory`

```bash
cd map_memory
flutter pub get
flutter run
```

Make sure the backend is already running before launching the app.

🌐 API Base URL
In lib/services/api_service.dart, configure your base URL:

---

✅ Features
🔐 Email/password registration and login

🔗 Partner connection via unique shared code

📝 Add memories with title, description, photo, date & location

🗺️ View memories on a map

🗃️ List view for timeline
