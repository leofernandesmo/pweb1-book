# Capítulo 1 — Introdução à Web e Ferramentas

> **Vídeo curto explicativo**  
> *(link será adicionado posteriormente)*

---

## 1.1 — O que é a Web e como ela funciona

> **Vídeo curto explicativo**

A **World Wide Web (WWW)**, frequentemente confundida no senso comum com a própria **Internet**, constitui, na realidade, um vasto sistema de informações globais que opera como uma camada de abstração de serviço *sobre* a infraestrutura física de redes. 
Enquanto a Internet refere-se estritamente à interconexão física global de computadores (hardware, cabos, roteadores) e aos protocolos de transporte de dados de baixo nível (como o **TCP/IP**), a Web é fundamentada em um conceito de **hipermídia** distribuída. 
Neste ecossistema digital, documentos e recursos — sejam eles textos, imagens ou aplicações — são identificados de forma única através de **URIs** (Uniform Resource Identifiers) e interconectados por meio de hiperlinks, criando uma "teia" complexa e não linear de informações navegáveis que transcendem as fronteiras geográficas dos servidores onde estão hospedados.

Do ponto de vista operacional, o funcionamento da Web baseia-se na **arquitetura cliente-servidor**, regida majoritariamente pelo protocolo de aplicação **HTTP** (Hypertext Transfer Protocol). 
O ciclo de vida de uma interação na Web inicia-se quando um "agente de usuário" (o cliente, tipicamente um navegador), submete uma **requisição** a um servidor remoto solicitando um recurso específico; este servidor processa o pedido e retorna uma **resposta** contendo o conteúdo solicitado — geralmente estruturado semanticamente em **HTML** e estilizado visualmente via **CSS**. 
O navegador, então, interpreta esses códigos recebidos para renderizar a interface gráfica final para o usuário, ocultando toda a complexidade da troca de dados subjacente.


