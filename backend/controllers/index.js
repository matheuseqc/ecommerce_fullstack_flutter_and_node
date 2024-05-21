const { MercadoPagoConfig, Preference } = require('mercadopago');

const accessToken = process.env.API_KEY;
const client = new MercadoPagoConfig({ accessToken });

exports.create = async (req, res) => {
  try {
    const { title, quantity, unit_price } = req.body;

    const preference = new Preference(client);
    const response = await preference.create({
      body: {
        items: [
          {
            title,
            quantity,
            unit_price
          }
        ]
      }
    });

    console.log(response); // Verifique a resposta no console para depuração

    // Verifique se a chave 'init_point' está presente na resposta
    if (response && response.init_point) {
      const checkoutURL = response.init_point;
      console.log('Checkout URL:', checkoutURL);
      res.json({ checkoutURL }); // Envie a URL de checkout para o front-end
    } else {
      throw new Error('URL de checkout não encontrada na resposta da API');
    }
  } catch (error) {
    console.error('Erro ao criar preferência:', error);
    res.status(500).json({ error: 'Erro ao criar preferência' });
  }
};
