const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const cartController = require('./controllers/cartController');
const favoriteController = require('./controllers/favoriteController');
const UserController = require('./controllers/UserController');

const app = express();
const PORT = 3000;

app.use(bodyParser.json());
app.use(cors());

// Rotas relacionadas ao carrinho
app.post('/cart/add', cartController.addToCart);
app.get('/cart', cartController.getCartItems);
app.delete('/cart/:cartItemId', cartController.removeFromCart);  // Corrigida

// Rotas relacionadas aos favoritos
app.get('/favorite', favoriteController.getFavorites);
app.delete('/favorite/remove', favoriteController.removeFromFavorites);
app.post('/favorite/add', favoriteController.addToFavorites);

// Rotas de usuário
app.post('/register', UserController.register);
app.post('/login', UserController.login); 

app.listen(PORT, () => {
    console.log(`Servidor rodando na porta ${PORT}`);
});
