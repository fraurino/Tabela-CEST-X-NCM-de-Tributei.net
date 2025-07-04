# Consulta NCM x CEST por UF (SP, MT, PR) via Tributei.net

Este projeto foi desenvolvido em **Lazarus Pascal** com o objetivo de consultar, de forma prática e automatizada, a tabela de **NCM x CEST** separada por **Unidades Federativas (UF)** diretamente do site [Tributei.net](https://tributei.net).

## 🔎 Sobre o Projeto

A aplicação realiza a leitura pública dos dados de NCM x CEST disponibilizados nos seguintes links:

- [Tabela NCM x CEST - São Paulo (SP)](https://tributei.net/blog/tabela-cest-ncm-de-sao-paulo-sp/)
- [Tabela NCM x CEST - Mato Grosso (MT)](https://tributei.net/blog/tabela-cest-ncm-de-mato-grosso-mt/)
- [Tabela NCM x CEST - Paraná (PR)](https://tributei.net/blog/tabela-cest-ncm-de-parana-pr/)

A consulta é feita diretamente por **requisição HTTP**, sem depender de banco de dados local, garantindo sempre a informação atualizada conforme publicada no blog.
![image](https://github.com/user-attachments/assets/27d818c7-18c3-4847-9186-e2639ab752ff) <p>
![image](https://github.com/user-attachments/assets/98097f22-1ada-44dc-a607-6a2bb8230354)



## ⚠️ Aviso Legal

- Todas as informações consultadas são **públicas** e disponibilizadas livremente pelo site Tributei.net.
- Este projeto **não viola** nenhuma política de acesso, visto que a coleta de dados simula o mesmo acesso feito por qualquer navegador convencional.
- Não há coleta, modificação, redistribuição ou comercialização dos dados.

## 📦 Tecnologias Utilizadas

- **Lazarus Pascal** (Free Pascal)
- **idHTTP** para requisições web
- **JSON** para leitura da resposta
- Interface básica com `StringGrid` para exibição dos dados

## ✅ Funcionalidades

- Escolha da UF (SP, MT ou PR)
- Leitura dinâmica da tabela no site Tributei.net
- Exibição automática dos dados em tabela local (StringGrid)
- Sem necessidade de banco de dados

## 🧑‍💻 Como Usar

1. Abra o projeto `.lpi` no **Lazarus IDE**
2. Compile e execute
3. Escolha a UF desejada
4. A aplicação buscará os dados e os exibirá automaticamente

## 📄 Licença

Este projeto é de código aberto, sob a licença MIT. Sinta-se livre para usar, modificar ou contribuir.

---

Feito com 💻 por Aurino - [Engenheiro de Software]
