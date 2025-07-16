const express = require('express'); 
const app = express(); 
const productRouter = require('./routers/product_router');
const connection = require('./connection/db');
const { errorHandler } = require('./middlewares/error_handler');
const logger = require('./middlewares/logger');
const cors = require('cors');

app.use(cors());
app.use(express.json());
app.use(logger);

app.use('/product', productRouter);

app.use(errorHandler);

app.listen(3000, () => {
    console.log('Server running at http://localhost:3000');
});