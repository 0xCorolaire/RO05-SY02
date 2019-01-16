library(simmer);
library(simmer.plot);
set.seed(1234);

#lamda parameter of PPH and mu parameter of exponential variable of servicing time
lambda <- 3
mu <- 4

# we define the queu and server environment
m.queue <- trajectory() %>%
  seize("server", amount=1) %>%
  timeout(function() rexp(1, mu)) %>%
  release("server", amount=1)
mm23.env <- simmer() %>%
  add_resource("server", capacity=2, queue_size=1) %>%
  add_generator("arrival", m.queue, function() rexp(1, lambda)) %>%
  run(until=2000)

# We can get the rejection when queue if full 
get_mon_arrivals(mm23.env) %>%
  with(sum(!finished) / length(finished))

# we can plot the simulation that converges to the theoretical average number of customers in the system  N
plot(get_mon_resources(mm23.env), "usage", "server", items="system") +
  geom_hline(yintercept=mm23.N)

AvgNumbOfCustomer <- mm23.N


#

update.delay <- trajectory() %>%
  set_attribute(c("start", "multiplier", "delay"), function() {
    # previous multiplier, service time left
    multiplier <- get_attribute(env, "multiplier")
    left <- sum(get_attribute(env, c("start", "delay"))) - now(env)
    # distribute processing capacity
    new_multiplier <- capacity / get_server_count(env, "sd.server")
    # return new values
    c(now(env), new_multiplier, left * multiplier / new_multiplier)
  }) %>%
  timeout_from_attribute("delay")

sd.queue <- trajectory() %>%
  seize("sd.server") %>%
  # initialisation
  set_attribute(c("start", "multiplier", "delay"), function()
    c(now(env), 1, rexp(1, mu))) %>%
  # set the handler and trigger it
  trap("update delay", handler=update.delay) %>%
  send("update delay") %>%
  # returning point
  untrap("update delay") %>%
  release("sd.server") %>%
  send("update delay")

lambda <- mu <- 4
capacity <- 2
arrivals <- data.frame(time=rexp(2000*lambda, lambda))

env <- simmer() %>%
  # M/M/2
  add_resource("server", capacity) %>%
  add_dataframe("arrival", m.queue, arrivals) %>%
  # state-dependent service rate
  add_resource("sd.server", capacity) %>%
  add_dataframe("sd.arrival", sd.queue, arrivals)

env %>%
  run() %>%
  get_mon_resources() %>%
  plot(metric="usage", c("server", "sd.server"))



