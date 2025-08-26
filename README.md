# Asset Borrowing System - mobileproject

**Mobile Application (Flutter) + REST API (Node.js) + MySQL Database (XAMPP) **

This project is a mobile application that allows students, staff and lecturers to efficiently manage borrowing and returning of assets.

# 📱 Features

 - Role-based login : Student, Staff, Lecturer
 - Asset borrowing with status : available, pending, borrowed, disabled
 -   Borrowing rules : 
	 - Students can borrow 1 asset per day
	 - Maximum borrowing period is 7 days
 - Asset Control : Staff can add,edit, or disable assets (only when status = available)

## 🛠️ Tech Stack

 - Frontend : Flutter (`mobileproject/Projectmobile/project/lib`)
 - Backend : Node.js + Express (`mobileproject/server`)
 - Database : MySQL (XAMPP)
 - API : RESTful ( IP :`http://localhost:3000`)

## ⚙️ Quick Start

 1. Clone the repository
 `git clone https://github.com/your-username/mobileproject.git
cd mobileproject/Projectmobile`

 2. Backend Setup
 `cd server`
 `npm install` 
`nodemon app.js`
	- Server will run at : http://localhost:3000
	- Note : Replace localhost in Flutter code with your machine's IP when using a real device :
	`Uri.parse('http://<YOUR_MACHINE_IP>:3000/<endpoint>')`

3. Database Setup (XAMPP)
	- Start MySQL 
	- Import the provided SQL file `mbproject.sql`
	- Ensure database credentials in `server/config` match your setup


4. Frontend Setup
	`flutter pub get`
	`flutter run`

	- On VS Code : Run > Run Without Debugging and select your device/simulator
	- Make sure device or simulator is on the same network as the server if using a real device.
