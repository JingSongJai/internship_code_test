const { validationResult } = require('express-validator');  

exports.errorHandler = (err, req, res) => {
    return res.status(500).json({ message: `Internal Server Error : ${err.message}` });
}

exports.validationHandler = (req, res, next) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(406).json({ message: errors.array() });
    }
    next();
}