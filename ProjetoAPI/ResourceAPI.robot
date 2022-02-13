*** Settings ***
Library        RequestsLibrary
Library        Collections


*** Variables ***
${url_token}                 https://login.sandbox.stone.com.br/auth/realms/stone_account/protocol/openid-connect/token
${base_url}                  https://sandbox-api.openbank.stone.com.br/api/v1/accounts
${account_id}                bccd3bf7-3369-4622-b769-71f93d66da87
${base_transferencia}        https://sandbox-api.openbank.stone.com.br/api/v1/dry_run/internal_transfers



*** Keywords ***
#Consulta de Saldo
Dado que estou logado na API
    ${body}=                      Create Dictionary          client_id=admin-cli                               grant_type=password    username=desafioqastone@gmail.com    password=desafioqa
    ${header}=                    Create dictionary          content_type=application/x-www-form-urlencoded
    ${response}=                  POST                       ${url_token}                                      headers=${header}      data=${body}
    ${accessToken}=               evaluate                   $response.json().get("access_token")
    ${token}=                     catenate                   Bearer                                            ${accessToken}
    Should Be Equal As Strings    ${response.status_code}    200                                               #valida status code
    ${tokenValido}=                  Create Dictionary          Authorization=${token}
    Set Global Variable           ${tokenValido}

Quando consulto meu saldo
    Create Session                GET                        ${base_url}/${account_id}/balance                
    ${retornoSaldo}=              GET                        ${base_url}/${account_id}/balance                            headers=${tokenValido}
    Set Global Variable           ${retornoSaldo}

Então meu saldo é exibido com sucesso 
    ${balance}                    Set Variable                ${retornoSaldo.json()['balance']}
    Log to Console                Saldo é: ${balance}
    Should Be Equal As Strings    ${retornoSaldo.status_code}  200

E realizo uma transferência interna de R$50,00
    ${body1}=                      Create Dictionary           amount=5000                                        account_id=bccd3bf7-3369-4622-b769-71f93d66da87           account_code=58859     
    ${header}=                     Create dictionary           content_type=application/json
    ${saldoAtualizado}=            POST                        ${base_transferencia}                              headers=${tokenValido}                                                         
    Set Global Variable            ${saldoAtualizado}  

Então meu saldo atualizado é exibido com sucesso 
    ${internal_transfers}            Set Variable             ${saldoAtualizado.json()['internal_transfers']}   
    Log To Console                   Saldo é: ${saldoAtualizado}
    Should Be Equal As Strings       ${saldoAtualizado.status_code}    202

Quando Realizo uma consulta de Extrato
    Create Session       GET          ${base_url}/${account_id}/statement
    ${retornaExtrato}    GET          ${base_url}/${account_id}/statement         headers=${tokenValido}
    Set Global Variable               ${retornaExtrato}    

Então meu Extrato é exibido com Sucesso
    ${statement}                        Set Variable                                ${retornaExtrato.json()['data']}
    Log To Console                                                                  ${retornaExtrato}
    Should Be Equal As Strings                                                      ${retornaExtrato.status_code}              200