> ### 📜 Breve Histórico da Web
> 
> 
> A gênese da World Wide Web remonta a março de **1989**, nas instalações do **CERN** (Organização Europeia para a Pesquisa Nuclear), próximo a Genebra. Foi neste cenário que o cientista da computação britânico **Sir Tim Berners-Lee** redigiu a proposta inicial para um sistema de gestão de informações baseado em hipertexto, visando resolver a dificuldade de compartilhamento de dados entre cientistas de diferentes universidades.
> Em **1990**, utilizando um computador NeXT, Berners-Lee desenvolveu as pedras angulares da Web: a linguagem HTML, o protocolo HTTP e o primeiro navegador (chamado *WorldWideWeb*). A materialização deste projeto ocorreu quando o **[primeiro website da história](http://info.cern.ch/hypertext/WWW/TheProject.html)** foi publicado, servindo como uma página explicativa sobre o próprio projeto. Em 1993, o CERN colocou o software da Web em domínio público, catalisando a explosão da Internet comercial.
> **Referência:** [CERN - The birth of the Web](https://home.cern/science/computing/birth-web)



### 1.1.1 — Cliente, Servidor e Navegador

A arquitetura da Web é fundamentada em um modelo de distribuição de tarefas conhecido como **Cliente-Servidor**. Para compreender o funcionamento da rede em um nível de engenharia de software, é imperativo dissociar os papéis funcionais de cada componente, entendendo que a comunicação entre eles é estritamente protocolada.

#### O Cliente (Client)

No contexto técnico, o **cliente** é a entidade ativa que inicia a comunicação. Ele não se define pelo hardware (o computador ou smartphone), mas sim pelo software que submete uma requisição de serviço. Na terminologia do protocolo HTTP, o cliente é frequentemente referido como **User Agent** (Agente de Usuário). Sua função primária é formatar mensagens de solicitação (Requests) seguindo padrões definidos — especificando método, cabeçalhos e corpo — e enviá-las através da rede para um endereço específico. Embora o navegador seja o exemplo mais comum, scripts de automação (como *crawlers* ou *bots*), aplicações móveis e interfaces de linha de comando (como cURL) também atuam como clientes.

#### O Servidor (Server)

O termo **servidor** possui uma dualidade semântica na informática. Fisicamente, refere-se ao **hardware**: computadores de alto desempenho, otimizados para operar ininterruptamente (24/7), equipados com redundância de armazenamento (RAID) e conexão de banda larga de alta capacidade. Logicamente, e mais importante para o desenvolvimento web, refere-se ao **software servidor** (como Apache, Nginx ou IIS). Este software atua como um processo *daemon* (processo de segundo plano) que "escuta" (listening) portas específicas da rede — tradicionalmente a porta 80 para HTTP e 443 para HTTPS. Ao receber uma requisição do cliente, o software servidor processa a lógica necessária, acessa bancos de dados se preciso, e devolve o recurso ou uma mensagem de erro.

#### O Navegador (Browser)

O **navegador** é uma implementação específica de um cliente HTTP, projetado para interação humana. Sua complexidade técnica reside no **Motor de Renderização** (*Rendering Engine*), um componente de software responsável por receber o fluxo de dados brutos do servidor (texto HTML, regras CSS, scripts JS) e transformá-los em uma representação visual interativa. O navegador compila esses dados na memória do dispositivo construindo a **DOM** (Document Object Model), uma árvore estrutural de objetos que o usuário pode visualizar e manipular. Exemplos de motores de renderização incluem o *Blink* (usado no Chrome e Edge), *Gecko* (Firefox) e *WebKit* (Safari).


### 1.1.2 — Requisições e Respostas (HTTP)
*(conteúdo será preenchido posteriormente)*

### 1.1.3 — Como páginas são renderizadas
*(conteúdo será preenchido posteriormente)*

#### **Atividades — Seção 1.1**
- **Quiz:** Fundamentos da Web *(link será adicionado)*
- **GitHub Classroom:** Fluxo Cliente → Servidor → Navegador *(link será adicionado)*

---

## 1.2 — Ferramentas Essenciais para Desenvolvimento Web

> **Vídeo curto explicativo**

### 1.2.1 — Navegadores e DevTools
### 1.2.2 — VS Code e extensões recomendadas
### 1.2.3 — Git e GitHub (visão inicial)
### 1.2.4 — Ambientes online (CodePen, JSFiddle)

#### **Atividades — Seção 1.2**
- **Quiz:** Ferramentas e DevTools *(link será adicionado)*
- **GitHub Classroom:** Criar repositório inicial e enviar `hello.html` *(link será adicionado)*

---

## 1.3 — Estrutura de um Projeto Web

> **Vídeo curto explicativo**

### 1.3.1 — Arquivos e pastas
### 1.3.2 — Estrutura mínima de um projeto
### 1.3.3 — Boas práticas de organização

#### **Atividades — Seção 1.3**
- **Quiz:** Estrutura de projeto *(link será adicionado)*
- **GitHub Classroom:** Criar estrutura inicial de um mini‑site *(link será adicionado)*

---


# MATERIAL DE REFERÊNCIA ABAIXO ...


# 1. Introdução

In this chapter, we introduce the core ideas of **[Topic]**.

---

## 1.1 Descriptive Text

This book uses plain Markdown so it can be:

- Read directly on the web
- Exported or printed to **PDF**
- Mixed with **code**, **figures**, **videos**, and **audio** seamlessly

> In software engineering education, using open materials allows students to
> inspect not only the final text but also the structure of the book, its
> version history, and collaborative contributions.

## Quiz rápido

<div class="quiz" data-answer="b">
  <p>Qual tag define um parágrafo em HTML?</p>

  <button data-option="a">&lt;div&gt;</button>
  <button data-option="b">&lt;p&gt;</button>
  <button data-option="c">&lt;span&gt;</button>

  <p class="feedback"></p>
</div>


## Experimente o código

<div class="code-runner">
  <textarea class="code-input">
<h1>Hello, mundo!</h1>
<p>Modifique este HTML e clique em Executar.</p>
  </textarea>

  <button class="run-code">Executar</button>

  <iframe class="code-output"></iframe>
</div>



## Vídeo da aula

<iframe width="100%" height="400"
src="https://www.youtube.com/embed/SEU_VIDEO_ID"
title="Vídeo da aula"
frameborder="0"
allowfullscreen></iframe>


## Criando componentes interativos com Material for MkDocs

### Abas

=== "HTML"
    ```html
    <p>Exemplo HTML</p>
    ```

=== "CSS"
    ```css
    p { color: red; }
    ```


### Acordeões
??? note "Clique para expandir"
    Este é um conteúdo oculto.


### Cards

# Exemplos de Cards

<div class="grid cards">

-   :material-code-tags: **HTML**
    ---
    Introdução ao HTML e estrutura básica.

-   :material-palette: **CSS**
    ---
    Estilização, layout e responsividade.

-   :material-language-javascript: **JavaScript**
    ---
    Interatividade, DOM e APIs.

</div>

<div class="grid cards">
  <ul>
    <li> Introdução ao HTML e estrutura básica. </li>
    <li> Estilização, layout e responsividade. </li>
    <li> Interatividade, DOM e APIs. </li>
  </ul>
</div>


---

## 1.2 Images

Store images under `docs/figures/` and reference them with relative paths:

![Example diagram of the system](../figures/example-diagram.png "System Architecture – Example")

Rendered:

![Example diagram of the system](../figures/example-diagram.png "System Architecture – Example")

> ℹ️ Replace `example-diagram.png` with your actual diagram.

---

## 1.3 Source Code in Different Languages

Below are examples of fenced code blocks with language tags for syntax highlighting.

=== "Python"

```python
def greet(name: str) -> str:
    """Return a greeting message."""
    return f"Hello, {name}!"

if __name__ == "__main__":
    print(greet("Student"))
```

=== "JavaScript"

```javascript
function sum(a, b) {
  return a + b;
}

console.log("Result:", sum(2, 3));
```

=== "Java"

```java
public class Hello {
    public static void main(String[] args) {
        String name = (args.length > 0) ? args[0] : "Student";
        System.out.println("Hello, " + name + "!");
    }
}
```

You can add more languages as needed: `c`, `cpp`, `bash`, `html`, etc.

---

## 1.4 Video (YouTube or Other Streaming)

Markdown has no native `<video>` tag, but we can:

### A. Simple Link

```markdown
Watch the introduction video:  
https://www.youtube.com/watch?v=YOUR_VIDEO_ID
```

Rendered:

Watch the introduction video:
[https://www.youtube.com/watch?v=YOUR_VIDEO_ID](https://www.youtube.com/watch?v=YOUR_VIDEO_ID)

### B. Clickable Thumbnail

Assuming you have `docs/figures/example-video-thumb.png`:

```markdown
[![Watch the video](../figures/example-video-thumb.png)](https://www.youtube.com/watch?v=YOUR_VIDEO_ID "Intro Video")
```

Rendered:

[![Watch the video](../figures/example-video-thumb.png)](https://www.youtube.com/watch?v=YOUR_VIDEO_ID "Intro Video")

---

## 1.5 Audio (Podcast or Lecture)

### Simple External Link

```markdown
Listen to the companion podcast episode:  
https://example.com/podcast/episode-1
```

Rendered:

Listen to the companion podcast episode:
[https://example.com/podcast/episode-1](https://example.com/podcast/episode-1)

### Embedded Local Audio File

If you place `example-audio.mp3` in `docs/media/`:

```html
<audio controls>
  <source src="../media/example-audio.mp3" type="audio/mpeg">
  Your browser does not support the audio element.
</audio>
```

Rendered:

<audio controls>
  <source src="../media/example-audio.mp3" type="audio/mpeg">
  Your browser does not support the audio element.
</audio>

Most modern browsers will show a built-in audio player.

---

## 1.6 “Playground” Exercise

!!! example "Try it yourself"
1. Copy the Python `greet` function from this chapter.
2. Modify it to accept an optional parameter `course`, and print
`"Hello, <name>, welcome to <course>!"`.
3. Run it in your local environment or an online IDE (e.g., Replit, GitHub Codespaces).

---

## 1.7 Quick Quiz

!!! question "Concept check"
1. Why is using Markdown a good choice for open textbooks?
2. What are the advantages of hosting the book on GitHub?
3. How can a student generate a PDF from this book?

??? info "Suggested answers (click to expand)"
1. Markdown is simple, version-controllable, and tool-agnostic, and it can be converted to HTML/PDF and many other formats.
2. GitHub provides version control, collaboration, issue tracking, and free hosting via GitHub Pages.
3. Use the **“Print / Save PDF”** menu item, then the browser’s **Print → Save as PDF** option.

---

[:material-arrow-left: Back to Preface](../preface.md)
[:material-arrow-right: Go to Chapter 2 – First Steps](02-first-steps.md)
