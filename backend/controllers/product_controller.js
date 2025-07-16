const { sql, pool, poolConnection } = require('../connection/db');

async function getProducts(req, res, next) {
    try {
        const page = parseInt(req.query.page) || 1; 
        const per_page = parseInt(req.query.per_page) || 10; 
        const offset = (page - 1) * per_page;
        const name = req.query.name || ''; 
        const sort = req.query.sort || ''; 
        const order = req.query.order || ''; 

        const allowedSorts = ['PRICE', 'STOCK']; 
        const allowedOrders = ['ASC', 'DESC']; 

        const sortField = allowedSorts.includes(sort.toUpperCase()) ? sort.toUpperCase() : 'PRODUCTID'; 
        const orderField = allowedOrders.includes(order.toUpperCase()) ? order.toUpperCase() : 'ASC'; 

        const query = `
                        SELECT PRODUCTID AS id, PRODUCTNAME AS productName, PRICE AS price, STOCK AS stock 
                        FROM PRODUCTS
                        WHERE PRODUCTNAME LIKE @name
                        ORDER BY ${sortField} ${orderField}
                        OFFSET @offset ROWS
                        FETCH NEXT @perPage ROWS ONLY;

                        SELECT COUNT(*) AS total FROM PRODUCTS;
                        `

        await poolConnection; 
        const result = await pool.request()
                                    .input('offset', sql.Int, offset)
                                    .input('perPage', sql.Int, per_page)
                                    .input('name', sql.VarChar, `%${name}%`)
                                    .query(query);

        const products = result.recordsets[0]; 
        const total = result.recordsets[1][0].total; 
        const totalPage = Math.ceil( total / per_page );

        return res.json({ 
            message: 'Products Retreived!', 
            page, 
            totalPage, 
            total,
            data: products
        });
    }
    catch (err) {
        next(err);
    }
}

async function getProduct(req, res, next) {
    try {
        if (!req.params.id) return res.status(406).json({ message: 'id params required!' });

        await poolConnection;
        const exist = await pool.request()
                                .input('id', sql.Int, req.params.id)
                                .query('SELECT * FROM PRODUCTS WHERE PRODUCTID = @id');

        if (exist.recordset.length === 0) {
            return res.status(404).json({ message: 'Product not found!' });
        }

        await poolConnection; 
        const result = await pool.request()
                                 .input('id', sql.Int, req.params.id)
                                 .query(`
                                    SELECT PRODUCTID AS id, PRODUCTNAME AS productName, PRICE AS price, STOCK AS stock
                                    FROM PRODUCTS WHERE PRODUCTID = @id`);

        return res.json({ message: 'Product Retreived!', data: result.recordset[0] });
    }
    catch (err) {
        next(err);
    }
}

async function addProduct(req, res, next) {
    try {
        await poolConnection; 
        const result = await pool.request()
        .input('name', sql.NVarChar(100), req.body.productName)
        .input('price', sql.Decimal, req.body.price)
        .input('stock', sql.Int, req.body.stock)
        .query(`INSERT INTO PRODUCTS(PRODUCTNAME, PRICE, STOCK) VALUES(@name, @price, @stock);
            
                SELECT PRODUCTID AS id, PRODUCTNAME AS productName, PRICE AS price, STOCK AS stock 
                FROM PRODUCTS WHERE PRODUCTID = SCOPE_IDENTITY();
            `);

        return res.json({ message: 'Product Added!', data: result.recordsets[0][0] });
    }
    catch (err) {
        next(err);
    }
}

async function updateProduct(req, res, next) {
    try {
        if (!req.params.id) return res.status(406).json({ message: 'id params required!' });

        await poolConnection;
        const exist = await pool.request()
                                .input('id', sql.Int, req.params.id)
                                .query('SELECT * FROM PRODUCTS WHERE PRODUCTID = @id');

        if (exist.recordset.length === 0) {
            return res.status(404).json({ message: 'Product not found!' });
        }

        await poolConnection; 
        const result = await pool.request()
                                 .input('name', sql.NVarChar(100), req.body.productName)
                                 .input('price', sql.Numeric, req.body.price)
                                 .input('stock', sql.Int, req.body.stock)
                                 .input('id', sql.Int, req.params.id)
                                 .query('UPDATE PRODUCTS SET PRODUCTNAME = @name, PRICE = @price, STOCK = @stock WHERE PRODUCTID = @id');
        
        return res.json({ message: 'Product Updated!', data: result.recordset });
    }
    catch (err) {
        next(err);
    }
}

async function deleteProduct(req, res, next) {
    try {
        if (!req.params.id) return res.status(406).json({ message: 'id params required!' });

        await poolConnection;
        const exist = await pool.request()
                                .input('id', sql.Int, req.params.id)
                                .query('SELECT * FROM PRODUCTS WHERE PRODUCTID = @id');

        if (exist.recordset.length === 0) {
            return res.status(404).json({ message: 'Product not found!' });
        }

        await poolConnection; 
        const result = await pool.request()
                                 .input('id', sql.Int, req.params.id)
                                 .query('DELETE PRODUCTS WHERE PRODUCTID = @id');

        return res.json({ message: 'Product Deleted!', data: result.recordset });
    }
    catch (err) {
        next(err);
    }
}

module.exports = {
    getProducts, 
    getProduct, 
    addProduct, 
    updateProduct, 
    deleteProduct
}