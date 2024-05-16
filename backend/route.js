const express = require('express');
const { PrismaClient } = require('@prisma/client');
const bodyParser = require('body-parser');
const cors = require('cors');

const prisma = new PrismaClient();
const app = express();
const PORT = 3000;

app.use(bodyParser.json());
app.use(cors());

// Adicionar produto ao carrinho
app.post('/cart/add', async (req, res) => {
    const { productId, quantity } = req.body;

    try {
        const product = await prisma.product.findUnique({
            where: { id: productId },
        });

        if (!product) {
            return res.status(404).json({ error: 'Produto não encontrado' });
        }

        const cartItem = await prisma.cart.create({
            data: {
                productId: productId,
                quantity: quantity,
            },
            include: {
                product: true,
            },
        });

        res.json(cartItem);
    } catch (error) {
        res.status(500).json({ error: 'Erro ao adicionar ao carrinho' });
    }
});

// Buscar itens do carrinho
app.get('/cart', async (req, res) => {
    try {
        const cartItems = await prisma.cart.findMany({
            include: {
                product: true,
            },
        });
        res.json(cartItems);
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Erro ao buscar itens do carrinho' });
    }
});

// Buscar favoritos
app.get('/favorite', async (req, res) => {
    try {
        const favorites = await prisma.favorite.findMany({
            include: {
                product: true,
            },
        });
        res.json(favorites);
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Erro ao buscar favoritos' });
    }
});

// Adicionar produto aos favoritos
app.post('/favorite/remove', async (req, res) => {
  try {
      const { productId, userId } = req.body;

      const favorite = await prisma.favorite.deleteMany({
          where: {
              productId: productId,
              userId: userId,
          },
      });

      if (favorite.count === 0) {
          return res.status(404).json({ error: 'Favorito não encontrado' });
      }

      res.status(200).json({ message: 'Produto removido dos favoritos com sucesso' });
  } catch (error) {
      console.error('Erro ao remover produto dos favoritos:', error);
      res.status(500).json({ error: 'Erro ao remover produto dos favoritos' });
  }
});

app.listen(PORT, () => {
    console.log(`Servidor rodando na porta ${PORT}`);
});
