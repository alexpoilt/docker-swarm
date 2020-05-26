# Docker Swarm

Swarm é o orquestrador nativo embutido na **Docker Engine** capaz de transformar máquinas distintas que estão executando o Docker em um cluster com apenas alguns comandos.

## Provisionamento

Para este **Vagrantfile** basta clonar o repositório e iniciar as máquinas:

```bash
git clone https://github.com/hector-vido/docker-swarm.git
cd docker-swarm
vagrant up
```

Para acessar as máquinas, procure pela máquina desejada e execute o `ssh`:

```bash
vagrant status
vagrant ssh manager
```

## Máquinas

Ao final do provisionamento, existirão quatro máquinas:

| Máquina | Endereço     | Papel                   |
|---------|--------------|-------------------------|
| manager | 172.27.11.10 | gerenciar, trabalhar    |
| worker1 | 172.27.11.20 | trabalhar               |
| worker2 | 172.27.11.30 | trabalhar               |
| storage | 172.27.11.40 | compartilhar diretórios |

## Inicialização do Swarm

O Swarm já estará funcionando quando as máquinas terminarem o provisionamento. De qualquer modo o comando utilizado para a inicialização deste Swarm, executando a partir da **manager** é:

```bash
docker swarm init --advertise-addr=172.27.11.10
```

Para adicionar outras máquinas, basta copiar o comando exibido na saída da execução anterior, ou obter novos tokens através do seguinte comando executado na **manager**:

```
docker swarm join-token manager # para outros managers
docker swarm join-token worker  # para outros workers
```

## Jenkins

É necessário instalar o binário do Docker no contêiner do Jenkins. O ideal é criar sua própria imagem baseado na imagem do Jenkins, mas por questões de facilidade deixarei os passos aqui:

```
docker exec -u root -ti 1a00f477f1bf sh -c 'apk update && apk add docker'
```
