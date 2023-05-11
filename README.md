# Canary

Canary is uptime monitor that leverage the Erlang OTP to maximize up time.  

# Architecture

To understand the architecture and the choices I've made it may help to understand what I wanted a uptime monitor to achieve. Canary is primarily used in my home lab to keep track of running hardware and virtual machines. Although I wanted to be able to visit the webpage and see which machines were up or down, I also wanted to keep track of the online status of the machine if I didn't have the page open. 

Most web frameworks follow the standard request/response model as illustrated in Figure 1 below.

![Standard HTTP request/response model](canary_architecture_std.png "Figure 1")


As a quick overview, your standard framework starts an http process that listens for requests. When a request comes in, it gathers the necessary data and presents it back to the user. 

This model makes it difficult to achieve some of the goals of the app. How would we start the processes to monitor each machine? Once we figured that out, how would we monitor and manage the failure of each process. We would also need to figure how to update the site with the updated info of each machine. Depending on the number of machines and the interval of data that is being tracked the database calls for the historical data could easily become a bottleneck. To keep things snappy, we would also need to figure how to run this asynchronously.

Luckily, the Phoenix Framework built on top of Erlang's OTP has tools to solve these problems built in. Canary's architecture looks like this:


![Canary Architecture](canary_architecture_phx.png "Figure 2")

What's going on here. First, at start up, the Canary app starts up a watcher for each machine that is being monitored in addition to the http server and channel process which we will broacast messages on.

# Development

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix

## Generated Models

```
mix phx.gen.html Machines Machine machines  name:string ip_address:string payload:map
```
