const { body } = require('express-validator');

productValidators = [
    body('productName')
        .notEmpty().withMessage('productName is required!'),
    body('price')
        .notEmpty().withMessage('price is required!')
        .isLength({ min: 0 }).withMessage('Price can\'t be negative!'),
    body('stock')
        .notEmpty().withMessage('stock is required!')
        .isLength({ min: 0 }).withMessage('Stock can\'t be negative!')
];

module.exports = productValidators;