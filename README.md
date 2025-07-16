## Full Product CRUD App (Flutter + Provider + Express.js + SQL Server)

This is a full-stack CRUD application for managing products. It includes:

- **Frontend:** Flutter + Provider
- **Backend:** Express.js + SQL Server
- **Features:** Pagination, Search, Sort, Lazy Load, Export to PDF

# 1. Set up for Backend (Express.js + SQL Server)

## - Requirements

- Node.js
- SQL Server
- `.env` file with:

```env
DB_USER=your_user
DB_PASSWORD=your_password
DB_SERVER=your_sever_name
DB_DATABASE=your_db_name
DB_PORT=your_sqlserver_port
```

## - Setup Instructions

1. Go to `backend/`
2. Run `npm install`
3. Create `.env` file (base on `.env.example`)
4. Start server:

   ```bash
   node app.js
   ```

5. Server will run at `http://localhost:3000`

## - API Endpoints

| Method | Endpoint       | Description                                                                           |
| ------ | -------------- | ------------------------------------------------------------------------------------- |
| GET    | `/product`     | Get paginated product list (optional params: `?page=1&name=abc&sort=Price&order=ASC`) |
| GET    | `/product/:id` | Get single product by ID                                                              |
| POST   | `/product`     | Add new product                                                                       |
| PUT    | `/product/:id` | Update product by ID                                                                  |
| DELETE | `/product/:id` | Delete product by ID                                                                  |

## - Note

You can create table with script from file in project `sql_script.sql` and sample data `sample_data.sql`

---

# 2. Set up for Frontend (Flutter + Provider)

## - Requirements

- Flutter SDK
- Device or Emulator

## - Setup Instructions

1. Go to `frontend/`
2. Run `flutter pub get`
3. Launch with:

   ```bash
   flutter run
   ```

## - Features

- Show all products with:
  - Lazy Loading
  - Pull-to-Refresh
  - Search (debounce)
  - Sort by ID (default), Price, Stock
  - Order (ASC/DESC)
- Add, Edit, Delete Products
- Export Products PDF (table of all products)

## - Note

Make sure the Flutter app points to:

```dart
BaseOptions(
  baseUrl: 'http://10.0.2.2:3000', // for Android emulator
)
```

Or change `10.0.2.2` to your actual IP on physical device.

---

# 3. Screenshots

<p float="left">
  <img width="1080" height="2340" alt="Screenshot_1752658784" src="https://github.com/user-attachments/assets/3a16e4f2-0ecc-4ec3-958e-859b5b5f04b7" width="30%" />
  <img width="1080" height="2340" alt="Screenshot_1752666229" src="https://github.com/user-attachments/assets/5b75775b-3fba-4bd6-a52b-ae16a23ec8da" width="30%" />
  <img width="1080" height="2340" alt="Screenshot_1752666258" src="https://github.com/user-attachments/assets/d8d54e64-d217-4ebe-b18e-3954bd83661e" width="30%" />
</p>
---

## Author

- **Taing ChingSong**
