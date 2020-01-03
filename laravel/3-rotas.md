# Rotas

Usando Closure
==============

> **closure** - Funções anônimas do PHP. Pode ser passada como um objeto, atribuir a uma variável, passar como parâmetro para outras funções/métodos ou até mesmo *serializar* (transformar um objeto em uma forma binária ou em formato de texto para poder transmiti-lo via rede ou armazenar seu conteúdo sem perda de dados).

```
Route::get('/', function () {
    return 'Hello, world!';
});
```

Quando o closure da rota ou método controlador terminada sua execução, o contéudo é retornado para fluir na pilha de resposta e pelo **middleware** antes de ser retornado ao usuário.

> **middleware** - Série de *wrappers* que permeiam um aplicativo e filtram e decoram suas entradas e saídas. Existem vários *wrappers* envolvidos no ciclo de solicitaçao e resposta do Larabel.

> **wrappers** - classes utilitárias cuja as funcionalidades que fornece são implementadas em outro lugar, biblioteca ou aplicação utilitária. A biblioteca phpGTK, por exemplo, contem classes wrappers para a biblioteca nativa do sistema operacional.

## Método estático

Utilizamos o facade **Route**, mas poderiamos ter utilizado:

```
$route->get('/', function(){
    return 'Hello, world!';
});
```

> **facades** - classes que fornecem acesso simples a partes básicas de funcionalidade do Laravel. Todos estão disponíveis no namespace global (**\Log** é um alias para **\Illuminate\Support\Facades\Log**), e usam métodos estáticos para acessar recursos não estáticos.

## Verbos de rota

Toda solicitação HTTP tem um "verbo", ou ação, que a acompanha. O laravel permite definir rotas de acordo com o verbo usado; os mais comuns são GET e POST, seguidos de PUT, DELETE e PATCH. Cadas método comunica algo diferente para o servidor e para o código sobre as intenções do chamador.

## Manipulando rotas

Rota chamando método controlador (**()index** do controlador **App\Http\Controllers\WelcomeController**):

```Route::get('/', 'WelcomeController@index');```

## Parametros

```
Route::get('users/{id}/comments/{commentId}', function(
    $id,
    $commentId
    ) {
    //
});
```

A ordem define a correspondência entre o(s) parametro(s) da rota e o(s) parametro(s) do método (da esquerda para a direita). Os nomes podem ser diferentes:

```
Route::get('users/{id}/comments/{commentId}', function($x, $y) {
    //
});
```
> É recomendável mantê-los iguais para ajudar na manutenção futura do código.

## Parametros Opcionais

É preciso fornecer um valor-padrão para a variável correspondente da rota.

```
Route::get('users/{id?}', function($id = 'fallbackId') {
    //
});
```

## Restrições de Rota

Expressões regulares (regexes) podem definir que uma rota só pode ser usada se um parâmetro atender a requesitos específicos. Exemplos:

```
Route::get('users/{id}', function($id) {
    //
})->where('id', '[0-9]+');

Route::get('users/{username}', function($username) {
    //
})->where('username', '[A-Za-z]+');

Route::get('posts/{id}/{slug}', function($id, $slug) {
    //
})->where(['id' => '[0-9]+', 'slug' => '[A-Za-z]+']);
```

Se o Laravel visitar o caminho da rota, mas o regex rejeitar o parâmetro, **ele não será encontrado**. As rotas são procuradas de cima para baixo, "users/abc" pularia o primeiro closure é encontraria uma correspondência no segundo closure. Já "posts/abc/123" retornaria *erro 404 Not Found*.

Nomes de Rota
=============

Referenciamos uma rota em outro lugar do aplicativo (views) pelo seu caminho utilizando o helper **url()**.

```
<a href="<?php echo url('/'); ?>">
// exibe <a href="http://blog/">
```

Podemos apelidar as rotas. Não sendo necessário reescrever os links do frontend se os caminhos mudarem:

```Route::get('/members/{id}', 'MemberController@show')->name('members.show');```

```<a href="<?php echo route('members,show', ['id' => 14]); ?>">```

> **helpers** - função PHP acessível globalmente que facilita a execução de alguma outra funcionalidade, por exemplo "str_replace".

### Convenções de nomenclaturas de rotas

A rota pode ser nomeada como quisermos, mas a convenção comum é usar **nome do recurso no plural, um ponto e a ação**. Exemplo:

```
photos.index
photos.create
photos.store
photos.show
photos.edit
photos.update
photos.destroy
```
Aprenda mais sobre as convenções em "Controladores de recursos", adiante.

> Um boa prática é usar nomes de rotas em vez de caminhos na referência às rotas, e portanto usar o helper route() em vez de url().

## Passando parametrôs com helper route()

Há diferentes maneiras de passar parâmetros:

* Opção 1 - Sem chaves, os parâmetros são atribuídos em ordem.

```
route('users.comments.show', [1, 2]);
http://myapp.com/users/1/comments/2
```

* Opção 2 - Com chave são associados aos parâmetros de rota que correspondem às suas chaves.

```
route('users.comments.show', ['userId' => 1, 'commentId' => 2]);
http://myapp.com/users/1/comments/2
```

```
route('users.comments.show', ['commentId' => 2, 'userId' => 1]);
http://myapp.com/users/1/comments/2
```

* Opção 3 - Outras informações não associadas aos parâmetros de rota são adicionadas como parâmetros de consulta.

```
route('users.comments.show', ['userId' => 1, 'commentId' => 2, 'opt' => 'a']);
http://myapp.com/users/1/comments/2?opt=a
```

