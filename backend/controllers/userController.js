const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();


exports.register = async (req, res) => {
    const { username, email, password } = req.body;

    try {
        // Verifica se o email já está em uso
        const existingUser = await prisma.user.findUnique({
            where: { email: email },
        });

        if (existingUser) {
            return res.status(400).json({ error: 'O email já está em uso' });
        }

        // Hash da senha
        

        // Cria o usuário no banco de dados
        const newUser = await prisma.user.create({
            data: {
                username: username,
                email: email,
                password: password,
            },
        });

        res.status(201).json({ message: 'Usuário cadastrado com sucesso', user: newUser });
    } catch (error) {
        console.error('Erro ao cadastrar usuário:', error);
        res.status(500).json({ error: 'Erro ao cadastrar usuário' });
    }
};

exports.login = async (req, res) => {
    const { email, password } = req.body;
    
    try {
        // Verifica se o email e a senha foram passados na solicitação
        if (!email || !password) {
            return res.status(400).json({ error: 'O email e a senha são obrigatórios' });
        }

        // Verifica se o usuário existe
        const user = await prisma.user.findUnique({
            where: {
                email: email,
            },
        });
    
        if (!user) {
            return res.status(404).json({ error: 'Usuário não encontrado' });
        }
    
        // Verifica a senha
        if (password !== user.password) {
            return res.status(401).json({ error: 'Senha incorreta' });
        }
    
        // Sucesso no login
        res.status(200).json({ message: 'Login bem-sucedido', user: user });
    } catch (error) {
        console.error('Erro ao fazer login:', error);
        res.status(500).json({ error: 'Erro ao fazer login' });
    }
};


