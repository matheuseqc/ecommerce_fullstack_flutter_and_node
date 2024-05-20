const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

exports.getFavorites = async (req, res) => {
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
};

exports.removeFromFavorites = async (req, res) => {
    const { productId } = req.body;
    try {
        const existingFavorite = await prisma.favorite.findFirst({
            where: {
                productId: productId,
            },
        });

        if (!existingFavorite) {
            return res.status(404).json({ error: 'Produto favorito não encontrado' });
        }

        await prisma.favorite.delete({
            where: {
                id: existingFavorite.id,
            },
        });

        res.status(200).json({ message: 'Produto removido dos favoritos com sucesso' });
    } catch (error) {
        console.error('Erro ao remover produto dos favoritos:', error);
        res.status(500).json({ error: 'Erro ao remover produto dos favoritos' });
    }
};


exports.addToFavorites = async (req, res) => {
    try {
        const { productId } = req.body;

        const favorite = await prisma.favorite.create({
            data: {
                productId: productId,
                
            },
        });

        res.status(201).json({ message: 'Produto adicionado aos favoritos com sucesso' });
    } catch (error) {
        console.error('Erro ao adicionar produto aos favoritos:', error);
        res.status(500).json({ error: 'Erro ao adicionar produto aos favoritos' });
    }
};
