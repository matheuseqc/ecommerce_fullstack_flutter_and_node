const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const cartController = require('./controllers/cartController');
const favoriteController = require('./controllers/favoriteController');
const UserController = require('./controllers/UserController');
const index = require('./controllers/index');

const app = express();
const PORT = 3333;

app.use(bodyParser.json());
app.use(cors());

// Rotas relacionadas ao carrinho
app.post('/cart/add', cartController.addToCart);
app.get('/cart', cartController.getCartItems);
app.delete('/cart/:cartItemId', cartController.removeFromCart);
app.put('/update', cartController.updateCartItemQuantity);  // Corrigida

// Rotas relacionadas aos favoritos
app.get('/favorite', favoriteController.getFavorites);
app.delete('/favorite/remove', favoriteController.removeFromFavorites);
app.post('/favorite/add', favoriteController.addToFavorites);

// Rotas de usuário
app.post('/register', UserController.register);
app.post('/login', UserController.login); 

// Rota de pagamento Mercado Pago
app.post('/create', index.create);


app.listen(PORT, () => {
    console.log(`Servidor rodando na porta ${PORT}`);
});
