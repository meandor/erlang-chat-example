# Chat Example

Simple example of sending messages from clients to a server

## Build
To compile everything:
````bash
erl -make
````

## Run
To start with compiled files, the <nodename> and a <cookie>:
````bash
erl -pa ebin/ -sname <nodename> -setcookie <cookie>
````

The server is fixed at node server@localhost

## Usage
To reload everything in the erlang shell:
````erlang
make:all([load]).
````

To start the server at node server@localhost:
````erlang
server:start().
````

To start a client:
````erlang
client:start({<ClientName,ClientNode>}).
````
Where <ClientName> is client and <ClientNode> the given nodename of the
erlang shell.

To send a message from a client:
````erlang
client:sendMessage(<Message>,{<ClientName,ClientNode>}).
````
Where <ClientName> is client and <ClientNode> the given nodename of the
erlang shell.
Message is the string of the message to be sent.