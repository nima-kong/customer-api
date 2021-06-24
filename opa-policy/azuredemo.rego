package azuredemo

import input.request.http

default allow = false



allow {
  v := input.request.http.headers.authorization
  startswith(v, "Bearer ")
  t := substring(v, count("Bearer "), -1)
  io.jwt.verify_hs256(t, "B41BD5F462719C6D6118E673A2389")
  [_, payload, _] := io.jwt.decode(t)
  payload.username == "alice"
  kong_consumer := input.consumer.username
  kong_consumer == "insomnia"
}
