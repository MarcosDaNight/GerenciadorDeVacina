<img src="https://i.imgur.com/pAqRIQk.png" alt="logo1" align="right" style="height: 100px; width:100px;"/> <img src="https://imgur.com/XcEOFuW.png" align="right" alt="logo2" style="height: 100px; width:100px;"/>


## GerenciadorDeVacina :hospital:
Repositório para o projeto da Disciplina de PLP
#### Descrição :pencil:
> O gerenciador de vacinas permite o cadastro dos pacientes e das vacinas tomadas. Dessa forma, é possível ter o controle das doses que estão sendo aplicadas evitando que pacientes tomem doses desnecessárias. Além disso, é possível também que os pacientes consigam visualizar qual vacina tomaram.

#### Demonstração :computer:
- Funcional: [Vídeo Funcional](https://youtu.be/ODa13h3eF4o)
- Lógico: [Vídeo Lógico](https://youtu.be/zavmHjDfTu4)
#### Funcionalidades (menu do projeto Haskell) :heavy_check_mark:
- Cadastro dos pacientes:
  > Entrando como admin, o cadastro é feito a partir do nome do paciente, CPF e data de nasciemento.
  ```
  Digite o nome do paciente: (Sem caracteres especiais)
  Raiani

  Digite o cpf do paciente: (Apenas números)
  123456789

  Digite a data de nascimento do paciente:
  05/03/2001

  O paciente foi cadastrado com sucesso!
  ```
- Cadastro das vacinas:
  > Entrando como admin, o cadastro é feito a partir do nome da vacina, ID, quantidade de doses e o prazo para a próxima dose.
  ```
  Digite o ID da vacina: (Sem caracteres especiais, entre 0-9)
  4

  Digite o nome da vacina:
  pfizer

  Digite o prazo para proxima dose da vacina em meses: (Apenas números)
  5

  Digite a quantidade de doses da vacina: (Apenas números)
  2

  A vacina foi cadastrada com sucesso!
  ```
- Atribuir uma vacina a um paciente:
  > Entrando como admin, a atribuição é feita a partir do ID da vacina, CPF do paciente e a data de aplicação.
  ```
  Digite o ID da Vacina:
  4

  Digite o CPF do paciente:
  123456789

  Digite a data da dose:
  03/09/2021
  "Vacina adicionada com sucesso!"
    ```
- Visualizar os próprios dados sendo paciente:
  > Entrando como paciente, é possível visualizar qual vacina foi tomada.
  ```
  Digite o CPF do paciente: 
  123456789
  Nome: Raiani | CPF: 123456789 | Vacina Tomada: pfizer
  ```
