const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function main() {
  await prisma.product.createMany({
    data: [
      {
        title: 'Camisa',
        body: 'Camisa de algodão',
        price: 39.99,
        image: 'assets/imagens/camisa.png',
      },
      {
        title: 'Videogame',
        body: 'Console de última geração',
        price: 499.99,
        image: 'assets/imagens/video.png',
      },
      {
        title: 'Tênis',
        body: 'Tênis esportivo',
        price: 79.99,
        image: 'assets/imagens/tenis.png',
      },
      {
        title: 'Celular',
        body: 'Smartphone com câmera de alta resolução',
        price: 699.99,
        image: 'assets/imagens/celular.png',
      },
      {
        title: 'Livro',
        body: 'Best-seller internacional',
        price: 19.99,
        image: 'assets/imagens/livro.png',
      },
      {
        title: 'Mochila',
        body: 'Mochila resistente para viagens',
        price: 49.99,
        image: 'assets/imagens/mochila.png',
      },
      {
        title: 'Óculos',
        body: 'Óculos de sol polarizados',
        price: 29.99,
        image: 'assets/imagens/oculos.png',
      },
      {
        title: 'Chinelo',
        body: 'Chinelo confortável',
        price: 19.99,
        image: 'assets/imagens/chinelo.png',
      },
      {
        title: 'Boné',
        body: 'Boné estiloso',
        price: 14.99,
        image: 'assets/imagens/bone.png',
      },
      {
        title: 'Fone de ouvido',
        body: 'Fone de ouvido sem fio',
        price: 59.99,
        image: 'assets/imagens/fone.png',
      },
    ],
  });
  console.log('Produtos criados com sucesso');
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
