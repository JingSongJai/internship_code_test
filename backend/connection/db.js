const sql = require('mssql'); 
require('dotenv').config();

const config = {
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_DATABASE,
    server: process.env.DB_SERVER,
    port: parseInt(process.env.DB_PORT),
    options: {
        encrypt: false,
        trustServerCertificate: true
    }
}

const pool = new sql.ConnectionPool(config);
const poolConnection = pool.connect();

module.exports = { sql, pool, poolConnection };