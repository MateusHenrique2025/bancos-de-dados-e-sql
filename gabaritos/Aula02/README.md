# Gabarito - Aula 02: Modelo Conceitual e Diagrama Entidade-Relacionamento (DER)

## Objetivo
Orientar a avaliação da capacidade do aluno de abstrair requisitos de negócio, identificar entidades fortes e associativas, definir atributos chave e mapear cardinalidades mínimas e máximas (`1:1`, `1:N`, `N:N`).

## Checklist de Verificação
- [ ] O aluno representou entidades em retângulos e relacionamentos em losangos (notação clássica de Chen) ou formato de tabela conceitual?
- [ ] O aluno identificou corretamente a cardinalidade `1:N` entre Turma e Alunos (via Matrícula)?
- [ ] O aluno identificou a cardinalidade `N:N` entre Médicos e Pacientes (resolvida pela entidade associativa Consulta)?
- [ ] As chaves primárias foram sublinhadas ou marcadas como `PK`?

---

## Solução do Laboratório

### Estudo de Caso 1: Sistema de Gestão Escolar (DER Conceitual)
* **Entidades:** `ALUNO`, `TURMA`, `CURSO`, `PROFESSOR`, `MATRICULA`
* **Relacionamentos e Cardinalidades:**
  * `CURSO (1,1) --- possui ---> (1,N) TURMA`
  * `PROFESSOR (1,1) --- leciona ---> (0,N) TURMA`
  * `ALUNO (1,N) --- realiza ---> (0,N) MATRICULA`
  * `TURMA (1,1) --- recebe ---> (1,N) MATRICULA`

### Estudo de Caso 2: E-commerce e Pedidos
* **Entidades:** `CLIENTE`, `PEDIDO`, `PRODUTO`, `ITEM_PEDIDO`
* **Relacionamentos:**
  * `CLIENTE (1,1) --- realiza ---> (0,N) PEDIDO`
  * `PEDIDO (1,N) --- contem ---> (1,1) ITEM_PEDIDO`
  * `PRODUTO (1,1) --- compoe ---> (0,N) ITEM_PEDIDO`
* **Justificativa da Associativa:** O relacionamento entre `PEDIDO` e `PRODUTO` é `N:N`. Atributos como `quantidade` e `preco_unitario_praticado` pertencem ao evento da venda, devendo residir na entidade associativa `ITEM_PEDIDO`.

---

## Pontos Comuns de Dificuldade
* **Colocar atributos na entidade errada:** Alunos costumam colocar `valor_pago` dentro de `PRODUTO`. Explique que o produto tem um preço sugerido de tabela, mas o valor efetivamente cobrado na data da compra pertence ao item do pedido.
