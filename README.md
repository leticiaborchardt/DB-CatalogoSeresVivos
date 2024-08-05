<div align="center">
  <h2>Banco de Dados - Catálogo de Seres Vivos</h2>
   <div>
     Este é um projeto de banco de dados que simula um catálogo de seres vivos com base na sigla ReFiCOFaGE e biodiversidade.
    </div>
</div>

## 📌 Conteúdo

- [O Projeto](#-o-projeto)
- [Tecnologias e Conhecimentos Aplicados](#-tecnologias-e-conhecimentos-aplicados)
- [Tabelas e Relacionamentos](#-tabelas-e-relacionamentos)
- [Autoria](#-autoria)

## 📖 O Projeto

Este projeto implementa um banco de dados relacional para armazenar informações sobre biodiversidade, incluindo reinos, filos, classes, ordens, famílias, gêneros, espécies, países, biomas, localizações, doenças e interações ecológicas. O banco de dados foi projetado para suportar consultas complexas e fornecer uma estrutura robusta para armazenar dados.

## 🧠 Tecnologias e Conhecimentos Aplicados

- PostgreSQL
- PostGIS

## 🔗 Tabelas e Relacionamentos

Para a catalogação dos seres vivos, utilizamos como base a sigla ReFICOFaAGE (reino, filo, classe, ordem, família, gênero e espécie). Para cada componente da sigla, foi criada uma tabela no banco de dados, cada tabela referencia o ID da tabela acima na hierarquia. 
Existem também tabelas que referenciam a localização de cada espécie, utilizando o tipo de dado Geography através da extensão PostGIS. Foi adicionada a dinâmica de histórico de espécies para que seja observado as suas evoluções, tabelas que representam as interações ecológicas de cada espécie, doenças acometidas, além de triggers e views que contribuem para o funcionamento do sistema.
[Acessar documentação completa](https://docs.google.com/document/d/1eX6teJWwXU7LJA2MC90gjusVKRKUL5oo4_BUeR3rQAg/edit?usp=sharing)

### Diagrama das tabelas
![Diagrama](https://i.ibb.co/DbhQH2C/bd-Seres-Vivos-drawio-1.png)

## ✍🏻 Autoria

Desenvolvido por:
- Caique Bezerra (https://github.com/caiqueb05)
- Júlia Montibeler (https://github.com/julia-montibeler)
- Letícia Borchardt (https://github.com/leticiaborchardt)