Grupos de rotas
===============

Por padrão um grupo de rotas não faz nada, não é diferente de separar com comentários no código. No entanto, o array vazio a seguir permite passar várias definições que serão aplicadas ao grupo de rotas inteiro.

```
Route::group([], function() {
    Route::get('hello', function() {
        return 'hello';
    });
    Route::get('world', function() {
        return 'world';
    });
});
```

## Middleware

Uso mais comum. No exemplo, criamos um grupo de rotas para as views do **dashboard** e **account** e aplicamos o middleware **auth** a ambas. Os usuários terão que fazer login no aplicativo para visulizar o dashboard ou a página da conta.

```
Route::group(['middleware' => 'auth'], function() {
    Route::get('dashboard', function() {
        return view('dashboard');
    });
    Route::get('account', function() {
        return view('account');
    });
});
```

## Prefixos de caminho

```
Route::group(['prefix' => 'api'], function() {
    Route::get('/', function() {
        // Manipula o caminho /api
    });
    Route::get('users', function() {
        // Manipula o caminho /api/users
    });
});
```

## Roteamento de subdomínio

Você pode querer apresentar diferentes seções do aplicativo (ou aplicativos totalmente distintos) para diferentes subdomínios.

```
Route::group(['domain' => 'api.myapp.com'], function() {
    Route::get('/', function() {
        //
    });
});
```

Ou ainda, definir parte do subdomínio como um parâmetro. Isso costuma ser feito em modelos multitenancy (multi-inquilino) como o Slack, em que cada empresa obtém seu próprio subdomínio.

```
Route::group(['domain' => '{account}.myapp.com'], function() {
    Route::get('/', function($account) {
        //
    });
    Route::get('users/{id}', function($account, $id) {
        return view('account');
    });
});
```

## Prefixo de namespace

Você pode evitar referências de controlador longas em grupos

```
// App\Http\Controllers\ControllerA
Route::get('/', 'ControllerA@index');
Route::group(['namespace' => 'API'], function() {
    // App\Http\Controllers\API\ControllerB
    Route::get('/', 'ControllerB@index');
});
```

## Prefixo de nome

Podemos prefixar strings ao nome da rota. Podemos definir que cada rota do grupo terá uma string específica prefixada ao seus nome.

```
Route::group(['as' => 'users.', 'prefix' => 'users'], function() {
    Route::group(['as' => 'comments.', 'prefix' => 'comments'], function() {
        Route::get('{id}', function($id) {
            // O nome da rota será users.comments.show
        })->name('show');
    })
});
```

Views
=====

> **views** - ou templates, são arquivos que descrevem como deve ser a aparência de alguma saída específica. Você pode ter views para JSON, XML ou emails, mais a views mais comuns em um framework web exibem HTML.

Há dois formatos: PHP simples (about.php) renderizado com o engine PHP ou templates Blade (about.blade.php) renderizado com o engine Blade. Depois de carregar a view poderá retorná-la, se ele não depender de nenhuma variável do controlador.

```
Route::get('/', function() {
    return view('home');
});
```

> Esse código procura uma view em *resources/views/home.blade.php* ou em *resources/views/home.php*, carrega o conteúdo, analisa qualquer estrutura de controle ou PHP inline até termos uma saída. Quando retornada, ela passa para o resto da pilha de resposta e acabará sendo retornada para o usuário.

### Passando variáveis a view

Carregando uma view e passando para ela uma única variável chamada tasks, que contém o resultado do método **Task:all()** (é uma consulta de banco de dados do Eloquent).

```
Route::get('tasks', function() {
    return view('tasks.index')->with('tasks', Task::all());
});
```

Controllers
===========

> **controllers** - são classes que organizam a lógica de uma ou mais rotas em um único local.

Controladores tendem a agrupar a lógica de várias rotas semelhantes, principalmente se o aplicativo for um CRUD. Assim, um controlador pode manipular todas as ações relacionadas a um recurso específico. **A Tarefa principal de um controlador ** é captar a intenção de uma solicitação HTTP e passá-la para o resto do aplicativo.

> Considere-os como guardas de trânsito que roteiam solicitações HTTP pelo aplicativo. Já que há outras maneiras de as solicitações chegarem - cron jobs, chamadas de linha de comando do Artisan, queue jobs etc.

Criando um controlador com o Artisan:

````php artisan make:controller TasksController```

> **Artisan** - ferramenta de linha de comando do Laravel. Pode ser usado para executar migrações,  criar usuários e outros registros de banco de dados manualmente e realizar muitas outras tarefas online de execução única.

Sob o namespace **make**, o Artisan fornece ferramentas para geração de esqueletos para vários arquivos do sistema.

## Namespace de controlador

Simplesmente podemos referenciar os controladorres pelo nome da classe. Também podemos ignorar **App\Http\Controllers** ao referenciá-los. Por padrão, o Laravel irá procurar controladores dentro desse namespace. Então se tiver um controlador **App\Http\Controllers\ExercisesController**, vai referenciá-lo em uma definição de rota como **ExercisesController**.

### Exemplo comum de método de controlador

```
public function index() {
    return view('tasks'.index)->with('tasks', Task::all());
}
```
## Gerando controladores de recursos

É possível gerar automaticamente métodos de rotas de recursos básicos como create() e update(). Passe o flag **--resource** quando você criar o controlador.

```php artisan make:controller TasksController --resource```

> **flag** - parâmetro inserido em algum local que pode estar ativo ou inativo (booleano).


