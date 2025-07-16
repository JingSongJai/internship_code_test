const router = require('express').Router(); 
const productController = require('../controllers/product_controller');
const productValidator = require('../validators/product_validator'); 
const { validationHandler } = require('../middlewares/error_handler');

router.get('/', productController.getProducts);
router.get('/:id', productController.getProduct);
router.post('/', productValidator, validationHandler, productController.addProduct);
router.put('/:id', productValidator, validationHandler, productController.updateProduct);
router.delete('/:id', productController.deleteProduct);

module.exports = router;