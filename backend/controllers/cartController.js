const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

exports.addToCart = async (req, res) => {
    const { productId, quantity } = req.body;

    try {
        const existingCartItem = await prisma.cart.findFirst({
            where: { productId: productId },
        });

        if (existingCartItem) {
            // Se o item já estiver no carrinho, atualize apenas a quantidade
            const updatedCartItem = await prisma.cart.update({
                where: { id: existingCartItem.id },
                data: { quantity: existingCartItem.quantity + quantity },
                include: { product: true },
            });
            
            res.json(updatedCartItem);
        } else {

            const newCartItem = await prisma.cart.create({
                data: {
                    productId: productId,
                    quantity: quantity,
                },
                include: { product: true },
            });
            
            res.json(newCartItem);
        }
    } catch (error) {
        res.status(500).json({ error: 'Erro ao adicionar ao carrinho' });
    }
};

exports.getCartItems = async (req, res) => {
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
}; // Adicionei o fechamento correto aqui

exports.removeFromCart = async (req, res) => {
    const { cartItemId } = req.params;
    
    try {
        const cartItem = await prisma.cart.findUnique({
            where: { id: parseInt(cartItemId) },
        });
    
        if (!cartItem) {
            return res.status(404).json({ error: 'Item do carrinho não encontrado' });
        }
    
        await prisma.cart.delete({
            where: { id: parseInt(cartItemId) },
        });
    
        res.json({ message: 'Item removido do carrinho com sucesso' });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Erro ao remover item do carrinho' });
    }
};
