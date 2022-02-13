*** Settings ***
Documentation     https://docs.openbank.stone.com.br/docs/referencia-da-api/
Resource          ResourceAPI.robot

*** Test Cases ***
Consulta de Saldo
    Dado que estou logado na API
    Quando consulto meu saldo 
    Então meu saldo é exibido com sucesso 

Realização de transferência interna
    Dado que estou logado na API
    E realizo uma transferência interna de R$50,00
    Então meu saldo atualizado é exibido com sucesso 

Consulta do Extrato
    Dado que estou logado na API
    Quando Realizo uma consulta de Extrato
    Então meu Extrato é exibido com Sucesso